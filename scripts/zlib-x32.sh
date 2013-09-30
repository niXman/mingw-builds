
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

PKG_VERSION=1.2.8
PKG_NAME=i686-zlib-${PKG_VERSION}-$LINK_TYPE_SUFFIX
PKG_DIR_NAME=zlib-${PKG_VERSION}
PKG_TYPE=.tar.gz
PKG_URLS=(
	"http://sourceforge.net/projects/libpng/files/zlib/${PKG_VERSION}/zlib-${PKG_VERSION}.tar.gz"
)

PKG_PRIORITY=prereq

#

PKG_PATCHES=(
	zlib/01-zlib-1.2.7-1-buildsys.mingw.patch
	zlib/02-no-undefined.mingw.patch
	zlib/03-dont-put-sodir-into-L.mingw.patch
	zlib/04-wrong-w8-check.mingw.patch
	zlib/05-fix-a-typo.mingw.patch
)

#

PKG_EXECUTE_AFTER_PATCH=(
	"mkdir -p $PREREQ_BUILD_DIR/i686-$PKG_DIR_NAME"
	"mkdir -p $PREREQ_BUILD_DIR/x86_64-$PKG_DIR_NAME"
	"lndir $SRCS_DIR/$PKG_DIR_NAME $PREREQ_BUILD_DIR/i686-$PKG_DIR_NAME"
	"lndir $SRCS_DIR/$PKG_DIR_NAME $PREREQ_BUILD_DIR/x86_64-$PKG_DIR_NAME"
)

#

PKG_CONFIGURE_FLAGS=(
	--prefix=$PREREQ_DIR/i686-zlib-$LINK_TYPE_SUFFIX
	$( [[ $GCC_DEPS_LINK_TYPE == $LINK_TYPE_SHARED ]] \
		&& echo "--shared" \
		|| echo "--static" \
	)
)

#

PKG_MAKE_FLAGS=(
	-j$JOBS
	STRIP=true
	all
)

#

PKG_INSTALL_FLAGS=(
	STRIP=true
	install
)

# **************************************************************************
