//
// The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
//
// This file is part of 'mingw-builds' project.
// Copyright (c) 2011,2012, by niXman (i dotty nixman doggy gmail dotty com)
// All rights reserved.
//
// Project: mingw-builds ( http://sourceforge.net/projects/mingwbuilds/ )
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
// - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer in
//     the documentation and/or other materials provided with the distribution.
// - Neither the name of the 'mingw-builds' nor the names of its contributors may
//     be used to endorse or promote products derived from this software
//     without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
// OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
// USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// **************************************************************************

#include <windows.h>
#include <cstdio>

typedef void(*func_t)();

int main() {
   HMODULE lib = LoadLibrary("dll1.dll");
   if ( !lib ) {
      printf("can`t load dll!\n");
      return 1;
   }
   
   func_t func = (func_t)GetProcAddress(lib, "func");
   if ( !func ) {
      printf("can`t resolve the func()\n");
		FreeLibrary(lib);
      return 1;
   }
   
   try {
      func();
		return 1;
   } catch ( ... ) {
		return 0;
   }
	return 0;
}
