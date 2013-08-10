
#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of 'MinGW-W64' project.
# Copyright (c) 2011,2012,2013 by niXman (i dotty nixman doggy gmail dotty com)
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

NAME=make
SRC_DIR_NAME=make
TYPE=cvs
REV=09/21/2012
URL=(
	":pserver:anonymous:@cvs.sv.gnu.org:/sources/make|repo:$TYPE|rev:$REV|module:$NAME"
)

PRIORITY=extra

#

PATCHES=(
	make/make-remove-double-quote.patch
	make/make-linebuf-mingw.patch
	make/make-getopt.patch
	make/make-Windows-Add-move-to-sh_cmds_dos.patch
)

#

EXECUTE_AFTER_PATCH=(
	"autoreconf -i"
)

#

CONFIGURE_FLAGS=(
	--host=$HOST
	--build=$TARGET
	--prefix=$PREFIX
	--enable-case-insensitive-file-system
	--program-prefix=mingw32-
	--enable-job-server
	--without-guile
	CFLAGS="\"$COMMON_CFLAGS\""
	LDFLAGS="\"$COMMON_LDFLAGS -L$LIBS_DIR/lib\""
)

#

MAKE_FLAGS=(
	-j$JOBS
	do-po-update
	scm-update
	all
)

#

INSTALL_FLAGS=(
	-j$JOBS
	$( [[ $STRIP_ON_INSTALL == yes ]] && echo install-strip || echo install )
)

# **************************************************************************
