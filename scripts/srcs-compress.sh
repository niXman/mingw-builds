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
	gcc-*-branch|gcc-trunk|cxx-conversion)
		GCC_REVISION="-rev-$(cd $SRCS_DIR/$GCC_NAME; svn info | grep 'Revision: ' | sed 's|Revision: ||')"
	;;
	*)
		GCC_REVISION=""
	;;
esac

case $GCC_NAME in
	gcc-?.?.?)		ARCHIVE_NAME=$TOP_DIR/../src-$GCC_NAME-release ;;
	gcc-4_6-branch)ARCHIVE_NAME=$TOP_DIR/../src-gcc-4.6.4-prerelease-$(date +%Y%m%d)$GCC_REVISION ;;
	gcc-4_7-branch)ARCHIVE_NAME=$TOP_DIR/../src-gcc-4.7.2-prerelease-$(date +%Y%m%d)$GCC_REVISION ;;
	gcc-4_8-branch)ARCHIVE_NAME=$TOP_DIR/../src-gcc-4.8.1-prerelease-$(date +%Y%m%d)$GCC_REVISION ;;
	gcc-4_9-branch)ARCHIVE_NAME=$TOP_DIR/../src-gcc-4.9.1-prerelease-$(date +%Y%m%d)$GCC_REVISION ;;
	cxx-conversion)ARCHIVE_NAME=$TOP_DIR/../src-gcc-4.8.1-prerelease-$(date +%Y%m%d)$GCC_REVISION ;;
	gcc-trunk)		ARCHIVE_NAME=$TOP_DIR/../src-gcc-4.8.0-snapshot-$(date +%Y%m%d)$GCC_REVISION ;;
	*) echo "gcc name error: \"$GCC_NAME\". terminate."; exit ;;
esac
#echo "ARCHIVE_NAME: $ARCHIVE_NAME"; exit 1

[[ ! -f $ARCHIVE_NAME.tar.7z ]] && {
	echo -n "--> compressing $SRCS_DIR..."

	LIST_OF_DIRS_FOR_COMPRESS=( $(find $SRCS_DIR -maxdepth 1 -type d -not -name "gcc-*") )
	LIST_OF_DIRS_FOR_COMPRESS[0]=$SRCS_DIR/$GCC_NAME
	#echo "${LIST_OF_DIRS_FOR_COMPRESS[@]}"; exit 1
	tar -cf - -C$SRCS_DIR/../ \
		--dereference --hard-dereference --exclude-vcs \
		${LIST_OF_DIRS_FOR_COMPRESS[@]} 2>/dev/null \
		| 7za a -t7z -mx=9 -mfb=64 -md=64m -ms=on -si \
		$ARCHIVE_NAME.tar.7z >/dev/null 2>&1
	
	[[ $? == 0 ]] && {
		echo "done"
	} || {
		echo; echo "error on compressing $MINGW_ROOT directory"
		exit 1
	}
} || {
	echo "---> compressed"
}
