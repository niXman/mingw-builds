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

[[ ! -f $BUILDS_DIR/gcc-post.marker ]] && {
	# remove <prefix>/mingw directory
	rm -rf $PREFIX/mingw >/dev/null 2>&1
	
	[[ $ARCHITECTURE == x32 ]] && {
		# libgcc_s.a
		cp -f $PREFIX/lib/gcc/$TARGET/lib/libgcc_s.a $PREFIX/$TARGET/lib/ || exit 1

		[[ $USE_DWARF_EXCEPTIONS == no ]] && {
			# 32bit dlls
			DLLS=( $(find $BUILDS_DIR/$GCC_NAME/$TARGET -path $BUILDS_DIR/$GCC_NAME/$TARGET/64 -prune -o -type f -name *.dll) )
			cp -f ${DLLS[@]} $PREFIX/bin/
			cp -f ${DLLS[@]} $PREFIX/$TARGET/lib/
			
			strip $PREFIX/bin/*.dll || exit 1
			strip $PREFIX/$TARGET/lib/*.dll || exit 1

			# 64 bit files
			[[ $USE_MULTILIB_MODE == yes ]] && {
				# libgcc_s.a
				cp -f $PREFIX/lib/gcc/$TARGET/lib64/libgcc_s.a $PREFIX/$TARGET/lib64/ || exit 1
				cp -f $(find $BUILDS_DIR/$GCC_NAME/$TARGET/64 -type f \( -iname *.dll ! -iname *winpthread* \)) $PREFIX/$TARGET/lib64/
				
				strip $PREFIX/$TARGET/lib64/*.dll || exit 1
			}
		}
	} || {
		# libgcc_s.a
		cp -f $PREFIX/lib/gcc/$TARGET/lib/libgcc_s.a $PREFIX/$TARGET/lib/ || exit 1
			
		# 64bit dlls
		DLLS=( $(find $BUILDS_DIR/$GCC_NAME/$TARGET -path $BUILDS_DIR/$GCC_NAME/$TARGET/32 -prune -o -type f -name *.dll) )
		cp -f ${DLLS[@]} $PREFIX/bin/
		cp -f ${DLLS[@]} $PREFIX/$TARGET/lib/
			
		strip $PREFIX/bin/*.dll || exit 1
		strip $PREFIX/$TARGET/lib/*.dll || exit 1
			
		# 32 bit files
		[[ $USE_MULTILIB_MODE == yes ]] && {
			# libgcc_s.a
			cp -f $PREFIX/lib/gcc/$TERGET/lib32/libgcc_s.a $PREFIX/$TARGET/lib32/ || exit 1
			cp -f $(find $BUILDS_DIR/$GCC_NAME/$TARGET/32 -type f \( -iname *.dll ! -iname *winpthread* \)) $PREFIX/$TARGET/lib32/
			
			strip $PREFIX/$TARGET/lib32/*.dll || exit 1
		}
	}
	
	touch $BUILDS_DIR/gcc-post.marker
}

# **************************************************************************
