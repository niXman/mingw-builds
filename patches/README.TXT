
- gcc-4.6-cloog_lang_c.patch
	...

- gcc-4.6-iconv.patch
	...

- gcc-4.6-stdthreads.patch
	...

- gcc-4.7-iconv.patch
	...

- gcc-4.7-stdthreads.patch
	...

- gcc-4.8-iconv.patch
	...

- make-linebuf-mingw.patch
	From Jonathan Liu (net147@gmail.com)
	The difference is that build_w32.bat doesn't define HAVE_LOCALE_H.
	The mingw-builds make uses the configure script which sets HAVE_LOCALE_H to 1.
	If HAVE_LOCALE_H is set to 1, setlocale(LC_ALL, "") is called in main.cpp
	and this prevents line buffering from working properly for some reason.

- make-remove-double-quote.patch
	From Jonathan Liu (net147@gmail.com)
	Read this: http://lists.gnu.org/archive/html/make-w32/2012-05/msg00000.html
	and this: http://lists.gnu.org/archive/html/make-w32/2012-09/msg00000.html
