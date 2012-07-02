#!/bin/bash

# **************************************************************************

#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of 'mingw-builds' project.
# Copyright (c) 2011,2012, by niXman (i dotty nixman doggy gmail dotty com)
# All rights reserved.
#
# Project: mingw-builds ( http://sourceforge.net/projects/mingwbuilds/ )
#
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
# - Redistributions of source code must retain the above copyright 
#     notice, this list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright 
#     notice, this list of conditions and the following disclaimer in 
#     the documentation and/or other materials provided with the distribution.
# - Neither the name of the 'mingw-builds' nor the names of its contributors may 
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

x32_HOST_MINGW_PATH=/d/mingw32
x64_HOST_MINGW_PATH=/d/mingw64

ENABLE_LANGUAGES=c,c++,fortran

BASE_CFLAGS="-O2 -pipe -fomit-frame-pointer -momit-leaf-frame-pointer"
BASE_CXXFLAGS="$BASE_CFLAGS"
BASE_CPPFLAGS=""
BASE_LDFLAGS="-pipe -s"

LINK_TYPE_STATIC="--enable-static --disable-shared"
LINK_TYPE_SHARED="--disable-static --enable-shared"
LINK_TYPE_BOTH="--enable-shared --enable-static"
GCC_DEPS_LINK_TYPE=$LINK_TYPE_STATIC

#LOGVIEWER="c:/progra~1/notepad++/notepad++.exe"
LOGVIEWER="c:/progra~2/notepad++/notepad++.exe"

SHOW_LOG_ON_ERROR=yes
PACK_IN_ARCHIVES=yes

JOBS=1

# **************************************************************************
