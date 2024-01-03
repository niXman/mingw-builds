
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

PKG_VERSION=$( [[ `echo $BUILD_VERSION | cut -d. -f1` == 4 || `echo $BUILD_VERSION | cut -d. -f1` == 5 ]] && { echo 7.12; } || { echo 11.2; } )
PKG_NAME=gdb-${PKG_VERSION}
PKG_DIR_NAME=gdb-${PKG_VERSION}
PKG_TYPE=.tar.xz
PKG_URLS=(
	"https://ftpmirror.gnu.org/gnu/gdb/gdb-${PKG_VERSION}${PKG_TYPE}"
)

PKG_PRIORITY=extra

#

PKG_PATCHES=(
	# https://sourceware.org/bugzilla/show_bug.cgi?id=15559
	#gdb/gdb-7.9-mingw-gcc-4.7.patch
	# http://sourceware.org/bugzilla/show_bug.cgi?id=15412
	gdb/gdb-perfomance.patch
	$( [[ ${PKG_VERSION} == 7.12 ]] && { echo "gdb/gdb-7.12-fix-using-gnu-print.patch"; } || { echo "gdb/gdb-fix-using-gnu-print.patch"; } )
	$( [[ ${PKG_VERSION} == 7.12 ]] && { echo "gdb/gdb-7.12-dynamic-libs.patch"; } || { echo "gdb/gdb-8.3.1-dynamic-libs.patch"; } )
	$( [[ ${PKG_VERSION} == 10.2 ]] && { echo "gdb/gdb-10.2-fix-gnulib-dependencies.patch"; } )
)

#

PKG_CONFIGURE_FLAGS=(
	--host=$HOST
	--build=$TARGET
	--prefix=$PREFIX
	#
	--enable-targets=$ENABLE_TARGETS
	--enable-64-bit-bfd
	#
	--enable-nls
	--disable-werror
	--disable-win32-registry
	--disable-rpath
	#
	--with-system-gdbinit=$PREFIX/etc/gdbinit
	--with-python=$PREFIX/opt/bin/python3.exe
	--with-expat
	--with-libiconv
	--with-zlib
	--enable-tui
	--disable-gdbtk
	#
	# the _WIN32_WINNT hack here because of: https://sourceware.org/pipermail/gdb/2022-November/050432.html
	CFLAGS="\"$COMMON_CFLAGS -I$LIBS_DIR/include/ncursesw -D__USE_MINGW_ANSI_STDIO=1 -fcommon -DNCURSES_STATIC -D_WIN32_WINNT=0x0601\""
	CXXFLAGS="\"$COMMON_CXXFLAGS -I$LIBS_DIR/include/ncursesw -D__USE_MINGW_ANSI_STDIO=1 -DNCURSES_STATIC -D_WIN32_WINNT=0x0601\""
	CPPFLAGS="\"$COMMON_CPPFLAGS -I$LIBS_DIR/include/ncursesw -D__USE_MINGW_ANSI_STDIO=1 -DNCURSES_STATIC -D_WIN32_WINNT=0x0601\""
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
