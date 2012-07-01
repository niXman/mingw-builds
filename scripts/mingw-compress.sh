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

case $GCC_NAME in
	gcc-*-branch|gcc-trunk|gcc-cxx-trunk)
		GCC_REVISION="-rev-$(cd $SRCS_DIR/$GCC_NAME; svn info | grep 'Revision: ' | sed 's|Revision: ||')"
	;;
	*)
		GCC_REVISION=""
	;;
esac

ARCHIVE_NAME=$TOP_DIR/../$([[ $ARCHITECTURE == x32 ]] && echo i686 || echo x86_64)-mingw-w64
case $GCC_NAME in
	gcc-?.?.?)			ARCHIVE_NAME=$ARCHIVE_NAME-$GCC_NAME-release-$ENABLE_LANGUAGES ;;
	gcc-4_6-branch)	ARCHIVE_NAME=$ARCHIVE_NAME-gcc-4.6.4-prerelease-$(date +%Y%m%d)$GCC_REVISION-$ENABLE_LANGUAGES ;;
	gcc-4_7-branch)	ARCHIVE_NAME=$ARCHIVE_NAME-gcc-4.7.2-prerelease-$(date +%Y%m%d)$GCC_REVISION-$ENABLE_LANGUAGES ;;
	gcc-4_8-branch)	ARCHIVE_NAME=$ARCHIVE_NAME-gcc-4.8.1-prerelease-$(date +%Y%m%d)$GCC_REVISION-$ENABLE_LANGUAGES ;;
	gcc-4_9-branch)	ARCHIVE_NAME=$ARCHIVE_NAME-gcc-4.9.1-prerelease-$(date +%Y%m%d)$GCC_REVISION-$ENABLE_LANGUAGES ;;
	gcc-cxx-trunk)		ARCHIVE_NAME=$ARCHIVE_NAME-gcc-4.8.1-prerelease-$(date +%Y%m%d)$GCC_REVISION-$ENABLE_LANGUAGES ;;
	gcc-trunk)			ARCHIVE_NAME=$ARCHIVE_NAME-gcc-4.8.0-snapshot-$(date +%Y%m%d)$GCC_REVISION-$ENABLE_LANGUAGES ;;
	#gcc-trunk)			 ARCHIVE_NAME=$ARCHIVE_NAME-gcc-4.9.0-snapshot-$(date +%Y%m%d)$GCC_REVISION-$ENABLE_LANGUAGES ;;
	*) echo "gcc name error: $GCC_NAME. terminate."; exit ;;
esac

[[ $USE_MULTILIB_MODE == yes ]] && {
	ARCHIVE_NAME=$ARCHIVE_NAME-multilib
} || {
	ARCHIVE_NAME=$ARCHIVE_NAME-nomultilib
}

[[ $USE_DWARF_EXCEPTIONS == no ]] && {
	ARCHIVE_NAME=$ARCHIVE_NAME-sjlj
} || {
	ARCHIVE_NAME=$ARCHIVE_NAME-dwarf
}

#echo "ARCHIVE_NAME: $ARCHIVE_NAME"

SEVENZIP_ARCHIVE_NAME=$ARCHIVE_NAME.7z
ZIP_ARCHIVE_NAME=$ARCHIVE_NAME.zip

[[ ! -f $SEVENZIP_ARCHIVE_NAME || ! -f $ZIP_ARCHIVE_NAME ]] && {
	MINGW_COPY_MARKER=$BUILDS_DIR/mingw-copy.marker
	MINGW_ROOT=$BUILDS_DIR/mingw

	echo "-> compressing $PREFIX"
	[[ ! -f $MINGW_COPY_MARKER ]] && {
		echo -n "--> copy PREFIX to new location..."
		rm -rf $PREFIX/mingw $MINGW_ROOT
		cp -rf $PREFIX $MINGW_ROOT
		[[ $? == 0 ]] && {
			echo "done"
			touch $MINGW_COPY_MARKER
		} || {
			echo "error on copying $PREFIX directory"
			exit 1
		}
	} || {
		[[ ! -d $MINGW_ROOT ]] && {
			echo -n "--> copy PREFIX to new location..."
			rm -rf $PREFIX/mingw $MINGW_ROOT
			cp -rf $PREFIX $MINGW_ROOT
			[[ $? == 0 ]] && {
				echo "done"
				touch $MINGW_COPY_MARKER
			} || {
				echo "error on copying $PREFIX directory"
				exit 1
			}
		}
	}
	
	rm -rf $PREFIX/mingw

	[[ ! -f $SEVENZIP_ARCHIVE_NAME ]] && {
		echo -n "---> \"$(basename $SEVENZIP_ARCHIVE_NAME)\" ... "
		( cd $BUILDS_DIR && 7za a -t7z -mx=9 -mfb=64 -md=64m -ms=on "$SEVENZIP_ARCHIVE_NAME" "$MINGW_ROOT" >/dev/null 2>&1 )
		[[ $? == 0 ]] && {
			echo "done"
		} || {
			echo; echo "error on compressing $MINGW_ROOT directory"
			exit 1
		}
	}

	[[ ! -f $ZIP_ARCHIVE_NAME ]] && {
		echo -n "---> \"$(basename $ZIP_ARCHIVE_NAME)\" ... "
		( cd $BUILDS_DIR && 7za a -tzip -mx=9 -mfb=64 -md=64m "$ZIP_ARCHIVE_NAME" "$MINGW_ROOT" >/dev/null 2>&1 )
		[[ $? == 0 ]] && {
			echo "done"
		} || {
			echo "error on compressing $MINGW_ROOT directory"
			exit 1
		}
	}

	[[ -f $MINGW_COPY_MARKER ]] && {
		echo -n "--> remove new PREFIX..."
		rm -rf $MINGW_ROOT
		rm $MINGW_COPY_MARKER
		echo "done"
	}
} || {
	echo "---> compressed"
}
