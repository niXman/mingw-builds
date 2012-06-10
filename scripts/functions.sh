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
	# $1 - name
	# $2 - sources type: .tar.gz, .tar.bz2 e.t.c...
	#      if library get from a repository, choose it's type: cvs, svn, hg, git
	# $3 - URL
	# $4 - log file name

	local WGET_TIMEOUT=5
	local WGET_TRIES=10
	local WGET_WAIT=2

	local marker=$SRCS_DIR/$1/_download.marker
	local result=0

	[[ -z $3 ]] && {
		echo "URL is empty. terminate."
		exit 1
	}

	[[ ! -f $marker ]] && {
		[[ $2 == cvs || $2 == svn || $2 == hg || $2 == git ]] && {
			local LIB_NAME=$SRCS_DIR/$1
		} || {
			local LIB_NAME=$SRCS_DIR/$1$2
		}

		echo -n "--> download..."

		case $2 in
			cvs)
				local _prev_dir=$PWD
				cd $SRCS_DIR
				eval ${3} > $4 2>&1
				result=$?
				cd $_prev_dir
			;;
			svn)
				svn co $3 $LIB_NAME > $4 2>&1
				result=$?
			;;
			hg)
				hg clone $3 $LIB_NAME > $4 2>&1
				result=$?
			;;
			git)
				git clone $3 $LIB_NAME > $4 2>&1
				result=$?
			;;
			*)
				[[ ! -f $marker && -f $LIB_NAME ]] && rm -rf $LIB_NAME
				wget \
					--tries=$WGET_TRIES \
					--timeout=$WGET_TIMEOUT \
					--wait=$WGET_WAIT \
					$3 -O $LIB_NAME > $4 2>&1
				result=$?
			;;
		esac

		[[ $result == 0 ]] && { echo " done"; touch $marker; } || { echo " error!"; }
	} || {
		echo " ---> downloaded"
	}
	return $result
}

# **************************************************************************

# uncompress sources
function func_uncompress {
	# $1 - name
	# $2 - ext
	# $3 - log file name

	local marker=$SRCS_DIR/$1/_uncompress.marker
	local result=0
	local tar_flags

	[[ $2 == .tar.gz || $2 == .tar.bz2 || $2 == .tar.lzma || $2 == .tar.xz ]] && {
		[[ ! -f $marker ]] && {
			echo -n "--> unpack..."
			case $2 in
				.tar.gz) tar_flags=f ;;
				.tar.bz2) tar_flags=jf ;;
				.tar.lzma|.tar.xz) tar_flags=Jf ;;
				*) echo " error. bad archive type: $2"; return 1 ;;
			esac
			tar xv$tar_flags $SRCS_DIR/$1$2 -C $SRCS_DIR > $3 2>&1
			result=$?
			[[ $result == 0 ]] && { echo " done"; touch $marker; } || { echo " error!"; }
		} || {
			echo " ---> unpacked"
		}
	}
	return $result
}

# **************************************************************************

# execute list of commands
function func_execute {
	# $1 - src dir name
   # $2 - message
   # $3 - commands list

   local -a _commands=( "${!3}" )
   _function_result=0

   declare -i _index=${#_commands[@]}-1
	local _cmd_marker_name=$SRCS_DIR/$1/exec-$_index.marker

   [[ -f $_cmd_marker_name ]] && {
		echo "---> executed"
		return $_function_result
   }
   _index=0

   [[ ${#_commands[@]} > 0 ]] && {
		echo -n "--> $2"
   }

   for it in "${_commands[@]}"; do
		_cmd_marker_name=$SRCS_DIR/$1/exec-$_index.marker
		local _cmd_log_name=$LOGS_DIR/$1/exec-$_index.log

      [[ ! -f $_cmd_marker_name ]] && {
         ( cd $SRCS_DIR/$1; eval ${it} > $_cmd_log_name 2>&1 )
         _function_result=$?
         [[ $_function_result != 0 ]] && {
            echo "error!"
            return $_function_result
         } || {
            touch $_cmd_marker_name
         }
      }

      ((_index++))
   done

   [[ $_index == ${#_commands[@]} ]] && echo "done"

   return $_function_result
}

# **************************************************************************

# apply list of patches
function func_apply_patches {
   # $1 - src dir name
   # $2 - list

   _function_result=0

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
         ( cd $SRCS_DIR/$1 && patch -p1 < "$PATCHES_DIR/${it}" > $LOGS_DIR/$1/patch-$_index.log 2>&1 )
         _function_result=$?
         [[ $_function_result == 0 ]] && {
            touch $_patch_marker_name
         } || {
            _function_result=1
            break
         }
      }

      ((_index++))
   done

	[[ $_function_result == 0 ]] && echo "done" || echo "error!"
   
   return $_function_result
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
		echo " ---> $6"
	}
	return $_result
}

# **************************************************************************

function run_test {
	# $1 - executable name
	# $2 - sources names
	# $3 - tests dir
	
	local -a _list=( "${!2}" )

	[[ $USE_DWARF_EXCEPTIONS == no ]] && {
		local -a _archs=(32 64)
	} || {
		local -a _archs=(32)
	}
	
	for arch_it in ${_archs[@]}; do
		[[ ! -f $3/$arch_it/$1.marker ]] && {
			for src_it in "${_list[@]}"; do
				local _first=$(echo $src_it | sed 's/\([^ ]*\).*/\1/' )
				local _prev=$( echo $src_it | sed '$s/ *\([^ ]* *\)$//' )
				local _last=$( echo $src_it | sed 's/^.* //' )
				local _cmp_log=$3/$arch_it/$_first-compilation.log
				local _run_log=$3/$arch_it/$_first-execution.log

				#echo "$PREFIX/bin/g++ -m${arch_it} $COMMON_CXXFLAGS $COMMON_LDFLAGS $TESTS_DIR/$_prev $3/$arch_it/$_last"
				#echo "$PREFIX/bin/gcc -m${arch_it} $COMMON_CFLAGS $COMMON_LDFLAGS $TESTS_DIR/$_prev $3/$arch_it/$_last"
				
				[[ ${_prev%% *} =~ .cpp ]] && {
					local _gcc_or_gpp=gpp
				} || {
					local _gcc_or_gpp=gcc
				}
				
				echo -n "--> $([[ $_gcc_or_gpp == gpp ]] && echo -n G++ || echo -n GCC) compile $arch_it: \"$_first\" ... "
				[[ $_gcc_or_gpp == gpp ]] && {
					echo "g++ -m${arch_it} $COMMON_CXXFLAGS $COMMON_LDFLAGS $TESTS_DIR/$_prev $3/$arch_it/$_last" > $_cmp_log
					( cd $3/$arch_it; g++ -m${arch_it} $COMMON_CXXFLAGS $COMMON_LDFLAGS $TESTS_DIR/$_prev $3/$arch_it/$_last >> $_cmp_log 2>&1 )
				} || {
					echo "gcc -m${arch_it} $COMMON_CXXFLAGS $COMMON_LDFLAGS $TESTS_DIR/$_prev $3/$arch_it/$_last" > $_cmp_log
					( cd $3/$arch_it; gcc -m${arch_it} $COMMON_CFLAGS $COMMON_LDFLAGS $TESTS_DIR/$_prev $3/$arch_it/$_last >> $_cmp_log 2>&1 )
				}
				local _result=$?
				[[ $_result == 0 ]] && {
					echo "done" 
				} || { 
					echo "error. terminate."; exit $_result
				}
				[[ $_last =~ .exe ]] && {
					echo -n "--> execute $arch_it: \"$_last\" -> "
					( cd $3/$arch_it; $_last > $_run_log 2>&1 )
					_result=$?
					[[ $_result == 0 ]] && {
						echo "$_result -> done"
					} || {
						echo "$_result -> error"
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
