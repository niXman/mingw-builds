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

function func_simplify_path {
	# $1 - path

	[[ $1 != "${1% *}" ]] && [[ "$(uname -o)" == "Msys" ]] && {
		pushd "$1" >/dev/null
		cmd /c 'for %i in (.) do @echo %~si' | sed -e "s#^\([[:alpha:]]\):#/\1#" -e 's#\\#/#g'
		popd >/dev/null
	} || {
		echo "$1"
	}
}

# **************************************************************************

function func_absolute_to_relative {
	# $1 - first path
	# $2 - second path

	local _common=$1
	local _target=$2
	local _back=""

	while [[ "${_target#$_common}" == "${_target}" ]]; do
		_common=$(dirname $_common)
		_back="../${_back}"
	done

	echo "${_back}${_target#$_common/}"
}

# **************************************************************************

# download the sources
function func_download {
	# $1 - srcs root path
	# $2 - src dir name
	# $3 - sources type: .tar.gz, .tar.bz2 e.t.c...
	#      if sources get from a repository, choose it's type: cvs, svn, hg, git
	# $4 - URL
	# $5 - log file name
	# $6 - marker file name
	# $7 - revision

	[[ -z $4 ]] && {
		echo "URL is empty. terminate."
		exit 1
	}

	local _WGET_TIMEOUT=5
	local _WGET_TRIES=10
	local _WGET_WAIT=2
	local _result=0

	[[ $3 == cvs || $3 == svn || $3 == hg || $3 == git ]] && {
		local _lib_name=$1/$2
	} || {
		local _lib_name=$1/$2$3
	}

	[[ ! -f $6 ]] && {
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
				cd $_prev_dir
				_result=$?
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
					--no-check-certificate \
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
	# $4 - log suffix
	# $5 - log dir
	# $6 - commands list

	local _result=0
	local -a _commands=( "${!6}" )
	declare -i _index=${#_commands[@]}-1
	local _cmd_marker_name=$1/$2/exec-$4-$_index.marker

   [[ -f $_cmd_marker_name ]] && {
		echo "---> executed"
		return $_result
   }
   _index=0

   [[ ${#_commands[@]} > 0 ]] && {
		echo -n "--> $3"
   }

   for it in "${_commands[@]}"; do
		_cmd_marker_name=$1/$2/exec-$4-$_index.marker
		local _cmd_log_name=$1/$2/exec-$4-$_index.log

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
	# $1 - srcs dir name
	# $2 - src dir name
	# $3 - logs dir
	# $4 - patches dir
	# $5 - list
	
	local _result=0
	_index=0
	local -a _list=( "${!5}" )
	[[ ${#_list[@]} == 0 ]] && return 0

	((_index=${#_list[@]}-1))
	[[ -f $1/$2/_patch-$_index.marker ]] && {
		echo "---> patched"
		return 0
	}
	_index=0

	[[ ${#_list[@]} > 0 ]] && {
		echo -n "--> patching..."
	}

	for it in ${_list[@]} ; do
		local _patch_marker_name=$1/$2/_patch-$_index.marker

		[[ ! -f $_patch_marker_name ]] && {
			( cd $1/$2 && patch -p1 < $4/${it} > $1/$2/patch-$_index.log 2>&1 )
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
	# $5 - build dir

	local _marker=$5/$1/_configure.marker
	local _result=0

	[[ ! -f $_marker ]] && {
		echo -n "--> configure..."
		( cd $5/$1 && eval $( func_absolute_to_relative $5/$1 $SRCS_DIR/$2 )/configure "${3}" > $4 2>&1 )
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
	# $7 - build dir

	local _marker=$7/$1/_$6.marker
	local _result=0

	[[ ! -f $_marker ]] && {
		echo -n "--> $5"
		( cd $7/$1 && eval ${3} > $4 2>&1 )
		_result=$?
		[[ $_result == 0 ]] && { echo " done"; touch $_marker; } || { echo " error!"; }
	} || {
		echo "---> $6"
	}
	return $_result
}

# **************************************************************************

function func_test {
	# $1 - executable name
	# $2 - sources names
	# $3 - tests dir

	local _result=0
	local -a _list=( "${!2}" )

	[[ $USE_MULTILIB == no ]] && {
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
					[[ $SHOW_LOG_ON_ERROR == yes ]] && $LOGVIEWER $_cmp_log &
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
						[[ $SHOW_LOG_ON_ERROR == yes ]] && $LOGVIEWER $_run_log &
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

function func_install_toolchain {
	# $1 - toolchains path
	# $2 - i686-mingw install path
	# $3 - x86_64-mingw install path
	# $4 - i686-mingw URL
	# $5 - x86_64-mingw URL

	# local _mingw32_archive_path=$1/${4##*/}
	# local _mingw64_archive_path=$1/${5##*/}

	# local _mingw32_download_log=$1/mingw32-download.log
	# local _mingw64_download_log=$1/mingw64-download.log
	# local _mingw32_download_marker=$1/mingw32-download.marker
	# local _mingw64_download_marker=$1/mingw64-download.marker
	# local _mingw32_uncompress_log=$1/mingw32-uncompress.log
	# local _mingw64_uncompress_log=$1/mingw64-uncompress.log
	# local _mingw32_uncompress_marker=$1/mingw32-uncompress.marker
	# local _mingw64_uncompress_marker=$1/mingw64-uncompress.marker
	# local _mingw32_move_marker=$1/mingw32-move.marker
	# local _mingw64_move_marker=$1/mingw64-move.marker

	# function func_check_toolchain {
		# # $1 - toolchains path
		# # $2 - is DWARF building
		# echo
	# }

	function download_mingw_x32 {
		# $1 - toolchains path
		# $2 - i686-mingw URL

		func_download \
			$1 \
			$(basename $2 .7z) \
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
			$(basename $2 .7z) \
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
			$(basename $2 .7z) \
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
			$(basename $2 .7z) \
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

	[[ ! -d $2 || ! $2/bin/gcc.exe ]] && {
		# x32 download
		echo -e "-> \E[32;40mx32 toolchain\E[37;40m"
		download_mingw_x32 \
			$1 \
			$4
		local _result=$?
		[[ $_result != 0 ]] && {
			echo "download error. terminate."
			return $_result
		}

		# x32 uncompress
		uncompress_mingw_x32 \
			$1 \
			$4
		local _result=$?
		[[ $_result != 0 ]] && {
			echo "uncompress error. terminate."
			return $_result
		}

		move_mingw \
			$1 \
			$2 \
			$1/mingw-x32-move.marker
		local _result=$?
		[[ $_result != 0 ]] && {
			echo "move error. terminate."
			return $_result
		}
	}

	[[ $EXCEPTIONS_MODEL == seh || $EXCEPTIONS_MODEL == sjlj ]] && {
		[[ ! -d $3 || ! $3/bin/gcc.exe ]] && {
			# x64 download
			echo -e "-> \E[32;40mx64 toolchain\E[37;40m"
			download_mingw_x64 \
				$1 \
				$5
			local _result=$?
			[[ $_result != 0 ]] && {
				echo "download error. terminate."
				return $_result
			}

			# x64 uncompress
			uncompress_mingw_x64 \
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
				$1/mingw-x64-move.marker
			local _result=$?
			[[ $_result != 0 ]] && {
				echo "move error. terminate."
				return $_result
			}

			return $_result
		}
	}

	return 0
}

# **************************************************************************

function func_map_gcc_name_to_gcc_type {
	# $1 - gcc name

	case $1 in
		gcc-?.?.?) echo release ;;
		gcc-*-branch) echo prerelease ;;
		gcc-trunk) echo snapshot ;;
		*) echo "gcc name error: $1. terminate."; exit 1 ;;
	esac
}

# **************************************************************************

function func_map_gcc_name_to_gcc_version {
	# $1 - gcc name

	case $1 in
		gcc-?.?.?)			echo "${1/gcc-/}" ;;
		gcc-4_6-branch)	echo "4.6.4" ;;
		gcc-4_7-branch)	echo "4.7.3" ;;
		gcc-4_8-branch)	echo "4.8.1" ;;
		gcc-4_9-branch)	echo "4.9.1" ;;
		gcc-trunk)			echo "4.8.0" ;;
		*) echo "gcc name error: $1. terminate."; exit 1 ;;
	esac
}

# **************************************************************************

function func_map_gcc_name_to_gcc_build_name {
	# $1 - sources root dir
	# $2 - gcc name

	local _type_str=$(func_map_gcc_name_to_gcc_type $2)
	local _gcc_version=$(func_map_gcc_name_to_gcc_version $2)
	local _build_name=$_gcc_version-$_type_str

	[[ $_type_str != release ]] && {
		case $2 in
			gcc-*-branch|gcc-trunk)
				local _gcc_rev="rev$(cd $1/$2 && svn info | grep 'Revision: ' | sed 's|Revision: ||')"
			;;
			*) local _gcc_rev="" ;;
		esac
		echo "$_build_name-$(date +%Y%m%d)-$_gcc_rev"
	} || {
		echo "$_build_name"
	}
}

# **************************************************************************

function func_create_mingw_archive_name {
	# $1 - build root dir
	# $2 - sources root dir
	# $3 - gcc name
	# $4 - architecture
	# $5 - exceptions model
	# $6 - threads model
	# $7 - revision number

	local _archive=$1/$4-$( \
		func_map_gcc_name_to_gcc_build_name \
			$2 \
			$3 \
	)-$6-$5

	[[ -n $7 ]] && {
		_archive=$_archive-rev$7
	}

	echo "$_archive.7z"
}

# **************************************************************************

function func_create_sources_archive_name {
	# $1 - build root dir
	# $2 - sources root dir
	# $3 - gcc name
	# $4 - revision number

	local _archive=$1/src-$( \
		func_map_gcc_name_to_gcc_build_name \
			$2 \
			$3 \
	)

	[[ -n $4 ]] && {
		_archive=$_archive-rev$4
	}

	echo "$_archive.tar.7z"
}

# **************************************************************************

function func_create_mingw_upload_cmd {
	# $1 - build root dir
	# $2 - sf user name
	# $3 - gcc name
	# $4 - archive name
	# $5 - architecture
	# $6 - threads model
	# $7 - exceptions model

	local _project_fs_root_dir=/home/frs/project/mingwbuilds/host-windows
	local _upload_cmd="cd $1 && scp $4 $2@frs.sourceforge.net:$_project_fs_root_dir"

	case $3 in
		gcc-?.?.?) _upload_cmd="$_upload_cmd/releases/$(echo $3 | sed 's|gcc-||')" ;;
		gcc-?_?-branch|gcc-trunk) _upload_cmd="$_upload_cmd/testing" ;;
		*) echo "gcc name error: \"$3\". terminate."; exit 1 ;;
	esac
	case $3 in
		gcc-4_6-branch) _upload_cmd="$_upload_cmd/4.6.4" ;;
		gcc-4_7-branch) _upload_cmd="$_upload_cmd/4.7.3" ;;
		gcc-4_8-branch) _upload_cmd="$_upload_cmd/4.8.1" ;;
		gcc-trunk) _upload_cmd="$_upload_cmd/4.8.0" ;;
	esac
	case $5 in
		x32) _upload_cmd="$_upload_cmd/32-bit" ;;
		x64) _upload_cmd="$_upload_cmd/64-bit" ;;
	esac
	_upload_cmd="$_upload_cmd/threads-$6/$7"

	echo "$_upload_cmd"
}

# **************************************************************************

function func_create_sources_upload_cmd {
	# $1 - build root dir
	# $2 - sf user name
	# $3 - gcc name
	# $4 - archive name

	local _project_fs_root_dir=/home/frs/project/mingwbuilds
	local _upload_cmd="cd $1 && scp $4 $2@frs.sourceforge.net:$_project_fs_root_dir/mingw-sources/$(func_map_gcc_name_to_gcc_version $3)"

	echo "$_upload_cmd"
}

# **************************************************************************
