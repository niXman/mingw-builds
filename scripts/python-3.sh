
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

PKG_VERSION=3.9.10
PKG_NAME=Python-${PKG_VERSION}
PKG_DIR_NAME=Python-${PKG_VERSION}
PKG_TYPE=git
PKG_URLS=(
	"https://github.com/msys2-contrib/cpython-mingw.git|branch:mingw-v$PKG_VERSION|repo:$PKG_TYPE|module:$PKG_NAME"
)

PKG_PRIORITY=extra

#

PKG_EXECUTE_AFTER_UNCOMPRESS=(
	"git reset --hard 12d1cb5" # Reset to this commit hash for reproducible builds
)

#

PKG_PATCHES=(
	python3/0100-get-libraries-tuple-append-list.patch
)

#

PKG_EXECUTE_AFTER_PATCH=(
	"autoreconf -vfi"
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
	--prefix=$LIBSW_DIR
	#
	--enable-shared
	--with-system-expat
	--with-system-ffi
	# --with-system-libmpdec
	--enable-loadable-sqlite-extensions
	--without-ensurepip
	--without-c-locale-coercion
	# --with-tzpath=$LIBS_DIR/share/zoneinfo
	--enable-optimizations
	#
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
