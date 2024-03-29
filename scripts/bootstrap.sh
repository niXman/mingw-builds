
#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of MinGW-W64(mingw-builds: https://github.com/niXman/mingw-builds) project.
# Copyright (c) 2011-2023 by niXman (i dotty nixman doggy gmail dotty com)
# Copyright (c) 2012-2015 by Alexpux (alexpux doggy gmail dotty com)
# All rights reserved.
#
# Project: MinGW-Builds ( https://github.com/niXman/mingw-builds )
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

PKG_NAME=bootstrap
PKG_DIR_NAME=bootstrap
PKG_PRIORITY=main

PKG_MAKE_PROG=clean
PKG_INSTALL_FLAGS=( dummy )

PKG_EXECUTE_AFTER_INSTALL=()

function clean {
	find $RUNTIME_DIR -mindepth 1 -maxdepth 1 -type d -name $BUILD_ARCHITECTURE* -exec rm -rf {} \;
	find $PREREQ_DIR -mindepth 1 -maxdepth 1 -type d -name $BUILD_ARCHITECTURE* -exec rm -rf {} \;
	find $PREREQ_BUILD_DIR -mindepth 1 -maxdepth 1 -type d -name $BUILD_ARCHITECTURE* -exec rm -rf {} \;
	# find $PREREQ_LOGS_DIR -mindepth 1 -maxdepth 1 -type d -name $BUILD_ARCHITECTURE* -exec rm -rf {} \;
	find $ROOT_DIR -mindepth 1 -maxdepth 3 -type d -path "*/$BUILD_ARCHITECTURE*$GCC_PART_NAME*$THREADS_MODEL*$EXCEPTIONS_MODEL*$RUNTIME_VERSION*$REV_NUM*/build/*" ! -path "*/$PKG_NAME" -exec rm -rf {} \;
	return 0
}

# **************************************************************************
