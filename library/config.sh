
#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of MinGW-W64(mingw-builds: https://github.com/niXman/mingw-builds) project.
# Copyright (c) 2011-2015 by niXman (i dotty nixman doggy gmail dotty com)
#                        ,by Alexpux (alexpux doggy gmail dotty com)
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

MINGW_W64_BUILDS_VERSION="MinGW-W64-builds-4.2.0"
MINGW_W64_PKG_STRING="Built by MinGW-W64 - mingwpy build"

# **************************************************************************

PROJECT_ROOT_URL=http://sourceforge.net/projects/mingw-w64
BUG_URL=$PROJECT_ROOT_URL
PROJECT_FS_ROOT_DIR=/home/frs/project/mingw-w64

# **************************************************************************

# Need for MSYS2
export MSYSTEM=MINGW32
export LC_ALL=en_US.UTF-8

# **************************************************************************

readonly PATCHES_DIR=$TOP_DIR/patches
readonly SOURCES_DIR=$TOP_DIR/sources
readonly TESTS_DIR=$TOP_DIR/tests
readonly TOOLCHAINS_DIR=$TOP_DIR/toolchains

readonly i686_HOST_MINGW_PATH=$TOOLCHAINS_DIR/mingw32
readonly x86_64_HOST_MINGW_PATH=$TOOLCHAINS_DIR/mingw64

ROOT_DIR=

# **************************************************************************

BASE_CFLAGS="-O2 -pipe"
BASE_CXXFLAGS="$BASE_CFLAGS"
BASE_CPPFLAGS=""
BASE_LDFLAGS="-pipe"

PROCESSOR_OPTIMIZATION_TUNE_32='generic'
PROCESSOR_OPTIMIZATION_ARCH_32='i686'
PROCESSOR_OPTIMIZATION_TUNE_64='core2'
PROCESSOR_OPTIMIZATION_ARCH_64='nocona'

# **************************************************************************

LINK_TYPE_BOTH="--enable-shared --enable-static"
LINK_TYPE_SHARED="--enable-shared --disable-static"
LINK_TYPE_STATIC="--enable-static --disable-shared"
LINK_TYPE_GCC=$LINK_TYPE_BOTH
GCC_DEPS_LINK_TYPE=$LINK_TYPE_STATIC

ENABLE_LANGUAGES='c,c++,fortran'

SHOW_LOG_ON_ERROR=yes

JOBS=1

RUNTIME_VERSION=v4
RUNTIME_BRANCH="master"

CLANG_GCC_VERSION=gcc-4.9.1

# **************************************************************************

FETCH_MODE=no
UPDATE_SOURCES=no
BUILD_ARCHITECTURE=
EXCEPTIONS_MODEL=sjlj
USE_MULTILIB=yes
STRIP_ON_INSTALL=yes
BOOTSTRAPING=no
THREADS_MODEL=posix
REV_NUM=
COMPRESSING_BINS=no
COMPRESSING_SRCS=no
UPLOAD_MINGW=no
UPLOAD_SOURCES=no
SF_USER=
SF_PASSWORD=
DEBUG_UPLOAD=no
LINK_TYPE_SUFFIX=static
BUILD_SHARED_GCC=yes
PKG_RUN_TESTSUITE=no
BUILD_MODE=
BUILD_MODE_VERSION=
BUILD_VERSION=
BUILD_EXTRAS=yes
GCC_NAME=

DEFAULT_PYTHON_VERSION=2

# **************************************************************************

func_test_vars_list_for_null \
	"HOST \
	BUILD \
	TARGET"

# **************************************************************************

echo -n "-> Checking OS bitness... "
readonly U_MACHINE=`(uname -m) 2>/dev/null` || U_MACHINE=unknown
case "${U_MACHINE}" in
	i[34567]86)
		[[ $(env | grep PROCESSOR_ARCHITEW6432) =~ AMD64 || $(env | grep PROCESSOR_ARCHITECTURE) =~ AMD64 ]] && {
			IS_64BIT_HOST=yes
			echo "64-bit"
		} || {
			IS_64BIT_HOST=no
			echo "32-bit"
		}
	;;
	x86_64|amd64)
		IS_64BIT_HOST=yes
		echo "64-bit"
	;;
	*)
		die "Unsupported bitness ($U_MACHINE). terminate."
	;;
esac

echo -n "-> Checking OS type... "
readonly U_SYSTEM=`(uname -s) 2>/dev/null` || U_SYSTEM=unknown
echo "$U_SYSTEM"

case "${U_SYSTEM}" in
	Linux)
		source $TOP_DIR/library/config-nix.sh
	;;
	MSYS*|MINGW*)
		source $TOP_DIR/library/config-win.sh
	;;
	Darwin)
		source $TOP_DIR/library/config-osx.sh
	;;
	*)
		die "Unsupported OS ($U_SYSTEM). terminate."
	;;
esac

# **************************************************************************

echo -n "-> Checking for installed packages... "
func_test_installed_packages
[[ $? == 1 ]] && exit 1
echo "done"

# **************************************************************************

LOGVIEWER=

func_find_logviewer \
	LOGVIEWERS[@] \
	LOGVIEWER
[[ $? != 0 || -z $LOGVIEWER ]] && {
	die "logviewer not found. terminate."
}

# **************************************************************************
