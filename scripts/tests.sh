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

[[ $USE_DWARF_EXCEPTIONS == no ]] && {
	mkdir -p $TESTS_ROOT_DIR/{32,64}
	[[ $ARCHITECTURE == x32 ]] && {
		cp -f $PREFIX/$TARGET/lib64/{libgcc_s_sjlj-1.dll,libgfortran-3.dll,libgomp-1.dll,libquadmath-0.dll,libssp-0.dll,libstdc++-6.dll,libwinpthread-1.dll} \
			$TESTS_ROOT_DIR/64/
	} || {
		cp -f $PREFIX/$TARGET/lib32/{libgcc_s_sjlj-1.dll,libgfortran-3.dll,libgomp-1.dll,libquadmath-0.dll,libssp-0.dll,libstdc++-6.dll,libwinpthread-1.dll} \
			$TESTS_ROOT_DIR/32/
	}
} || {
	mkdir -p $TESTS_ROOT_DIR/32
}

# **************************************************************************
# **************************************************************************
# **************************************************************************

list1=(
	"dll1.cpp -shared -o dll1.dll"
	"dlltest1.cpp -o dlltest1.exe"
)

run_test \
	"dlltest1" \
	list1[@] \
	$TESTS_ROOT_DIR

# **************************************************************************

list2=(
	"dll2.cpp -shared -o dll2.dll"
	"dlltest2.cpp -L. -ldll2 -o dlltest2.exe"
)

run_test \
	"dlltest2" \
	list2[@] \
	$TESTS_ROOT_DIR

# **************************************************************************

list3=(
	"ltoint.cpp -I$TESTS_DIR -flto -c -o ltoint.o"
	"ltotest.cpp ltoint.o -flto -I$TESTS_DIR -o ltotest.exe"
)

run_test \
	"ltotest" \
	list3[@] \
	$TESTS_ROOT_DIR

# **************************************************************************

list4=(
	"omptest.c -fopenmp -o omptest.exe"
)

run_test \
	"omptest" \
	list4[@] \
	$TESTS_ROOT_DIR

# **************************************************************************

list5=(
	"pthtest.c -mthreads -o pthtest.exe"
)

run_test \
	"pthtest" \
	list5[@] \
	$TESTS_ROOT_DIR

# **************************************************************************

list6=(
	"thtest.cpp -std=c++0x -o thtest.exe"
)

run_test \
	"thtest" \
	list6[@] \
	$TESTS_ROOT_DIR

# **************************************************************************

list7=(
	"last_error_test.cpp -o last_error_test.exe"
)

run_test \
	"last_error_test" \
	list7[@] \
	$TESTS_ROOT_DIR

# **************************************************************************

list8=(
	"timetest.c -o timetest.exe"
)

run_test \
	"timetest" \
	list8[@] \
	$TESTS_ROOT_DIR

# **************************************************************************

list9=(
	"sleeptest.cpp -std=c++0x -o sleeptest.exe"
)

run_test \
	"sleeptest" \
	list9[@] \
	$TESTS_ROOT_DIR

# **************************************************************************

# list7=(
	# "tmtest.cpp -std=c++0x -fgnu-tm -o tmtest.exe"
# )

# run_test \
	# "tmtest" \
	# list7[@] \
	# $TESTS_ROOT_DIR

# **************************************************************************
