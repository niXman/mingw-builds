
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

PKG_NAME=mingw-w64-runtime-post
PKG_DIR_NAME=mingw-w64-runtime-post
PKG_PRIORITY=main

PKG_MAKE_PROG=runtime_post_install
PKG_INSTALL_FLAGS=( dummy )

# Delete the marker files if the GCC folder is missing, means that need to copy again for the correct GCC version
[[ $BUILD_MODE == "gcc" && ! -d $BUILDS_DIR/$GCC_NAME ]] && rm -f $BUILDS_DIR/$PKG_NAME/_installed.marker
[[ $BUILD_MODE != "gcc" && ! -d $BUILDS_DIR/$CLANG_GCC_VERSION ]] && rm -f $BUILDS_DIR/$PKG_NAME/_installed.marker;


function runtime_post_install {
	[[ ! -d $PREFIX/mingw ]] && mkdir -p $PREFIX/mingw
	[[ ! -d $PREFIX/$TARGET ]] && mkdir -p $PREFIX/$TARGET

	[[ $USE_MULTILIB == yes ]] && {
		RUNTIMEPREFIX=$RUNTIME_DIR/$BUILD_ARCHITECTURE-mingw-w64-$RUNTIME_VERSION-multi
	} || {
		RUNTIMEPREFIX=$RUNTIME_DIR/$BUILD_ARCHITECTURE-mingw-w64-$RUNTIME_VERSION-nomulti
	}

	cp -rfv $RUNTIMEPREFIX/* $PREFIX/$TARGET || { echo "1"; return 1; }
	cp -rfv $RUNTIMEPREFIX/* $PREFIX/mingw || { echo "2"; return 1; }

	mkdir -pv $PREFIX/bin $PREFIX/$TARGET/{lib,include}

	# iconv
	cp -fv $PREREQ_DIR/$BUILD_ARCHITECTURE-libiconv-$LINK_TYPE_SUFFIX/include/*.h $PREFIX/$TARGET/include/ || { echo "3"; return 1; }
	[[ $GCC_DEPS_LINK_TYPE == *--enable-shared* ]] && {
		cp -fv $PREREQ_DIR/$BUILD_ARCHITECTURE-libiconv-$LINK_TYPE_SUFFIX/lib/*.dll.a $PREFIX/$TARGET/lib/ || { echo "4"; return 1; }
		cp -fv $PREREQ_DIR/$BUILD_ARCHITECTURE-libiconv-$LINK_TYPE_SUFFIX/bin/*.dll $PREFIX/bin/ || { echo "5"; return 1; }
		cp -fv $PREREQ_DIR/$BUILD_ARCHITECTURE-libiconv-$LINK_TYPE_SUFFIX/bin/*.dll $PREFIX/$TARGET/lib/ || { echo "6"; return 1; }
	}
	[[ $GCC_DEPS_LINK_TYPE == *--enable-static* ]] && {
		cp -fv $PREREQ_DIR/$BUILD_ARCHITECTURE-libiconv-$LINK_TYPE_SUFFIX/lib/*.a $PREFIX/$TARGET/lib/ || { echo "7"; return 1; }
	}

	# zlib
	cp -fv $PREREQ_DIR/$BUILD_ARCHITECTURE-zlib-$LINK_TYPE_SUFFIX/include/*.h $PREFIX/$TARGET/include/ || { echo "8"; return 1; }
	[[ $GCC_DEPS_LINK_TYPE == *--enable-shared* ]] && {
		cp -fv $PREREQ_DIR/$BUILD_ARCHITECTURE-zlib-$LINK_TYPE_SUFFIX/lib/libz.dll.a $PREFIX/$TARGET/lib/ || { echo "9"; return 1; }
		cp -fv $PREREQ_DIR/$BUILD_ARCHITECTURE-zlib-$LINK_TYPE_SUFFIX/bin/*.dll $PREFIX/bin/ || { echo "10"; return 1; }
		cp -fv $PREREQ_DIR/$BUILD_ARCHITECTURE-zlib-$LINK_TYPE_SUFFIX/bin/*.dll $PREFIX/$TARGET/lib/ || { echo "11"; return 1; }
	}
	[[ $GCC_DEPS_LINK_TYPE == *--enable-static* ]] && {
		cp -fv $PREREQ_DIR/$BUILD_ARCHITECTURE-zlib-$LINK_TYPE_SUFFIX/lib/libz.a $PREFIX/$TARGET/lib/ || { echo "12"; return 1; }
	}

	# winpthreads
	[[ $BUILD_SHARED_GCC == yes ]] && {
		cp -fv $RUNTIME_DIR/$BUILD_ARCHITECTURE-winpthreads-$RUNTIME_VERSION/bin/libwinpthread-1.dll $PREFIX/bin/ || { echo "13"; return 1; }
		cp -fv $RUNTIME_DIR/$BUILD_ARCHITECTURE-winpthreads-$RUNTIME_VERSION/bin/libwinpthread-1.dll $PREFIX/$TARGET/lib/ || { echo "14"; return 1; }
		cp -fv $RUNTIME_DIR/$BUILD_ARCHITECTURE-winpthreads-$RUNTIME_VERSION/lib/libwinpthread.dll.a $PREFIX/$TARGET/lib/ || { echo "15"; return 1; }
		cp -fv $RUNTIME_DIR/$BUILD_ARCHITECTURE-winpthreads-$RUNTIME_VERSION/lib/libpthread.dll.a $PREFIX/$TARGET/lib/ || { echo "16"; return 1; }
	}
	cp -fv $RUNTIME_DIR/$BUILD_ARCHITECTURE-winpthreads-$RUNTIME_VERSION/lib/libwinpthread.a $PREFIX/$TARGET/lib/ || { echo "17"; return 1; }
	cp -fv $RUNTIME_DIR/$BUILD_ARCHITECTURE-winpthreads-$RUNTIME_VERSION/lib/libpthread.a $PREFIX/$TARGET/lib/ || { echo "18"; return 1; }
	cp -fv $RUNTIME_DIR/$BUILD_ARCHITECTURE-winpthreads-$RUNTIME_VERSION/include/*.h $PREFIX/$TARGET/include/ || { echo "19"; return 1; }

	[[ $USE_MULTILIB == yes ]] && {
		local _reverse_bits=$(func_get_reverse_arch_bit $BUILD_ARCHITECTURE)
		local _reverse_arch=$(func_get_reverse_arch $BUILD_ARCHITECTURE)

		mkdir -pv $PREFIX/$TARGET/lib$_reverse_bits

		# iconv
		[[ $GCC_DEPS_LINK_TYPE == *--enable-shared* ]] && {
			cp -fv $PREREQ_DIR/$_reverse_arch-libiconv-$LINK_TYPE_SUFFIX/bin/*.dll $PREFIX/$TARGET/lib$_reverse_bits/ || { echo "20"; return 1; }
			cp -fv $PREREQ_DIR/$_reverse_arch-libiconv-$LINK_TYPE_SUFFIX/lib/*.dll.a $PREFIX/$TARGET/lib$_reverse_bits/ || { echo "21"; return 1; }
		}
		[[ $GCC_DEPS_LINK_TYPE == *--enable-static* ]] && {
			cp -fv $PREREQ_DIR/$_reverse_arch-libiconv-$LINK_TYPE_SUFFIX/lib/*.a $PREFIX/$TARGET/lib$_reverse_bits/ || { echo "22"; return 1; }
		}

		# zlib
		[[ $GCC_DEPS_LINK_TYPE == *--enable-shared* ]] && {
			cp -fv $PREREQ_DIR/$_reverse_arch-zlib-$LINK_TYPE_SUFFIX/bin/*.dll $PREFIX/$TARGET/lib$_reverse_bits/ || { echo "23"; return 1; }
			cp -fv $PREREQ_DIR/$_reverse_arch-zlib-$LINK_TYPE_SUFFIX/lib/*.dll.a $PREFIX/$TARGET/lib$_reverse_bits/ || { echo "24"; return 1; }
		}
		[[ $GCC_DEPS_LINK_TYPE == *--enable-static* ]] && {
			cp -fv $PREREQ_DIR/$_reverse_arch-zlib-$LINK_TYPE_SUFFIX/lib/*.a $PREFIX/$TARGET/lib$_reverse_bits/ || { echo "25"; return 1; }
		}

		# winpthreads
		[[ $BUILD_SHARED_GCC == yes ]] && {
			cp -fv $RUNTIME_DIR/$_reverse_arch-winpthreads-$RUNTIME_VERSION/bin/libwinpthread-1.dll $PREFIX/$TARGET/lib$_reverse_bits/ || { echo "26"; return 1; }
			cp -fv $RUNTIME_DIR/$_reverse_arch-winpthreads-$RUNTIME_VERSION/lib/libwinpthread.dll.a $PREFIX/$TARGET/lib$_reverse_bits/ || { echo "27"; return 1; }
			cp -fv $RUNTIME_DIR/$_reverse_arch-winpthreads-$RUNTIME_VERSION/lib/libpthread.dll.a $PREFIX/$TARGET/lib$_reverse_bits/ || { echo "28"; return 1; }
		}
		cp -fv $RUNTIME_DIR/$_reverse_arch-winpthreads-$RUNTIME_VERSION/lib/libwinpthread.a $PREFIX/$TARGET/lib$_reverse_bits/ || { echo "29"; return 1; }
		cp -fv $RUNTIME_DIR/$_reverse_arch-winpthreads-$RUNTIME_VERSION/lib/libpthread.a $PREFIX/$TARGET/lib$_reverse_bits/ || { echo "30"; return 1; }

		mkdir -pv $BUILDS_DIR/$GCC_NAME/$TARGET/$_reverse_bits/{libgcc,libgfortran,libgomp,libitm,libquadmath,libssp,libstdc++-v3}
		[[ $BUILD_SHARED_GCC == yes ]] && {
			echo $BUILDS_DIR/$GCC_NAME/$TARGET/$_reverse_bits/{libgcc,libgfortran,libgomp,libitm,libquadmath,libssp,libstdc++-v3} \
				| xargs -n 1 cp $PREFIX/$TARGET/lib$_reverse_bits/libwinpthread-1.dll || { echo "31"; return 1; }
		}
	}

	cp -rfv $PREFIX/$TARGET/* $PREFIX/mingw/ || { echo "32"; return 1; }

	[[ $GCC_DEPS_LINK_TYPE == *--enable-shared* ]] && {
		cp -fv $PREREQ_DIR/$HOST-$LINK_TYPE_SUFFIX/bin/*.dll $PREFIX/bin/
		cp -fv $PREREQ_DIR/$BUILD_ARCHITECTURE-libiconv-$LINK_TYPE_SUFFIX/bin/*.dll $PREFIX/bin/
	}

	return 0
}

# **************************************************************************
