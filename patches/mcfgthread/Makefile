
mcfgthread_cflags = \
	-D_WIN32_WINNT=0x0601 \
	-D__USE_MINGW_ANSI_STDIO \
	-D_CRT_SECURE_NO_WARNINGS \
	-fstack-protector \
	-fno-omit-frame-pointer \
	-momit-leaf-frame-pointer \
	-fmerge-all-constants \
	-fstrict-aliasing \
	-ffast-math \
	-fdata-sections \
	-ffunction-sections \
	-funwind-tables \
	-Werror=conversion \
	-Werror=sign-compare \
	-Werror=sign-conversion \
	-Werror=write-strings \
	-Werror=return-type \
	-Werror=double-promotion \
	-Wmissing-declarations \
	-Wswitch-enum \
	-Wmissing-field-initializers \
	-Wshadow \
	-Wunused-function \
	-Wunused-label \
	-Wunused-local-typedefs \
	-Wunused-but-set-variable \
	-Wunused-but-set-parameter \
	-Wunused-const-variable \
	-masm=intel \
	-msse2 \
	-mfpmath=sse+387 \
	-fno-ident

mcfgthread_ldflags = \
	-nostdlib \
	-Wl,--dynamicbase \
	-Wl,--nxcompat \
	-Wl,--gc-sections \
	-Wl,--subsystem,windows:6.1 \
	-Wl,--kill-at \
	-Wl,--exclude-all-symbols \
	-Wl,--disable-auto-import

mcfgthread_public_headers = \
	fwd.h \
	atomic.h \
	teb.h \
	clock.h \
	mutex.h \
	shared_mutex.h \
	cond.h \
	once.h \
	sem.h \
	event.h \
	thread.h \
	cxa.h \
	dtor_queue.h \
	exit.h \
	tls.h \
	cpu_collection.h \
	gthr_aux.h \
	gthr.h \
	gthr_libobjc.h \
	c11.h \
	libcxx.h \
	cxx11.hpp

mcfgthread_obj_min = \
	xglobals.o \
	clock.o \
	mutex.o \
	shared_mutex.o \
	cond.o \
	once.o \
	sem.o \
	event.o \
	thread.o \
	cxa.o \
	dtor_queue.o \
	exit.o \
	tls.o \
	cpu_collection.o

mcfgthread_obj_ex = \
	gthr_aux.o \
	gthr.o \
	gthr_libobjc.o \
	c11.o \
	libcxx.o

.PHONY: all install install-strip install-common

all: libmcfgthread.a libmcfgthread-$(ABI_MAJOR).dll

libmcfgthread.a: $(mcfgthread_obj_min:%=static/%) $(mcfgthread_obj_ex:%=static/%)
	$(AR) rcs $@ $?

libmcfgthread-$(ABI_MAJOR).dll: $(mcfgthread_obj_min:%=shared/%) $(mcfgthread_obj_ex:%=shared/%) libkernel32.a libntdll.a version.o
	$(CC) -shared $(LDFLAGS) $(mcfgthread_ldflags) -Wl,--out-implib,libmcfgthread.dll.a -o $@ $+

static/%.o: $(SOURCE_DIR)/src/%.c
	mkdir -p static
	$(CC) $(CFLAGS) $(mcfgthread_cflags) -I. -o $@ -c $<

shared/%.o: $(SOURCE_DIR)/src/%.c
	mkdir -p shared
	$(CC) $(CFLAGS) $(mcfgthread_cflags) -ffreestanding -D__MCF_IN_DLL -I. -o $@ -c $<

version.o: $(SOURCE_DIR)/src/version.rc
	$(RC) -I. -c65001 -o $@ -i $<

%.i386.def: $(SOURCE_DIR)/src/%.def.in
	sed -E 's/(@[0-9]+)@/\1/g' $< > $@

%.def: $(SOURCE_DIR)/src/%.def.in
	sed -E 's/(@[0-9]+)@//g' $< > $@

lib%.a: %$(DEF_SUFFIX).def
	$(DLLTOOL) -k -l $@ -d $<

install-common: libmcfgthread.a libmcfgthread-$(ABI_MAJOR).dll
	mkdir -p $(DESTDIR)/{bin,include/mcfgthread,lib}
	for i in $(mcfgthread_public_headers); do cp -f $(SOURCE_DIR)/$$i $(DESTDIR)/include/mcfgthread/; done
	cp -f version.h $(DESTDIR)/include/mcfgthread/
	cp -f libmcfgthread.a libmcfgthread.dll.a $(DESTDIR)/lib/

install: install-common
	cp -f libmcfgthread-$(ABI_MAJOR).dll $(DESTDIR)/bin/

install-strip: install-common
	$(STRIP) -s -o $(DESTDIR)/bin/libmcfgthread-$(ABI_MAJOR).dll libmcfgthread-$(ABI_MAJOR).dll
