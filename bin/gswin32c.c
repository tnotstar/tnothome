/* -*- coding: utf-8 -*-
 *
 * Copyright (c) 2020 Antonio Alvarado Hernández
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 *
 */

#include <stdlib.h>
#include <string.h>
#include <process.h>
#include <sys/stat.h>

#define WIN32_LEAN_AND_MEAN
#include <windows.h>


char const COMMAND[] = "gswin64c.exe";
char const DELIMITER[] = ";";

char cmdpath[MAX_PATH];


char *
resolve_command_path(char const *command) {
    char *path = getenv("PATH");
    if (path == NULL)
        return NULL;

    char *token = strtok(path, DELIMITER);
    while (token != NULL) {
        size_t toklen = strlen(token);

        strcpy(cmdpath, token);
        strcpy(cmdpath + toklen + 1, command);

        *(cmdpath + toklen) = '\\';

        struct stat statinfo;
        if (stat(cmdpath, &statinfo) == 0)
            return cmdpath;

        token = strtok(NULL, DELIMITER);
    }

    return NULL;
}


int
main (int argc, char *argv[]) {
	argv[0] = resolve_command_path(COMMAND);
	if (argv[0] == NULL)
        return -1;

	return spawnv(P_WAIT, argv[0], argv);
}
