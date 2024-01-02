
#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of MinGW-W64(mingw-builds: https://github.com/niXman/mingw-builds) project.
# Copyright (c) 2011-2023 by niXman (i dotty nixman doggy gmail dotty com)
# Copyright (c) 2012-2015 by Alexpux (alexpux doggy gmail dotty com)
# All rights reserved.
#
# Project: MinGW-Builds ( https://github.com/niXman/mingw-builds )
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

PKG_VERSION=13.2.0
PKG_NAME=gcc-${PKG_VERSION}
PKG_DIR_NAME=gcc-${PKG_VERSION}
PKG_TYPE=.tar.xz
PKG_URLS=(
	"https://ftpmirror.gnu.org/gnu/gcc/gcc-${PKG_VERSION}/gcc-${PKG_VERSION}${PKG_TYPE}"
)

PKG_PRIORITY=main

#

PKG_PATCHES=(
	gcc/gcc-5.1-iconv.patch
	gcc/gcc-4.8-libstdc++export.patch
	gcc/gcc-12-fix-for-windows-not-minding-non-existant-parent-dirs.patch
	gcc/gcc-5.1.0-make-xmmintrin-header-cplusplus-compatible.patch
	gcc/gcc-5-dwarf-regression.patch
	gcc/gcc-13.2.0-ktietz-libgomp.patch
	gcc/gcc-libgomp-ftime64.patch
	gcc/0020-libgomp-Don-t-hard-code-MS-printf-attributes.patch
	gcc/gcc-10-libgcc-ldflags.patch
	gcc/gcc-12-replace-abort-with-fancy_abort.patch
	gcc/gcc-13-mcf-sjlj-avoid-infinite-recursion.patch
)

#

PKG_CONFIGURE_FLAGS=(
	--host=$HOST
	--build=$BUILD
	--target=$TARGET
	#
	--prefix=$MINGWPREFIX
	--with-sysroot=$PREFIX
	#--with-gxx-include-dir=$MINGWPREFIX/$TARGET/include/c++
	#
	$LINK_TYPE_GCC
	#
	$( [[ $USE_MULTILIB == yes ]] \
		&& echo "--enable-targets=all --enable-multilib" \
		|| echo "--disable-multilib" \
	)
	$( [[ "$DISABLE_GCC_LTO" == yes ]] \
		&& echo "--enable-languages=$ENABLE_LANGUAGES" \
		|| echo "--enable-languages=$ENABLE_LANGUAGES,lto"
	)
	--enable-libstdcxx-time=yes
	--enable-threads=$THREADS_MODEL
	$( [[ $THREADS_MODEL == win32 ]] \
		&& echo "--enable-libstdcxx-threads=yes" \
	)
	--enable-libgomp
	--enable-libatomic
	$( [[ "$MSVCRT_PHOBOS_OK" == yes && "$D_LANG_ENABLED" == yes ]] \
		&& echo "--enable-libphobos"
	)
	$( [[ "$DISABLE_GCC_LTO" == yes ]] \
		&& echo "--disable-lto" \
		|| echo "--enable-lto"
	)
	--enable-graphite
	--enable-checking=release
	--enable-fully-dynamic-string
	--enable-version-specific-runtime-libs
	--enable-libstdcxx-filesystem-ts=yes
	$( [[ $EXCEPTIONS_MODEL == dwarf ]] \
		&& echo "--disable-sjlj-exceptions --with-dwarf2" \
	)
	$( [[ $EXCEPTIONS_MODEL == sjlj ]] \
		&& echo "--enable-sjlj-exceptions" \
	)
	#
	$( [[ $RUNTIME_MAJOR_VERSION -ge 11 ]] \
		&& echo "--disable-libssp" \
	)
	--disable-libstdcxx-pch
	--disable-libstdcxx-debug
	$( [[ $BOOTSTRAPING == yes ]] \
		&& echo "--enable-bootstrap" \
		|| echo "--disable-bootstrap" \
	)
	--disable-rpath
	--disable-win32-registry
	--enable-nls
	--with-libintl-prefix=/usr/lib
	--with-libintl-type=autostaticshared
	--with-included-gettext
	--disable-werror
	--disable-symvers
	#
	--with-gnu-as
	--with-gnu-ld
	#
	$PROCESSOR_OPTIMIZATION
	$PROCESSOR_TUNE
	#
	--with-libiconv
	--with-system-zlib
	--with-{gmp,mpfr,mpc,isl}=$PREREQ_DIR/$HOST-$LINK_TYPE_SUFFIX
	--with-pkgversion="\"$BUILD_ARCHITECTURE-$THREADS_MODEL-$EXCEPTIONS_MODEL${REV_STRING}, $MINGW_W64_PKG_STRING\""
	--with-bugurl=$BUG_URL
	#
	CFLAGS="\"$COMMON_CFLAGS\""
	CXXFLAGS="\"$COMMON_CXXFLAGS\""
	CPPFLAGS="\"$COMMON_CPPFLAGS\""
	LDFLAGS="\"$COMMON_LDFLAGS $( [[ $BUILD_ARCHITECTURE == i686 ]] && echo -Wl,--large-address-aware )\""
	LD_FOR_TARGET=$PREFIX/bin/ld.exe
	--with-boot-ldflags="\"$LDFLAGS -Wl,--disable-dynamicbase -static-libstdc++ -static-libgcc\""
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
