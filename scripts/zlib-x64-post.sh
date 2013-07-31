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
ZLIB_VERSION=$( grep 'VERSION=' $TOP_DIR/scripts/zlib.sh | sed 's|VERSION=||' )
ZLIB_ARCH=x64
OLD_PATH=$PATH
export PATH=$x64_HOST_MINGW_PATH/bin:$ORIGINAL_PATH

[[ ! -f $PREREQ_BUILD_DIR/$ZLIB_ARCH-zlib-${ZLIB_VERSION}-post.marker ]] && {
		
	mkdir -p $PREREQ_DIR/$ZLIB_ARCH-zlib
	mkdir -p $CURR_LOGS_DIR/$ZLIB_ARCH-zlib-${ZLIB_VERSION}
	
	cp -rf $SRCS_DIR/zlib-${ZLIB_VERSION} $PREREQ_BUILD_DIR || exit 1
	mv $PREREQ_BUILD_DIR/zlib-${ZLIB_VERSION} $PREREQ_BUILD_DIR/$ZLIB_ARCH-zlib-${ZLIB_VERSION}
	
	cd $PREREQ_BUILD_DIR/$ZLIB_ARCH-zlib-${ZLIB_VERSION}
	
	make -f win32/Makefile.gcc \
		CC=x86_64-w64-mingw32-gcc \
		AR=ar \
		RC=windres \
		DLLWRAP=dllwrap \
		-j$JOBS \
		all > $CURR_LOGS_DIR/$ZLIB_ARCH-zlib-${ZLIB_VERSION}/make.log || exit 1
	
	make -f win32/Makefile.gcc \
		INCLUDE_PATH=$PREREQ_DIR/$ZLIB_ARCH-zlib/include \
		LIBRARY_PATH=$PREREQ_DIR/$ZLIB_ARCH-zlib/lib \
		BINARY_PATH=$PREREQ_DIR/$ZLIB_ARCH-zlib/bin \
		install > $CURR_LOGS_DIR/$ZLIB_ARCH-zlib-${ZLIB_VERSION}/install.log || exit 1
	
	touch $PREREQ_BUILD_DIR/$ZLIB_ARCH-zlib-${ZLIB_VERSION}-post.marker
}

[[ ! -f $BUILDS_DIR/$ZLIB_ARCH-zlib-post.marker ]] && {
	mkdir -p $PREFIX/bin $PREFIX/mingw
	[[ ($USE_MULTILIB == yes) && ($BUILD_ARCHITECTURE == x32) ]] && {
		mkdir -p $PREFIX/$TARGET/lib64

		cp -f $PREREQ_DIR/$ZLIB_ARCH-zlib/lib/*.a $PREFIX/$TARGET/lib64/ || exit 1
	} || {
		mkdir -p $PREFIX/$TARGET/{lib,include}

		cp -f $PREREQ_DIR/$ZLIB_ARCH-zlib/lib/*.a $PREFIX/$TARGET/lib/ || exit 1
		cp -f $PREREQ_DIR/$ZLIB_ARCH-zlib/include/*.h $PREFIX/$TARGET/include/ || exit 1
	}
	cp -rf $PREFIX/$TARGET/* $PREFIX/mingw/ || exit 1
	touch $BUILDS_DIR/$ZLIB_ARCH-zlib-post.marker
}

export PATH=$OLD_PATH

# **************************************************************************
