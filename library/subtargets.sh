
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

readonly LIBICONV_X32_SUBTARGETS=(
	libiconv-x32-pre
	libiconv-x32
	libiconv-x32-post
)

readonly LIBICONV_X64_SUBTARGETS=(
	libiconv-x64-pre
	libiconv-x64
	libiconv-x64-post
)

readonly WINPTHREADS_X32_SUBTARGETS=(
	winpthreads-x32-pre
	winpthreads-x32
	winpthreads-x32-post
)

readonly WINPTHREADS_X64_SUBTARGETS=(
	winpthreads-x64-pre
	winpthreads-x64
	winpthreads-x64-post
)

readonly ZLIB_X32_SUBTARGETS=(
	zlib
	zlib-x32-post
)

readonly ZLIB_X64_SUBTARGETS=(
	zlib
	zlib-x64-post
)

readonly SUBTARGETS_PART1=(
	gmp
	mpfr
	mpc
	ppl
	isl
	cloog
	mingw-w64-api
	mingw-w64-crt
)

readonly PYTHON_SUBTARGETS=(
	libgnurx
	bzip2
	libffi
	expat
	#tcl
	#tk
	$([[ $PYTHON_VERSION == 3.3.0 ]] && echo "xz-utils")
	sqlite
	ncurses
	readline
	python-$PYTHON_VERSION
)

readonly CLANG_SUBTARGETS=(
	clang-$CLANG_VERSION
)

readonly SUBTARGETS_PART2=(
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
	$([[ $COMPRESSING_MINGW == yes ]] && echo "mingw-compress")
)

case $BUILD_MODE in
	clang)
		readonly SUBTARGETS=(
			${CLANG_SUBTARGETS[@]}
			cleanup
			licenses
			build-info
			$([[ $COMPRESSING_MINGW == yes ]] && echo mingw-compress)
		)
	;;
	gcc)
		[[ $USE_MULTILIB == yes ]] && {
			readonly SUBTARGETS=(
				${LIBICONV_X32_SUBTARGETS[@]}
				${LIBICONV_X64_SUBTARGETS[@]}
				${ZLIB_X32_SUBTARGETS[@]}
				${ZLIB_X64_SUBTARGETS[@]}	
				${SUBTARGETS_PART1[@]}
				${WINPTHREADS_X32_SUBTARGETS[@]}
				${WINPTHREADS_X64_SUBTARGETS[@]}
				${SUBTARGETS_PART2[@]}
			)
			readonly PROCESSOR_OPTIMIZATION="--with-arch-32=$PROCESSOR_OPTIMIZATION_ARCH_32 --with-arch-64=$PROCESSOR_OPTIMIZATION_ARCH_64"
			readonly PROCESSOR_TUNE="--with-tune-32=$PROCESSOR_OPTIMIZATION_TUNE_32 --with-tune-64=$PROCESSOR_OPTIMIZATION_TUNE_64"
		} || {
			[[ $BUILD_ARCHITECTURE == x32 ]] && {
				readonly SUBTARGETS=(
					${LIBICONV_X32_SUBTARGETS[@]}
					${ZLIB_X32_SUBTARGETS[@]}
					${SUBTARGETS_PART1[@]}
					${WINPTHREADS_X32_SUBTARGETS[@]}
					${SUBTARGETS_PART2[@]}
				)
				readonly PROCESSOR_OPTIMIZATION="--with-arch=$PROCESSOR_OPTIMIZATION_ARCH_32"
				readonly PROCESSOR_TUNE="--with-tune=$PROCESSOR_OPTIMIZATION_TUNE_32"
			} || {
				readonly SUBTARGETS=(
					${LIBICONV_X64_SUBTARGETS[@]}
					${ZLIB_X64_SUBTARGETS[@]}
					${SUBTARGETS_PART1[@]}
					${WINPTHREADS_X64_SUBTARGETS[@]}
					${SUBTARGETS_PART2[@]}
				)
				readonly PROCESSOR_OPTIMIZATION="--with-arch=$PROCESSOR_OPTIMIZATION_ARCH_64"
				readonly PROCESSOR_TUNE="--with-tune=$PROCESSOR_OPTIMIZATION_TUNE_64"
			}
		}
	;;
	python)
		readonly SUBTARGETS=(
			${PYTHON_SUBTARGETS[@]}
			cleanup
			licenses
			build-info
			$([[ $COMPRESSING_MINGW == yes ]] && echo mingw-compress)
		)
	;;
esac

# **************************************************************************
