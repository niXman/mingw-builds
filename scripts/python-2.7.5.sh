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

VERSION=2.7.5
NAME=Python-${VERSION}
SRC_DIR_NAME=Python-${VERSION}
TYPE=.tar.bz2
URL=(
	"http://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tar.bz2"
)

PRIORITY=extra

#

PATCHES=(
	Python/${VERSION}/0005-MINGW.patch
	Python/${VERSION}/0006-mingw-removal-of-libffi-patch.patch
	Python/${VERSION}/0007-mingw-system-libffi.patch
	Python/${VERSION}/0010-mingw-osdefs-DELIM.patch	
	Python/${VERSION}/0015-mingw-use-posix-getpath.patch
	Python/${VERSION}/0020-mingw-w64-test-for-REPARSE_DATA_BUFFER.patch
	Python/${VERSION}/0025-mingw-regen-with-stddef-instead.patch
	Python/${VERSION}/0030-mingw-add-libraries-for-_msi.patch
	Python/${VERSION}/0035-MSYS-add-MSYSVPATH-AC_ARG.patch
	Python/${VERSION}/0040-mingw-cygwinccompiler-use-CC-envvars-and-ld-from-print-prog-name.patch
	Python/${VERSION}/0045-cross-darwin.patch
	Python/${VERSION}/0050-mingw-sysconfig-like-posix.patch
	Python/${VERSION}/0055-mingw-pdcurses_ISPAD.patch
	Python/${VERSION}/0060-mingw-static-tcltk.patch
	Python/${VERSION}/0065-mingw-x86_64-size_t-format-specifier-pid_t.patch
	Python/${VERSION}/0070-python-disable-dbm.patch
	Python/${VERSION}/0075-add-python-config-sh.patch
	Python/${VERSION}/0080-mingw-nt-threads-vs-pthreads.patch
	Python/${VERSION}/0085-cross-dont-add-multiarch-paths-if.patch
	Python/${VERSION}/0090-mingw-reorder-bininstall-ln-symlink-creation.patch
	Python/${VERSION}/0095-mingw-use-backslashes-in-compileall-py.patch
	Python/${VERSION}/0100-mingw-distutils-MSYS-convert_path-fix-and-root-hack.patch
	Python/${VERSION}/0105-mingw-MSYS-no-usr-lib-or-usr-include.patch
	Python/${VERSION}/0110-mingw-_PyNode_SizeOf-decl-fix.patch
	Python/${VERSION}/0115-mingw-cross-includes-lower-case.patch
	Python/${VERSION}/0500-mingw-install-LDLIBRARY-to-LIBPL-dir.patch
	Python/${VERSION}/0505-add-build-sysroot-config-option.patch
	Python/${VERSION}/0510-cross-PYTHON_FOR_BUILD-gteq-275-and-fullpath-it.patch
	Python/${VERSION}/0515-mingw-add-GetModuleFileName-path-to-PATH.patch
	Python/${VERSION}/0520-Add-interp-Python-DESTSHARED-to-PYTHONPATH-b4-pybuilddir-txt-dir.patch
	Python/${VERSION}/0525-msys-monkeypatch-os-system-via-sh-exe.patch
	Python/${VERSION}/9999-re-configure-d.patch
)

#

EXECUTE_AFTER_PATCH=(
	"rm -rf Modules/expat"
	"rm -rf Modules/_ctypes/libffi*"
	"rm -rf Modules/zlib"
	"autoconf"
	"autoheader"
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

[[ -d $PREREQ_DIR ]] && {
	pushd $PREREQ_DIR > /dev/null
	PREREQW_DIR=`pwd -W`
	popd > /dev/null
}

LIBFFI_VERSION=$( grep 'VERSION=' $TOP_DIR/scripts/libffi.sh | sed 's|VERSION=||' )
MY_CPPFLAGS="-I$LIBSW_DIR/include -I$LIBSW_DIR/include/ncurses -I$PREREQW_DIR/$ARCHITECTURE-zlib/include -I$PREFIXW/opt/include"

# Workaround for conftest error on 64-bit builds
export ac_cv_working_tzset=no
#

CONFIGURE_FLAGS=(
	--host=$HOST
	--build=$BUILD
	#
	--prefix=$([[ $PYTHON_ONLY_MODE == no ]] && echo $PREFIX/opt || echo $PREFIX)
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
	LDFLAGS="\"$COMMON_LDFLAGS -L$PREREQW_DIR/$ARCHITECTURE-zlib/lib -L$PREFIXW/opt/lib -L$LIBSW_DIR/lib\""
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
