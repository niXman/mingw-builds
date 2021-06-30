The scripts provided by the MinGW-W64 project[1] are designed
for building the dual-target(i686/x86_64) MinGW-W64 compiler for i686/x86_64 hosts.

The scripts are distributed under the 'BSD 3' license[2].

In order to use the scripts provided by the MinGW-W64 project it is needed:

1. Windows-64bit or Linux + Wine-64bit

2. Install MSYS2 from:
  `http://sourceforge.net/projects/msys2/`
  (MSYS2 wiki: https://www.msys2.org/wiki/MSYS2-installation/)

3. Get the scripts into `<msys root>/home/<user>/mingw-builds`:
  `cd && git clone <paste correct url>`
  (see the diff between the 'master' and 'develop' branches, maybe you need
   the 'develop' branch exactly)

4. In the MSYS2 file structure delete or rename the `/mingw32` and `/mingw64` directory.

5. Delete the paths pointing to any preinstalled MinGW from the `PATH`
  environment variable.

6. Go into the MinGW-builds root directory.
  `cd && cd mingw-builds`

7. Options:
```
  --mode=[gcc|python|clang]-<version> - what package to build with version.
  --arch=<i686|x86_64>                - build architecture.
  --buildroot=<path>                  - using '<path>' as build directory.
                                        By default used MSYS user home directory.
  --fetch-only                        - only download all the sources without start building.
  --update-sources                    - try to update sources from repositories before build.
  --exceptions=<model>                - exceptions handling model.
                                        Available: dwarf, seh(gcc>=4.8.0 only), sjlj, dwarfseh (picks by architecture).
  --use-lto                           - building with using LTO.
  --no-strip                          - don't strip executables during install.
  --no-multilib                       - build GCC without multilib support (default for DWARF and SEH exception models).
  --static-gcc                        - build static GCC.
  --dyn-deps                          - build GCC with dynamically dependencies.
  --rt-version=<v3|v4|v5|v6|v7|v8|v9> - version of mingw-w64 runtime to build.
  --rev=N                             - number of the build revision.
  --with-testsuite                    - run testsuite for packages that contain flags for it.
  --threads=<posix|win32>             - used threads model.
  --enable-languages=<langs>          - comma separated list(without spaces) of gcc supported languages.
                                        available languages: ada,c,c++,fortran,objc,obj-c++
```
  For more options run: "./build --help"

8. Run:
*  `./build --mode=gcc-4.8.1 --arch=i686` for building i686-MinGW-w64
*  `./build --mode=gcc-4.8.1 --arch=x86_64` for building x86_64-MinGW-w64
*  `./build --mode=gcc-4.8.1 --arch=x86_64 --preload` for preload sources and building x86_64-MinGW-w64
*  `./build --mode=gcc-4.8.1 --arch=i686 --exceptions=dwarf` for building i686-MinGW-w64 with DWARF exception handling

For example, during the process of building of the i686-gcc-4.7.2 will
  be created the following directories:
```
  <buildroot>/i686-4.7.2-release-posix-sjlj-rev1/build
  <buildroot>/i686-4.7.2-release-posix-sjlj-rev1/libs
  <buildroot>/i686-4.7.2-release-posix-sjlj-rev1/logs
  <buildroot>/i686-4.7.2-release-posix-sjlj-rev1/prefix
```

For x86_64:
```
  <buildroot>/x86_64-4.7.2-release-posix-sjlj-rev1/build
  <buildroot>/x86_64-4.7.2-release-posix-sjlj-rev1/libs
  <buildroot>/x86_64-4.7.2-release-posix-sjlj-rev1/logs
  <buildroot>/x86_64-4.7.2-release-posix-sjlj-rev1/prefix
```

And the sources directory:
  `<buildroot>/src`


The archives with the built MinGW will be created in `<buildroot>/archives/`

At the moment, successfully building the following versions:
```
  gcc-4.6.4
  gcc-4.7.0
  gcc-4.7.1
  gcc-4.7.2
  gcc-4.7.3
  gcc-4.7.4
  gcc-4.8.0
  gcc-4.8.1
  gcc-4.8.2
  gcc-4.8.3
  gcc-4.8.4
  gcc-4.8.5
  gcc-4.9.0
  gcc-4.9.1
  gcc-4.9.2
  gcc-4.9.3
  gcc-4.9.4
  gcc-5.1.0
  gcc-5.2.0
  gcc-5.3.0
  gcc-5.4.0
  gcc-5.5.0
  gcc-6.1.0
  gcc-6.2.0
  gcc-6.3.0
  gcc-6.4.0
  gcc-6.5.0
  gcc-7.1.0
  gcc-7.2.0
  gcc-7.3.0
  gcc-7.4.0
  gcc-7.5.0
  gcc-8.1.0
  gcc-8.2.0
  gcc-8.3.0
  gcc-8.4.0
  gcc-8.5.0
  gcc-9.1.0
  gcc-9.2.0
  gcc-9.3.0
  gcc-9.4.0
  gcc-10.1.0
  gcc-10.2.0
  gcc-10.3.0
  gcc-11.1.0
  gcc-4.6-branch (currently 4.6.5 prerelease)
  gcc-4.7-branch (currently 4.7.5 prerelease)
  gcc-4.8-branch (currently 4.8.6 prerelease)
  gcc-4.9-branch (currently 4.9.5 prerelease)
  gcc-5-branch (currently 5.6.0 prerelease)
  gcc-6-branch (currently 6.6.0 prerelease)
  gcc-7-branch (currently 7.6.0 prerelease)
  gcc-8-branch (currently 8.6.0 prerelease)
  gcc-9-branch (currently 9.5.0-prerelease)
  gcc-10-branch (currently 10.4.0-prerelease)
  gcc-11-branch (currently 11.2.0-prerelease)
  gcc-trunk (currently 12.0.0 snapshot)
```

Builds also contains patches for building Python 2.7.9 and 3.4.3 versions for support gdb pretty printers.
Big thanks for these patches to:
```
  2010-2013 Roumen Petrov, Руслан Ижбулатов
  2012-2015 Ray Donnelly, Alexey Pavlov
```

[1] http://sourceforge.net/projects/mingw-w64/

[2] http://www.opensource.org/licenses/BSD-3-Clause
