
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

PKG_NAME=llvm-git
PKG_DIR_NAME=llvm-git
PKG_TYPE=git

PKG_URLS=(
	"http://llvm.org/git/llvm.git|repo:$PKG_TYPE|module:$PKG_NAME"
	"http://llvm.org/git/clang.git|repo:$PKG_TYPE|dir:$PKG_NAME/tools|module:clang"
	"http://llvm.org/git/compiler-rt.git|repo:$PKG_TYPE|dir:$PKG_NAME/projects|module:compiler-rt"
	"http://llvm.org/git/test-suite.git|repo:$PKG_TYPE|dir:$PKG_NAME/projects|module:test-suite"
)

PKG_PRIORITY=main

#

PKG_PATCHES=(
	clang/clang-3.4-enable-tls.patch
	clang/clang-3.4-mingw-w64-header-search.patch
)

#

PKG_CONFIGURE_FLAGS=(
	--host=$HOST
	--build=$BUILD
	--target=$TARGET
	#
	--prefix=${PREFIX}
	--with-sysroot=$PREFIX
	--enable-targets=x86,x86_64
	#
	--enable-optimized
	--disable-assertions
	--disable-pthreads
	#--enable-shared
	#--enable-embed-stdcxx
	#--enable-libcpp
	#--enable-cxx11
	#
	--enable-docs
	#
	#--enable-libffi
	#--enable-ltdl-install
	#
	#--with-c-include-dir
	#--with-gcc-toolchain
	#--with-default-sysroot
	#--with-binutils-include
	#--with-bug-report-url
	#
)

#

PKG_MAKE_FLAGS=(
	-j$JOBS
	all
)

#

PKG_INSTALL_FLAGS=(
	-j$JOBS
	install
)

#
PKG_EXECUTE_AFTER_INSTALL=(
	"[[ ! -f $PREFIX/bin/clang.exe ]] && cp -f $PREFIX/bin/$TARGET-clang.exe $PREFIX/bin/clang.exe"
	"[[ ! -f $PREFIX/bin/clang++.exe ]] && cp -f $PREFIX/bin/$TARGET-clang++.exe $PREFIX/bin/clang++.exe"
	" mkdir -p $PREFIX/lib/clang-analyzer"
	"cp -rf $SRCS_DIR/$PKG_NAME/tools/clang/tools/scan-build $PREFIX/lib/clang-analyzer/"
	"cp -rf $SRCS_DIR/$PKG_NAME/tools/clang/tools/scan-view $PREFIX/lib/clang-analyzer/"
	"cp -f $PREFIX/lib/clang-analyzer/scan-build/scan-build $PREFIX/bin/scan-build"
	"cp -f $PREFIX/lib/clang-analyzer/scan-view/scan-view $PREFIX/bin/scan-view"
	# scan-build looks for clang within the same directory
	"cp -f $PREFIX/bin/clang.exe $PREFIX/lib/clang-analyzer/scan-build/clang.exe"
	"python2 -m compileall $PREFIX/lib/clang-analyzer"
	"python2 -O -m compileall $PREFIX/lib/clang-analyzer"	
)

# **************************************************************************
