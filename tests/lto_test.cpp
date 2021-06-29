//
// The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
//
// This file is part of MinGW-W64(mingw-builds: https://github.com/niXman/mingw-builds) project.
// Copyright (c) 2011-2021 by niXman (i dotty nixman doggy gmail dotty com)
// Copyright (c) 2012-2015 by Alexpux (alexpux doggy gmail dotty com)
// All rights reserved.
//
// Project: MinGW-W64 ( http://sourceforge.net/projects/mingw-w64/ )
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
// - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer in
//     the documentation and/or other materials provided with the distribution.
// - Neither the name of the 'MinGW-W64' nor the names of its contributors may
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

#include <iostream>
#include <time.h>

#include "lto_int.h"

int main(int argc, char* const argv[])
{
  int i1, i2, i3;
  Int int1, int2, int3;
  double sum;

  clock_t start, end;
  double cpu_time_used;

  sum = 0.0;
  start = clock();
  for (int i = 0; i < 1000000000; i++)
  {
    i1 = i;
    i2 = i + 1;
    i3 = i1 +i2;
    sum = sum + i3;
  }
  end = clock();
  cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
  std::cout << sum << std::endl;
  std::cout << cpu_time_used << std::endl;

  sum = 0.0;
  start = clock();
  for (int i = 0; i < 1000000000; i++)
  {
    int1 = i;
    int2 = i + 1;
    int3 = int1 +int2;
    sum = sum + int3.value;
  }
  end = clock();
  cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
  std::cout << sum << std::endl;
  std::cout << cpu_time_used << std::endl;

  return 0;
}
