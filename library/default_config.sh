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

MINGW_W64_BUILDS_VERSION="MinGW-W64-builds-0.0.1"
PKG_VERSION="Built by MinGW-W64 project"

# **************************************************************************

PROJECT_ROOT_URL=http://sourceforge.net/projects/mingw-w64
BUG_URL=$PROJECT_ROOT_URL
PROJECT_FS_ROOT_DIR=/home/frs/project/mingw-w64

# **************************************************************************

# Need for MSYS2
export MSYSTEM=MINGW32
export LC_ALL=en_US.UTF-8

# **************************************************************************

readonly PATCHES_DIR=$TOP_DIR/patches
readonly SOURCES_DIR=$TOP_DIR/sources
readonly TESTS_DIR=$TOP_DIR/tests
readonly TOOLCHAINS_DIR=$TOP_DIR/toolchains

readonly x32_HOST_MINGW_PATH=$TOOLCHAINS_DIR/mingw32
readonly x64_HOST_MINGW_PATH=$TOOLCHAINS_DIR/mingw64

ROOT_DIR=$(func_simplify_path "$HOME")

# **************************************************************************

BASE_CFLAGS="-O2 -pipe"
BASE_CXXFLAGS="$BASE_CFLAGS"
BASE_CPPFLAGS=""
BASE_LDFLAGS="-pipe"

PROCESSOR_OPTIMIZATION_TUNE_32='generic'
PROCESSOR_OPTIMIZATION_ARCH_32='i686'
PROCESSOR_OPTIMIZATION_TUNE_64='core2'
PROCESSOR_OPTIMIZATION_ARCH_64='nocona'

# **************************************************************************

LINK_TYPE_BOTH="--enable-shared --enable-static"
LINK_TYPE_SHARED="--enable-shared --disable-static"
LINK_TYPE_STATIC="--enable-static --disable-shared"
GCC_DEPS_LINK_TYPE=$LINK_TYPE_STATIC

ENABLE_LANGUAGES='ada,c,c++,fortran,objc,obj-c++'

SHOW_LOG_ON_ERROR=yes

JOBS=1

RUNTIME_VERSION=v4
RUNTIME_BRANCH="trunk"

# **************************************************************************

FETCH_MODE=no
UPDATE_SOURCES=no
BUILD_ARCHITECTURE=
EXCEPTIONS_MODEL=sjlj
USE_MULTILIB=yes
STRIP_ON_INSTALL=yes
BOOTSTRAPING=no
THREADS_MODEL=posix
REV_NUM=
COMPRESSING_MINGW=no
COMPRESSING_SRCS=no
UPLOAD_MINGW=no
UPLOAD_SOURCES=no
SF_USER=
SF_PASSWORD=
DEBUG_UPLOAD=no
LINK_TYPE_SUFFIX=static

BUILD_MODE=
BUILD_MODE_VERSION=
BUILD_VERSION=
GCC_NAME=

DEFAULT_PYTHON_VERSION=2.7.5

# **************************************************************************