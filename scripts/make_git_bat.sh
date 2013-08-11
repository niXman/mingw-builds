
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

NAME=make_git
SRC_DIR_NAME=make_git
TYPE=git
URL=(
	"http://git.savannah.gnu.org/cgit/make.git|repo:$TYPE|module:$NAME"
)

PRIORITY=extra

#

PATCHES=(
	make/make-linebuf-mingw.patch
	make/make-getopt.patch
)

#

EXECUTE_AFTER_PATCH=(
)

#

CONFIGURE_FLAGS=(
)

#

MAKE_FLAGS=(
)

#

INSTALL_FLAGS=(
)

EXECUTE_AFTER_INSTALL=(
	"cp -rf $SRCS_DIR/$NAME $CURR_BUILD_DIR/"
	"cmd /c 'build_w32.bat gcc'"
	"strip -s gnumake.exe -o mingw32-make.exe"
	"cp -f mingw32-make.exe $PREFIX/bin/"
	"cp -f libgnumake-1.dll.a $PREFIX/lib/"
	"cp -f gnumake.h $PREFIX/include/"
)
# **************************************************************************
