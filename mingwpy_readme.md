# mingwpy customization of mingw-builds

## prepare msys2 to allow mingw-builds to run

Install and update a fresh msys2 from https://msys2.github.io according the instructions given on this site.

*NEVER* use an installation path with SPACES or other special characters!

Install the following tools and programs with the help of pacman:
`pacman -Sy svn zip tar autoconf make libtool automake p7zip patch bison gettext-devel wget curl sshpass`

Now make sure the mingw-w64 toolchain supplied by pacman is NOT installed:
`$ gcc -v` should show the following error: `bash: gcc: command not found`

## build the 64-bit toolchain

`./build --mode=gcc-5.3.0 --static-gcc --arch=x86_64 --march-x64='x86-64' --mtune-x64='generic' --buildroot=/tmp/x86_64 --rev=201601 --rt-version=trunk --threads=win32 --exceptions=seh --enable-languages=c,c++,fortran --fetch-only`

`./build --mode=gcc-5.3.0 --static-gcc --arch=x86_64 --march-x64='x86-64' --mtune-x64='generic' --buildroot=/tmp/x86_64 --rev=201601 --rt-version=trunk --threads=win32 --exceptions=seh --enable-languages=c,c++,fortran --bootstrap --no-multilib --bin-compress`

## build the 32-bit toolchain

`./build --mode=gcc-5.3.0 --static-gcc --arch=i686 --march-x32='pentium4' --mtune-x32='generic' --buildroot=/tmp/i686 --rev=201601 --rt-version=trunk --threads=win32 --exceptions=sjlj --enable-languages=c,c++,fortran --fetch-only`

`./build --mode=gcc-5.3.0 --static-gcc --arch=i686 --march-x32='pentium4' --mtune-x32='generic' --buildroot=/tmp/i686 --rev=201601 --rt-version=trunk --threads=win32 --exceptions=sjlj --enable-languages=c,c++,fortran --bootstrap --no-multilib --bin-compress`
