
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

PKG_VERSION=4.7.0
PKG_NAME=gcc-${PKG_VERSION}
PKG_DIR_NAME=gcc-${PKG_VERSION}
PKG_TYPE=.tar.bz2
PKG_URLS=(
	"https://ftp.gnu.org/gnu/gcc/gcc-${PKG_VERSION}/gcc-${PKG_VERSION}${PKG_TYPE}"
)
PKG_PRIORITY=main

#

PKG_PATCHES=(
	gcc/gcc-4.7-stdthreads.patch
	gcc/gcc-4.7-iconv.patch
	gcc/gcc-4.7-vswprintf.patch
	gcc/gcc-4.6-fix_mismatch_in_gnu_inline_attributes.patch
	gcc/gcc-4.7-wrong_include_search_path_composition.patch
	gcc/gcc-4.7-seg_fault_when_building_gcc.patch
)

#

PKG_CONFIGURE_FLAGS=(
	--host=$HOST
	--build=$BUILD
	--target=$TARGET
	#
	--prefix=$MINGWPREFIX
	--with-sysroot=$PREFIX
	--with-gxx-include-dir=$MINGWPREFIX/$TARGET/include/c++
	#
	$LINK_TYPE_GCC
	#
	$( [[ $USE_MULTILIB == yes ]] \
		&& echo "--enable-targets=all --enable-multilib" \
		|| echo "--disable-multilib" \
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
	$( [[ $EXCEPTIONS_MODEL == dwarf ]] \
		&& echo "--disable-sjlj-exceptions --with-dwarf2" \
	)
	$( [[ $EXCEPTIONS_MODEL == sjlj ]] \
		&& echo "--enable-sjlj-exceptions" \
	)
	#
	--disable-ppl-version-check
	--disable-cloog-version-check
	--disable-libstdcxx-pch
	--disable-libstdcxx-debug
	$( [[ $BOOTSTRAPING == yes ]] \
		&& echo "--enable-bootstrap" \
		|| echo "--disable-bootstrap" \
	)
	--disable-rpath
	--disable-win32-registry
	--disable-nls
	--disable-werror
	--disable-symvers
	#
	--with-gnu-as
	--with-gnu-ld
	#
	$PROCESSOR_OPTIMIZATION
	$PROCESSOR_TUNE
	#
	$( [[ $GCC_DEPS_LINK_TYPE == *--disable-shared* ]] \
		&& echo "--with-host-libstdcxx='-static -lstdc++'" \
	)
	--with-libiconv
	--with-system-zlib
	--with-{gmp,mpfr,mpc,ppl,cloog}=$PREREQ_DIR/$HOST-$LINK_TYPE_SUFFIX
	--with-pkgversion="\"$BUILD_ARCHITECTURE-$THREADS_MODEL-$EXCEPTIONS_MODEL${REV_STRING}, $MINGW_W64_PKG_STRING\""
	--with-bugurl=$BUG_URL
	#
	CFLAGS="\"$COMMON_CFLAGS\""
	CXXFLAGS="\"$COMMON_CXXFLAGS\""
	CPPFLAGS="\"$COMMON_CPPFLAGS\""
	LDFLAGS="\"$COMMON_LDFLAGS\""
	MAKEINFO=missing
	LD_FOR_TARGET=$PREFIX/bin/ld.exe
)

#

PKG_MAKE_FLAGS=(
	-j$JOBS
	all
)

#

PKG_INSTALL_FLAGS=(
	-j1
	DESTDIR=$BASE_BUILD_DIR
	$( [[ $STRIP_ON_INSTALL == yes ]] && echo install-strip || echo install )
)

# **************************************************************************
