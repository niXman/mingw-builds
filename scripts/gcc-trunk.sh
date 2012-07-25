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

NAME=gcc-trunk
SRC_DIR_NAME=gcc-trunk
URL=svn://gcc.gnu.org/svn/gcc/trunk
TYPE=svn

#

PATCHES=( gcc-4.7-stdthreads.patch gcc-4.7-iconv.patch )

#

CONFIGURE_FLAGS=(
	--host=$HOST
	--build=$BUILD
	--target=$TARGET
	#
	--prefix=$PREFIX
	--with-sysroot=$PREFIX
	#
	$LINK_TYPE_BOTH
	#
	$( [[ $USE_DWARF_EXCEPTIONS == yes ]] \
		&& echo "--disable-multilib" \
		|| echo "--enable-targets=all --enable-multilib" \
	)
	--enable-languages=$ENABLE_LANGUAGES,lto
	--enable-libstdcxx-time=yes
	--enable-threads=$THREADS_MODEL
	--enable-libgomp
	--enable-lto
	--enable-graphite
	--enable-cloog-backend=isl
	--enable-checking=release
	--enable-fully-dynamic-string
	--enable-version-specific-runtime-libs
	$( [[ $USE_DWARF_EXCEPTIONS == yes ]] \
		&& echo "--disable-sjlj-exceptions --with-dwarf2" \
		|| echo "--enable-sjlj-exceptions" \
	)
	#
	--disable-ppl-version-check
	--disable-cloog-version-check
	--disable-libstdcxx-pch
	--disable-libstdcxx-debug
	--disable-bootstrap
	--disable-rpath
	--disable-win32-registry
	--disable-nls
	--disable-werror
	--disable-symvers
	#
	--with-gnu-ld
	--with-tune=generic
	$( [[ $GCC_DEPS_LINK_TYPE == *--disable-shared* ]] \
		&& echo "--with-host-libstdcxx='-static -lstdc++'" \
	)
	--with-libiconv
	--with-{gmp,mpfr,mpc,ppl,cloog}=$LIBS_DIR
	--with-pkgversion="\"$PKGVERSION\""
	--with-bugurl=$BUG_URL
	#
	CFLAGS="\"$COMMON_CFLAGS\""
	CXXFLAGS="\"$COMMON_CXXFLAGS\""
	CPPFLAGS="\"$COMMON_CPPFLAGS\""
	LDFLAGS="\"$COMMON_LDFLAGS\""
)

#

MAKE_FLAGS=(
	-j$JOBS
	all
)

#

INSTALL_FLAGS=(
	-j$JOBS
	install-strip
)

# **************************************************************************
