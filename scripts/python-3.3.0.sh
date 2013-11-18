#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of 'MinGW-W64' project.
# Copyright (c) 2011,2012,2013 by niXman (i dotty nixman doggy gmail dotty com)
# Copyright (c) 2012,2013 by Alexpux (alexpux doggy gmail dotty com)
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

PKG_VERSION=3.3.0
PKG_NAME=Python-${PKG_VERSION}
PKG_DIR_NAME=Python-${PKG_VERSION}
PKG_TYPE=.tar.bz2
PKG_URLS=(
	"http://www.python.org/ftp/python/${PKG_VERSION}/Python-${PKG_VERSION}.tar.bz2"
)

PKG_PRIORITY=extra

#

PKG_PATCHES=(
	Python/${PKG_VERSION}/0000-add-python-config-sh.patch
	Python/${PKG_VERSION}/0005-cross-fixes.patch
	Python/${PKG_VERSION}/0010-cross-darwin-feature.patch
	Python/${PKG_VERSION}/0030-py3k-20121004-MINGW.patch
	Python/${PKG_VERSION}/0031-py3k-20121004-MINGW-removal-of-pthread-patch.patch
	Python/${PKG_VERSION}/0032-py3k-20121004-MINGW-ntthreads.patch
	Python/${PKG_VERSION}/0033-py3k-mingw-ntthreads-vs-pthreads.patch
	Python/${PKG_VERSION}/0034-py3k-20121004-MINGW-removal-of-libffi-patch.patch
	Python/${PKG_VERSION}/0035-mingw-system-libffi.patch
	Python/${PKG_VERSION}/0045-mingw-use-posix-getpath.patch
	Python/${PKG_VERSION}/0050-mingw-sysconfig-like-posix.patch
	Python/${PKG_VERSION}/0055-mingw-_winapi_as_builtin_for_Popen_in_cygwinccompiler.patch
	Python/${PKG_VERSION}/0060-mingw-x86_64-size_t-format-specifier-pid_t.patch
	Python/${PKG_VERSION}/0065-cross-dont-add-multiarch-paths-if-cross-compiling.patch
	Python/${PKG_VERSION}/0070-mingw-use-backslashes-in-compileall-py.patch
	Python/${PKG_VERSION}/0075-msys-convert_path-fix-and-root-hack.patch
	Python/${PKG_VERSION}/0080-mingw-hack-around-double-copy-scripts-issue.patch
	Python/${PKG_VERSION}/0085-allow-static-tcltk.patch
	Python/${PKG_VERSION}/0090-CROSS-avoid-ncursesw-include-path-hack.patch
	Python/${PKG_VERSION}/0091-CROSS-properly-detect-WINDOW-_flags-for-different-nc.patch
	Python/${PKG_VERSION}/0092-mingw-pdcurses_ISPAD.patch
	Python/${PKG_VERSION}/0095-no-xxmodule-for-PYDEBUG.patch
	Python/${PKG_VERSION}/0100-grammar-fixes.patch
	Python/${PKG_VERSION}/0105-builddir-fixes.patch
	Python/${PKG_VERSION}/0110-msys-monkeypatch-os-system-via-sh-exe.patch
	Python/${PKG_VERSION}/0115-msys-replace-slashes-used-in-io-redirection.patch
	Python/${PKG_VERSION}/9999-re-configure-d.patch
)

#

PKG_EXECUTE_AFTER_PATCH=(
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

[[ -d $PREREQ_DIR ]] && {
	pushd $PREREQ_DIR > /dev/null
	PREREQW_DIR=`pwd -W`
	popd > /dev/null
}

LIBFFI_VERSION=$( grep 'PKG_VERSION=' $TOP_DIR/scripts/libffi.sh | sed 's|PKG_VERSION=||' )
MY_CPPFLAGS="-I$LIBSW_DIR/include -I$LIBSW_DIR/include/ncursesw -I$PREREQW_DIR/$BUILD_ARCHITECTURE-zlib-$LINK_TYPE_SUFFIX/include"

# Workaround for conftest error on 64-bit builds
export ac_cv_working_tzset=no

#

PKG_CONFIGURE_FLAGS=(
	--host=$HOST
	--build=$BUILD
	#
	--prefix=$LIBS_DIR
	#
	--enable-shared
	--without-pydebug
	--with-system-expat
	--with-system-ffi
	--enable-loadable-sqlite-extensions
	#
	CC="$HOST-gcc"
	LIBFFI_INCLUDEDIR="$LIBSW_DIR/lib/libffi-$LIBFFI_VERSION/include"
	CFLAGS="\"$COMMON_CFLAGS -D__USE_MINGW_ANSI_STDIO=1\""
	CPPFLAGS="\"$COMMON_CPPFLAGS $MY_CPPFLAGS\""
	LDFLAGS="\"$COMMON_LDFLAGS -L$PREREQW_DIR/$BUILD_ARCHITECTURE-zlib-$LINK_TYPE_SUFFIX/lib -L$LIBSW_DIR/lib\""
)

#

PKG_MAKE_FLAGS=(
	-j$JOBS
	all
)

#

PKG_INSTALL_FLAGS=(
	install
)

#

[[ $BUILD_MODE == gcc || $BUILD_MODE == python ]] && {
	[[ $BUILD_MODE == gcc ]] && {
		RM_PYTHON_TEST_DIR_CMD="rm -rf $LIBS_DIR/lib/python?.?/test"
	} || {
		RM_PYTHON_TEST_DIR_CMD="rm -rf $PREFIX/lib/python?.?/test"
	}
}

PKG_EXECUTE_AFTER_INSTALL=(
	"$RM_PYTHON_TEST_DIR_CMD"
)

# **************************************************************************
