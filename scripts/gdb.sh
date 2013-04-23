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

VERSION=7.5.1
NAME=gdb-${VERSION}
SRC_DIR_NAME=gdb-${VERSION}
URL=ftp://ftp.gnu.org/gnu/gdb/gdb-${VERSION}.tar.bz2
TYPE=.tar.bz2
PRIORITY=main

#REL_PYTHON_PATH=$(func_absolute_to_relative $PREFIX/bin $PREFIX/opt/bin)
#

PATCHES=()

#

CONFIGURE_FLAGS=(
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
	--with-python
	--with-expat
	--with-libiconv
	--with-zlib
	--disable-tui
	--disable-gdbtk
	#
	CFLAGS="\"$COMMON_CFLAGS -I$PREFIX/opt/include/python2.7\""
	CXXFLAGS="\"$COMMON_CXXFLAGS\""
	CPPFLAGS="\"$COMMON_CPPFLAGS\""
	LDFLAGS="\"$COMMON_LDFLAGS -L$PREFIX/opt/lib/python2.7/config\""
)

#

MAKE_FLAGS=(
	-j$JOBS
	all
)

#

INSTALL_FLAGS=(
	-j$JOBS
	install
)

# **************************************************************************
