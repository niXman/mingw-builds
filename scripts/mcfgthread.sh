
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

PKG_VERSION=2.5-ga.1
PKG_NAME=$PKG_ARCHITECTURE-mcfgthread-${PKG_VERSION}
PKG_DIR_NAME=mcfgthread-${PKG_VERSION}
PKG_TYPE=.tar.gz
PKG_URLS=(
	"https://github.com/lhmouse/mcfgthread/archive/refs/tags/v${PKG_VERSION}${PKG_TYPE}"
)

PKG_PRIORITY=prereq

#

PKG_PATCHES=()

#

ABI_MAJOR=$(echo $PKG_VERSION | sed -E 's/([^.]+)\.([^.]+)-([^.]+).*/\1/')
ABI_MINOR=$(echo $PKG_VERSION | sed -E 's/([^.]+)\.([^.]+)-([^.]+).*/\2/')
ABI_STRING=$(echo $PKG_VERSION | sed -E 's/([^.]+)\.([^.]+)-([^.]+).*/\1.\2.\3/')

PKG_EXECUTE_AFTER_CONFIGURE=(
	"sed 's/@abi_major@/$ABI_MAJOR/g; s/@abi_minor@/$ABI_MINOR/g; s/@abi_string@/$ABI_STRING/g' $SRCS_DIR/$PKG_DIR_NAME/mcfgthread/version.h.in > version.h"
)

#

PKG_MAKE_FLAGS=(
	-f "$PATCHES_DIR/mcfgthread/Makefile"
	-j$JOBS
	all
	CC=gcc
	AR=ar
	DLLTOOL=dlltool
	STRIP=strip
	RC=windres
	CFLAGS="\"$COMMON_CFLAGS\""
	CXXFLAGS="\"$COMMON_CXXFLAGS\""
	CPPFLAGS="\"$COMMON_CPPFLAGS\""
	LDFLAGS="\"$COMMON_LDFLAGS\""
	ABI_MAJOR=$ABI_MAJOR
	SOURCE_DIR="$SRCS_DIR/$PKG_DIR_NAME/mcfgthread"
	DEF_SUFFIX="$( [[ $PKG_ARCHITECTURE == i686 ]] && echo .i386 )"
)

#

PKG_INSTALL_FLAGS=(
	-f "$PATCHES_DIR/mcfgthread/Makefile"
	-j$JOBS
	$( [[ $STRIP_ON_INSTALL == yes ]] && echo install-strip || echo install )
	STRIP=strip
	DESTDIR="$PREREQ_DIR/$PKG_ARCHITECTURE-mcfgthread"
	ABI_MAJOR=$ABI_MAJOR
	SOURCE_DIR="$SRCS_DIR/$PKG_DIR_NAME/mcfgthread"
)

# **************************************************************************
