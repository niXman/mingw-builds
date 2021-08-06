
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

PKG_VERSION=8.6.11
PKG_NAME=tk${PKG_VERSION}
PKG_DIR_NAME=tk${PKG_VERSION}
PKG_SUBDIR_NAME=win
PKG_TYPE=.tar.gz
PKG_URLS=(
	"http://prdownloads.sourceforge.net/tcl/tk${PKG_VERSION}-src${PKG_TYPE}"
)

PKG_PRIORITY=extra

#

PKG_PATCHES=(
	tk/003-fix-forbidden-colon-in-paths.mingw.patch
	tk/004-install-man.mingw.patch
	tk/006-prevent-tclStubsPtr-segfault.patch
	$([[ $RUNTIME_VERSION == v1 || $RUNTIME_VERSION == v2 ]] && echo "tk/007-mingw-w64-compatibility-fix.patch")
	tk/008-dont-link-shared-with--static-libgcc.patch
)

#

PKG_EXECUTE_AFTER_PATCH=(
	"cd win && autoreconf -fi"
)

#

PKG_CONFIGURE_FLAGS=(
	--host=$HOST
	--build=$BUILD
	--target=$TARGET
	#
	--prefix=$LIBS_DIR
	--with-tcl=$LIBS_DIR/lib
	#
	--enable-shared
	#
	$( [[ $BUILD_ARCHITECTURE == x86_64 ]] \
		&& echo "--enable-64bit"
	)
	#
)

#

PKG_EXECUTE_AFTER_CONFIGURE=(
	"sed -i -e 's,mingw-tcl,tcl,g' win/Makefile"
	"sed -i -e 's,/usr/include,$LIBS_DIR/include,g' win/Makefile"
#	"sed -i -e 's,libtclstub86.a,libtclstub86.dll.a,g' win/Makefile"
#	"sed -i -e 's,tcl8.5/libtclstub86,libtclstub86,g' win/Makefile"
	"sed -i -e 's,libtcl86.a,libtcl86.dll.a,g' win/Makefile"
	"sed -i -e 's,tcl8.6/libtcl86,libtcl86,g' win/Makefile"
)

#

PKG_MAKE_FLAGS=(
	-j$JOBS
	TCL_LIBRARY=$LIBS_DIR/lib/tk8.6
	all
)

#

PKG_TESTSUITE_FLAGS=(
	-j$JOBS
	test
)

#

PKG_INSTALL_FLAGS=(
	-j$JOBS
	TK_LIBRARY=$LIBS_DIR/lib/tk8.6
	install
)

#

PKG_EXECUTE_AFTER_INSTALL=(
	"ln -s $LIBS_DIR/bin/wish86.exe $LIBS_DIR/bin/wish.exe"
#	"mv $LIBS_DIR/lib/libtk86.a $LIBS_DIR/lib/libtk86.dll.a"
#	"mv $LIBS_DIR/lib/libtkstub86.a $LIBS_DIR/lib/libtkstub86.dll.a"
	"ln -s $LIBS_DIR/lib/libtk86.dll.a $LIBS_DIR/lib/libtk.dll.a"
	"ln -s $LIBS_DIR/lib/tkConfig.sh $LIBS_DIR/lib/tk8.6/tkConfig.sh"
	"mkdir -p $LIBS_DIR/include/tk-private/{generic,win}"
	"find $SRCS_DIR/$PKG_DIR_NAME/generic $SRCS_DIR/$PKG_DIR_NAME/win -name \"*.h\" -exec cp -p '{}' $LIBS_DIR/include/tcl-private/'{}' ';'"
)

# **************************************************************************
