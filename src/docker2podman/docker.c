/*
 * docker.c - Docker to Podman shim for Windows
 *
 * Purpose: act as a transparent replacement for the "docker" command,
 * forwarding all calls to "podman" (which must be available in the PATH).
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

/* On Windows, the practical command-line length limit is 32767 chars */
#define CMD_MAX 32767

int main(int argc, char *argv[])
{
    char cmd[CMD_MAX];
    int  pos = 0;
    int  i;
    int  ret;

    /*
     * Build the command line:
     *   podman <arg1> <arg2> ... <argN>
     *
     * Arguments containing spaces are wrapped in double quotes.
     * Arguments that are already quoted are passed through as-is.
     */

    /* Write the base executable name */
    pos += snprintf(cmd + pos, CMD_MAX - pos, "podman");

    for (i = 1; i < argc && pos < CMD_MAX - 4; i++) {
        int needs_quotes = 0;
        const char *p;

        /* Does the argument contain spaces or tabs? */
        for (p = argv[i]; *p; p++) {
            if (*p == ' ' || *p == '\t') {
                needs_quotes = 1;
                break;
            }
        }

        if (needs_quotes) {
            pos += snprintf(cmd + pos, CMD_MAX - pos, " \"%s\"", argv[i]);
        } else {
            pos += snprintf(cmd + pos, CMD_MAX - pos, " %s", argv[i]);
        }
    }

    if (pos >= CMD_MAX) {
        fprintf(stderr, "docker-shim: command line too long (>%d characters).\n",
                CMD_MAX);
        return 1;
    }

    /*
     * system() on Windows launches cmd.exe /C <cmd>, which is enough
     * to inherit stdin/stdout/stderr and return the child process exit
     * code via the return value of system().
     *
     * Note: under MSVC/MinGW the return value of system() is directly
     * the child's exit code. TinyCC follows the same convention.
     */
    ret = system(cmd);

    /*
     * system() returns -1 if the process could not be launched (e.g.
     * podman is not in the PATH).
     */
    if (ret == -1) {
        fprintf(stderr,
                "docker-shim: could not execute podman.\n"
                "  Make sure 'podman' is installed and available in the PATH.\n"
                "  Command attempted: %s\n", cmd);
        return 127; /* shell convention: command not found */
    }

    return ret;
}