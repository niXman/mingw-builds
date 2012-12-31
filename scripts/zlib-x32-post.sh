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
ZLIB_VERSION=$( grep 'VERSION=' $TOP_DIR/scripts/zlib.sh | sed 's|VERSION=||' )
ZLIB_ARCH=x32
OLD_PATH=$PATH
export PATH=$x32_HOST_MINGW_PATH/bin:$ORIGINAL_PATH

[[ ! -f $PREREQ_BUILD_DIR/$ARCHITECTURE-zlib-${ZLIB_VERSION}-post.marker ]] && {
		
	mkdir -p $PREREQ_DIR/$ARCHITECTURE-zlib-${ZLIB_VERSION}
	mkdir -p $CURR_LOGS_DIR/$ARCHITECTURE-zlib-${ZLIB_VERSION}
	
	cp -rf $SRCS_DIR/zlib-${ZLIB_VERSION} $PREREQ_BUILD_DIR || exit 1
	mv $PREREQ_BUILD_DIR/zlib-${ZLIB_VERSION} $PREREQ_BUILD_DIR/$ARCHITECTURE-zlib-${ZLIB_VERSION}
	
	cd $PREREQ_BUILD_DIR/$ARCHITECTURE-zlib-${ZLIB_VERSION}
	
	make -f win32/Makefile.gcc \
		CC=i686-w64-mingw32-gcc \
		AR=ar \
		RC=windres \
		DLLWRAP=dllwrap \
		STRIP=strip \
		-j$JOBS \
		all > $CURR_LOGS_DIR/$ARCHITECTURE-zlib-${ZLIB_VERSION}/make.log || exit 1
	
	make -f win32/Makefile.gcc \
		INCLUDE_PATH=$PREREQ_DIR/$ARCHITECTURE-zlib-${ZLIB_VERSION}/include \
		LIBRARY_PATH=$PREREQ_DIR/$ARCHITECTURE-zlib-${ZLIB_VERSION}/lib \
		BINARY_PATH=$PREREQ_DIR/$ARCHITECTURE-zlib-${ZLIB_VERSION}/bin \
		SHARED_MODE=1 \
		install > $CURR_LOGS_DIR/$ARCHITECTURE-zlib-${ZLIB_VERSION}/install.log || exit 1

	#rm -rf $ARCHITECTURE-zlib-${ZLIB_VERSION}/lib/libz.a
	
	touch $PREREQ_BUILD_DIR/$ARCHITECTURE-zlib-${ZLIB_VERSION}-post.marker
}

[[ ! -f $BUILDS_DIR/$ZLIB_ARCH-zlib-${ZLIB_VERSION}-post.marker ]] && {
	mkdir -p $PREFIX/bin $PREFIX/mingw
	[[ ($USE_MULTILIB == yes) && ($ARCHITECTURE == x64) ]] && {
		mkdir -p $PREFIX/$TARGET/{lib,lib32,include}

		cp -f $PREREQ_DIR/$ZLIB_ARCH-zlib-${ZLIB_VERSION}/lib/*.a $PREFIX/$TARGET/lib32/ || exit 1
		cp -f $PREREQ_DIR/$ZLIB_ARCH-zlib-${ZLIB_VERSION}/bin/zlib1.dll $PREFIX/$TARGET/lib32/ || exit 1

		mkdir -p $BUILDS_DIR/$GCC_NAME/$TARGET/32/{libgcc,libgfortran,libgomp,libitm,libquadmath,libssp,libstdc++-v3}
		echo $BUILDS_DIR/$GCC_NAME/$TARGET/32/{libgcc,libgfortran,libgomp,libitm,libquadmath,libssp,libstdc++-v3} \
			| xargs -n 1 cp $PREFIX/$TARGET/lib32/zlib1.dll || exit 1
	} || {
		mkdir -p $PREFIX/$TARGET/{lib,include}

		cp -rf $PREREQ_DIR/$ZLIB_ARCH-zlib-${ZLIB_VERSION}/* $PREFIX/ > /dev/null || exit 1

		cp -f $PREREQ_DIR/$ZLIB_ARCH-zlib-${ZLIB_VERSION}/lib/*.a $PREFIX/$TARGET/lib/ || exit 1
		cp -f $PREREQ_DIR/$ZLIB_ARCH-zlib-${ZLIB_VERSION}/include/*.h $PREFIX/$TARGET/include/ || exit 1
		cp -f $PREREQ_DIR/$ZLIB_ARCH-zlib-${ZLIB_VERSION}/bin/zlib1.dll $PREFIX/$TARGET/lib/ || exit 1

		COMMON_CFLAGS="$COMMON_CFLAGS -I$PREREQ_DIR/$ZLIB_ARCH-zlib-${ZLIB_VERSION}/include"
		COMMON_LDFLAGS="$COMMON_LDFLAGS -L$PREREQ_DIR/$ZLIB_ARCH-zlib-${ZLIB_VERSION}/lib"
	}
	cp -rf $PREFIX/$TARGET/* $PREFIX/mingw/ || exit 1
	touch $BUILDS_DIR/$ZLIB_ARCH-zlib-${ZLIB_VERSION}-post.marker
}

export PATH=$OLD_PATH

# **************************************************************************