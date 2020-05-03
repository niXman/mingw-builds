
#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of MinGW-W64(mingw-builds: https://github.com/niXman/mingw-builds) project.
# Copyright (c) 2011-2017 by niXman (i dotty nixman doggy gmail dotty com)
# Copyright (c) 2012-2015 by Alexpux (alexpux doggy gmail dotty com)
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

PKG_VERSION=2.7.18
PKG_NAME=Python-${PKG_VERSION}
PKG_DIR_NAME=Python-${PKG_VERSION}
PKG_TYPE=.tar.xz
PKG_URLS=(
	"http://www.python.org/ftp/python/${PKG_VERSION}/Python-${PKG_VERSION}${PKG_TYPE}"
)

PKG_PRIORITY=extra

#

PKG_EXECUTE_AFTER_UNCOMPRESS=(
	"rm -f Misc/config_mingw Misc/cross_mingw32 Misc/python-config.sh.in Python/fileblocks.c"
)

#

PKG_PATCHES=(
	Python2/0100-MINGW-BASE-use-NT-thread-model.patch
	Python2/0110-MINGW-translate-gcc-internal-defines-to-python-platf.patch
	Python2/0120-MINGW-use-header-in-lowercase.patch
	Python2/0130-MINGW-configure-MACHDEP-and-platform-for-build.patch
	Python2/0140-MINGW-preset-configure-defaults.patch
	Python2/0150-MINGW-configure-largefile-support-for-windows-builds.patch
	Python2/0160-MINGW-add-wincrypt.h-in-Python-random.c.patch
	Python2/0180-MINGW-init-system-calls.patch
	Python2/0190-MINGW-detect-REPARSE_DATA_BUFFER.patch
	Python2/0200-MINGW-build-in-windows-modules-winreg.patch
	Python2/0210-MINGW-determine-if-pwdmodule-should-be-used.patch
	Python2/0220-MINGW-default-sys.path-calculations-for-windows-plat.patch
	Python2/0230-MINGW-AC_LIBOBJ-replacement-of-fileblocks.patch
	Python2/0250-MINGW-compiler-customize-mingw-cygwin-compilers.patch
	Python2/0270-CYGWIN-issue13756-Python-make-fail-on-cygwin.patch
	Python2/0290-issue6672-v2-Add-Mingw-recognition-to-pyport.h-to-al.patch
	Python2/0300-MINGW-configure-for-shared-build.patch
	Python2/0310-MINGW-dynamic-loading-support.patch
	Python2/0320-MINGW-implement-exec-prefix.patch
	Python2/0330-MINGW-ignore-main-program-for-frozen-scripts.patch
	Python2/0340-MINGW-setup-exclude-termios-module.patch
	Python2/0350-MINGW-setup-_multiprocessing-module.patch
	Python2/0360-MINGW-setup-select-module.patch
	Python2/0370-MINGW-setup-_ctypes-module-with-system-libffi.patch
	Python2/0380-MINGW-defect-winsock2-and-setup-_socket-module.patch
	Python2/0390-MINGW-exclude-unix-only-modules.patch
	Python2/0400-MINGW-setup-msvcrt-module.patch
	Python2/0410-MINGW-build-extensions-with-GCC.patch
	Python2/0420-MINGW-use-Mingw32CCompiler-as-default-compiler-for-m.patch
	Python2/0430-MINGW-find-import-library.patch
	Python2/0440-MINGW-setup-_ssl-module.patch
	Python2/0460-MINGW-generalization-of-posix-build-in-sysconfig.py.patch
	Python2/0462-MINGW-support-stdcall-without-underscore.patch
	Python2/0480-MINGW-generalization-of-posix-build-in-distutils-sys.patch
	Python2/0490-MINGW-customize-site.patch
	Python2/0500-add-python-config-sh.patch
	Python2/0510-cross-darwin-feature.patch
	Python2/0520-py3k-mingw-ntthreads-vs-pthreads.patch
	Python2/0530-mingw-system-libffi.patch
	Python2/0540-mingw-semicolon-DELIM.patch
	Python2/0550-mingw-regen-use-stddef_h.patch
	Python2/0560-mingw-use-posix-getpath.patch
	Python2/0565-mingw-add-ModuleFileName-dir-to-PATH.patch
	Python2/0570-mingw-add-BUILDIN_WIN32_MODULEs-time-msvcrt.patch
	Python2/0580-mingw32-test-REPARSE_DATA_BUFFER.patch
	Python2/0590-mingw-INSTALL_SHARED-LDLIBRARY-LIBPL.patch
	Python2/0600-msys-mingw-prefer-unix-sep-if-MSYSTEM.patch
	Python2/0610-msys-cygwin-semi-native-build-sysconfig.patch
	Python2/0620-mingw-sysconfig-like-posix.patch
	Python2/0630-mingw-_winapi_as_builtin_for_Popen_in_cygwinccompiler.patch
	Python2/0640-mingw-x86_64-size_t-format-specifier-pid_t.patch
	Python2/0650-cross-dont-add-multiarch-paths-if-cross-compiling.patch
	Python2/0660-mingw-use-backslashes-in-compileall-py.patch
	Python2/0670-msys-convert_path-fix-and-root-hack.patch
	Python2/0690-allow-static-tcltk.patch
	Python2/0710-CROSS-properly-detect-WINDOW-_flags-for-different-nc.patch
	Python2/0720-mingw-pdcurses_ISPAD.patch
	Python2/0740-grammar-fixes.patch
	Python2/0750-Add-interp-Python-DESTSHARED-to-PYTHONPATH-b4-pybuilddir-txt-dir.patch
	Python2/0760-msys-monkeypatch-os-system-via-sh-exe.patch
	Python2/0770-msys-replace-slashes-used-in-io-redirection.patch
	Python2/0790-mingw-add-_exec_prefix-for-tcltk-dlls.patch
	Python2/0800-mingw-install-layout-as-posix.patch
	Python2/0820-mingw-reorder-bininstall-ln-symlink-creation.patch
	Python2/0830-add-build-sysroot-config-option.patch
	Python2/0840-add-builddir-to-library_dirs.patch
	Python2/0850-cross-PYTHON_FOR_BUILD-gteq-276-and-fullpath-it.patch
	Python2/0855-mingw-fix-ssl-dont-use-enum_certificates.patch
	Python2/0860-mingw-build-optimized-ext.patch
	Python2/0870-mingw-add-LIBPL-to-library-dirs.patch
	Python2/0910-fix-using-dllhandle-and-winver-mingw.patch
	Python2/1000-dont-link-with-gettext.patch
	Python2/1010-ctypes-python-dll.patch
	Python2/1020-gdbm-module-includes.patch
	Python2/1030-use-gnu_printf-in-format.patch
	Python2/1040-install-msilib.patch
	Python2/1050-Fixed-building-under-Windows-10.patch
	Python2/1900-ctypes-dont-depend-on-internal-libffi.patch
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
	"sed -i -e \"s|^#.* /usr/local/bin/python|#!/usr/bin/python2|\" Lib/cgi.py"
	"sed -i \"s/python2.3/python2/g\" Lib/distutils/tests/test_build_scripts.py Lib/distutils/tests/test_install_scripts.py Tools/scripts/gprof2html.py"
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
	--enable-optimizations
	#
	LIBFFI_INCLUDEDIR="$LIBSW_DIR/lib/libffi-$LIBFFI_VERSION/include"
	OPT=""
	CFLAGS="\"$COMMON_CFLAGS -fwrapv -DNDEBUG -D__USE_MINGW_ANSI_STDIO=1\""
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
