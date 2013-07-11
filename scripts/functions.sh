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

function die {
	echo $@
	exit 1
}

# **************************************************************************

function check_program {
	command -v "$@" > /dev/null 2>&1 || { die "Command $@ not found. Terminate."; }
}

# **************************************************************************

function get_reverse_triplet {
	case ${1%%-*} in
		i686) echo "x86_64-${1#*-}" ;;
		amd64|x86_64) echo "i686-${1#*-}" ;;
	esac
}

# **************************************************************************

function get_reverse_arch {
	case $1 in
		x32) echo "x64" ;;
		x64) echo "x32" ;;
	esac
}

# **************************************************************************

function get_filename_extension {
	local _filename=$1
	local _ext=
	local _finish=0
	case "${_filename##*.}" in
		bz2|gz|lzma|xz) 
			_ext=$_ext'.'${_filename##*.}
			_filename=${_filename%$_ext}
			local _sub_ext=$(get_filename_extension $_filename)
			[[ "$_sub_ext" == ".tar" ]] && _ext=$_sub_ext$_ext
		;;
		*)
			_ext='.'${_filename##*.}
		;;
	esac
	echo "$_ext"
}

# **************************************************************************

function check_languages {
	OLD_IFS=$IFS                 
	IFS=","                           
	local langs=( $1 )
	IFS=$OLD_IFS
	local errs=""
	
	[[ ${#langs[@]} == 0 ]] && {
		die "You must specify languages to build"
	} || {
		for sub in ${langs[@]}; do
			! [[ "$sub" == "ada" || "$sub" == "c" || "$sub" == "c++" || \
				  "$sub" == "fortran" || "$sub" == "objc" || "$sub" == "obj-c++" ]] && {
				errs=$errs' '$sub
			}
		done

		[[ x"$errs" != x ]] && {
			die "Follow languages not supported: $errs"
		}
	}
}

# **************************************************************************

function has_lang {
	OLD_IFS=$IFS                 
	IFS=","                           
	local langs=( $ENABLE_LANGUAGES )
	IFS=$OLD_IFS
	local errs=""
		
	[[ ${#langs[@]} == 0 ]] && {
		return "0"
	} || {
		for sub in ${langs[@]}; do
			[[ "$sub" == "$1" ]] && {
				return "1"
			}
		done
	}
	return "0"
}

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
	# $1 - list of URLs	

	local -a _list=( "${!1}" )
	[[ ${#_list[@]} == 0 ]] && {
		echo "--> Doesn't need to download."
		return 0
	}

	local _WGET_TIMEOUT=5
	local _WGET_TRIES=10
	local _WGET_WAIT=2
	local _result=0

	for it in ${_list[@]} ; do
		OLD_IFS=$IFS                 
		IFS="|"                           
		local _params=( $it )
		IFS=$OLD_IFS

		local _filename=
		local _marker_name=
		local _log_name=
		local _url=${_params[0]}
		local _repo=
		local _branch=
		local _rev=
		local _dir=
		local _root=$SRCS_DIR
		local _module=
		local _lib_name=
		
		local _index=1
		while [ "$_index" -lt "${#_params[@]}" ]
		do
			OLD_IFS=$IFS                 
			IFS=":"                           
			local _params2=( ${_params[$_index]} )
			IFS=$OLD_IFS
			case ${_params2[0]} in
				branch) _branch=${_params2[1]} ;;
				dir)    _dir=${_params2[1]} ;;
				module) _module=${_params2[1]} ;;
				repo)   _repo=${_params2[1]} ;;
				rev)    _rev=${_params2[1]} ;;
				root)   _root=${_params2[1]} ;;
			esac
			_index=$(($_index+1))
		done

		[[ -n $_module && -n $_repo ]] && {
			_filename=$_module
		} || {
			_filename=$(basename $_url)
		}

		_log_name=$MARKERS_DIR/${_filename}-download.log
		_marker_name=$MARKERS_DIR/${_filename}-download.marker	
		[[ ! -f $_marker_name ]] && {
			[[ $_repo == cvs || $_repo == svn || $_repo == hg || $_repo == git ]] && {
				echo -n "--> download $_filename..."

				[[ -n $_dir ]] && {
					_lib_name=$_root/$_filename
				} || {
					_lib_name=$_root/$_dir/$_filename
				}
				case $_repo in
					cvs)
						local _prev_dir=$PWD
						cd $SRCS_DIR
						[[ -n $_rev ]] && {
							cvs -z9 -d $_url co -D$_rev $_module > $_log_name 2>&1
						} || {
							cvs -z9 -d $_url co $_module > $_log_name 2>&1
						}
						cd $_prev_dir
						_result=$?
					;;
					svn)
						[[ -n $_rev ]] && {
							svn co -r $_rev $_url $_lib_name > $_log_name 2>&1
						} || {
							svn co $_url $_lib_name > $_log_name 2>&1
						}
						_result=$?
					;;
					hg)
						hg clone $_url $_lib_name > $_log_name 2>&1
						_result=$?
					;;
					git)
						[[ -n $_branch ]] && {
							git clone --branch $_branch $_url $_lib_name > $_log_name 2>&1
						} || {
							git clone $_url $_lib_name > $_log_name 2>&1
						}
						_result=$?
					;;
				esac	
			} || {
				_lib_name=$SRCS_DIR/$_filename
				[[ -f $_lib_name ]] && {
					echo -n "--> Delete corrupted download..."
					rm -f $_filename
					echo " done"
				}
				echo -n "--> download $_filename..."
				wget \
					--tries=$_WGET_TRIES \
					--timeout=$_WGET_TIMEOUT \
					--wait=$_WGET_WAIT \
					--no-check-certificate \
					$_url -O $_lib_name > $_log_name 2>&1
				_result=$?
			}
			[[ $_result == 0 ]] && {
				echo " done"
				touch $_marker_name
			} || {
				[[ $SHOW_LOG_ON_ERROR == yes ]] && $LOGVIEWER $_log_name &
				die "Error $_result"
			}
		} || {
			echo "---> $_filename downloaded"
		}	
	done
	return $_result
}

# **************************************************************************

# uncompress sources
function func_uncompress {
	# $1 - list of archives

	local -a _list=( "${!1}" )
	[[ ${#_list[@]} == 0 ]] && {
		echo "--> Unpack doesn't need."
		return 0
	}

	for it in ${_list[@]} ; do
		OLD_IFS=$IFS                 
		IFS="|"                           
		local _params=( $it )
		IFS=$OLD_IFS
		
		local _result=0
		local _unpack_cmd
		local _marker_name=
		local _log_name=
		local _filename=
		local _ext=
		local _url=${_params[0]}
		local _module=
		local _dir=
		local _root=$SRCS_DIR
		local _lib_name=
		
		local _index=1
		while [ "$_index" -lt "${#_params[@]}" ]
		do
			OLD_IFS=$IFS                 
			IFS=":"                           
			local _params2=( ${_params[$_index]} )
			IFS=$OLD_IFS
			case ${_params2[0]} in
				dir)    _dir=${_params2[1]} ;;
				root)   _root=${_params2[1]} ;;
				module) _module=${_params2[1]} ;;
			esac
			_index=$(($_index+1))
		done

		_lib_name=${_root}/${_dir}
		_filename=$(basename ${_params[0]})	
		_log_name=$MARKERS_DIR/${_filename}-unpack.log
		_marker_name=$MARKERS_DIR/${_filename}-unpack.marker
		_ext=$(get_filename_extension $_filename)
		[[ $_ext == .tar.gz || $_ext == .tar.bz2 || $_ext == .tar.lzma \
		|| $_ext == .tar.xz || $_ext == .tar.7z || $_ext == .7z || $_ext == .tgz ]] && {
			[[ ! -f $_marker_name ]] && {
				echo -n "--> unpack $_filename..."
				case $_ext in
					.tar.gz|.tgz) _unpack_cmd="tar xvf $SRCS_DIR/$_filename -C $_lib_name > $_log_name 2>&1" ;;
					.tar.bz2) _unpack_cmd="tar xvjf $SRCS_DIR/$_filename -C $_lib_name > $_log_name 2>&1" ;;
					.tar.lzma|.tar.xz) _unpack_cmd="tar xvJf $SRCS_DIR/$_filename -C $_lib_name > $_log_name 2>&1" ;;
					.tar.7z) die "unimplemented. terminate." ;;
					.7z) _unpack_cmd="7za x $SRCS_DIR/$_filename -o$_lib_name > $_log_name 2>&1" ;;
					*) die " error. bad archive type: $_ext" ;;
				esac
				eval ${_unpack_cmd}
				_result=$?
				[[ $_result == 0 ]] && {
					echo " done"
					touch $_marker_name
				} || {
					[[ $SHOW_LOG_ON_ERROR == yes ]] && $LOGVIEWER $_log_name &
					die "Error $_result"
				}
			} || {
				echo "---> $_filename unpacked"
			}
		}
	done
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
	
	_index=0
	((_index=${#_commands[@]}-1))
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

	[[ $_index == ${#_commands[@]} ]] && echo " done"

	return $_result
}

# **************************************************************************

# apply list of patches
function func_apply_patches {
	# $1 - srcs dir name
	# $2 - src dir name
	# $3 - logs dir
	# $4 - patches dir
	# $5 - patches list
	
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
			[[ -f $PATCHES_DIR/${it} ]] || die "Patch $PATCHES_DIR/${it} not found!"
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

	[[ $_result == 0 ]] && echo " done" || echo "error!"

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

# функция, выполняет сборку и/или выполнение тестов.
# первым аргументом требует имя результирующего исполняемого файла.
# вторым аргументом - список файлов(.c/.cpp/.o) с опциями для их сборки.
#   первым, должно быть имя файла с расширением.

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
				local _ext=${_first##*.}
				local _run_log=$3/$arch_it/$_first-execution.log

				case $_ext in
					c)
						printf "%-50s" "--> GCC     $arch_it: \"$_first\" ... "
						local _log_file=$3/$arch_it/$_first-c-compilation.log
						echo "gcc -m${arch_it} $COMMON_CXXFLAGS $COMMON_LDFLAGS $TESTS_DIR/$_prev $3/$arch_it/$_last" > $_log_file
						( cd $3/$arch_it && gcc -m${arch_it} $COMMON_CFLAGS $COMMON_LDFLAGS $TESTS_DIR/$_prev $3/$arch_it/$_last >> $_log_file 2>&1 )
					;;
					cpp)
						printf "%-50s" "--> G++     $arch_it: \"$_first\" ... "
						local _log_file=$3/$arch_it/$_first-cpp-compilation.log
						echo "g++ -m${arch_it} $COMMON_CXXFLAGS $COMMON_LDFLAGS $TESTS_DIR/$_prev $3/$arch_it/$_last" > $_log_file
						( cd $3/$arch_it && g++ -m${arch_it} $COMMON_CXXFLAGS $COMMON_LDFLAGS $TESTS_DIR/$_prev $3/$arch_it/$_last >> $_log_file 2>&1 )
					;;
					o)
						printf "%-50s" "--> LD      $arch_it: \"$_last\" ... "
						local _log_file=$3/$arch_it/$_first-link.log
						echo "g++ -m${arch_it} $src_it" > $_log_file
						( cd $3/$arch_it && g++ -m${arch_it} $src_it >> $_log_file 2>&1 )
					;;
				esac
				_result=$?
				[[ $_result == 0 ]] && {
					echo "-> $_result -> done"
				} || {
					echo "-> $_result -> error. terminate."
					[[ $SHOW_LOG_ON_ERROR == yes ]] && $LOGVIEWER $_log_file &
					exit $_result
				}
				[[ $_last =~ .exe ]] && {
					printf "%-50s" "--> execute $arch_it: \"$_last\" ... "
					( cd $3/$arch_it && ./$_last > $_run_log 2>&1 )
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

	[[ ! -d $2 || ! $2/bin/gcc.exe ]] && {
		# x32 download
		echo -e "-> \E[32;40mx32 toolchain\E[37;40m"
		local -a _url32=( "$4|root:$1" )
		func_download _url32[@]
		func_uncompress _url32[@]

	}

	[[ $EXCEPTIONS_MODEL == seh || $EXCEPTIONS_MODEL == sjlj ]] && {
		[[ ! -d $3 || ! $3/bin/gcc.exe ]] && {
			# x64 download
			echo -e "-> \E[32;40mx64 toolchain\E[37;40m"
			local -a _url64=( "$5|root:$1" )
			func_download _url64[@]
			func_uncompress _url64[@]
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
		gcc-4_7-branch)	echo "4.7.4" ;;
		gcc-4_8-branch)	echo "4.8.2" ;;
		gcc-4_9-branch)	echo "4.9.1" ;;
		gcc-trunk)			echo "4.9.0" ;;
		*) die "gcc name error: $1. terminate." ;;
	esac
}

# **************************************************************************

function func_map_gcc_name_to_gcc_build_name {
	# $1 - sources root dir
	# $2 - gcc name

	local _gcc_type=$(func_map_gcc_name_to_gcc_type $2)
	local _gcc_version=$(func_map_gcc_name_to_gcc_version $2)
	local _build_name=$_gcc_version-$_gcc_type

	[[ $_gcc_type != release ]] && {
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
		*) die "gcc name error: \"$3\". terminate." ;;
	esac
	case $3 in
		gcc-4_6-branch) _upload_cmd="$_upload_cmd/4.6.5" ;;
		gcc-4_7-branch) _upload_cmd="$_upload_cmd/4.7.4" ;;
		gcc-4_8-branch) _upload_cmd="$_upload_cmd/4.8.2" ;;
		gcc-trunk) _upload_cmd="$_upload_cmd/4.9.0" ;;
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

function func_download_repository_file {
	#1 - repository file name
	
	local _src="http://sourceforge.net/projects/mingwbuilds/files/host-windows/repository.txt"
	wget $_src -O "$1"
	local _result=$?
	[[ $_result != 0 ]] && { die "error($_result) when downloading repository file. terminate."; }
}

function func_update_repository_file {
	#1 - repository file name
	#2 - version
	#3 - architecture
	#4 - threads model
	#5 - exceptions model
	#6 - revision
	#7 - url for archive
	
	[[ ! -f $1 ]] && {
		die "repository file \"$1\" is not exists. terminate."
		exit 1
	}
	
	echo "$2|$3|$4|$5|$6|$7" >> $1
}

function func_upload_repository_file {
	#1 - file name
	echo "";
}

# **************************************************************************
