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

function func_absolute_to_relative {
   local common_part=$1
   local target=$2
   local back=""

   while [[ "${target#$common_part}" == "${target}" ]]; do
      common_part=$(dirname $common_part)
      back="../${back}"
   done

   echo "${back}${target#$common_part/}"
}

# **************************************************************************

# download the sources
function func_download {
	# $1 - srcs root path
	# $2 - name
	# $3 - sources type: .tar.gz, .tar.bz2 e.t.c...
	#      if sources get from a repository, choose it's type: cvs, svn, hg, git
	# $4 - URL
	# $5 - log file name
	# $6 - marker file name
	# $7 - revision

	local _WGET_TIMEOUT=5
	local _WGET_TRIES=10
	local _WGET_WAIT=2

	local _marker=$SRCS_DIR/$1/_download.marker
	local _result=0

	[[ -z $4 ]] && {
		echo "URL is empty. terminate."
		exit 1
	}

	[[ ! -f $6 ]] && {
		[[ $3 == cvs || $3 == svn || $3 == hg || $3 == git ]] && {
			local _lib_name=$1/$2
		} || {
			local _lib_name=$1/$2$3
		}

		echo -n "--> download..."

		case $3 in
			cvs)
				local _prev_dir=$PWD
				cd $1
				[[ -n $7 ]] && {
					cvs -z9 -d $4 co -D$7 $2 > $5 2>&1
				} || {
					cvs -z9 -d $4 co $2 > $5 2>&1
				}
				_result=$?
				cd $_prev_dir
			;;
			svn)
				[[ -n $7 ]] && {
					svn co -r $7 $4 $_lib_name > $5 2>&1
				} || {
					svn co $4 $_lib_name > $5 2>&1
				}
				_result=$?
			;;
			hg)
				hg clone $4 $_lib_name > $5 2>&1
				_result=$?
			;;
			git)
				git clone $4 $_lib_name > $5 2>&1
				_result=$?
			;;
			*)
				[[ ! -f $6 && -f $_lib_name ]] && rm -rf $_lib_name
				wget \
					--tries=$_WGET_TRIES \
					--timeout=$_WGET_TIMEOUT \
					--wait=$_WGET_WAIT \
					$4 -O $_lib_name > $5 2>&1
				_result=$?
			;;
		esac

		[[ $_result == 0 ]] && { echo " done"; touch $6; } || { echo " error!"; }
	} || {
		echo "---> downloaded"
	}
	return $_result
}

# **************************************************************************

# uncompress sources
function func_uncompress {
	# $1 - srcs root path
	# $2 - name
	# $3 - ext
	# $4 - marker file name
	# $5 - log file name

	local _marker=$SRCS_DIR/$1/_uncompress.marker
	local _result=0
	local _unpack_cmd

	[[ $3 == .tar.gz || $3 == .tar.bz2 || $3 == .tar.lzma \
	|| $3 == .tar.xz || $3 == .tar.7z || $3 == .7z ]] && {
		[[ ! -f $4 ]] && {
			echo -n "--> unpack..."
			case $3 in
				.tar.gz) _unpack_cmd="tar xvf $1/$2$3 -C $1 > $5 2>&1" ;;
				.tar.bz2) _unpack_cmd="tar xvjf $1/$2$3 -C $1 > $5 2>&1" ;;
				.tar.lzma|.tar.xz) _unpack_cmd="tar xvJf $1/$2$3 -C $1 > $5 2>&1" ;;
				.tar.7z) echo "unimplemented. terminate."; exit 1 ;;
				.7z) _unpack_cmd="7za x $1/$2$3 -o$1 > $5 2>&1" ;;
				*) echo " error. bad archive type: $3"; return 1 ;;
			esac
			eval ${_unpack_cmd}
			_result=$?
			[[ $_result == 0 ]] && { echo " done"; touch $4; } || { echo " error!"; }
		} || {
			echo "---> unpacked"
		}
	}
	return $_result
}

# **************************************************************************

# execute list of commands
function func_execute {
	# $1 - execute dir
	# $2 - src dir name
	# $3 - message
	# $4 - commands list

	local _result=0
	local -a _commands=( "${!4}" )
	declare -i _index=${#_commands[@]}-1
	local _cmd_marker_name=$1/$2/exec-$_index.marker

   [[ -f $_cmd_marker_name ]] && {
		echo "---> executed"
		return $_result
   }
   _index=0

   [[ ${#_commands[@]} > 0 ]] && {
		echo -n "--> $3"
   }

   for it in "${_commands[@]}"; do
		_cmd_marker_name=$1/$2/exec-$_index.marker
		local _cmd_log_name=$LOGS_DIR/$2/exec-$_index.log

      [[ ! -f $_cmd_marker_name ]] && {
         ( cd $1/$2 && eval ${it} > $_cmd_log_name 2>&1 )
         _result=$?
         [[ $_result != 0 ]] && {
            echo "error!"
            return $_result
         } || {
            touch $_cmd_marker_name
         }
      }

      ((_index++))
   done

   [[ $_index == ${#_commands[@]} ]] && echo "done"

   return $_result
}

# **************************************************************************

# apply list of patches
function func_apply_patches {
	# $1 - src dir name
	# $2 - list

	local _result=0
	_index=0
	local -a _list=( "${!2}" )
	[[ ${#_list[@]} == 0 ]] && return 0

	((_index=${#_list[@]}-1))
	[[ -f $SRCS_DIR/$1/_patch-$_index.marker ]] && {
		echo "---> patched"
		return 0
	}
	_index=0

	[[ ${#_list[@]} > 0 ]] && {
		echo -n "--> patching..."
	}

	for it in ${_list[@]} ; do
		local _patch_marker_name=$SRCS_DIR/$1/_patch-$_index.marker
		[[ ! -f $_patch_marker_name ]] && {
			( cd $SRCS_DIR/$1 && patch -p1 < $PATCHES_DIR/${it} > $LOGS_DIR/$1/patch-$_index.log 2>&1 )
			_result=$?
			[[ $_result == 0 ]] && {
				touch $_patch_marker_name
			} || {
				_result=1
				break
			}
		}
		((_index++))
	done

	[[ $_result == 0 ]] && echo "done" || echo "error!"

	return $_result
}

# **************************************************************************

# configure
function func_configure {
	# $1 - name
	# $2 - src dir name
	# $3 - flags
	# $4 - log file name

	local _marker=$BUILDS_DIR/$1/_configure.marker
	local _result=0

	[[ ! -f $_marker ]] && {
		echo -n "--> configure..."
		( cd $BUILDS_DIR/$1 && eval $( func_absolute_to_relative $BUILDS_DIR/$2 $SRCS_DIR/$2 )/configure "${3}" > $4 2>&1 )
		_result=$?
		[[ $_result == 0 ]] && {
			echo " done"
			touch $_marker
			return $_result
		} || {
			echo " error!"
			return $_result
		}
	} || {
		echo "---> configured"
	}

	return $_result
}

# **************************************************************************

# make
function func_make {
	# $1 - name
	# $2 - src dir name
	# $3 - command line
	# $4 - log file name
	# $5 - text
	# $6 - text if completed

	local _marker=$BUILDS_DIR/$1/_$6.marker
	local _result=0

	[[ ! -f $_marker ]] && {
		echo -n "--> $5"
		( cd $BUILDS_DIR/$2 && eval ${3} > $4 2>&1 )
		_result=$?
		[[ $_result == 0 ]] && { echo " done"; touch $_marker; } || { echo " error!"; }
	} || {
		echo "---> $6"
	}
	return $_result
}

# **************************************************************************

function run_test {
	# $1 - executable name
	# $2 - sources names
	# $3 - tests dir

	local _result=0
	local -a _list=( "${!2}" )

	[[ $USE_MULTILIB_MODE == no ]] && {
		[[ $ARCHITECTURE == x32 ]] && {
			local -a _archs=(32)
		} || {
			local -a _archs=(64)
		}
	} || {
		local -a _archs=(32 64)
	}

	for arch_it in ${_archs[@]}; do
		[[ ! -f $3/$arch_it/$1.marker ]] && {
			for src_it in "${_list[@]}"; do
				local _first=$(echo $src_it | sed 's/\([^ ]*\).*/\1/' )
				local _prev=$( echo $src_it | sed '$s/ *\([^ ]* *\)$//' )
				local _last=$( echo $src_it | sed 's/^.* //' )
				local _cmp_log=$3/$arch_it/$_first-compilation.log
				local _run_log=$3/$arch_it/$_first-execution.log

				printf "%-50s" "--> $([[ ${_prev%% *} =~ .cpp ]] && echo -n G++ || echo -n GCC) compile $arch_it: \"$_first\" ... "
				[[ ${_prev%% *} =~ .cpp ]] && {
					echo "g++ -m${arch_it} $COMMON_CXXFLAGS $COMMON_LDFLAGS $TESTS_DIR/$_prev $3/$arch_it/$_last" > $_cmp_log
					( cd $3/$arch_it && g++ -m${arch_it} $COMMON_CXXFLAGS $COMMON_LDFLAGS $TESTS_DIR/$_prev $3/$arch_it/$_last >> $_cmp_log 2>&1 )
				} || {
					echo "gcc -m${arch_it} $COMMON_CXXFLAGS $COMMON_LDFLAGS $TESTS_DIR/$_prev $3/$arch_it/$_last" > $_cmp_log
					( cd $3/$arch_it && gcc -m${arch_it} $COMMON_CFLAGS $COMMON_LDFLAGS $TESTS_DIR/$_prev $3/$arch_it/$_last >> $_cmp_log 2>&1 )
				}
				_result=$?
				[[ $_result == 0 ]] && {
					echo "-> $_result -> done"
				} || {
					echo "-> $_result -> error. terminate."
					[[ $SHOW_LOG_ON_ERROR == yes ]] && $LOGVIEWER $_cmp_log
					exit $_result
				}
				[[ $_last =~ .exe ]] && {
					printf "%-50s" "--> execute     $arch_it: \"$_last\" ... "
					( cd $3/$arch_it && $_last > $_run_log 2>&1 )
					_result=$?
					[[ $_result == 0 ]] && {
						echo "-> $_result -> done"
					} || {
						echo "-> $_result -> error. terminate."
						[[ $SHOW_LOG_ON_ERROR == yes ]] && $LOGVIEWER $_run_log
						exit $_result
					}
				}
			done

			touch $3/$arch_it/$1.marker
		} || {
			echo "---> test $arch_it: \"$1\" - passed"
		}
	done
}

# **************************************************************************

function func_install_host_mingw {
	# $1 - toolchains path
	# $2 - list of architectures
	# $3 - i686-mingw install path
	# $4 - x86_64-mingw install path
	# $5 - i686-mingw URL
	# $6 - x86_64-mingw URL
	
	function download_mingw_x32 {
		# $1 - toolchains path
		# $2 - i686-mingw URL
		
		func_download \
			$1 \
			$(basename $2 | sed 's|.7z||') \
			.7z \
			$2 \
			$1/mingw-x32-download.log \
			$1/mingw-x32-download.marker \
			""
		return $?
	}
	
	function download_mingw_x64 {
		# $1 - toolchains path
		# $2 - x86_64-mingw URL
		
		func_download \
			$1 \
			$(basename $2 | sed 's|.7z||') \
			.7z \
			$2 \
			$1/mingw-x64-download.log \
			$1/mingw-x64-download.marker \
			""
		return $?
	}
	
	function uncompress_mingw_x32 {
		# $1 - toolchains path
		# $2 - i686-mingw archive filename

		func_uncompress \
			$1 \
			$(basename $2 | sed 's|.7z||') \
			.7z \
			$1/mingw-x32-uncompress.marker \
			$1/mingw-x32-uncompress.log
		return $?
	}
	function uncompress_mingw_x64 {
		# $1 - toolchains path
		# $2 - x86_64-mingw archive filename

		func_uncompress \
			$1 \
			$(basename $2 | sed 's|.7z||') \
			.7z \
			$1/mingw-x64-uncompress.marker \
			$1/mingw-x64-uncompress.log
		return $?
	}
	
	function move_mingw {
		# $1 - toolchains path
		# $2 - destination path
		# $3 - marker file name
	
		[[ ! -f $3 ]] && {
			# check if MinGW root directory name is valid
			[[ ! -d $1/mingw ]] && {
				echo "bad MinGW root path name. terminate."
				exit 1
			}
			
			# rename MinGW directory
			echo -n "--> move... "
			mv $1/mingw $2
			local _result=$?
			[[ $_result != 0 ]] && {
				echo "error when move root MinGW path. terminate."
				exit 1
			} || {
				touch $3 && echo "done" || return 1
			}
		} || {
			echo "---> moved"
		}
		return $_result
	}
	
	local -a _architectures=( "${!2}" )
	
	[[ ${_architectures[@]} =~ x64 ]] && {
		# x32 download
		echo -e "-> \E[32;40mx32 toolchain\E[37;40m"
		download_mingw_x32 \
			$1 \
			$5
		local _result=$?
		[[ $_result != 0 ]] && {
			echo "download error. terminate."
			return $_result
		}

		# x32 uncompress
		uncompress_mingw_x32 \
			$1 \
			$5
		local _result=$?
		[[ $_result != 0 ]] && {
			echo "uncompress error. terminate."
			return $_result
		}

		move_mingw \
			$1 \
			$3 \
			$1/mingw-x32-move.marker
		local _result=$?
		[[ $_result != 0 ]] && {
			echo "move error. terminate."
			return $_result
		}

		# x64 download
		echo -e "-> \E[32;40mx64 toolchain\E[37;40m"
		download_mingw_x64 \
			$1 \
			$6
		local _result=$?
		[[ $_result != 0 ]] && {
			echo "download error. terminate."
			return $_result
		}

		# x64 uncompress
		uncompress_mingw_x64 \
			$1 \
			$6
		local _result=$?
		[[ $_result != 0 ]] && {
			echo "uncompress error. terminate."
			return $_result
		}

		move_mingw \
			$1 \
			$4 \
			$1/mingw-x64-move.marker
		local _result=$?
		[[ $_result != 0 ]] && {
			echo "move error. terminate."
			return $_result
		}

		return $_result
	} || {
		# download only 32-bit toolchain
		echo -e "-> \E[32;40mx32 toolchain\E[37;40m"
		download_mingw_x32 \
			$1 \
			$5
		local _result=$?
		[[ $_result != 0 ]] && {
			echo "download error. terminate."
			return $_result
		}

		# uncompress
		uncompress_mingw_x32 \
			$1 \
			$5
		local _result=$?
		[[ $_result != 0 ]] && {
			echo "download error. terminate."
			return $_result
		}

		move_mingw \
			$1 \
			$3 \
			$1/mingw-x32-move.marker
		local _result=$?
		[[ $_result != 0 ]] && {
			echo "move error. terminate."
			return $_result
		}
		
		return $_result
	}
}

# **************************************************************************
