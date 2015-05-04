/*
 * Copyright (c) 2011-2014, JANET(UK)
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * 3. Neither the name of JANET(UK) nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
*/
#ifdef HAVE_GETPWUID
#include <stdlib.h>
#include <sys/types.h>
#include <pwd.h>
#endif
#ifdef OS_WIN32
#include <io.h>
#include <fcntl.h>
#include <stdio.h>
#include <windows.h>
#endif

const char * MoonshotGetUserName()
{
#ifdef HAVE_GETPWUID
   struct passwd *pwd = getpwuid(getuid());
   return pwd ? pwd->pw_name : "unknown";
#else
   return "unknown";
#endif
}

const char * GetFlatStoreUsersFilePath()
{
   return MOONSHOT_FLATSTORE_USERS;
}

#ifdef OS_WIN32
static int con_to_std(DWORD std_id, FILE *fp_out)
{
    HANDLE con_handle;
    int fd;
    FILE *fp;
    con_handle = GetStdHandle(std_id);
    if (con_handle == INVALID_HANDLE_VALUE)
        return 0;
    fd = _open_osfhandle((intptr_t)con_handle, _O_TEXT);
    if (fd == -1)
        return 0;
    fp = _fdopen(fd, "w" );
    if (fp == NULL)
        return 0;
    *fp_out = *fp;
    setvbuf(fp_out, NULL, _IONBF, 0 );
    return 1;
}

int moonshot_attach_console()
{
#if 0
    if (AttachConsole(ATTACH_PARENT_PROCESS) != 0) {
        if (con_to_std(STD_OUTPUT_HANDLE, stdout) &&
            con_to_std(STD_ERROR_HANDLE, stderr)) {
            return 1;
        }
    }
#endif
    if (AllocConsole() && AttachConsole(GetCurrentProcessId())) {
        if (con_to_std(STD_OUTPUT_HANDLE, stdout) &&
            con_to_std(STD_ERROR_HANDLE, stderr)) {
            return 1;
        }
    }

    return 0;
}
#endif

