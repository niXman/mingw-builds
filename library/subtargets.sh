#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of 'MinGW-W64' project.
# Copyright (c) 2011,2012,2013 by niXman (i dotty nixman doggy gmail dotty com)
# Copyright (c) 2012,2013 by Alexpux (alexpux doggy gmail dotty com)
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

function fun_get_subtargets {
   # $1 - mode (gcc, clang, python)
	# $2 - version

	local readonly LIBICONV_X32_SUBTARGETS=(
		fix-path-for-x32-pre
		libiconv-x32
		fix-path-for-x32-post
	)

	local readonly LIBICONV_X64_SUBTARGETS=(
		fix-path-for-x64-pre
		libiconv-x64
		fix-path-for-x64-post
	)

	local readonly WINPTHREADS_X32_SUBTARGETS=(
		fix-path-for-x32-pre
		winpthreads-x32
		fix-path-for-x32-post
	)

	local readonly WINPTHREADS_X64_SUBTARGETS=(
		fix-path-for-x64-pre
		winpthreads-x64
		fix-path-for-x64-post
	)

	local readonly ZLIB_X32_SUBTARGETS=(
		fix-path-for-x32-pre
		zlib-x32
		fix-path-for-x32-post
	)

	local readonly ZLIB_X64_SUBTARGETS=(
		fix-path-for-x64-pre
		zlib-x64
		fix-path-for-x64-post
	)

	local readonly SUBTARGETS_PART1=(
		gmp
		mpfr
		mpc
		$( [[ $2 == 4.6.? || $2 == 4.7.? ]] && echo ppl )
		isl
		cloog
		mingw-w64-api
		mingw-w64-crt
	)

	[[ $1 == gcc ]] && {
		local readonly python_version=$DEFAULT_PYTHON_VERSION
	} || {
		local readonly python_version=$2
	}

	local readonly PYTHON_SUBTARGETS=(
		libgnurx
		bzip2
		libffi
		expat
		#tcl
		#tk
		$([[ $python_version == 3.3.0 ]] && echo xz-utils)
		sqlite
		ncurses
		readline
		python-$python_version
	)

	local readonly CLANG_SUBTARGETS=(
		clang-$2
	)

	local readonly SUBTARGETS_PART2=(
		mingw-w64-runtime-post
		binutils
		binutils-post
		$GCC_NAME
		gcc-post
		mingw-w64-libraries-libmangle
		#mingw-w64-libraries-pseh
		mingw-w64-tools-gendef
		mingw-w64-tools-genidl
		mingw-w64-tools-genpeimg
		mingw-w64-tools-widl
		${PYTHON_SUBTARGETS[@]}
		3rdparty-post
		gdbinit
		gdb
		gdb-wrapper
		make_git_bat
		cleanup
		licenses
		build-info
		tests
		$([[ $COMPRESSING_MINGW == yes ]] && echo mingw-compress)
	)

	case $1 in
		clang)
			local readonly SUBTARGETS=(
				${CLANG_SUBTARGETS[@]}
				cleanup
				licenses
				build-info
				$([[ $COMPRESSING_MINGW == yes ]] && echo mingw-compress)
			)
		;;
		gcc)
			[[ $USE_MULTILIB == yes ]] && {
				local readonly SUBTARGETS=(
					${LIBICONV_X32_SUBTARGETS[@]}
					${LIBICONV_X64_SUBTARGETS[@]}
					${ZLIB_X32_SUBTARGETS[@]}
					${ZLIB_X64_SUBTARGETS[@]}	
					${SUBTARGETS_PART1[@]}
					${WINPTHREADS_X32_SUBTARGETS[@]}
					${WINPTHREADS_X64_SUBTARGETS[@]}
					${SUBTARGETS_PART2[@]}
				)
			} || {
				[[ $BUILD_ARCHITECTURE == i686 ]] && {
					local readonly SUBTARGETS=(
						${LIBICONV_X32_SUBTARGETS[@]}
						${ZLIB_X32_SUBTARGETS[@]}
						${SUBTARGETS_PART1[@]}
						${WINPTHREADS_X32_SUBTARGETS[@]}
						${SUBTARGETS_PART2[@]}
					)
				} || {
					local readonly SUBTARGETS=(
						${LIBICONV_X64_SUBTARGETS[@]}
						${ZLIB_X64_SUBTARGETS[@]}
						${SUBTARGETS_PART1[@]}
						${WINPTHREADS_X64_SUBTARGETS[@]}
						${SUBTARGETS_PART2[@]}
					)
				}
			}
		;;
		python)
			local readonly SUBTARGETS=(
				${PYTHON_SUBTARGETS[@]}
				cleanup
				licenses
				build-info
				$([[ $COMPRESSING_MINGW == yes ]] && echo mingw-compress)
			)
		;;
	esac
	
	echo ${SUBTARGETS[@]}
}

# **************************************************************************
