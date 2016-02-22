
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

PKG_NAME=mingw-w64-crt-${RUNTIME_VERSION}
PKG_DIR_NAME=mingw-w64${MINGW_PKG_DIR_VERSION_SUFFIX}/mingw-w64-crt

[[ $USE_MULTILIB == yes ]] && {
	PKG_NAME=$BUILD_ARCHITECTURE-$PKG_NAME-multi
} || {
	PKG_NAME=$BUILD_ARCHITECTURE-$PKG_NAME-nomulti
}

PKG_PRIORITY=runtime

#

PKG_PATCHES=(
	mingw-w64/fpclassify.patch
)

#

[[ $USE_MULTILIB == yes ]] && {
	LIBCONF="--enable-lib32 --enable-lib64"
	CRTPREFIX=$RUNTIME_DIR/$BUILD_ARCHITECTURE-mingw-w64-${RUNTIME_VERSION}-multi
} || {
	CRTPREFIX=$RUNTIME_DIR/$BUILD_ARCHITECTURE-mingw-w64-${RUNTIME_VERSION}-nomulti
	[[ $BUILD_ARCHITECTURE == i686 ]] && {
		LIBCONF="--enable-lib32 --disable-lib64"
	} || {
		LIBCONF="--disable-lib32 --enable-lib64"
	}
}

PKG_CONFIGURE_FLAGS=(
	--host=$HOST
	--build=$BUILD
	--target=$TARGET
	#
	--prefix=$CRTPREFIX
	--with-sysroot=$CRTPREFIX
	#
	$LIBCONF
	--enable-wildcard
	#
	CFLAGS="\"$COMMON_CFLAGS\""
	CXXFLAGS="\"$COMMON_CXXFLAGS\""
	CPPFLAGS="\"$COMMON_CPPFLAGS\""
	LDFLAGS="\"$COMMON_LDFLAGS\""
)

#

PKG_MAKE_FLAGS=(
	-j$JOBS
	all
)

#

PKG_INSTALL_FLAGS=(
	-j$JOBS
	$( [[ $STRIP_ON_INSTALL == yes ]] && echo install-strip || echo install )
)

# **************************************************************************
