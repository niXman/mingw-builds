
#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of MinGW-W64(mingw-builds: https://github.com/niXman/mingw-builds) project.
# Copyright (c) 2011-2015 by niXman (i dotty nixman doggy gmail dotty com)
#                        ,by Alexpux (alexpux doggy gmail dotty com)
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

function func_get_licenses {
	# $1 - mode (gcc/python/clang)

	local readonly python_part=(
		mingw-libgnurx
		bzip2
		libffi
		expat
		tcl
		tk
		xz
		sqlite
		ncurses
		readline
		python
	)

	local readonly gcc_part=(
		gmp
		mpfr
		mpc
		ppl
		cloog
		libiconv
		zlib
		mingw-w64
		winpthreads
		binutils
		gcc
		gdb
		make
	)
	local readonly clang_part=(
		clang
	)

	case $1 in
		gcc)
			echo -n "${gcc_part[@]}"
		;;
		python)
			echo -n "${python_part[@]}"
		;;
		clang)
			echo -n "${clang_part[@]}"
		;;
	esac
}

# **************************************************************************

[[ ! -f $BUILDS_DIR/licenses.marker ]] && {
	mkdir -p $PREFIX/licenses || die "can't create licenses directory. terminate."

	readonly LICENSES=( \
		$( \
			func_get_licenses \
				$BUILD_MODE \
		) \
	)

	[[ ${#LICENSES[@]} > 1 ]] && {
		readonly licenses_cmd="cp -rf $TOP_DIR/licenses/{$(echo ${LICENSES[@]} | sed 's| |,|g')} $PREFIX/licenses/"
	} || {
		readonly licenses_cmd="cp -rf $TOP_DIR/licenses/${LICENSES[@]} $PREFIX/licenses/"
	}

	#echo "licenses_cmd: ${licenses_cmd}"
	eval ${licenses_cmd} || die "can't copy licenses. terminate."

	touch $BUILDS_DIR/licenses.marker
}

# **************************************************************************
