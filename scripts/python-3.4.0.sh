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

PKG_VERSION=3.4.0
PKG_NAME=Python-${PKG_VERSION}
PKG_DIR_NAME=Python-${PKG_VERSION}
PKG_TYPE=.tar.xz
PKG_URLS=(
	"http://www.python.org/ftp/python/${PKG_VERSION}/Python-${PKG_VERSION}${PKG_TYPE}"
)

PKG_PRIORITY=extra

#

PKG_EXECUTE_AFTER_UNCOMPRESS=(
	"rm -f Misc/config_mingw Misc/cross_mingw32 Python/fileblocks.c"
)

#

PKG_PATCHES=(
	Python/${PKG_VERSION}/0100-MINGW-BASE-use-NT-thread-model.patch
	Python/${PKG_VERSION}/0110-MINGW-translate-gcc-internal-defines-to-python-platf.patch
	Python/${PKG_VERSION}/0130-MINGW-configure-MACHDEP-and-platform-for-build.patch
	Python/${PKG_VERSION}/0140-MINGW-preset-configure-defaults.patch
	Python/${PKG_VERSION}/0150-MINGW-configure-largefile-support-for-windows-builds.patch
	Python/${PKG_VERSION}/0160-MINGW-add-wincrypt.h-in-Python-random.c.patch
	Python/${PKG_VERSION}/0170-MINGW-add-srcdir-PC-to-CPPFLAGS.patch
	Python/${PKG_VERSION}/0180-MINGW-init-system-calls.patch
	Python/${PKG_VERSION}/0190-MINGW-detect-REPARSE_DATA_BUFFER.patch
	Python/${PKG_VERSION}/0200-MINGW-build-in-windows-modules-winreg.patch
	Python/${PKG_VERSION}/0210-MINGW-determine-if-pwdmodule-should-be-used.patch
	Python/${PKG_VERSION}/0220-MINGW-default-sys.path-calculations-for-windows-plat.patch
	Python/${PKG_VERSION}/0230-MINGW-AC_LIBOBJ-replacement-of-fileblocks.patch
	Python/${PKG_VERSION}/0240-MINGW-use-main-to-start-execution.patch
	Python/${PKG_VERSION}/0250-MINGW-compiler-customize-mingw-cygwin-compilers.patch
	Python/${PKG_VERSION}/0260-MINGW-compiler-enable-new-dtags.patch
	Python/${PKG_VERSION}/0270-CYGWIN-issue13756-Python-make-fail-on-cygwin.patch
	Python/${PKG_VERSION}/0280-issue17219-add-current-dir-in-library-path-if-buildi.patch
	Python/${PKG_VERSION}/0290-issue6672-v2-Add-Mingw-recognition-to-pyport.h-to-al.patch
	Python/${PKG_VERSION}/0300-MINGW-configure-for-shared-build.patch
	Python/${PKG_VERSION}/0310-MINGW-dynamic-loading-support.patch
	Python/${PKG_VERSION}/0320-MINGW-implement-exec-prefix.patch
	Python/${PKG_VERSION}/0330-MINGW-ignore-main-program-for-frozen-scripts.patch
	Python/${PKG_VERSION}/0340-MINGW-setup-exclude-termios-module.patch
	Python/${PKG_VERSION}/0350-MINGW-setup-_multiprocessing-module.patch
	Python/${PKG_VERSION}/0360-MINGW-setup-select-module.patch
	Python/${PKG_VERSION}/0370-MINGW-setup-_ctypes-module-with-system-libffi.patch
	Python/${PKG_VERSION}/0380-MINGW-defect-winsock2-and-setup-_socket-module.patch
	Python/${PKG_VERSION}/0390-MINGW-exclude-unix-only-modules.patch
	Python/${PKG_VERSION}/0400-MINGW-setup-msvcrt-and-_winapi-modules.patch
	Python/${PKG_VERSION}/0410-MINGW-build-extensions-with-GCC.patch
	Python/${PKG_VERSION}/0420-MINGW-use-Mingw32CCompiler-as-default-compiler-for-m.patch
	Python/${PKG_VERSION}/0430-MINGW-find-import-library.patch
	Python/${PKG_VERSION}/0440-MINGW-setup-_ssl-module.patch
	Python/${PKG_VERSION}/0450-MINGW-export-_PyNode_SizeOf-as-PyAPI-for-parser-modu.patch
	Python/${PKG_VERSION}/0460-MINGW-generalization-of-posix-build-in-sysconfig.py.patch
	Python/${PKG_VERSION}/0462-MINGW-support-stdcall-without-underscore.patch
	Python/${PKG_VERSION}/0464-use-replace-instead-rename-to-avoid-failure-on-windo.patch
	Python/${PKG_VERSION}/0470-MINGW-avoid-circular-dependency-from-time-module-dur.patch
	Python/${PKG_VERSION}/0480-MINGW-generalization-of-posix-build-in-distutils-sys.patch
	Python/${PKG_VERSION}/0490-MINGW-customize-site.patch
	Python/${PKG_VERSION}/0500-add-python-config-sh.patch
	Python/${PKG_VERSION}/0510-cross-darwin-feature.patch
	Python/${PKG_VERSION}/0520-py3k-mingw-ntthreads-vs-pthreads.patch
	Python/${PKG_VERSION}/0530-mingw-system-libffi.patch
	Python/${PKG_VERSION}/0540-mingw-semicolon-DELIM.patch
	Python/${PKG_VERSION}/0550-mingw-regen-use-stddef_h.patch
	Python/${PKG_VERSION}/0560-mingw-use-posix-getpath.patch
	Python/${PKG_VERSION}/0565-mingw-add-ModuleFileName-dir-to-PATH.patch
	Python/${PKG_VERSION}/0570-mingw-add-BUILDIN_WIN32_MODULEs-time-msvcrt.patch
	Python/${PKG_VERSION}/0580-mingw32-test-REPARSE_DATA_BUFFER.patch
	Python/${PKG_VERSION}/0590-mingw-INSTALL_SHARED-LDLIBRARY-LIBPL.patch
	Python/${PKG_VERSION}/0600-msys-mingw-prefer-unix-sep-if-MSYSTEM.patch
	Python/${PKG_VERSION}/0610-msys-cygwin-semi-native-build-sysconfig.patch
	Python/${PKG_VERSION}/0620-mingw-sysconfig-like-posix.patch
	Python/${PKG_VERSION}/0630-mingw-_winapi_as_builtin_for_Popen_in_cygwinccompiler.patch
	Python/${PKG_VERSION}/0640-mingw-x86_64-size_t-format-specifier-pid_t.patch
	Python/${PKG_VERSION}/0650-cross-dont-add-multiarch-paths-if-cross-compiling.patch
	Python/${PKG_VERSION}/0660-mingw-use-backslashes-in-compileall-py.patch
	Python/${PKG_VERSION}/0670-msys-convert_path-fix-and-root-hack.patch
	Python/${PKG_VERSION}/0690-allow-static-tcltk.patch
	Python/${PKG_VERSION}/0700-CROSS-avoid-ncursesw-include-path-hack.patch
	Python/${PKG_VERSION}/0710-CROSS-properly-detect-WINDOW-_flags-for-different-nc.patch
	Python/${PKG_VERSION}/0720-mingw-pdcurses_ISPAD.patch
	Python/${PKG_VERSION}/0730-mingw-fix-ncurses-module.patch
	Python/${PKG_VERSION}/0740-grammar-fixes.patch
	Python/${PKG_VERSION}/0750-builddir-fixes.patch
	Python/${PKG_VERSION}/0760-msys-monkeypatch-os-system-via-sh-exe.patch
	Python/${PKG_VERSION}/0770-msys-replace-slashes-used-in-io-redirection.patch
	Python/${PKG_VERSION}/0790-mingw-add-_exec_prefix-for-tcltk-dlls.patch
	Python/${PKG_VERSION}/0800-mingw-install-layout-as-posix.patch
	Python/${PKG_VERSION}/0810-remove_path_max.default.patch
	Python/${PKG_VERSION}/0820-dont-link-with-gettext.patch
	Python/${PKG_VERSION}/0830-ctypes-python-dll.patch
	Python/${PKG_VERSION}/0840-gdbm-module-includes.patch
	Python/${PKG_VERSION}/0850-use-gnu_printf-in-format.patch
	Python/${PKG_VERSION}/1000-fix-building-posixmodule.patch
)

#

PKG_EXECUTE_AFTER_PATCH=(
	"rm -rf Modules/expat"
	"rm -rf Modules/_ctypes/libffi*"
	"rm -rf Modules/zlib"
	"autoreconf -vfi"
	"rm -rf autom4te.cache"
	"touch Include/graminit.h"
	"touch Python/graminit.c"
	"touch Parser/Python.asdl"
	"touch Parser/asdl.py"
	"touch Parser/asdl_c.py"
	"touch Include/Python-ast.h"
	"touch Python/Python-ast.c"
	"echo \"\" > Parser/pgen.stamp"
)

#

[[ -d $LIBS_DIR ]] && {
	pushd $LIBS_DIR > /dev/null
	LIBSW_DIR=`pwd -W`
	popd > /dev/null
}

[[ -d $PREREQ_DIR ]] && {
	pushd $PREREQ_DIR > /dev/null
	PREREQW_DIR=`pwd -W`
	popd > /dev/null
}

LIBFFI_VERSION=$( grep 'PKG_VERSION=' $TOP_DIR/scripts/libffi.sh | sed 's|PKG_VERSION=||' )
MY_CPPFLAGS="-I$LIBSW_DIR/include -I$LIBSW_DIR/include/ncursesw -I$PREREQW_DIR/$BUILD_ARCHITECTURE-zlib-$LINK_TYPE_SUFFIX/include"

# Workaround for conftest error on 64-bit builds
export ac_cv_working_tzset=no

#

PKG_CONFIGURE_FLAGS=(
	--host=$HOST
	--build=$BUILD
	#
	--prefix=$LIBS_DIR
	#
	--enable-shared
	--with-threads
	--with-system-expat
	--with-system-ffi
	--enable-loadable-sqlite-extensions
	--without-ensurepip
	#
	LIBFFI_INCLUDEDIR="$LIBSW_DIR/lib/libffi-$LIBFFI_VERSION/include"
	CFLAGS="\"$COMMON_CFLAGS -D__USE_MINGW_ANSI_STDIO=1\""
	CPPFLAGS="\"$COMMON_CPPFLAGS $MY_CPPFLAGS\""
	LDFLAGS="\"$COMMON_LDFLAGS -L$PREREQW_DIR/$BUILD_ARCHITECTURE-zlib-$LINK_TYPE_SUFFIX/lib -L$LIBSW_DIR/lib\""
)

#

PKG_MAKE_FLAGS=(
	-j$JOBS
	all
)

#

PKG_INSTALL_FLAGS=(
	install
)

#

[[ $BUILD_MODE == gcc || $BUILD_MODE == python ]] && {
	[[ $BUILD_MODE == gcc ]] && {
		RM_PYTHON_TEST_DIR_CMD="rm -rf $LIBS_DIR/lib/python?.?/test"
	} || {
		RM_PYTHON_TEST_DIR_CMD="rm -rf $PREFIX/lib/python?.?/test"
	}
}

PKG_EXECUTE_AFTER_INSTALL=(
	"$RM_PYTHON_TEST_DIR_CMD"
)

# **************************************************************************
