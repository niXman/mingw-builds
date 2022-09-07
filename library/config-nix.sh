
#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of MinGW-W64(mingw-builds: https://github.com/niXman/mingw-builds) project.
# Copyright (c) 2011-2021 by niXman (i dotty nixman doggy gmail dotty com)
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

readonly HOST_MINGW_VERSION=
readonly HOST_MINGW_RT_VERSION=
readonly HOST_MINGW_BUILD_REV=
readonly i686_HOST_MINGW_PATH_URL=
readonly x86_64_HOST_MINGW_PATH_URL=

readonly TOOLCHAINS_DIR=/usr/bin
readonly i686_HOST_MINGW_PATH=$TOOLCHAINS_DIR
readonly x86_64_HOST_MINGW_PATH=$TOOLCHAINS_DIR

# **************************************************************************

function func_get_host { echo "$1-w64-mingw32"; }
function func_get_build { echo "$1-linux-gnu"; }
function func_get_target { echo "$1-w64-mingw32"; }

readonly CROSS_BUILDS=yes
readonly PKG_RUN_TESTSUITE=no

# **************************************************************************

readonly REPOSITORY_FILE=$PROJECT_ROOT_URL/files/host-linux/repository.txt

# **************************************************************************

readonly LOGVIEWERS=(
	"kate"
	"gedit"
	"subl"
	"nano"
	"mcview"
)

# **************************************************************************

function func_test_installed_packages {
	declare -A osInfo
	osInfo["/etc/redhat-release"]=yum
	osInfo["/etc/arch-release"]=pacman
	osInfo["/etc/gentoo-release"]=emerge
	osInfo["/etc/SuSE-release"]=zypp
	osInfo["/etc/debian_version"]=apt-get
	osInfo["/etc/alpine-release"]=apk

	local package_man=
	for f in ${!osInfo[@]}; do
	    if [[ -f $f ]]; then
	        package_man="${osInfo[$f]}"
	    fi
	done

	local common_packages=(
		git
		tar
		zip
		p7zip
		make
		patch
		automake
		autoconf
		autoconf-archive
		libtool
		flex
		bison
		gettext
		wget
		texinfo
		autogen
		dejagnu
	)

	local package_install=""
	case $package_man in
		yum)
			die "support for the YUM package manager is not implemented!"
		;;
		pacman)
			die "support for the PACMAN package manager is not implemented!"
		;;
		emerge)
			die "support for the EMERGE package manager is not implemented!"
		;;
		zypp)
			die "support for the ZYPP package manager is not implemented!"
		;;
		apt-get)
			local deb_packages=(
				xutils-dev
			)
			package_install="sudo $package_man -y install $(printf " %s" "${common_packages[@]}") $(printf " %s" "${deb_packages[@]}")"
		;;
		aptk)
			die "support for the APK package manager is not implemented!"
		;;
		*)
			die "unknown OS distribution!"
		;;
	esac

	#echo "package_install=${package_install}"
	echo "--> installing required packages..."
	eval "${package_install}" || return 1

	return 0
}

# **************************************************************************
