/*
 * docker.c - Docker to Podman shim for Windows (CreateProcess version)
 *
 * Purpose: act as a transparent replacement for the "docker" command,
 * forwarding all calls to "podman" (which must be available in the PATH).
 *
 * This version uses CreateProcess() directly instead of system(), which
 * avoids spawning an intermediate cmd.exe shell and gives zero overhead,
 * proper exit-code propagation, and full stdin/stdout/stderr inheritance.
 *
 * Build with TinyCC 0.9.7.x on Windows:
 *   tcc docker.c -o docker.exe
 *
 * Usage: place docker.exe in a directory that appears before any existing
 * Docker installation in the PATH, or in any PATH directory if Docker
 * is not installed.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
 * Pull in the Windows API.
 * TinyCC ships its own <windows.h> that covers CreateProcess, WaitForSingleObject,
 * GetExitCodeProcess, STARTUPINFO, PROCESS_INFORMATION, etc.
 */
#include <windows.h>

/* On Windows, the practical command-line length limit is 32767 chars */
#define CMD_MAX 32767

/*
 * append_arg()
 *
 * Appends one argument to the command-line buffer, quoting it when necessary
 * following the Microsoft C runtime quoting rules:
 *   - If the argument contains spaces, tabs, or is empty, wrap it in
 *     double quotes.
 *   - Backslashes immediately before a closing double quote must be doubled.
 *   - Double quotes inside the argument are escaped with a backslash.
 *
 * Returns the number of characters written, or -1 on overflow.
 */
static int append_arg(char *buf, int pos, int maxlen, const char *arg)
{
    int needs_quotes = 0;
    const char *p;
    int start = pos;

    /* Determine whether quoting is needed */
    if (arg[0] == '\0') {
        needs_quotes = 1; /* empty argument must be passed as "" */
    } else {
        for (p = arg; *p; p++) {
            if (*p == ' ' || *p == '\t' || *p == '"') {
                needs_quotes = 1;
                break;
            }
        }
    }

    /* Space separator (skip for the very first token "podman") */
    if (pos > 0) {
        if (pos >= maxlen - 1) return -1;
        buf[pos++] = ' ';
    }

    if (!needs_quotes) {
        /* Simple copy */
        for (p = arg; *p; p++) {
            if (pos >= maxlen - 1) return -1;
            buf[pos++] = *p;
        }
    } else {
        if (pos >= maxlen - 1) return -1;
        buf[pos++] = '"';

        for (p = arg; *p; p++) {
            if (*p == '\\') {
                /*
                 * Count consecutive backslashes; if they are followed by a
                 * double quote (or end-of-string), double them.
                 */
                int num_bs = 0;
                const char *q = p;
                while (*q == '\\') { num_bs++; q++; }

                if (*q == '"' || *q == '\0') {
                    /* Double every backslash */
                    int j;
                    for (j = 0; j < num_bs * 2; j++) {
                        if (pos >= maxlen - 1) return -1;
                        buf[pos++] = '\\';
                    }
                } else {
                    /* Leave backslashes as-is */
                    int j;
                    for (j = 0; j < num_bs; j++) {
                        if (pos >= maxlen - 1) return -1;
                        buf[pos++] = '\\';
                    }
                }
                /* Advance p to the last backslash (loop will do p++) */
                p = q - 1;
            } else if (*p == '"') {
                /* Escape the double quote */
                if (pos >= maxlen - 2) return -1;
                buf[pos++] = '\\';
                buf[pos++] = '"';
            } else {
                if (pos >= maxlen - 1) return -1;
                buf[pos++] = *p;
            }
        }

        if (pos >= maxlen - 1) return -1;
        buf[pos++] = '"';
    }

    buf[pos] = '\0';
    return pos - start;
}

int main(int argc, char *argv[])
{
    char             cmd[CMD_MAX];
    int              pos = 0;
    int              i;
    STARTUPINFOA     si;
    PROCESS_INFORMATION pi;
    DWORD            exit_code;
    BOOL             ok;

    /* -------------------------------------------------------------------
     * 1. Build the command line: podman <arg1> <arg2> ... <argN>
     * ------------------------------------------------------------------- */

    /* Start with the executable name */
    strncpy(cmd, "podman", CMD_MAX - 1);
    cmd[CMD_MAX - 1] = '\0';
    pos = (int)strlen(cmd);

    for (i = 1; i < argc; i++) {
        if (append_arg(cmd, pos, CMD_MAX, argv[i]) < 0) {
            fprintf(stderr,
                    "docker-shim: command line too long (>%d characters).\n",
                    CMD_MAX);
            return 1;
        }
        pos = (int)strlen(cmd);
    }

    /* -------------------------------------------------------------------
     * 2. Set up STARTUPINFO to inherit the parent's console handles.
     *    This gives podman the same stdin/stdout/stderr as the caller,
     *    so pipes, redirections, and ANSI colours all work correctly.
     * ------------------------------------------------------------------- */
    ZeroMemory(&si, sizeof(si));
    si.cb = sizeof(si);
    /* Do NOT set STARTF_USESTDHANDLES — leaving it unset lets Windows
     * inherit the handles automatically, which is exactly what we want. */

    ZeroMemory(&pi, sizeof(pi));

    /* -------------------------------------------------------------------
     * 3. Launch podman.
     *
     *    lpApplicationName = NULL  → Windows searches the PATH for "podman"
     *                                using the first token of lpCommandLine.
     *    bInheritHandles   = TRUE  → child inherits console handles.
     *    CREATE_NO_WINDOW not set  → child shares the caller's console window.
     * ------------------------------------------------------------------- */
    ok = CreateProcessA(
        NULL,           /* application name (derived from cmd) */
        cmd,            /* full command line                    */
        NULL,           /* process security attributes          */
        NULL,           /* thread security attributes           */
        TRUE,           /* inherit handles                      */
        0,              /* creation flags                       */
        NULL,           /* inherit parent's environment block   */
        NULL,           /* inherit parent's current directory   */
        &si,
        &pi
    );

    if (!ok) {
        DWORD err = GetLastError();
        fprintf(stderr,
                "docker-shim: could not launch podman (Windows error %lu).\n"
                "  Make sure 'podman' is installed and available in the PATH.\n"
                "  Command attempted: %s\n",
                (unsigned long)err, cmd);
        return 127; /* shell convention: command not found */
    }

    /* -------------------------------------------------------------------
     * 4. Wait for podman to finish, then retrieve and forward its exit code.
     * ------------------------------------------------------------------- */
    WaitForSingleObject(pi.hProcess, INFINITE);

    exit_code = 1; /* safe default */
    GetExitCodeProcess(pi.hProcess, &exit_code);

    /* Release handles — we no longer need them */
    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);

    return (int)exit_code;
}