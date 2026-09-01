#define WIN32_LEAN_AND_MEAN
#include <windows.h>

#define COMMAND_NAME "wsl.exe"
#define COMMAND_SEP  " "

int APIENTRY
WinMain(HINSTANCE hInstance, HINSTANCE hPrevInst, LPSTR lpCmdLine, int nCmdShow) {
	STARTUPINFO si;
	PROCESS_INFORMATION pi;

	size_t cb = sizeof(COMMAND_NAME) + sizeof(COMMAND_SEP) + strlen(lpCmdLine) + 1;
	LPSTR cmdline = (LPSTR) HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, cb);
	
	if (!cmdline) {
		return -1;
	}

	strncpy(cmdline, COMMAND_NAME, cb);
	strncat(cmdline, COMMAND_SEP, cb);
	strncat(cmdline, lpCmdLine, cb);
	
	ZeroMemory(&si, sizeof(si));
	si.cb = sizeof(si);

	ZeroMemory(&pi, sizeof(pi));

	if (CreateProcessA(NULL, cmdline, NULL, NULL, FALSE, CREATE_NO_WINDOW, NULL, NULL, &si, &pi)) {
		WaitForSingleObject(pi.hProcess, INFINITE);
		CloseHandle(pi.hProcess);
		CloseHandle(pi.hThread);
	}

	HeapFree(GetProcessHeap(), 0, cmdline);
	return 0;
}
