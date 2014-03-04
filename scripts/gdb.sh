
#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of 'MinGW-W64' project.
# Copyright (c) 2011,2012,2013,2014 by niXman (i dotty nixman doggy gmail dotty com)
# Copyright (c) 2012,2013,2014 by Alexpux (alexpux doggy gmail dotty com)
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

PKG_VERSION=7.7
PKG_NAME=gdb-${PKG_VERSION}
PKG_DIR_NAME=gdb-${PKG_VERSION}
PKG_TYPE=.tar.bz2
PKG_URLS=(
	"ftp://ftp.gnu.org/gnu/gdb/gdb-${PKG_VERSION}.tar.bz2"
)

PKG_PRIORITY=main

#

PKG_PATCHES=(
	# https://sourceware.org/ml/gdb-patches/2013-11/msg00224.html
	gdb/gdb-fix-display-tabs-on-mingw.patch
	# https://sourceware.org/bugzilla/show_bug.cgi?id=15559
	gdb/gdb-mingw-gcc-4.7.patch
	# http://sourceware.org/bugzilla/show_bug.cgi?id=15412
	gdb/gdb-perfomance.patch
	# https://sourceware.org/bugzilla/show_bug.cgi?id=12127
#	gdb/gdb-python-fix-crash.patch
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
	--disable-nls
	--disable-werror
	--disable-win32-registry
	--disable-rpath
	#
	--with-system-gdbinit=$PREFIX/etc/gdbinit
	--with-python=$PREFIX/opt/bin/python-config.sh
	--with-expat
	--with-libiconv
	--with-zlib
	--disable-tui
	--disable-gdbtk
	#
	CFLAGS="\"$COMMON_CFLAGS -D__USE_MINGW_ANSI_STDIO=1\""
	CXXFLAGS="\"$COMMON_CXXFLAGS -D__USE_MINGW_ANSI_STDIO=1\""
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
	install
)

# **************************************************************************
