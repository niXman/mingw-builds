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

echo -n "-> Checking OS bitness... "
readonly U_MACHINE=`(uname -m) 2>/dev/null` || U_MACHINE=unknown
case "${U_MACHINE}" in
	i[34567]86)
		[[ $(env | grep PROCESSOR_ARCHITEW6432) =~ AMD64 || $(env | grep PROCESSOR_ARCHITECTURE) =~ AMD64 ]] && {
			IS_64BIT_HOST=yes
			echo "64-bit"
		} || {
			IS_64BIT_HOST=no
			echo "32-bit"
		}
	;;
	x86_64|amd64)
		IS_64BIT_HOST=yes
		echo "64-bit"
	;;
	*)
		die "Unsupported bitness ($U_MACHINE). terminate."
	;;
esac

echo -n "-> Checking OS type... "
readonly U_SYSTEM=`(uname -s) 2>/dev/null` || U_SYSTEM=unknown
echo "$U_SYSTEM"

case "${U_SYSTEM}" in
	Linux)
		source $TOP_DIR/library/config-nix.sh
	;;
	MSYS*|MINGW*)
		source $TOP_DIR/library/config-win.sh
	;;
	Darwin)
		source $TOP_DIR/library/config-osx.sh
	;;
	*)
		die "Unsupported OS ($U_SYSTEM). terminate."
	;;
esac

readonly COMMON_TOOLS="$HOST_TOOLS 7za autoconf aclocal bison flex gettext git libtool lndir m4 make svn tar wget xz"
func_check_tools "$COMMON_TOOLS"

# **************************************************************************

LOGVIEWER=

func_find_logviewer \
	LOGVIEWERS[@] \
	LOGVIEWER
[[ $? != 0 || -z $LOGVIEWER ]] && {
	die "logviewer not found. terminate."
}

# **************************************************************************

func_test_vars_list_for_null \
	"HOST \
	BUILD \
	TARGET"

# **************************************************************************
