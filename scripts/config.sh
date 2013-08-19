#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of 'MinGW-W64' project.
# Copyright (c) 2011,2012,2013 by niXman (i dotty nixman doggy gmail dotty com)
# Copyright (c) 2012,2013 by Alexpux (alexpux doggy gmail dotty com)
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

SHOW_LOG_ON_ERROR=yes

JOBS=1

# **************************************************************************

MINGW_W64_BUILDS_VERSION="MinGW-W64-builds-0.0.1"
PKG_VERSION="Built by MinGW-W64 project"

# **************************************************************************

PROJECT_ROOT_URL=http://sourceforge.net/projects/mingw-w64
BUG_URL=$PROJECT_ROOT_URL
PROJECT_FS_ROOT_DIR=/home/frs/project/mingw-w64

# **************************************************************************

echo -n "Checking operating system... "
readonly U_SYSTEM=`(uname -s) 2>/dev/null`  || U_SYSTEM=unknown
echo "$U_SYSTEM"

case "${U_SYSTEM}" in
	Linux)
		. ./scripts/config-nix.sh
	;;
	MSYS*|MINGW*)
		. ./scripts/config-win.sh
	;;
	Darwin)
		. ./scripts/config-osx.sh
	;;
	*)
		die "Unsupported OS ($U_SYSTEM). terminate."
	;;
esac

echo -n "Checking OS bitness... "
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
	x86_64 | amd64)
		IS_64BIT_HOST=yes
		echo "64-bit"
	;;
	*)
		die "Unsupported bitness ($U_MACHINE). terminate."
	;;
esac

# **************************************************************************

LOGVIEWER=

func_find_logviewer \
	LOGVIEWERS[@] \
	LOGVIEWER
[[ $? != 0 || -z $LOGVIEWER ]] && {
	die "logviewer not found. terminate."
}

# **************************************************************************

func_test_vars_list_for_null \
	"x32_HOST \
	x32_BUILD \
	x32_TARGET \
	x64_HOST \
	x64_BUILD \
	x64_TARGET"

# **************************************************************************
