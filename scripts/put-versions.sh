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

[[ ! -f $BUILDS_DIR/put-versions.marker ]] && {
	VERSION_FILE=$PREFIX/versions.txt
	echo > $VERSION_FILE

	_PROCESSED_SUBS=()

	for sub in ${SUBTARGETS[@]}; do
		[[ $sub == put-versions ]] && continue
		
		_pack_type=$( grep 'TYPE=' $TOP_DIR/scripts/${sub}.sh )
		[[ -n $_pack_type ]] && {
			_pack_type=$( echo "$_pack_type" | sed 's|TYPE=||g' )
			_pack_name=$( grep 'SRC_DIR_NAME=' $TOP_DIR/scripts/${sub}.sh | sed 's|SRC_DIR_NAME=||' )
			
			[[ -n $( echo "${_PROCESSED_SUBS[@]}" | grep $_pack_name ) ]] && continue
			_PROCESSED_SUBS=( ${_PROCESSED_SUBS[@]} $_pack_name )
			
			echo "name: $_pack_name" >> $VERSION_FILE
			echo "url: $( grep 'URL=' $TOP_DIR/scripts/${sub}.sh | sed 's|URL=||' )" >> $VERSION_FILE
			
			cd $SRCS_DIR/$_pack_name
			[[ $? != 0 ]] && { echo "error in $SRCS_DIR/$_pack_name"; exit 1; }
			
			case $_pack_type in
				cvs) echo "revision: $( grep 'REV=' $TOP_DIR/scripts/${sub}.sh | sed 's|REV=||' )" >> $VERSION_FILE ;;
				svn) echo "revision: $( svn info | grep 'Revision: ' | sed 's|Revision: ||' )" >> $VERSION_FILE ;;
				hg) echo "revision: unimplemented" >> $VERSION_FILE ;;
				git) echo "revision: unimplemented" >> $VERSION_FILE ;;
				*) echo "version: $( echo $_pack_name | sed 's/[^0-9.]*\([0-9.]*\).*/\1/' )" >> $VERSION_FILE ;;
			esac
			echo "" >> $VERSION_FILE
		}
	done

	touch $BUILDS_DIR/put-versions.marker
}

# **************************************************************************
