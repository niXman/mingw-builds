
#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of 'mingw-builds' project.
# Copyright (c) 2011,2012,2013 by niXman (i dotty nixman doggy gmail dotty com)
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

export MSYSTEM=MINGW32
export LC_ALL=en_US.UTF-8

# **************************************************************************

ENABLE_LANGUAGES='ada,c,c++,fortran,objc,obj-c++'

BASE_CFLAGS="-O2 -pipe"
BASE_CXXFLAGS="$BASE_CFLAGS"
BASE_CPPFLAGS=""
BASE_LDFLAGS="-pipe"

LINK_TYPE_BOTH="--enable-shared --enable-static"
LINK_TYPE_SHARED="--enable-shared --disable-static"
LINK_TYPE_STATIC="--enable-static --disable-shared"
GCC_DEPS_LINK_TYPE=$LINK_TYPE_STATIC
LINK_TYPE_SUFFIX="static"

SHOW_LOG_ON_ERROR=yes

JOBS=1

# **************************************************************************

MINGW_BUILDS_VERSION="MinGW-W64-builds-0.0.1"
PKG_VERSION="Built by MinGW-W64 project"

# **************************************************************************

PROJECT_ROOT_URL=http://sourceforge.net/projects/mingw-w64
BUG_URL=$PROJECT_ROOT_URL
PROJECT_FS_ROOT_DIR=/home/frs/project/mingw-w64

# **************************************************************************

[[ $(env | grep PROCESSOR_ARCHITEW6432) =~ AMD64 || $(env | grep PROCESSOR_ARCHITECTURE) =~ AMD64 ]] && {
	IS_64BIT_HOST=yes
} || {
	IS_64BIT_HOST=no
}

# **************************************************************************

IS_LINUX_HOST=no
IS_WINDOWS_HOST=no
IS_MACOSX_HOST=no

case $OSTYPE in
	linux-gnu)
		IS_LINUX_HOST=yes
		. ./scripts/config-nix.sh
	;;
	msys)
		IS_WINDOWS_HOST=yes
		. ./scripts/config-win.sh
	;;
	darwin*)
		IS_MACOSX_HOST=yes
		. ./scripts/config-osx.sh
	;;
	*)
		echo "bad host($OSTYPE). terminate."
		exit 1
	;;
esac

# **************************************************************************

LOGVIEWER=

func_find_logviewer \
	LOGVIEWERS[@] \
	LOGVIEWER

[[ $? != 0 ]] && {
	die "logviewer not found. terminate."
}

[[ -z $LOGVIEWER ]] && {
	die "var LOGVIEWER is NULL. terminate."
}

# **************************************************************************

[[ -z $x32_HOST_MINGW_PATH_URL || -z $x64_HOST_MINGW_PATH_URL ]] && {
	die "x32_HOST_MINGW_PATH_URL or x64_HOST_MINGW_PATH_URL is empty. terminate."
}

func_test_vars_list_for_null \
  "x32_HOST \
	x32_BUILD \
	x32_TARGET \
	x64_HOST \
	x64_BUILD \
	x64_TARGET"

# **************************************************************************
