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

VERSION=2.5.1
NAME=libgnurx-${VERSION}
SRC_DIR_NAME=mingw-libgnurx-${VERSION}
URL=https://sourceforge.net/projects/mingw/files/Other/UserContributed/regex/mingw-regex-${VERSION}/mingw-libgnurx-${VERSION}-src.tar.gz
TYPE=.tar.gz
PRIORITY=extra

#

PATCHES=(
	libgnurx/mingw32-libgnurx-honor-destdir.patch
)

#

EXECUTE_AFTER_PATCH=(
	"cp -rf $PATCHES_DIR/libgnurx/mingw32-libgnurx-configure.ac $SRCS_DIR/mingw-libgnurx-2.5.1/configure.ac"
	"cp -rf $PATCHES_DIR/libgnurx/mingw32-libgnurx-Makefile.am $SRCS_DIR/mingw-libgnurx-2.5.1/Makefile.am"
	"touch AUTHORS"
	"touch NEWS"
	"libtoolize --copy"
	"aclocal"
	"autoconf"
	"automake --add-missing"
)

#

CONFIGURE_FLAGS=(
	--host=$HOST
	--build=$BUILD
	--target=$TARGET
	#
	--prefix=$LIBS_DIR
	#
	$LINK_TYPE_STATIC
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
	install
)

EXECUTE_AFTER_INSTALL=(
	"cp -f $LIBS_DIR/lib/libgnurx.a $LIBS_DIR/lib/libregex.a"
)

# **************************************************************************
