
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

PKG_NAME=3rdparty-post
PKG_DIR_NAME=3rdparty-post
PKG_PRIORITY=extra

PKG_EXECUTE_AFTER_INSTALL=(
	python_deps_post
)

function python_deps_post {
	case $BUILD_MODE in
		gcc)
			local _toolchain_path=$PREFIX
		;;
		*)
			local _toolchain_path=$(eval "echo \${${BUILD_ARCHITECTURE}_HOST_MINGW_PATH}")
		;;
	esac
	local _gcc_dll=( \
		$(find $_toolchain_path/bin -type f \
						-name libgcc*.dll -o \
						-name libwinpthread*.dll \
		) \
	)
	[[ ${#_gcc_dll[@]} >0 ]] && {
		cp -f ${_gcc_dll[@]} $LIBS_DIR/bin/ >/dev/null 2>&1
	}

	rm -f $LIBS_DIR/bin/{bz*,bunzip2}
	rm -f $LIBS_DIR/bin/{tclsh.exe,tclsh86.exe,openssl.exe,capinfo.exe,captoinfo.exe,clear.exe,idle,infocmp.exe}
	rm -f $LIBS_DIR/bin/{infotocap.exe,c_rehash,ncursesw5-config,reset.exe,sqlite3.exe,tabs.exe}
	rm -f $LIBS_DIR/bin/{tic.exe,toe.exe,tput.exe,tset.exe,wish.exe,wish86.exe,xmlwf,testgdbm.exe}
	rm -f $LIBS_DIR/bin/{lzmadec.exe,lzmainfo.exe,unxz.exe,xz*}

	#rm -rf $LIBS_DIR/include
	rm -rf $LIBS_DIR/lib/pkgconfig
	#find $LIBS_DIR/lib -maxdepth 1 -type f -name *.a -print0 | xargs -0 rm -f
	find $LIBS_DIR/lib -type f -name *.la -print0 | xargs -0 rm -f
	rm -rf $LIBS_DIR/man
	rm -rf $LIBS_DIR/share/man
	rm -rf $LIBS_DIR/share/info
}

# **************************************************************************
