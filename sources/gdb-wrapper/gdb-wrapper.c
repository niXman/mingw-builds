/***************************************************************************
** The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
**
** This file is part of 'mingw-builds' project.
** Copyright (c) 2011,2012, by niXman (i dotty nixman doggy gmail dotty com)
** All rights reserved.
**
** Project: mingw-builds ( http://sourceforge.net/projects/mingwbuilds/ )
**
** Redistribution and use in source and binary forms, with or without 
** modification, are permitted provided that the following conditions are met:
** - Redistributions of source code must retain the above copyright 
**     notice, this list of conditions and the following disclaimer.
** - Redistributions in binary form must reproduce the above copyright 
**     notice, this list of conditions and the following disclaimer in 
**     the documentation and/or other materials provided with the distribution.
** - Neither the name of the 'mingw-builds' nor the names of its contributors may 
**     be used to endorse or promote products derived from this software 
**     without specific prior written permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
** A PARTICULAR PURPOSE ARE DISCLAIMED.
** IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY 
** DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS 
** OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
** CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
** OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
** USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
***************************************************************************/

#include <windows.h>

#include <stdio.h>
#include <strings.h>

#define DIE_IF_FALSE(var) \
	do { \
		if ( !(var) ) { \
			fprintf(stderr, "%s(%d)[%d]: expression \"%s\" fail. terminate.\n" \
				,__FILE__ \
				,__LINE__ \
				,GetLastError() \
				,#var \
			); \
			exit(1); \
		} \
	} while (0)

int main(int argc, char** argv) {
	enum {
		 envbufsize = 1024*32
		,exebufsize = 1024
		,cmdbufsize = envbufsize
	};
	
	char *envbuf, *sep, *resbuf, *cmdbuf;
	DWORD len, exitCode;
	STARTUPINFO si;
	PROCESS_INFORMATION pi;

	DIE_IF_FALSE(
		(envbuf = malloc(envbufsize))
	);
	DIE_IF_FALSE(
		(cmdbuf = malloc(cmdbufsize))
	);
	*cmdbuf = 0;
	
	DIE_IF_FALSE(
		GetEnvironmentVariable("PATH", envbuf, envbufsize)
	);
	//printf("env: %s\n", envbuf);
	
	DIE_IF_FALSE(
		GetModuleFileName(0, cmdbuf, exebufsize)
	);
	//printf("curdir: %s\n", cmdbuf);
	
	DIE_IF_FALSE(
		(sep = strrchr(cmdbuf, '\\'))
	);
	*(sep+1) = 0;
	strcat(cmdbuf, "..\\opt\\bin");
	//printf("sep: %s\n", cmdbuf);

	len = strlen(envbuf)+strlen(cmdbuf)
		+1  /* for envronment separator */
		+1; /* for zero-terminator */
	
	DIE_IF_FALSE(
		(resbuf = malloc(len))
	);
	
	DIE_IF_FALSE(
		(snprintf(resbuf, len, "%s;%s", cmdbuf, envbuf) > 0)
	);
	//printf("res: %s\n", resbuf);
	
	DIE_IF_FALSE(
		SetEnvironmentVariable("PATH", resbuf)
	);

	*(sep+1) = 0;
	strcat(cmdbuf, "..\\opt");
	//printf("PYTHONHOME: %s\n", cmdbuf);
	DIE_IF_FALSE(
		SetEnvironmentVariable("PYTHONHOME", cmdbuf)
	);
	
	*(sep+1) = 0;
	strcat(cmdbuf, "gdborig.exe ");
	
	if ( argc > 1 ) {
		for ( ++argv; *argv; ++argv ) {
			len = strlen(cmdbuf);
			snprintf(cmdbuf+len, cmdbufsize-len, "%s ", *argv);
		}
	}
	//printf("cmd: %s\n", cmdbuf);

	memset(&si, 0, sizeof(si));
	si.cb = sizeof(si);
	
	memset(&pi, 0, sizeof(pi));

	DIE_IF_FALSE(
		CreateProcess(
			 0	// exe name
			,cmdbuf	// command line
			,0			// process security attributes
			,0			// primary thread security attributes
			,FALSE		// handles are NOT inherited
			,0			// creation flags
			,0			// use parent's environment
			,0			// use parent's current directory
			,&si		// STARTUPINFO pointer
			,&pi		// receives PROCESS_INFORMATION
		)
	);
	
	WaitForSingleObject(pi.hProcess, INFINITE);
	
	DIE_IF_FALSE(
		GetExitCodeProcess(pi.hProcess, &exitCode)
	);
	
	CloseHandle( pi.hProcess );
	CloseHandle( pi.hThread );
    
	free(envbuf);
	free(resbuf);
	free(cmdbuf);
	
	return exitCode;
}
