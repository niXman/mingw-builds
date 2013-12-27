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

readonly i686_HOST_MINGW_PATH_URL="http://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win32/Personal%20Builds/mingw-builds/4.8.2/threads-posix/{exceptions}/i686-4.8.2-release-posix-{exceptions}-rt_v3-rev0.7z"
readonly x86_64_HOST_MINGW_PATH_URL="http://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/4.8.2/threads-posix/{exceptions}/x86_64-4.8.2-release-posix-{exceptions}-rt_v3-rev0.7z"

# **************************************************************************

HOST=$BUILD_ARCHITECTURE-w64-mingw32
BUILD=$BUILD_ARCHITECTURE-w64-mingw32
TARGET=$BUILD_ARCHITECTURE-w64-mingw32

readonly HOST_TOOLS=""
readonly CROSS_BUILDS=no

# **************************************************************************

readonly REPOSITORY_FILE=$PROJECT_ROOT_URL/files/host-windows/repository.txt

# **************************************************************************

readonly LOGVIEWERS=(
	"c:/progra~2/notepad++/notepad++.exe"
	"c:/progra~1/notepad++/notepad++.exe"
	"notepad"
)

# **************************************************************************

[[ -z $i686_HOST_MINGW_PATH_URL || -z $x86_64_HOST_MINGW_PATH_URL ]] && {
	die "i686_HOST_MINGW_PATH_URL or x86_64_HOST_MINGW_PATH_URL is empty. terminate."
}

[[ -d /mingw ]] && {
	die "please remove \"/mingw\" directory. terminate."
}

[[ -n $(which "gcc.exe" 2>/dev/null) || \
	-n $(which "i686-pc-mingw32-gcc.exe" 2>/dev/null) || \
	-n $(which "i686-w64-mingw32-gcc.exe" 2>/dev/null) || \
	-n $(which "x86_64-w64-mingw32-gcc.exe" 2>/dev/null) \
]] && {
	die "remove from PATH any existing MinGW directory. terminate."
}

# **************************************************************************
