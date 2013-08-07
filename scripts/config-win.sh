
#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of 'mingw-builds' project.
# Copyright (c) 2011,2012,2013 by niXman (i dotty nixman doggy gmail dotty com)
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

x32_HOST_MINGW_PATH_URL=http://sourceforge.net/projects/mingwbuilds/files/host-windows/releases/4.7.3/32-bit/threads-posix/sjlj/x32-4.7.3-release-posix-sjlj-rev1.7z
x64_HOST_MINGW_PATH_URL=http://sourceforge.net/projects/mingwbuilds/files/host-windows/releases/4.7.3/64-bit/threads-posix/sjlj/x64-4.7.3-release-posix-sjlj-rev1.7z

# **************************************************************************

x32_HOST=i686-w64-mingw32
x32_BUILD=i686-w64-mingw32
x32_TARGET=i686-w64-mingw32

x64_HOST=x86_64-w64-mingw32
x64_BUILD=x86_64-w64-mingw32
x64_TARGET=x86_64-w64-mingw32

# **************************************************************************

REPOSITORY_FILE=$PROJECT_ROOT_URL/files/host-windows/repository.txt

# **************************************************************************

LOGVIEWERS=(
	"c:/progra~2/notepad++/notepad++.exe"
	"c:/progra~1/notepad++/notepad++.exe"
)

# **************************************************************************
