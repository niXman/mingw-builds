
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

echo -n "--> Switching to new compiler..."
export PATH=$PREFIX/bin:$PREFIX/opt/bin:$LIBS_DIR/bin:$ORIGINAL_PATH
echo "done"
		
[[ ! -f $BUILDS_DIR/gcc-post.marker ]] && {
	# remove <prefix>/mingw directory
	rm -rf $PREFIX/mingw >/dev/null 2>&1

	_gcc_version=$(func_map_gcc_name_to_gcc_version $GCC_NAME)
	# libgcc_s.a
	cp -f $PREFIX/lib/gcc/$TARGET/lib/libgcc_s.a $PREFIX/$TARGET/lib/ \
		|| die "Cannot copy libgcc_s.a to $PREFIX/$TARGET/lib"

	func_has_lang objc
	is_objc=$?
	[[ $is_objc == 1 ]] && {
		# libobjc
		cp -f $BUILDS_DIR/${GCC_NAME}/${TARGET}/libobjc/.libs/libobjc.a $PREFIX/lib/gcc/$TARGET/$_gcc_version/ \
			|| die "Cannot copy libobjc.a to $PREFIX/lib/gcc/$TARGET/$_gcc_version"
		cp -f $BUILDS_DIR/${GCC_NAME}/${TARGET}/libobjc/.libs/libobjc.dll.a $PREFIX/lib/gcc/$TARGET/$_gcc_version/ \
			|| die "Cannot copy libobjc.dll.a to $PREFIX/lib/gcc/$TARGET/$_gcc_version"
		# objc headers
		cp -rf ${SRCS_DIR}/${GCC_NAME}/libobjc/objc $PREFIX/lib/gcc/$TARGET/$_gcc_version/include \
			|| die "Cannot copy objc headers to $PREFIX/lib/gcc/$TARGET/$_gcc_version/include"
	}

	# builded architecture dlls
	DLLS=( $(find $BUILDS_DIR/$GCC_NAME/$TARGET \( -path $BUILDS_DIR/$GCC_NAME/$TARGET/32 \
			-o -path $BUILDS_DIR/$GCC_NAME/$TARGET/64 \
			-o -path $BUILDS_DIR/$GCC_NAME/gcc/ada \
			-o -path $BUILDS_DIR/$GCC_NAME/$TARGET/libada/adainclude \) -prune -o -type f -name *.dll) )
	cp -f ${DLLS[@]} $PREFIX/bin/ >/dev/null 2>&1
	cp -f ${DLLS[@]} $PREFIX/$TARGET/lib/ >/dev/null 2>&1
			
	[[ $STRIP_ON_INSTALL == yes ]] && {
		strip $PREFIX/bin/*.dll || die "Error stripping dlls from $PREFIX/bin"
		strip $PREFIX/$TARGET/lib/*.dll || die "Error stripping dlls from $PREFIX/$TARGET/lib"
	}

	[[ $USE_MULTILIB == yes ]] && {
		# Second architecture bit dlls
		# libgcc_s.a
		cp -f $PREFIX/lib/gcc/$TARGET/lib${REVERSE_ARCHITECTURE/x/}/libgcc_s.a $PREFIX/$TARGET/lib${REVERSE_ARCHITECTURE/x/}/ \
			|| die "Cannot copy libgcc_s.a to $PREFIX/$TARGET/lib${REVERSE_ARCHITECTURE/x/}/"

		[[ $is_objc == 1 ]] && {
			# libobjc libraries
			cp -f $BUILDS_DIR/${GCC_NAME}/${TARGET}/${REVERSE_ARCHITECTURE/x/}/libobjc/.libs/libobjc.a $PREFIX/lib/gcc/$TARGET/$_gcc_version/${REVERSE_ARCHITECTURE/x/}/ \
				|| die "Cannot copy libobjc.a to $PREFIX/lib/gcc/$TARGET/$_gcc_version/${REVERSE_ARCHITECTURE/x/}"
			cp -f $BUILDS_DIR/${GCC_NAME}/${TARGET}/${REVERSE_ARCHITECTURE/x/}/libobjc/.libs/libobjc.dll.a $PREFIX/lib/gcc/$TARGET/$_gcc_version/${REVERSE_ARCHITECTURE/x/}/ \
				|| die "Cannot copy libobjc.dll.a to $PREFIX/lib/gcc/$TARGET/$_gcc_version/${REVERSE_ARCHITECTURE/x/}"
		}

		find $BUILDS_DIR/$GCC_NAME/$TARGET/${REVERSE_ARCHITECTURE/x/} -path $BUILDS_DIR/$GCC_NAME/$TARGET/${REVERSE_ARCHITECTURE/x/}/libada/adainclude \
			-prune -o -type f -iname *.dll ! -iname *winpthread* -print0 \
			| xargs -0 -I{} cp -f {} $PREFIX/$TARGET/lib${REVERSE_ARCHITECTURE/x/}/ || die "Error copying ${REVERSE_ARCHITECTURE/x/}-bit dlls"

		[[ $STRIP_ON_INSTALL == yes ]] && {
			strip $PREFIX/$TARGET/lib${REVERSE_ARCHITECTURE/x/}/*.dll || die "Error stripping ${REVERSE_ARCHITECTURE/x/}-bit dlls"
		}
	}

	unset _gcc_version
	touch $BUILDS_DIR/gcc-post.marker
}

# **************************************************************************
