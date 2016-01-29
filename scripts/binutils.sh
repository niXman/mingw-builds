
#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of 'MinGW-W64' project.
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

PKG_VERSION=2.25
PKG_NAME=binutils-${PKG_VERSION}
[[ $USE_MULTILIB == yes ]] && {
	PKG_NAME=$BUILD_ARCHITECTURE-$PKG_NAME-multi
} || {
	PKG_NAME=$BUILD_ARCHITECTURE-$PKG_NAME-nomulti
}
PKG_DIR_NAME=binutils-${PKG_VERSION}
PKG_TYPE=.tar.bz2
PKG_URLS=(
	"https://ftp.gnu.org/gnu/binutils/binutils-${PKG_VERSION}.tar.bz2"
)

PKG_PRIORITY=prereq

#

PKG_PATCHES=(
	binutils/0001-enable-gold-on.mingw32.patch
	binutils/0002-check-for-unusual-file-harder.patch
	binutils/0008-fix-libiberty-makefile.mingw.patch
	binutils/0009-fix-libiberty-configure.mingw.patch
	binutils/0110-binutils-mingw-gnu-print.patch
	binutils/9ac47a4.diff
	binutils/27aaeda.diff
	binutils/a93d5cb.diff
	binutils/fixes-a-problem-recognizing-libraries-created-by-VS.patch
	binutils/binutils-IMPORT_DATA-fix-2.patch
)
# Note: binutis-IMPORT_DATA-fix-2.patch is not included the master
# branch of upstream binutils at this time:
# https://sourceware.org/bugzilla/show_bug.cgi?id=19541

#

[[ $USE_MULTILIB == yes ]] && {
	BINUTILSPREFIX=$PREREQ_DIR/$BUILD_ARCHITECTURE-binutils-multi
	RUNTIMEPREFIX=$RUNTIME_DIR/$BUILD_ARCHITECTURE-mingw-w64-multi
} || {
	BINUTILSPREFIX=$PREREQ_DIR/$BUILD_ARCHITECTURE-binutils-nomulti
	RUNTIMEPREFIX=$RUNTIME_DIR/$BUILD_ARCHITECTURE-mingw-w64-nomulti
}

PKG_CONFIGURE_FLAGS=(
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
	$( [[ $ARCHITECTURE == x86_64 ]] \
		&& echo "--enable-64-bit-bfd" \
	)
	#
	--enable-lto
	--enable-plugins
	--enable-gold
	--enable-install-libiberty
	#
	--with-libiconv-prefix=$PREREQ_DIR/$BUILD_ARCHITECTURE-libiconv-$LINK_TYPE_SUFFIX
	#
	--disable-rpath
	--disable-nls
	--disable-shared
	#
	$LINK_TYPE_GCC
	#
	CFLAGS="\"$COMMON_CFLAGS\""
	CXXFLAGS="\"$COMMON_CXXFLAGS\""
	CPPFLAGS="\"$COMMON_CPPFLAGS\""
	LDFLAGS="\"$COMMON_LDFLAGS $( [[ $BUILD_ARCHITECTURE == i686 ]] && echo -Wl,--large-address-aware )\""
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
