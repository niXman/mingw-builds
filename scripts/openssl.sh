
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

PKG_VERSION=1.0.1f
PKG_NAME=openssl-${PKG_VERSION}
PKG_DIR_NAME=openssl-${PKG_VERSION}
PKG_TYPE=.tar.gz
PKG_URLS=(
	"http://www.openssl.org/source/openssl-${PKG_VERSION}.tar.gz"
)

PKG_PRIORITY=extra
PKG_LNDIR=yes
PKG_CONFIGURE_SCRIPT=Configure
#

PKG_PATCHES=(
	openssl/openssl-1.0.0a-ldflags.patch
	openssl/openssl-1.0.0d-windres.patch
	openssl/openssl-1.0.0h-pkg-config.patch
	openssl/openssl-1.0.1-parallel-build.patch
	openssl/openssl-1.0.1-x32.patch
	openssl/openssl-0.9.6-x509.patch
	openssl/openssl-1.0.1f-manfix.patch
)

#

PKG_CONFIGURE_FLAGS=(
	--prefix=$LIBS_DIR
	#
	shared
	threads
	zlib
	enable-camellia
	enable-idea
	enable-mdc2
	enable-tlsext
	enable-rfc3779
	$( [[ $BUILD_ARCHITECTURE == i686 ]] \
		&& echo "mingw" \
		|| echo "mingw64" \
	)
)

#

PKG_MAKE_FLAGS=(
	-j$JOBS
	ZLIB_INCLUDE="\"-I$PREREQW_DIR/$BUILD_ARCHITECTURE-zlib-$LINK_TYPE_SUFFIX/include\""
	depend
	all
)

#

PKG_INSTALL_FLAGS=(
	-j$JOBS
	install
)

# **************************************************************************
