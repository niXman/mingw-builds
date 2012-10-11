#!/bin/bash

#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of 'mingw-builds' project.
# Copyright (c) 2011,2012, by niXman (i dotty nixman doggy gmail dotty com)
# All rights reserved.
#
# Project: mingw-builds ( http://sourceforge.net/projects/mingwbuilds/ )
#
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
# - Redistributions of source code must retain the above copyright 
#     notice, this list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright 
#     notice, this list of conditions and the following disclaimer in 
#     the documentation and/or other materials provided with the distribution.
# - Neither the name of the 'mingw-builds' nor the names of its contributors may 
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

export PATH=$PREFIX/bin:$ORIGINAL_PATH

TESTS_ROOT_DIR=$BUILDS_DIR/tests

[[ $USE_MULTILIB == yes ]] && {
	mkdir -p $TESTS_ROOT_DIR/{32,64}
	[[ $ARCHITECTURE == x32 ]] && {
		cp -f $( find $PREFIX/$TARGET/lib64 -type f \( -iname *.dll \) ) \
			$TESTS_ROOT_DIR/64/
	} || {
		cp -f $( find $PREFIX/$TARGET/lib32 -type f \( -iname *.dll \) ) \
			$TESTS_ROOT_DIR/32/
	}
} || {
	[[ $ARCHITECTURE == x32 ]] && {
		mkdir -p $TESTS_ROOT_DIR/32
	} || {
		mkdir -p $TESTS_ROOT_DIR/64
	}
}

# **************************************************************************
# **************************************************************************
# **************************************************************************

list1=(
	"dll1.cpp -shared -o dll1.dll"
	"dll_test1.cpp -o dll_test1.exe"
)

func_test \
	"dll_test1" \
	list1[@] \
	$TESTS_ROOT_DIR

# **************************************************************************

list2=(
	"dll2.cpp -shared -o dll2.dll"
	"dll_test2.cpp -L. -ldll2 -o dll_test2.exe"
)

func_test \
	"dll_test2" \
	list2[@] \
	$TESTS_ROOT_DIR

# **************************************************************************

list3=(
	"lto_int.cpp -I$TESTS_DIR -flto -c -o lto_int.o"
	"lto_test.cpp lto_int.o -flto -I$TESTS_DIR -o lto_test.exe"
)

func_test \
	"lto_test" \
	list3[@] \
	$TESTS_ROOT_DIR

# **************************************************************************

list4=(
	"omp_test.c -fopenmp -o omp_test.exe"
)

func_test \
	"omp_test" \
	list4[@] \
	$TESTS_ROOT_DIR

# **************************************************************************

list5=(
	"pthread_test.c -mthreads -lpthread -o pthread_test.exe"
)

func_test \
	"pthread_test" \
	list5[@] \
	$TESTS_ROOT_DIR

# **************************************************************************

[[ $THREADS_MODEL == posix ]] && {
	list6=(
		"stdthread_test.cpp -std=c++0x -o stdthread_test.exe"
	)

	func_test \
		"stdthread_test" \
		list6[@] \
		$TESTS_ROOT_DIR
}

# **************************************************************************

list7=(
	"lasterror_test1.cpp -o lasterror_test1.exe"
)

func_test \
	"lasterror_test1" \
	list7[@] \
	$TESTS_ROOT_DIR

# **************************************************************************

list8=(
	"lasterror_test2.cpp -o lasterror_test2.exe"
)

func_test \
	"lasterror_test2" \
	list8[@] \
	$TESTS_ROOT_DIR

# **************************************************************************

list9=(
	"time_test.c -lpthread -o time_test.exe"
)

func_test \
	"time_test" \
	list9[@] \
	$TESTS_ROOT_DIR

# **************************************************************************

[[ $THREADS_MODEL == posix ]] && {
	list10=(
		"sleep_test.cpp -std=c++0x -o sleep_test.exe"
	)

	func_test \
		"sleep_test" \
		list10[@] \
		$TESTS_ROOT_DIR
}

# **************************************************************************
