
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

if [[ `echo $BUILD_VERSION | cut -d. -f1` == 4 && `echo $BUILD_VERSION | cut -d. -f2` -le 8 ]] || [[ `echo $BUILD_VERSION | cut -d. -f1` == 4 && `echo $BUILD_VERSION | cut -d. -f2` == 9 && `echo $BUILD_VERSION | cut -d. -f3` -le 2 ]]; then
   PKG_VERSION=0.12.2
   PKG_TYPE=.tar.lzma
elif [[ `echo $BUILD_VERSION | cut -d. -f1` == 4 ]] || [[ `echo $BUILD_VERSION | cut -d. -f1` == 5 && `echo $BUILD_VERSION | cut -d. -f2` -le 2 ]]; then
   PKG_VERSION=0.14.1
   PKG_TYPE=.tar.xz
elif [[ `echo $BUILD_VERSION | cut -d. -f1` == 5 ]]; then
   PKG_VERSION=0.18
   PKG_TYPE=.tar.xz
elif [[ `echo $BUILD_VERSION | cut -d. -f1` -le 7 && ${BUILD_VERSION} != trunk ]]; then
   PKG_VERSION=0.19
   PKG_TYPE=.tar.xz
elif [[ `echo $BUILD_VERSION | cut -d. -f1` -le 10 && ${BUILD_VERSION} != trunk ]]; then
   PKG_VERSION=0.23
   PKG_TYPE=.tar.xz
else
   PKG_VERSION=0.24
   PKG_TYPE=.tar.xz
fi
PKG_NAME=$BUILD_ARCHITECTURE-isl-${PKG_VERSION}-$LINK_TYPE_SUFFIX
PKG_DIR_NAME=isl-${PKG_VERSION}
PKG_URLS=(
	"http://isl.gforge.inria.fr/isl-${PKG_VERSION}${PKG_TYPE}"
)

PKG_PRIORITY=prereq

#

PKG_PATCHES=(
	$([[ ${PKG_VERSION} == 0.12.2 ]] && echo "isl/isl-0.12-no-undefined.patch" || echo "isl/isl-0.14.1-no-undefined.patch" )
)

#

if [[  ${PKG_VERSION:2:2} -ge 18 ]]; then
	PKG_EXECUTE_AFTER_PATCH=(
		"aclocal"
		"automake"
	)
fi

PKG_CONFIGURE_FLAGS=(
	--host=$HOST
	--build=$BUILD
	--target=$TARGET
	#
	--prefix=$PREREQ_DIR/$HOST-$LINK_TYPE_SUFFIX
	#
	$GCC_DEPS_LINK_TYPE
	#
	--with-gmp-prefix=$PREREQ_DIR/$HOST-$LINK_TYPE_SUFFIX
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

PKG_TESTSUITE_FLAGS=(
	-j$JOBS
	check
)

#

PKG_INSTALL_FLAGS=(
	-j$JOBS
	$( [[ $STRIP_ON_INSTALL == yes ]] && echo install-strip || echo install )
)

# **************************************************************************
