
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

function func_clear_env {
	unset PKG_ARCHITECTURE
	unset PKG_NAME
	unset PKG_DISPLAY_NAME
	unset PKG_VERSION
	unset PKG_DIR_NAME
	unset PKG_SUBDIR_NAME
	unset PKG_PRIORITY
	unset PKG_TYPE
	unset PKG_REVISION
	unset PKG_URLS
	unset PKG_LNDIR
	unset PKG_EXECUTE_AFTER_DOWNLOAD
	unset PKG_EXECUTE_AFTER_UNCOMPRESS
	unset PKG_PATCHES
	unset PKG_EXECUTE_AFTER_PATCH
	unset PKG_CONFIGURE_FLAGS
	unset PKG_EXECUTE_AFTER_CONFIGURE
	unset PKG_MAKE_FLAGS
	unset PKG_INSTALL_FLAGS
	unset PKG_EXECUTE_AFTER_INSTALL
	unset PKG_TESTSUITE_FLAGS
	unset PKG_CONFIGURE_SCRIPT
	unset PKG_MAKE_PROG
	unset PKG_CONFIGURE_PROG

	unset CDPATH
	unset PYTHONHOME
}

function switch_to_reverse_arch {
	# $1 - architecture to switch
	ORIG_ARCH_PATH=$PATH
	local _arch_gcc_path=$(eval "echo \${${1}_HOST_MINGW_PATH}")
	export PATH=$_arch_gcc_path/bin:$ORIGINAL_PATH

	OLD_HOST=$HOST
	OLD_BUILD=$BUILD
	OLD_TARGET=$TARGET
	HOST=$REVERSE_HOST
	BUILD=$REVERSE_BUILD
	TARGET=$REVERSE_TARGET
}

function switch_back_to_arch {
	export PATH=$ORIG_ARCH_PATH

	HOST=$OLD_HOST
	BUILD=$OLD_BUILD
	TARGET=$OLD_TARGET

	unset ORIG_ARCH_PATH
	unset OLD_HOST
	unset OLD_BUILD
	unset OLD_TARGET
}

# **************************************************************************

function die {
	# $1 - message on exit
	# $2 - exit code
	local _retcode=1
	[[ -n $2 ]] && _retcode=$2
	echo
	>&2 echo $1
	exit $_retcode
}

function func_show_log {
	# $1 - log file
	[[ $SHOW_LOG_ON_ERROR == yes ]] && {
		[[ $LOGVIEWER_WAIT == yes ]] && {
			$LOGVIEWER $1
		} || {
			$LOGVIEWER $1 &
		}
	}
}

# **************************************************************************

function func_check_tools {
	# $1 - list of programs
	local _list=( $1 )
	local _it=
	local _err=

	echo -n "-> Checking for necessary tools... "
	for _it in ${_list[@]}; do
		command -v "$_it" > /dev/null 2>&1
		[[ $? != 0 ]] && {
			_err="$_err $_it"
		}
	done
	[[ -n $_err ]] && {
		die "Some of necessary tools not found: $_err"
	} || {
		echo "done"
	}
}

# **************************************************************************

function func_get_reverse_triplet {
	case ${1%%-*} in
		i686) echo "x86_64-${1#*-}" ;;
		x86_64) echo "i686-${1#*-}" ;;
	esac
}

# **************************************************************************

function func_get_arch_bit {
	case $1 in
		i686) echo "32" ;;
		x86_64) echo "64" ;;
	esac
}

# **************************************************************************

function func_get_reverse_arch_bit {
	case $1 in
		i686) echo "64" ;;
		x86_64) echo "32" ;;
	esac
}

# **************************************************************************

function func_get_reverse_arch {
	case $1 in
		i686) echo "x86_64" ;;
		x86_64) echo "i686" ;;
	esac
}

# **************************************************************************

function func_get_filename_extension {
	# $1 - filename

	local _filename=$1
	local _ext=
	local _finish=0
	case "${_filename##*.}" in
		bz2|gz|lzma|xz)
			_ext=$_ext'.'${_filename##*.}
			_filename=${_filename%$_ext}
			local _sub_ext=$(func_get_filename_extension $_filename)
			[[ "$_sub_ext" == ".tar" ]] && _ext=$_sub_ext$_ext
		;;
		*)
			_ext='.'${_filename##*.}
		;;
	esac
	echo "$_ext"
}

# **************************************************************************

function func_check_languages {
	local langs=( ${1//,/ } )
	local lang=
	local _lang_err=

	[[ ${#langs[@]} == 0 ]] && {
		die "you must specify languages to build. terminate."
	} || {
		for lang in ${langs[@]}; do
			case $lang in
				ada|c|c++|fortran|objc|obj-c++) ;;
				d) D_LANG_ENABLED="yes" ;;
				*) _lang_err+=" \"$lang\"" ;;
			esac
		done
		[[ -n "$_lang_err" ]] && { die "the following languages are not supported: $_lang_err. terminate."; }
	}
}

# **************************************************************************

function func_test_vars_list_for_null {
	# $1 - array of vars

	local list=( $1 )
	local it=

	for it in ${list[@]}; do
		eval "test -z $it"
		[[ $? == 0 ]] && { die "var \"$it\" is NULL. terminate."; }
	done
}

# **************************************************************************

function func_has_lang {
	local langs=( ${ENABLE_LANGUAGES//,/ } )
	local errs=
	local lang=

	[[ ${#langs[@]} == 0 ]] && {
		return "0"
	} || {
		for lang in ${langs[@]}; do
			[[ "$lang" == "$1" ]] && {
				return "1"
			}
		done
	}
	return "0"
}

# **************************************************************************

# find the first installed logviewer from the list
function func_find_logviewer {
	# $1 - list of viewers
	# $2 - var name to pass viewer name

	local -a _arr=( "${!1}" )
	local it=
	for it in ${_arr[@]}; do
		command -v "$it" > /dev/null 2>&1
		[[ $? == 0 ]] && {
			eval "$2=\"$it\""
			return 0;
		}
	done

	return 1
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
		[[ $SHORT_OUTPUT != "yes" ]] && echo "--> Doesn't need to download"
		return 0
	}

	local _WGET_TIMEOUT=60
	local _WGET_TRIES=10
	local _WGET_WAIT=2
	local _result=0
	local it=

	for it in ${_list[@]} ; do
		local _params=( ${it//|/ } )

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
		while [ "$_index" -lt "${#_params[@]}" ]; do
			local _params2=( $(echo ${_params[$_index]} | sed 's|:| |g') )
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
		local _repo_update=no
		local _is_repo=no
		[[ $_repo == cvs || $_repo == svn || $_repo == hg || $_repo == git ]] && {
			_is_repo=yes
			[[ $UPDATE_SOURCES == yes ]] && { _repo_update=yes; }
		}
		[[ ! -f $_marker_name || $_repo_update == yes ]] && {
			[[ $_is_repo == yes ]] && {
				echo -n "--> checkout $_filename..."

				[[ -z $_dir ]] && {
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
						[[ -d $_lib_name/.svn ]] && {
							pushd $_lib_name > /dev/null
							svn-clean -f > $_log_name 2>&1
							svn cleanup >> $_log_name 2>&1
							svn status | rm -rf $(awk '/^?/{$1 = ""; print $0}') >> $_log_name 2>&1
							svn revert -R ./ >> $_log_name 2>&1
							[[ -n $_rev ]] && {
								svn up -r $_rev >> $_log_name 2>&1
							} || {
								svn up >> $_log_name 2>&1
							}
							popd > /dev/null
						} || {
							[[ -n $_rev ]] && {
								svn co -r $_rev $_url $_lib_name > $_log_name 2>&1
							} || {
								svn co $_url $_lib_name > $_log_name 2>&1
							}
						}
						_result=$?
					;;
					hg)
						hg clone $_url $_lib_name > $_log_name 2>&1
						_result=$?
					;;
					git)
						[[ -d $_lib_name/.git ]] && {
							pushd $_lib_name > /dev/null
							git clean -f > $_log_name 2>&1
							git reset --hard >> $_log_name 2>&1
							git pull >> $_log_name 2>&1
							popd > /dev/null
						} || {
							[[ -n $_branch ]] && {
								git clone --branch $_branch $_url $_lib_name > $_log_name 2>&1
							} || {
								git clone $_url $_lib_name > $_log_name 2>&1
							}
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
				func_show_log $_log_name
				die " error $_result" $_result
			}
		} || {
			[[ $SHORT_OUTPUT != "yes" ]] && echo "---> $_filename downloaded"
		}
	done
}

# **************************************************************************

# uncompress sources
function func_uncompress {
	# $1 - list of archives

	local -a _list=( "${!1}" )
	local it=
	[[ ${#_list[@]} == 0 ]] && {
		[[ $SHORT_OUTPUT != "yes" ]] && echo "--> Unpack doesn't need"
		return 0
	}

	for it in ${_list[@]} ; do
		local _params=( ${it//|/ } )
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
			local _params2=( $(echo ${_params[$_index]} | sed 's|:| |g') )
			case ${_params2[0]} in
				dir)    _dir=${_params2[1]} ;;
				root)   _root=${_params2[1]} ;;
				module) _module=${_params2[1]} ;;
			esac
			_index=$(($_index+1))
		done

		_lib_name=${_root}/${_dir}
		_filename=$(basename ${_params[0]})
		local _log_dir=$SRCS_DIR/$PKG_DIR_NAME
		[[ -n $2 ]] && {
			_log_dir=$2
		}
		_log_name=$_log_dir/${_filename}-unpack.log
		_marker_name=$_log_dir/${_filename}-unpack.marker
		_ext=$(func_get_filename_extension $_filename)
		[[ $_ext == .tar.gz || $_ext == .tar.bz2 || $_ext == .tar.lzma || $_ext == .tar.xz \
		|| $_ext == .tar.7z || $_ext == .7z || $_ext == .tgz || $_ext == .zip ]] && {
			[[ ! -f $_marker_name ]] && {
				echo -n "--> unpack $_filename..."
				case $_ext in
					.tar.gz|.tgz) _unpack_cmd="tar xvf $SRCS_DIR/$_filename -C $_lib_name > $_log_name 2>&1" ;;
					.tar.bz2) _unpack_cmd="tar xvjf $SRCS_DIR/$_filename -C $_lib_name > $_log_name 2>&1" ;;
					.tar.lzma|.tar.xz) _unpack_cmd="tar xvJf $SRCS_DIR/$_filename -C $_lib_name > $_log_name 2>&1" ;;
					.tar.7z) die "unimplemented. terminate." ;;
					.7z) _unpack_cmd="7za x $SRCS_DIR/$_filename -o$_lib_name > $_log_name 2>&1" ;;
					.zip) _unpack_cmd="unzip $SRCS_DIR/$_filename -d $_lib_name > $_log_name 2>&1" ;;
					*) die " error. bad archive type: $_ext" ;;
				esac
				eval ${_unpack_cmd} || true
				_result=$?
				[[ $_result == 0 ]] && {
					echo " done"
					touch $_marker_name
				} || {
					func_show_log $_log_name
					die " error $_result" $_result
				}
			} || {
				[[ $SHORT_OUTPUT != "yes" ]] && echo "---> $_filename unpacked"
			}
		}
	done
}

# **************************************************************************

# execute list of commands
function func_execute {
	# $1 - execute dir
	# $2 - src dir name
	# $3 - message
	# $4 - log suffix
	# $5 - commands list

	local _result=0
	local -a _commands=( "${!5}" )
	local it=

	local _index=0
	((_index=${#_commands[@]}-1))
	local _cmd_marker_name=$1/$2/exec-$4-$_index.marker
	[[ -f $_cmd_marker_name ]] && {
		[[ $SHORT_OUTPUT != "yes" ]] && echo "---> $4 executed"
		return $_result
	}
	_index=0

	[[ ${#_commands[@]} > 0 ]] && {
		echo -n "--> $3"
	}

	for it in "${_commands[@]}"; do
		local _cmd_marker_name=$1/$2/exec-$4-$_index.marker
		local _cmd_log_name=$1/$2/exec-$4-$_index.log
		local _cmd_command_cmd=$1/$2/exec-$4-$_index.cmd

		[[ ! -f $_cmd_marker_name ]] && {
			pushd $1/$2 > /dev/null
			echo "${it}" > $_cmd_command_cmd 2>&1
			eval ${it} > $_cmd_log_name 2>&1
			_result=$?
			popd > /dev/null
			[[ $_result == 0 ]] && {
				touch $_cmd_marker_name
			} || {
				break
			}
		}
		((_index++))
	done

	[[ $_result == 0 ]] && {
		echo " done"
	} || {
		func_show_log $_cmd_log_name
		die "Failed to execute \"${it}\"" $_result
	}
}

# **************************************************************************

# apply list of patches
function func_apply_patches {
	# $1 - srcs dir name
	# $2 - src dir name
	# $3 - patches dir
	# $4 - patches list

	local _result=0
	local it=
	local applevel=
	local _index=0
	local -a _list=( "${!4}" )
	[[ ${#_list[@]} == 0 ]] && return 0

	((_index=${#_list[@]}-1))
	[[ -f $1/$2/_patch-$_index.marker ]] && {
		[[ $SHORT_OUTPUT != "yes" ]] && echo "---> patched"
		return 0
	}
	_index=0

	[[ ${#_list[@]} > 0 ]] && {
		echo -n "--> patching..."
	}

	for it in ${_list[@]} ; do
		local _patch_marker_name=$1/$2/_patch-$_index.marker
		local _patch_log_name=$1/$2/patch-$_index.log
		local _patch_file=$3/${it}

		[[ ! -f $_patch_marker_name ]] && {
			[[ -f $_patch_file ]] || die "Patch $_patch_file not found!"
			local _level=
			local _found=no
			pushd $1/$2 > /dev/null
			for _level in 0 1 2 3; do
				local _applevel=$_level
				patch -p$_level --dry-run -i $_patch_file > $_patch_log_name 2>&1
				_result=$?
				[[ $_result == 0 ]] && {
					_found=yes
					break
				}
			done
			[[ $_found == yes ]] && {
				patch -p$_applevel -i $_patch_file > $_patch_log_name 2>&1
				_result=$?
				[[ $_result == 0 ]] && {
					touch $_patch_marker_name
				}
			} || {
				die "Not found level for patch ${it}, error=$_result"
				_result=1
				break
			}
			popd > /dev/null
		}
		((_index++))
	done

	[[ $_result == 0 ]] && {
		echo " done"
	} || {
		func_show_log $_patch_log_name
		echo " error"
		die "Failed to apply patch ${it} at level $_applevel"
	}
}

# **************************************************************************

# configure
function func_configure {
	# $1 - name
	# $2 - src dir name
	# $3 - flags
	# $4 - log file name
	# $5 - build dir
	# $6 - lndir
	# $7 - build subdir

	[[ $6 == yes ]] && {
		mkdir -p $5/$1
		[[ ! -f $5/$1/lndir.marker ]] && {
			lndir $SRCS_DIR/$2 $5/$1 > /dev/null
			touch $5/$1/lndir.marker
		}
	}
	local _marker=$5/$1/_configure.marker
	local _result=0
	local _subsrcdir=$2
	local _subbuilddir=$1
	[[ -n $7 ]] && {
		_subbuilddir=$_subbuilddir/$7
		_subsrcdir=$_subsrcdir/$7
	}

	[[ ! -f $_marker ]] && {
		#echo "CFLAGS=\"$CFLAGS\", CXXFLAGS=\"$CXXFLAGS\", CPPFLAGS=\"$CPPFLAGS\", LDFLAGS=\"$LDFLAGS\""
		#echo "ARGS=\"${3}\""
		echo -n "--> configure..."
		pushd $5/$_subbuilddir > /dev/null
		[[ $6 == yes ]] && {
			local _rel_dir="."
		} || {
			local _rel_dir=$( func_absolute_to_relative $5/$_subbuilddir $SRCS_DIR/$_subsrcdir )
		}
		eval $PKG_CONFIGURE_PROG $_rel_dir/$PKG_CONFIGURE_SCRIPT "${3}" > $4 2>&1
		_result=$?
		popd > /dev/null
		[[ $_result == 0 ]] && {
			echo " done"
			touch $_marker
		} || {
			func_show_log $4
			die " error!" $_result
		}
	} || {
		[[ $SHORT_OUTPUT != "yes" ]] && echo "---> configured"
	}
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
	# $8 - build subdir

	local _marker=$7/$1/_$6.marker
	local _result=0
	local _subdir=$1
	[[ -n $8 ]] && {
		_subdir=$_subdir/$8
	}

	[[ ! -f $_marker ]] && {
		echo -n "--> $5"
		pushd $7/$_subdir > /dev/null
		eval ${3} > $4 2>&1
		_result=$?
		popd > /dev/null
		[[ $_result == 0 ]] && {
			echo " done"
			touch $_marker
		} || {
			func_show_log $4
			die " error!" $_result
		}
	} || {
		[[ $SHORT_OUTPUT != "yes" ]] && echo "---> $6"
	}
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

	[[ $BUILD_MODE == gcc ]] && {
		local CC_NAME=gcc
		local CXX_NAME=g++
		local LD_NAME=g++
	} || {
		local CC_NAME=clang
		local CXX_NAME=clang++
		local LD_NAME=clang++
	}
	local CC_FLAGS="-O2"
	local CXX_FLAGS="$CC_FLAGS"
	local LD_FLAGS="-s"

	local _result=0
	local -a _list=( "${!2}" )
	local arch_it=
	local src_it=

	[[ $USE_MULTILIB == no ]] && {
		local -a _archs=($BUILD_ARCHITECTURE)
	} || {
		local _reverse_arch=$(func_get_reverse_arch $BUILD_ARCHITECTURE)
		local -a _archs=($BUILD_ARCHITECTURE $_reverse_arch)
	}

	for arch_it in ${_archs[@]}; do
		[[ ! -f $3/$arch_it/$1.marker ]] && {
			local _arch_bits=$(func_get_arch_bit $arch_it)
			for src_it in "${_list[@]}"; do
				local _first=$(echo $src_it | sed 's/\([^ ]*\).*/\1/' )
				local _prev=$( echo $src_it | sed '$s/ *\([^ ]* *\)$//' )
				local _last=$( echo $src_it | sed 's/^.* //' )
				local _ext=${_first##*.}

				pushd $3/$arch_it > /dev/null
				case $_ext in
					c)
						printf "%-50s" "--> $CC_NAME      $arch_it: \"$_first\" ... "
						local _log_file=$3/$arch_it/$_first-compilation.log
						local _cmd=$( echo "$CC_NAME -m$_arch_bits $CC_FLAGS $LD_FLAGS $TESTS_DIR/$_prev $3/$arch_it/$_last" )
						echo "$_cmd" > $_log_file
						eval ${_cmd} >> $_log_file 2>&1
					;;
					cpp)
						printf "%-50s" "--> $CXX_NAME     $arch_it: \"$_first\" ... "
						local _log_file=$3/$arch_it/$_first-compilation.log
						local _cmd=$( echo "$CXX_NAME -m$_arch_bits $CXX_FLAGS $LD_FLAGS $TESTS_DIR/$_prev $3/$arch_it/$_last" )
						echo "$_cmd" > $_log_file
						eval ${_cmd} >> $_log_file 2>&1
					;;
					o)
						printf "%-50s" "--> $LD_NAME      $arch_it: \"$_last\" ... "
						local _log_file=$3/$arch_it/$_first-link.log
						local _cmd=$( echo "$LD_NAME $LD_FLAGS -m$_arch_bits $src_it" )
						echo "$_cmd" > $_log_file
						eval ${_cmd} >> $_log_file 2>&1
					;;
				esac
				_result=$?
				popd > /dev/null
				[[ $_result == 0 ]] && {
					echo "-> $_result -> done"
				} || {
					func_show_log $_log_file
					die "-> $_result -> error. terminate." $_result
				}
				[[ $_last =~ .exe ]] && {
					printf "%-50s" "--> execute $arch_it: \"$_last\" ... "
					local _run_log=$3/$arch_it/$_first-execution.log
					pushd $3/$arch_it > /dev/null
					./$_last > $_run_log 2>&1
					_result=$?
					popd > /dev/null
					[[ $_result == 0 ]] && {
						echo "-> $_result -> done"
					} || {
						func_show_log $_run_log
						die "-> $_result -> error. terminate." $_result
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

function func_abstract_toolchain {
	# $1 - toolchains top directory
	# $2 - toolchain URL
	# $3 - install path
	# $4 - toolchain arch
	local -a _url=( "$2|root:$1" )
	local _filename=$(basename $2)

	echo -e "-> ${COLOR_STATUS}$4 toolchain${COLOR_RESET}"
	[[ ! -f $1/${_filename}-unpack.marker ]] && {
		[[ -d $3 ]] && {
			echo "--> Found previously installed $4 toolchain."
			echo -n "---> Remove previous $4 toolchain..."
			rm -rf $3
			rm $(dirname $3)/$4-*-unpack.log
			rm $(dirname $3)/$4-*-unpack.marker
			echo " done"
		} || {
			echo -n "--> $4 toolchain is not installed "
		}
		func_download _url[@]
		func_uncompress _url[@] $1
	} || {
		[[ $SHORT_OUTPUT != "yes" ]] && echo "--> Toolchain installed."
	}
}

function func_install_toolchain {
	# $1 - toolchains path
	# $2 - i686-mingw install path
	# $3 - x86_64-mingw install path
	# $4 - i686-mingw URL
	# $5 - x86_64-mingw URL

	[[ $USE_MULTILIB == yes || -z ${BUILD_ARCHITECTURE} ]] && {
		local _arch=both
	} || {
		local _arch=$BUILD_ARCHITECTURE
	}
	case $_arch in
		i686)
			func_abstract_toolchain $1 $4 $2 $_arch
		;;
		x86_64)
			func_abstract_toolchain $1 $5 $3 $_arch
		;;
		both)
			func_abstract_toolchain $1 $4 $2 i686
			func_abstract_toolchain $1 $5 $3 x86_64
		;;
		*)
			die "Can't install toolchain for architecture $_arch."
		;;
	esac
}

# **************************************************************************

function func_map_gcc_name_to_gcc_type {
	# $1 - gcc name

	case $1 in
		gcc-*.?.?) echo release ;;
		gcc-*-branch) echo prerelease ;;
		gcc-trunk) echo snapshot ;;
		*) echo "gcc name error: $1. terminate."; exit 1 ;;
	esac
}

# **************************************************************************

function func_map_gcc_name_to_gcc_version {
	# $1 - gcc name

	case $1 in
		gcc-*.?.?)		echo "${1/gcc-/}" ;;
		gcc-4_6-branch)	echo "4.6.5" ;;
		gcc-4_7-branch)	echo "4.7.5" ;;
		gcc-4_8-branch)	echo "4.8.6" ;;
		gcc-4_9-branch)	echo "4.9.5" ;;
		gcc-5-branch)	echo "5.6.0" ;;
		gcc-6-branch)	echo "6.5.0" ;;
		gcc-7-branch)	echo "7.6.0" ;;
		gcc-8-branch)	echo "8.6.0" ;;
		gcc-9-branch)	echo "9.4.0" ;;
		gcc-10-branch)	echo "10.4.0" ;;
		gcc-11-branch)	echo "11.2.0" ;;
		gcc-trunk)		echo "12.0.0" ;;
		*) die "gcc name error: $1. terminate." ;;
	esac
}

# **************************************************************************

function func_map_gcc_name_to_gcc_build_name {
	# $1 - sources root dir
	# $2 - gcc name

	local _gcc_type=$(func_map_gcc_name_to_gcc_type $2)
	local _gcc_version=$(func_map_gcc_name_to_gcc_version $2)
	local _build_name=$_gcc_version
	[[ $BUILD_SHARED_GCC == no ]] && {
		_build_name=$_build_name-static
	}
	_build_name=$_build_name-$_gcc_type

	[[ $_gcc_type != release ]] && {
		case $2 in
			gcc-*-branch|gcc-trunk)
				if [ -d "$1/$2/.git" ]; then
					local _gcc_rev="rev$(cd $1/$2 && git log --pretty=format:'%h' -n 1)"
				else
					local _gcc_rev="rev$(cd $1/$2 && svn info | grep 'Revision: ' | sed 's|Revision: ||')"
				fi
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

	_archive=$_archive-rt_${RUNTIME_VERSION}
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
		_archive=$_archive-rt_${RUNTIME_VERSION}-rev$4
	}

	echo "$_archive.tar.7z"
}

# **************************************************************************

function func_create_mingw_upload_cmd {
	# $1 - build root dir
	# $2 - sf user name
	# $3 - sf password
	# $4 - gcc name
	# $5 - archive name
	# $6 - architecture
	# $7 - threads model
	# $8 - exceptions model

	local _gcc_version=$(func_map_gcc_name_to_gcc_version $4)
	local _upload_cmd="sshpass -p $3 scp $5 $2@frs.sourceforge.net:$PROJECT_FS_ROOT_DIR/'Toolchains\ targetting\ Win$( [[ $6 == i686 ]] && echo 32 || echo 64 )/Personal\ Builds/mingw-builds/$_gcc_version/threads-$7/$8'"

	echo "$_upload_cmd"
}

# **************************************************************************

function func_create_sources_upload_cmd {
	# $1 - build root dir
	# $2 - sf user name
	# $3 - sf user password
	# $4 - gcc name
	# $5 - archive name

	local _upload_cmd="sshpass -p $3 scp $5 $2@frs.sourceforge.net:$PROJECT_FS_ROOT_DIR/'Toolchain\ sources/Personal\ Builds/mingw-builds/$(func_map_gcc_name_to_gcc_version $4)'"

	echo "$_upload_cmd"
}

# **************************************************************************

function func_create_url_for_archive {
	# $1 - base URL
	# $2 - gcc name
	# $3 - architecture
	# $4 - threads model
	# $5 - exceptions model

	local _gcc_version=$(func_map_gcc_name_to_gcc_version $2)
	local _upload_url="$1/files/Toolchains targetting Win$( [[ $3 == i686 ]] && echo 32 || echo 64 )/Personal Builds/mingw-builds/$_gcc_version/threads-$4/$5"
	_upload_url=${_upload_url// /%20}

	echo "$_upload_url"
}

function func_update_repository_file {
	# $1 - repository file name
	# $2 - version
	# $3 - architecture
	# $4 - threads model
	# $5 - exceptions model
	# $6 - revision
	# $7 - url for archive
	# $8 - archive file name

	[[ ! -f $1 ]] && { die "repository file \"$1\" is not exists. terminate."; }

	printf "%5s|%-6s|%5s|%-5s|%-5s|%s\n" $2 $3 $4 $5 "rev$6" "$7/$8" >> $1
}

function func_create_repository_file_upload_cmd {
	# $1 - local file name
	# $2 - sf user name
	# $3 - sf user password

	echo "sshpass -p $3 scp $1 $2@frs.sourceforge.net:$PROJECT_FS_ROOT_DIR/'Toolchains\ targetting\ Win32/Personal\ Builds/mingw-builds/installer'"
}

# **************************************************************************

function func_dbg_hook {
	# $1 - subtarget name
	# $2 - hook name

	for hook in $DBG_HOOKS; do
		[[ $hook == "$1|$2|"* ]] && {
			local hook_script=${hook/$1|$2|/}
			echo "--> Calling hook $1|$2 => $hook_script"
			source $hook_script
		}
	done
}

# **************************************************************************
