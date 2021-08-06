
#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of MinGW-W64(mingw-builds: https://github.com/niXman/mingw-builds) project.
# Copyright (c) 2011-2021 by niXman (i dotty nixman doggy gmail dotty com)
# Copyright (c) 2012-2015 by Alexpux (alexpux doggy gmail dotty com)
# All rights reserved.
#
# Project: MinGW-W64 ( http://sourceforge.net/projects/mingw-w64/ )
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# - Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in
#     the documentation and/or other materials provided with the distribution.
# - Neither the name of the 'MinGW-W64' nor the names of its contributors may
#     be used to endorse or promote products derived from this software
#     without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
# USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# **************************************************************************

PKG_NAME=tests
PKG_DIR_NAME=tests/$PKG_ARCHITECTURE
PKG_PRIORITY=main

dll_test1_list=(
	"dll1.cpp -shared -o dll1.dll"
	"dll_test1.cpp -o dll_test1.exe"
)

dll_test2_list=(
	"dll2.cpp -shared -o dll2.dll"
	"dll_test2.cpp -L. -ldll2 -o dll_test2.exe"
)

lto_test_list=(
	"lto_int.cpp -I$TESTS_DIR -flto -c -o lto_int.o"
	"lto_test.cpp -I$TESTS_DIR -flto -c -o lto_test.o"
	"lto_int.o lto_test.o -flto -o lto_test.exe"
)

omp_test_list=(
	"omp_test.c -fopenmp -o omp_test.exe"
)

pthread_test_list=(
	"pthread_test.c -mthreads -lpthread -o pthread_test.exe"
)

[[ `echo $BUILD_VERSION | cut -d. -f1` == 4 && `echo $BUILD_VERSION | cut -d. -f2` -le 6 ]] && (
	stdthread_test_list=(
		"stdthread_test.cpp -std=c++0x -o stdthread_test.exe"
	)
) || (
	stdthread_test_list=(
		"stdthread_test.cpp -std=c++11 -o stdthread_test.exe"
	)
)

lasterror_test1_list=(
	"lasterror_test1.cpp -o lasterror_test1.exe"
)

lasterror_test2_list=(
	"lasterror_test2.cpp -o lasterror_test2.exe"
)

time_test_list=(
	"time_test.c -lpthread -o time_test.exe"
)

[[ `echo $BUILD_VERSION | cut -d. -f1` == 4 && `echo $BUILD_VERSION | cut -d. -f2` -le 6 ]] && (
	sleep_test_list=(
		"sleep_test.cpp -std=c++0x -o sleep_test.exe"
	)
) || (
	sleep_test_list=(
		"sleep_test.cpp -std=c++11 -o sleep_test.exe"
	)
)

random_device_list=(
	"random_device.cpp -std=c++11 -o random_device.exe"
)

filesystem_list=(
    "filesystem.cpp -std=c++11 -lstdc++fs -o filesystem.exe"
)

# **************************************************************************
# **************************************************************************
# **************************************************************************

declare -A PKG_TESTS
[[ $BUILD_SHARED_GCC == yes ]] && { PKG_TESTS["dll_test1"]=dll_test1_list[@]; }
[[ $BUILD_SHARED_GCC == yes ]] && { PKG_TESTS["dll_test2"]=dll_test2_list[@]; }
PKG_TESTS["lto_test"]=lto_test_list[@]
PKG_TESTS["omp_test"]=omp_test_list[@]
PKG_TESTS["pthread_test"]=pthread_test_list[@]
[[ $THREADS_MODEL == posix ]] && { PKG_TESTS["stdthread_test"]=stdthread_test_list[@]; }
PKG_TESTS["lasterror_test1"]=lasterror_test1_list[@]
PKG_TESTS["lasterror_test2"]=lasterror_test2_list[@]
PKG_TESTS["time_test"]=time_test_list[@]
[[ $THREADS_MODEL == posix ]] && { PKG_TESTS["sleep_test"]=sleep_test_list[@]; }
[[ `echo $BUILD_VERSION | cut -d. -f1` -ge 6 ]] && { PKG_TESTS["random_device"]=random_device_list[@]; }
[[ `echo $BUILD_VERSION | cut -d. -f1` -ge 7 ]] && { PKG_TESTS["filesystem"]=filesystem_list[@]; }
