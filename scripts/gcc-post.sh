
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

PKG_NAME=gcc-post
PKG_DIR_NAME=gcc-post
PKG_PRIORITY=main

PKG_MAKE_PROG=gcc_post_install
PKG_INSTALL_FLAGS=( dummy )

PKG_EXECUTE_AFTER_INSTALL=(
	gcc_switch_compilers
)

# Remove the after install markers in order to force another run
rm -f $BUILDS_DIR/$PKG_NAME/exec-after_install-*.marker

function gcc_post_install {
	# remove <prefix>/mingw directory
	rm -rf $PREFIX/mingw > /dev/null 2>&1

	[[ $BUILD_MODE == clang ]] && {
		local _GCC_NAME=$CLANG_GCC_VERSION
	} || {
		local _GCC_NAME=$GCC_NAME
	}

	local _gcc_version=$(func_map_gcc_name_to_gcc_version $_GCC_NAME)
	local _reverse_bits=$(func_get_reverse_arch_bit $BUILD_ARCHITECTURE)
	[[ $BUILD_SHARED_GCC == yes ]] && {
		# libgcc_s.a
		cp -f $PREFIX/lib/gcc/$TARGET/lib/libgcc_s.a $PREFIX/$TARGET/lib/ \
			|| die "Cannot copy libgcc_s.a to $PREFIX/$TARGET/lib"
	}

	func_has_lang objc
	local is_objc=$?
	[[ $is_objc == 1 ]] && {
		# libobjc
		cp -f $BUILDS_DIR/$_GCC_NAME/$TARGET/libobjc/.libs/libobjc.a $PREFIX/lib/gcc/$TARGET/$_gcc_version/ \
			|| die "Cannot copy libobjc.a to $PREFIX/lib/gcc/$TARGET/$_gcc_version"
		[[ $BUILD_SHARED_GCC == yes ]] && {
			cp -f $BUILDS_DIR/$_GCC_NAME/$TARGET/libobjc/.libs/libobjc.dll.a $PREFIX/lib/gcc/$TARGET/$_gcc_version/ \
				|| die "Cannot copy libobjc.dll.a to $PREFIX/lib/gcc/$TARGET/$_gcc_version"
		}
		# objc headers
		cp -rf ${SRCS_DIR}/$_GCC_NAME/libobjc/objc $PREFIX/lib/gcc/$TARGET/$_gcc_version/include \
			|| die "Cannot copy objc headers to $PREFIX/lib/gcc/$TARGET/$_gcc_version/include"
	}

	[[ $BUILD_SHARED_GCC == yes ]] && {
		# builded architecture dlls
		local _dlls=( $(find $BUILDS_DIR/$_GCC_NAME/$TARGET \
				-not \( -path $BUILDS_DIR/$_GCC_NAME/$TARGET/32 -prune \) \
				-not \( -path $BUILDS_DIR/$_GCC_NAME/$TARGET/64 -prune \) \
				-not \( -path $BUILDS_DIR/$_GCC_NAME/gcc/ada -prune \) \
				-not \( -path $BUILDS_DIR/$_GCC_NAME/$TARGET/libada/adainclude -prune \) \
				-type f -name *.dll) )
		cp -f ${_dlls[@]} $PREFIX/bin/ > /dev/null 2>&1 || die "Cannot copy architecture dlls to $PREFIX/bin/"
		cp -f ${_dlls[@]} $PREFIX/$TARGET/lib/ > /dev/null 2>&1 || die "Cannot copy architecture dlls to $PREFIX/lib/"

		[[ $STRIP_ON_INSTALL == yes ]] && {
			strip $PREFIX/bin/*.dll || die "Error stripping dlls from $PREFIX/bin"
			strip $PREFIX/$TARGET/lib/*.dll || die "Error stripping dlls from $PREFIX/$TARGET/lib"
		}
	}
	[[ $USE_MULTILIB == yes ]] && {
		[[ $BUILD_SHARED_GCC == yes ]] && {
			# libgcc_s.a
			cp -f $PREFIX/lib/gcc/$TARGET/lib$_reverse_bits/libgcc_s.a $PREFIX/$TARGET/lib$_reverse_bits/ \
				|| die "Cannot copy libgcc_s.a to $PREFIX/$TARGET/lib${_reverse_bits}/"
		}

		[[ $is_objc == 1 ]] && {
			# libobjc libraries
			cp -f $BUILDS_DIR/$_GCC_NAME/$TARGET/$_reverse_bits/libobjc/.libs/libobjc.a $PREFIX/lib/gcc/$TARGET/$_gcc_version/$_reverse_bits/ \
				|| die "Cannot copy libobjc.a to $PREFIX/lib/gcc/$TARGET/$_gcc_version/${_reverse_bits}"
			[[ $BUILD_SHARED_GCC == yes ]] && {
				cp -f $BUILDS_DIR/$_GCC_NAME/$TARGET/$_reverse_bits/libobjc/.libs/libobjc.dll.a $PREFIX/lib/gcc/$TARGET/$_gcc_version/$_reverse_bits/ \
					|| die "Cannot copy libobjc.dll.a to $PREFIX/lib/gcc/$TARGET/$_gcc_version/${_reverse_bits}"
			}
		}

		[[ $BUILD_SHARED_GCC == yes ]] && {
			# Second architecture bit dlls
			find $BUILDS_DIR/$_GCC_NAME/$TARGET/$_reverse_bits \
				-not \( -path $BUILDS_DIR/$_GCC_NAME/$TARGET/$_reverse_bits/libada/adainclude -prune \) \
				-type f -name *.dll ! -name *winpthread* -print0 \
				| xargs -0 -I{} cp -f {} $PREFIX/$TARGET/lib$_reverse_bits/ || die "Error copying ${_reverse_bits}-bit dlls"

			[[ $STRIP_ON_INSTALL == yes ]] && {
				strip $PREFIX/$TARGET/lib$_reverse_bits/*.dll || die "Error stripping ${_reverse_bits}-bit dlls"
			}
		}
	}
	
	return 0
}

function gcc_switch_compilers {
	# Change the path to use the new compilers instead of the old ones
	export PATH=$PREFIX/bin:$LIBS_DIR/bin:$ORIGINAL_PATH
}

# **************************************************************************
