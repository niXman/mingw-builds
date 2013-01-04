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

VERSION=2.7.3
NAME=Python-${VERSION}
SRC_DIR_NAME=Python-${VERSION}
URL=http://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tar.bz2
TYPE=.tar.bz2
PRIORITY=extra

#

PATCHES=(
	Python-${VERSION}/0000-CROSS.patch
	Python-${VERSION}/0005-MINGW.patch
	Python-${VERSION}/0006-mingw-removal-of-libffi-patch.patch
	Python-${VERSION}/0007-mingw-system-libffi.patch	
	Python-${VERSION}/0010-mingw-use-posix-getpath.patch
	Python-${VERSION}/0015-cross-darwin.patch
	Python-${VERSION}/0020-mingw-sysconfig-like-posix.patch
	Python-${VERSION}/0025-mingw-pdcurses_ISPAD.patch
	Python-${VERSION}/0030-mingw-static-tcltk.patch
	Python-${VERSION}/0035-mingw-x86_64-size_t-format-specifier-pid_t.patch
	Python-${VERSION}/0040-python-disable-dbm.patch
	Python-${VERSION}/0045-disable-grammar-dependency-on-pgen-executable.patch
	Python-${VERSION}/0050-add-python-config-sh.patch
	Python-${VERSION}/0055-mingw-nt-threads-vs-pthreads.patch
	Python-${VERSION}/0060-cross-dont-add-multiarch-paths-if.patch
	Python-${VERSION}/0065-mingw-reorder-bininstall-ln-symlink-creation.patch
	Python-${VERSION}/0070-mingw-use-backslashes-in-compileall-py.patch
	Python-${VERSION}/0075-mingw-distutils-MSYS-convert_path-fix-and-root-hack.patch
	Python-${VERSION}/0100-upgrade-internal-libffi-to-3.0.11.patch
)

#

EXECUTE_AFTER_PATCH=(
	"rm -rf Modules/expat"
	"rm -rf Modules/_ctypes/libffi*"
	"rm -rf Modules/zlib"
	"autoconf"
	"autoheader"
	"rm pyconfig.h.in~"
	"rm -rf autom4te.cache"
	"touch Include/graminit.h"
	"touch Python/graminit.c"
	"touch Parser/Python.asdl"
	"touch Parser/asdl.py"
	"touch Parser/asdl_c.py"
	"touch Include/Python-ast.h"
	"touch Python/Python-ast.c"
	"echo \"\" > Parser/pgen.stamp"
)

#

[[ -d $LIBS_DIR ]] && {
	pushd $LIBS_DIR > /dev/null
	LIBSW_DIR=`pwd -W`
	popd > /dev/null
}

[[ -d $PREFIX ]] && {
	pushd $PREFIX > /dev/null
	PREFIXW=`pwd -W`
	popd > /dev/null
}

LIBFFI_VERSION=$( grep 'VERSION=' $TOP_DIR/scripts/libffi.sh | sed 's|VERSION=||' )
MY_CPPFLAGS="-I$LIBSW_DIR/include -I$LIBSW_DIR/include/ncurses -I$ZLIB_WINST/include -I$PREFIXW/opt/include"

# Workaround for conftest error on 64-bit builds
export ac_cv_working_tzset=no
#

CONFIGURE_FLAGS=(
	--host=$HOST
	--build=$BUILD
	#
	--prefix=$PREFIX/opt
	#
	--enable-shared
	--disable-ipv6
	--without-pydebug
	--with-system-expat
	--with-system-ffi
	#
	CXX="$HOST-g++"
	LIBFFI_INCLUDEDIR="$LIBSW_DIR/lib/libffi-$LIBFFI_VERSION/include"
	OPT=""
	CFLAGS="\"$COMMON_CFLAGS -fwrapv -DNDEBUG -D__USE_MINGW_ANSI_STDIO=1\""
	CXXFLAGS="\"$COMMON_CXXFLAGS -fwrapv -DNDEBUG -D__USE_MINGW_ANSI_STDIO=1 $MY_CPPFLAGS\""
	CPPFLAGS="\"$COMMON_CPPFLAGS $MY_CPPFLAGS\""
	LDFLAGS="\"$COMMON_LDFLAGS -L$ZLIB_WINST/lib -L$PREFIXW/opt/lib -L$LIBSW_DIR/lib\""
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

# **************************************************************************
