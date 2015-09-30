
#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of 'MinGW-W64' project.
# Copyright (c) 2011,2012,2013,2014 by niXman (i dotty nixman doggy gmail dotty com)
# Copyright (c) 2012,2013,2014 by Alexpux (alexpux doggy gmail dotty com)
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

function runtime_post_install {
	local readonly MARKER_NAME=$BUILDS_DIR/mingw-w64-runtime-post.marker
	[[ ! -d $PREFIX/mingw ]] && mkdir -p $PREFIX/mingw
	[[ ! -d $PREFIX/$TARGET ]] && mkdir -p $PREFIX/$TARGET

	if [[ $BUILD_MODE == gcc ]]; then
		[[ -f $MARKER_NAME && ! -d $BUILDS_DIR/$GCC_NAME ]] && {
			rm -f $MARKER_NAME
		}
	else
		[[ -f $MARKER_NAME && ! -d $BUILDS_DIR/$CLANG_GCC_VERSION ]] && {
			rm -f $MARKER_NAME
		}
	fi

	[[ ! -f $MARKER_NAME ]] && {
		[[ $USE_MULTILIB == yes ]] && {
			RUNTIMEPREFIX=$RUNTIME_DIR/$BUILD_ARCHITECTURE-mingw-w64-$RUNTIME_VERSION-multi
		} || {
			RUNTIMEPREFIX=$RUNTIME_DIR/$BUILD_ARCHITECTURE-mingw-w64-$RUNTIME_VERSION-nomulti
		}

		cp -rf $RUNTIMEPREFIX/* $PREFIX/$TARGET || { echo "1"; exit 1; }
		cp -rf $RUNTIMEPREFIX/* $PREFIX/mingw || { echo "2"; exit 1; }

		mkdir -p $PREFIX/bin $PREFIX/$TARGET/{lib,include}

		# iconv
		cp -f $PREREQ_DIR/$BUILD_ARCHITECTURE-libiconv-$LINK_TYPE_SUFFIX/include/*.h $PREFIX/$TARGET/include/ || { echo "3"; exit 1; }
		[[ $GCC_DEPS_LINK_TYPE == *--enable-shared* ]] && {
			cp -f $PREREQ_DIR/$BUILD_ARCHITECTURE-libiconv-$LINK_TYPE_SUFFIX/lib/*.dll.a $PREFIX/$TARGET/lib/ || { echo "4"; exit 1; }
			cp -f $PREREQ_DIR/$BUILD_ARCHITECTURE-libiconv-$LINK_TYPE_SUFFIX/bin/*.dll $PREFIX/bin/ || { echo "5"; exit 1; }
			cp -f $PREREQ_DIR/$BUILD_ARCHITECTURE-libiconv-$LINK_TYPE_SUFFIX/bin/*.dll $PREFIX/$TARGET/lib/ || { echo "6"; exit 1; }
		}
		[[ $GCC_DEPS_LINK_TYPE == *--enable-static* ]] && {
			cp -f $PREREQ_DIR/$BUILD_ARCHITECTURE-libiconv-$LINK_TYPE_SUFFIX/lib/*.a $PREFIX/$TARGET/lib/ || { echo "7"; exit 1; }
		}

		# zlib
		cp -f $PREREQ_DIR/$BUILD_ARCHITECTURE-zlib-$LINK_TYPE_SUFFIX/include/*.h $PREFIX/$TARGET/include/ || { echo "8"; exit 1; }
		[[ $GCC_DEPS_LINK_TYPE == *--enable-shared* ]] && {
			cp -f $PREREQ_DIR/$BUILD_ARCHITECTURE-zlib-$LINK_TYPE_SUFFIX/lib/libz.dll.a $PREFIX/$TARGET/lib/ || { echo "9"; exit 1; }
			cp -f $PREREQ_DIR/$BUILD_ARCHITECTURE-zlib-$LINK_TYPE_SUFFIX/bin/*.dll $PREFIX/bin/ || { echo "10"; exit 1; }
			cp -f $PREREQ_DIR/$BUILD_ARCHITECTURE-zlib-$LINK_TYPE_SUFFIX/bin/*.dll $PREFIX/$TARGET/lib/ || { echo "11"; exit 1; }
		}
		[[ $GCC_DEPS_LINK_TYPE == *--enable-static* ]] && {
			cp -f $PREREQ_DIR/$BUILD_ARCHITECTURE-zlib-$LINK_TYPE_SUFFIX/lib/libz.a $PREFIX/$TARGET/lib/ || { echo "12"; exit 1; }
		}

		# winpthreads
		[[ $BUILD_SHARED_GCC == yes ]] && {
			cp -f $RUNTIME_DIR/$BUILD_ARCHITECTURE-winpthreads-$RUNTIME_VERSION/bin/libwinpthread-1.dll $PREFIX/bin/ || { echo "13"; exit 1; }
			cp -f $RUNTIME_DIR/$BUILD_ARCHITECTURE-winpthreads-$RUNTIME_VERSION/bin/libwinpthread-1.dll $PREFIX/$TARGET/lib/ || { echo "14"; exit 1; }
			cp -f $RUNTIME_DIR/$BUILD_ARCHITECTURE-winpthreads-$RUNTIME_VERSION/lib/libwinpthread.dll.a $PREFIX/$TARGET/lib/ || { echo "15"; exit 1; }
			cp -f $RUNTIME_DIR/$BUILD_ARCHITECTURE-winpthreads-$RUNTIME_VERSION/lib/libpthread.dll.a $PREFIX/$TARGET/lib/ || { echo "16"; exit 1; }
		}
		cp -f $RUNTIME_DIR/$BUILD_ARCHITECTURE-winpthreads-$RUNTIME_VERSION/lib/libwinpthread.a $PREFIX/$TARGET/lib/ || { echo "17"; exit 1; }
		cp -f $RUNTIME_DIR/$BUILD_ARCHITECTURE-winpthreads-$RUNTIME_VERSION/lib/libpthread.a $PREFIX/$TARGET/lib/ || { echo "18"; exit 1; }
		cp -f $RUNTIME_DIR/$BUILD_ARCHITECTURE-winpthreads-$RUNTIME_VERSION/include/*.h $PREFIX/$TARGET/include/ || { echo "19"; exit 1; }
	
		[[ $USE_MULTILIB == yes ]] && {
			local _reverse_bits=$(func_get_reverse_arch_bit $BUILD_ARCHITECTURE)
			local _reverse_arch=$(func_get_reverse_arch $BUILD_ARCHITECTURE)

			mkdir -p $PREFIX/$TARGET/lib$_reverse_bits

			# iconv
			[[ $GCC_DEPS_LINK_TYPE == *--enable-shared* ]] && {
				cp -f $PREREQ_DIR/$_reverse_arch-libiconv-$LINK_TYPE_SUFFIX/bin/*.dll $PREFIX/$TARGET/lib$_reverse_bits/ || { echo "20"; exit 1; }
				cp -f $PREREQ_DIR/$_reverse_arch-libiconv-$LINK_TYPE_SUFFIX/lib/*.dll.a $PREFIX/$TARGET/lib$_reverse_bits/ || { echo "21"; exit 1; }
			}
			[[ $GCC_DEPS_LINK_TYPE == *--enable-static* ]] && {
				cp -f $PREREQ_DIR/$_reverse_arch-libiconv-$LINK_TYPE_SUFFIX/lib/*.a $PREFIX/$TARGET/lib$_reverse_bits/ || { echo "22"; exit 1; }
			}

			# zlib
			[[ $GCC_DEPS_LINK_TYPE == *--enable-shared* ]] && {
				cp -f $PREREQ_DIR/$_reverse_arch-zlib-$LINK_TYPE_SUFFIX/bin/*.dll $PREFIX/$TARGET/lib$_reverse_bits/ || { echo "23"; exit 1; }
				cp -f $PREREQ_DIR/$_reverse_arch-zlib-$LINK_TYPE_SUFFIX/lib/*.dll.a $PREFIX/$TARGET/lib$_reverse_bits/ || { echo "24"; exit 1; }
			}
			[[ $GCC_DEPS_LINK_TYPE == *--enable-static* ]] && {
				cp -f $PREREQ_DIR/$_reverse_arch-zlib-$LINK_TYPE_SUFFIX/lib/*.a $PREFIX/$TARGET/lib$_reverse_bits/ || { echo "25"; exit 1; }
			}

			# winpthreads
			[[ $BUILD_SHARED_GCC == yes ]] && {
				cp -f $RUNTIME_DIR/$_reverse_arch-winpthreads-$RUNTIME_VERSION/bin/libwinpthread-1.dll $PREFIX/$TARGET/lib$_reverse_bits/ || { echo "26"; exit 1; }
				cp -f $RUNTIME_DIR/$_reverse_arch-winpthreads-$RUNTIME_VERSION/lib/libwinpthread.dll.a $PREFIX/$TARGET/lib$_reverse_bits/ || { echo "27"; exit 1; }
				cp -f $RUNTIME_DIR/$_reverse_arch-winpthreads-$RUNTIME_VERSION/lib/libpthread.dll.a $PREFIX/$TARGET/lib$_reverse_bits/ || { echo "28"; exit 1; }
			}
			cp -f $RUNTIME_DIR/$_reverse_arch-winpthreads-$RUNTIME_VERSION/lib/libwinpthread.a $PREFIX/$TARGET/lib$_reverse_bits/ || { echo "29"; exit 1; }
			cp -f $RUNTIME_DIR/$_reverse_arch-winpthreads-$RUNTIME_VERSION/lib/libpthread.a $PREFIX/$TARGET/lib$_reverse_bits/ || { echo "30"; exit 1; }

			mkdir -p $BUILDS_DIR/$GCC_NAME/$TARGET/$_reverse_bits/{libgcc,libgfortran,libgomp,libitm,libquadmath,libssp,libstdc++-v3}
			[[ $BUILD_SHARED_GCC == yes ]] && {
				echo $BUILDS_DIR/$GCC_NAME/$TARGET/$_reverse_bits/{libgcc,libgfortran,libgomp,libitm,libquadmath,libssp,libstdc++-v3} \
					| xargs -n 1 cp $PREFIX/$TARGET/lib$_reverse_bits/libwinpthread-1.dll || { echo "31"; exit 1; }
			}
		}

		cp -rf $PREFIX/$TARGET/* $PREFIX/mingw/ || { echo "32"; exit 1; }

		[[ $GCC_DEPS_LINK_TYPE == *--enable-shared* ]] && {
			cp -f $PREREQ_DIR/$HOST-$LINK_TYPE_SUFFIX/bin/*.dll $PREFIX/bin/
			cp -f $PREREQ_DIR/$BUILD_ARCHITECTURE-libiconv-$LINK_TYPE_SUFFIX/bin/*.dll $PREFIX/bin/
		}

		touch $MARKER_NAME || { echo "33"; exit 1; }
	}
	
	return 0
}

runtime_post_install
[[ $? != 0 ]] && die " error in runtime_post_install()"

# **************************************************************************
