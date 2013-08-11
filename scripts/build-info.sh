#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of 'MinGW-W64' project.
# Copyright (c) 2011,2012,2013 by niXman (i dotty nixman doggy gmail dotty com)
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

function func_build_info() {
	local readonly INFO_FILE=$PREFIX/build-info.txt
	echo > $INFO_FILE

	echo "# **************************************************************************" >> $INFO_FILE
	echo >> $INFO_FILE
	echo "version : $MINGW_W64_BUILDS_VERSION" >> $INFO_FILE
	echo "user    : $(whoami)" >> $INFO_FILE
	echo "date    : $(date +%m.%d.%Y-%X)" >> $INFO_FILE
	[[ -n $(echo $RUN_ARGS | grep '\-\-sf-password=') ]] && {
		local readonly _RUN_ARGS=$(echo $RUN_ARGS | sed "s|$SF_PASSWORD|***********|g")
	} || {
		local readonly _RUN_ARGS="$RUN_ARGS"
	}
	echo "args    : $_RUN_ARGS" >> $INFO_FILE
	echo "PATH    : $ORIGINAL_PATH" >> $INFO_FILE
	echo "x32_PATH: $x32_PATH" >> $INFO_FILE
	echo "x64_PATH: $x64_PATH" >> $INFO_FILE
	echo >> $INFO_FILE
	echo "# **************************************************************************" >> $INFO_FILE
	echo >> $INFO_FILE
	echo "host gcc 32-bit:" >> $INFO_FILE
	$x32_HOST_MINGW_PATH/bin/gcc -v >> $INFO_FILE 2>&1
	echo >> $INFO_FILE
	echo "# **************************************************************************" >> $INFO_FILE
	echo >> $INFO_FILE
	[[ $USE_MULTILIB == yes ]] && {
		echo "host gcc 64-bit:" >> $INFO_FILE
		$x64_HOST_MINGW_PATH/bin/gcc -v >> $INFO_FILE 2>&1
		echo >> $INFO_FILE
		echo "# **************************************************************************" >> $INFO_FILE
		echo >> $INFO_FILE
	}

	echo "host ld:" >> $INFO_FILE
	$x32_HOST_MINGW_PATH/bin/ld -V 2>&1 >> $INFO_FILE
	echo >> $INFO_FILE
	echo "# **************************************************************************" >> $INFO_FILE
	echo >> $INFO_FILE

	local subtargets_it=
	for subtargets_it in ${SUBTARGETS[@]}; do
		[[ $subtargets_it == build-info ]] && continue
		[[ -z $(grep 'CONFIGURE_FLAGS=' $TOP_DIR/scripts/$subtargets_it.sh) ]] && continue
		. $TOP_DIR/scripts/$subtargets_it.sh
		echo "name         : $NAME" >> $INFO_FILE
		echo "type         : $TYPE" >> $INFO_FILE
		local prev_dir=$PWD
		cd $SRCS_DIR/$SRC_DIR_NAME
		case $TYPE in
			cvs) echo "revision     : $REV" >> $INFO_FILE ;;
			svn) echo "revision     : $( svn info | grep 'Revision: ' | sed 's|Revision: ||' )" >> $INFO_FILE ;;
			hg)  echo "revision     : unimplemented" >> $INFO_FILE ;;
			git) echo "SHA          : $( export TERM=cygwin && git log -1 --pretty=format:%H )" >> $INFO_FILE ;;
			*)   echo "version      : $VERSION" >> $INFO_FILE ;;
		esac
		cd $prev_dir
		
		[[ ${#URL[@]} > 1 ]] && {
			local urls_it=
			local urls=
			
			for urls_it in ${URL[@]}; do
				urls="$urls $(echo $urls_it | sed -n 's/\([^|]*\)|.*/\1/p')"
			done
			
			echo "urls         : $(echo $urls | sed 's| |, |g')" >> $INFO_FILE
		} || {
			echo "url          : $URL" >> $INFO_FILE
		}
		echo "patches      : $(echo ${PATCHES[@]} | sed 's| |, |g')" >> $INFO_FILE
		echo "configuration: ${CONFIGURE_FLAGS[@]}" >> $INFO_FILE
		echo >> $INFO_FILE
		echo "# **************************************************************************" >> $INFO_FILE
		echo >> $INFO_FILE
	done
}

# **************************************************************************

func_build_info

# **************************************************************************
