
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

PKG_NAME=build-info
PKG_DIR_NAME=build-info
PKG_PRIORITY=main

PKG_EXECUTE_AFTER_INSTALL=(
	func_build_info
)

# Remove any markers in order to force another run
rm -f $BUILDS_DIR/$PKG_NAME/*.marker

function func_build_info() {
	local readonly INFO_FILE=$PREFIX/build-info.txt
	echo > $INFO_FILE

	echo "# **************************************************************************" >> $INFO_FILE
	echo >> $INFO_FILE
	echo "version : $MINGW_W64_BUILDS_VERSION" >> $INFO_FILE
	echo "user    : $(whoami)" >> $INFO_FILE
	echo "date    : $(date +%m.%d.%Y-%X)" >> $INFO_FILE
	[[ -n $(echo $RUN_ARGS | grep '\-\-sf-pass=') ]] && {
		local readonly _RUN_ARGS=$(echo "$RUN_ARGS" | sed "s|$SF_PASSWORD|***********|g")
	} || {
		local readonly _RUN_ARGS="$RUN_ARGS"
	}
	echo "args    : $_RUN_ARGS" >> $INFO_FILE
	echo "PATH    : $ORIGINAL_PATH" >> $INFO_FILE
    echo "CFLAGS  : $BASE_CFLAGS" >> $INFO_FILE
    echo "CXXFLAGS: $BASE_CXXFLAGS" >> $INFO_FILE
    echo "CPPFLAGS: $BASE_CPPFLAGS" >> $INFO_FILE
    echo "LDFLAGS : $BASE_LDFLAGS" >> $INFO_FILE
	echo >> $INFO_FILE
	echo "# **************************************************************************" >> $INFO_FILE
	echo >> $INFO_FILE
	[[ -f $i686_HOST_MINGW_PATH/bin/gcc.exe ]] && {
		echo "host gcc 32-bit:" >> $INFO_FILE
		$i686_HOST_MINGW_PATH/bin/gcc -v >> $INFO_FILE 2>&1
		echo >> $INFO_FILE
		echo "# **************************************************************************" >> $INFO_FILE
		echo >> $INFO_FILE
	}
	[[ -f $x86_64_HOST_MINGW_PATH/bin/gcc.exe ]] && {
		echo "host gcc 64-bit:" >> $INFO_FILE
		$x86_64_HOST_MINGW_PATH/bin/gcc -v >> $INFO_FILE 2>&1
		echo >> $INFO_FILE
		echo "# **************************************************************************" >> $INFO_FILE
		echo >> $INFO_FILE
	}

	[[ -f $i686_HOST_MINGW_PATH/bin/ld.exe ]] && {
		echo "host ld 32-bit:" >> $INFO_FILE
		$i686_HOST_MINGW_PATH/bin/ld -V 2>&1 >> $INFO_FILE
		echo >> $INFO_FILE
		echo "# **************************************************************************" >> $INFO_FILE
		echo >> $INFO_FILE
	}
	[[ -f $x86_64_HOST_MINGW_PATH/bin/ld.exe ]] && {
		echo "host ld 64-bit:" >> $INFO_FILE
		$x86_64_HOST_MINGW_PATH/bin/ld -V 2>&1 >> $INFO_FILE
		echo >> $INFO_FILE
		echo "# **************************************************************************" >> $INFO_FILE
		echo >> $INFO_FILE
	}

	local subtargets_it=
	local filtered_subtargets=${SUBTARGETS[@]}
	[[ $BOOTSTRAPINGALL == yes ]] && {
		read -ra filtered_subtargets<<<$(echo ${SUBTARGETS[@]} | awk -v RS='[[:space:]]+' '!a[$0]++{printf "%s%s", $0, RT}')
	}
	for subtargets_it in ${filtered_subtargets[@]}; do
		local rule_arr=( ${subtargets_it//|/ } )
		local sub_rule=${rule_arr[0]}
		[[ ${sub_rule} == build-info ]] && continue
		[[ -z $(grep 'PKG_CONFIGURE_FLAGS=' $TOP_DIR/scripts/${sub_rule}.sh) ]] && continue
		[[ $BUILD_EXTRAS == no ]] && {
			[[ -z $(grep 'PKG_PRIORITY=extra' $TOP_DIR/scripts/${sub_rule}.sh) ]] || continue
		}
		source $TOP_DIR/scripts/${sub_rule}.sh
		echo "name         : $PKG_NAME" >> $INFO_FILE
		echo "type         : $PKG_TYPE" >> $INFO_FILE
		pushd $SRCS_DIR/$PKG_DIR_NAME > /dev/null
		case $PKG_TYPE in
			cvs) echo "revision     : $PKG_REVISION" >> $INFO_FILE ;;
			svn) echo "revision     : $( svn info | grep 'Revision: ' | sed 's|Revision: ||' )" >> $INFO_FILE ;;
			hg)  echo "revision     : unimplemented" >> $INFO_FILE ;;
			git) echo "SHA          : $( export TERM=cygwin && git log -1 --pretty=format:%H )" >> $INFO_FILE ;;
			*)   echo "version      : $PKG_VERSION" >> $INFO_FILE ;;
		esac
		popd > /dev/null

		[[ ${#PKG_URLS[@]} > 1 ]] && {
			local urls_it=
			local urls=

			for urls_it in ${PKG_URLS[@]}; do
				local _params=( ${urls_it//|/ } )
				local _real_url=${_params[0]}
				urls="$urls $(echo $_real_url | sed -n 's/\([^|]*\)|.*/\1/p')"
			done

			echo "urls         : $(echo $urls | sed 's| |, |g')" >> $INFO_FILE
		} || {
			local _params=( ${PKG_URLS//|/ } )
			local _real_url=${_params[0]}
			echo "url          : $_real_url" >> $INFO_FILE
		}
		echo "patches      : $(echo ${PKG_PATCHES[@]} | sed 's| |, |g')" >> $INFO_FILE
		echo "configuration: ${PKG_CONFIGURE_FLAGS[@]}" >> $INFO_FILE
		echo >> $INFO_FILE
		echo "# **************************************************************************" >> $INFO_FILE
		echo >> $INFO_FILE
	done
}
