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

[[ ! -f $BUILDS_DIR/put-info.marker ]] && {
	INFO_FILE=$PREFIX/info.txt
	echo > $INFO_FILE
	
	echo "# **************************************************************************" >> $INFO_FILE
	echo >> $INFO_FILE
	echo "version : $MINGW_BUILDS_VERSION" >> $INFO_FILE
	echo "user    : $(whoami)" >> $INFO_FILE
	echo "date    : $(date +%m.%d.%Y-%X)" >> $INFO_FILE
	echo "args    : $RUN_ARGS" >> $INFO_FILE
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
	
	for it in ${SUBTARGETS[@]}; do
		[[ $it == put-info ]] && continue
		[[ -z $(grep 'CONFIGURE_FLAGS=' $TOP_DIR/scripts/$it.sh) ]] && continue
		. $TOP_DIR/scripts/$it.sh
		echo "$NAME configuration:" >> $INFO_FILE
		echo "${CONFIGURE_FLAGS[@]}" >> $INFO_FILE
		echo >> $INFO_FILE
		[[ ${#PATCHES[@]} > 0 ]] && {
			echo "patches:" >> $INFO_FILE
			echo "${PATCHES[@]}" | sed "s| |\n|g" >> $INFO_FILE
			echo >> $INFO_FILE
		}
		echo "# **************************************************************************" >> $INFO_FILE
		echo >> $INFO_FILE
	done

	touch $BUILDS_DIR/put-info.marker
}

# **************************************************************************
