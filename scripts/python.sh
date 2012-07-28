#!/bin/bash

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

[[ $ARCHITECTURE == x32 ]] && {
	PYTHON_NAME=python-2.7-x32
} || {
	PYTHON_NAME=python-2.7-x64
}

mkdir -p $LOGS_DIR/$PYTHON_NAME
mkdir -p $BUILDS_DIR/$PYTHON_NAME

[[ ! -d $SRCS_DIR/$PYTHON_NAME ]] && mkdir -p $SRCS_DIR/$PYTHON_NAME

[[ -f $SRCS_DIR/$PYTHON_NAME/_download.marker ]] && {
   echo "---> downloaded"
} || {
   echo -n "--> download..."
   wget http://mingw-builds.googlecode.com/files/$PYTHON_NAME.tar.bz2 \
      -O $SRCS_DIR/$PYTHON_NAME.tar.bz2 > $LOGS_DIR/$PYTHON_NAME/download.log 2>&1 || exit 1
   echo "done"
   touch $SRCS_DIR/$PYTHON_NAME/_download.marker
}

[[ -f $SRCS_DIR/$PYTHON_NAME/_unpack.marker ]] && {
   echo "---> unpacked"
} || {
   echo -n "--> unpack..."
   tar -xvjf $SRCS_DIR/$PYTHON_NAME.tar.bz2 -C $SRCS_DIR/$PYTHON_NAME \
      > $LOGS_DIR/$PYTHON_NAME/unpack.log 2>&1 || exit 1
   echo "done"
   touch $SRCS_DIR/$PYTHON_NAME/_unpack.marker
}

[[ -f $BUILDS_DIR/$PYTHON_NAME/_install.marker ]] && {
   echo "---> installed"
} || {
   echo -n "--> installing..."
   cd $SRCS_DIR/$PYTHON_NAME
   
   cp libpython2.7.a $LIBS_DIR/lib/ || exit 1
   cp bin/python27.dll $PREFIX/bin/ || exit 1
   mkdir -p $PREFIX/bin/lib || exit 1
   cp -rf lib/python27/* $PREFIX/bin/lib/ || exit 1
   mkdir -p $LIBS_DIR/include/python || exit 1
   cp -rf include/* $LIBS_DIR/include/python/ || exit 1

   echo "done"
   touch $BUILDS_DIR/$PYTHON_NAME/_install.marker
}

# **************************************************************************
