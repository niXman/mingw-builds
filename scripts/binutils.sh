#!/bin/bash

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

VERSION=2.23.2
NAME=binutils-${VERSION}
[[ $USE_MULTILIB == yes ]] && {
	NAME=$BUILD_ARCHITECTURE-$NAME-multi
} || {
	NAME=$BUILD_ARCHITECTURE-$NAME-nomulti
}
SRC_DIR_NAME=binutils-${VERSION}
TYPE=.tar.bz2
URL=(
	"ftp://mirrors.kernel.org/sources.redhat.com/binutils/releases/binutils-${VERSION}.tar.bz2"
)

PRIORITY=prereq

#

PATCHES=(
	binutils/binutils-2.23.2-fix-docs.patch
)

#

[[ $USE_MULTILIB == yes ]] && {
	BINUTILSPREFIX=$PREREQ_DIR/$BUILD_ARCHITECTURE-binutils-multi
	RUNTIMEPREFIX=$RUNTIME_DIR/$BUILD_ARCHITECTURE-mingw-w64-multi
} || {
	BINUTILSPREFIX=$PREREQ_DIR/$BUILD_ARCHITECTURE-binutils-nomulti
	RUNTIMEPREFIX=$RUNTIME_DIR/$BUILD_ARCHITECTURE-mingw-w64-nomulti
}

CONFIGURE_FLAGS=(
	--host=$HOST
	--build=$BUILD
	--target=$TARGET
	#
	--prefix=$BINUTILSPREFIX
	--with-sysroot=$RUNTIMEPREFIX
	#
	$( [[ $USE_MULTILIB == yes ]] \
		&& echo "--enable-targets=$ENABLE_TARGETS --enable-multilib --enable-64-bit-bfd" \
		|| echo "--disable-multilib"
	)
	#
	$( [[ $ARCHITECTURE == x64 ]] \
		&& echo "--enable-64-bit-bfd" \
	)
	#
	--enable-lto
	#
	--with-libiconv-prefix=$PREREQ_DIR/libiconv-$BUILD_ARCHITECTURE
	#
	--disable-nls
	#
	$LINK_TYPE_BOTH
	#
	CFLAGS="\"$COMMON_CFLAGS\""
	CXXFLAGS="\"$COMMON_CXXFLAGS\""
	CPPFLAGS="\"$COMMON_CPPFLAGS\""
	LDFLAGS="\"$COMMON_LDFLAGS $( [[ $BUILD_ARCHITECTURE == x32 ]] && echo -Wl,--large-address-aware )\""
)

#

MAKE_FLAGS=(
	-j$JOBS
	all
)

#

INSTALL_FLAGS=(
	-j$JOBS
	$( [[ $STRIP_ON_INSTALL == yes ]] && echo install-strip || echo install )
)

# **************************************************************************
