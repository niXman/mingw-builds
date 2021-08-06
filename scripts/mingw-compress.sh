
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

function func_compress_mingw() {
	case $BUILD_MODE in
		clang)
			local ARCHIVE_NAME=$ARCHIVES_DIR/clang-$BUILD_VERSION-$BUILD_ARCHITECTURE-$EXCEPTIONS_MODEL-$THREADS_MODEL-$REV_NUM.7z
		;;
		gcc)
			local ARCHIVE_NAME=$( \
				func_create_mingw_archive_name \
					$ARCHIVES_DIR \
					$SRCS_DIR \
					$GCC_NAME \
					$BUILD_ARCHITECTURE \
					$EXCEPTIONS_MODEL \
					$THREADS_MODEL \
					$REV_NUM \
			)
		;;
		python)
			local ARCHIVE_NAME=$ARCHIVES_DIR/python-$BUILD_VERSION-$BUILD_ARCHITECTURE.7z
		;;
	esac

	[[ ! -f $ARCHIVE_NAME ]] && {
		echo "-> compressing $PREFIX"
		[[ -d $PREFIX/mingw ]] && {
			cd $BUILDS_DIR
			rm -rf $PREFIX/mingw
		}

		[[ ! -f $ARCHIVE_NAME ]] && {
			echo -n "---> \"$(basename $ARCHIVE_NAME)\" ... "
			( cd $BUILDS_DIR && 7za a -t7z -mx=9 -mfb=64 -md=64m -ms=on \
				"$ARCHIVE_NAME" "$PREFIX" >/dev/null 2>&1 \
			)
			[[ $? == 0 ]] && {
				echo "done"
			} || {
				echo; echo "error on compressing $PREFIX directory"
				exit 1
			}
		}
	} || {
		echo "---> compressed"
	}
}

func_compress_mingw

# **************************************************************************
