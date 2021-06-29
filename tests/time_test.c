//
// The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
//
// This file is part of MinGW-W64(mingw-builds: https://github.com/niXman/mingw-builds) project.
// Copyright (c) 2011-2021 by niXman (i dotty nixman doggy gmail dotty com)
// Copyright (c) 2012-2015 by Alexpux (alexpux doggy gmail dotty com)
// All rights reserved.
//
// Project: MinGW-W64 ( http://sourceforge.net/projects/mingw-w64/ )
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
// - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer in
//     the documentation and/or other materials provided with the distribution.
// - Neither the name of the 'MinGW-W64' nor the names of its contributors may
//     be used to endorse or promote products derived from this software
//     without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
// OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
// USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// **************************************************************************

#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <errno.h>
#include <windows.h>

#define POW10_3                 1000
#define POW10_6                 1000000
#define POW10_9                 1000000000

#define assert(_Expression) (void)( (!!(_Expression)) || (_my_assert(#_Expression, __FILE__, __LINE__), 0) )

static __inline void _my_assert(char *message, char *file, unsigned int line)
{
    fprintf(stderr, "Assertion failed: %s , file %s, line %u\n", message, file, line);
    exit(1);
}

void test_clock_gettime()
{
    int rc;
    struct timespec tp, request = { 1, 0 }, remain;

    rc = clock_gettime(CLOCK_REALTIME, &tp);
    assert(rc == 0);
    printf("[%10"PRId64".%09d] clock_gettime (CLOCK_REALTIME)\n", (__int64) tp.tv_sec, (int) tp.tv_nsec);

    rc = clock_gettime(CLOCK_MONOTONIC, &tp);
    assert(rc == 0);
    printf("[%10"PRId64".%09d] clock_gettime (CLOCK_MONOTONIC)\n", (__int64) tp.tv_sec, (int) tp.tv_nsec);

    rc = clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &tp);
    assert(rc == 0);
    printf("[%10"PRId64".%09d] clock_gettime (CLOCK_PROCESS_CPUTIME_ID)\n", (__int64) tp.tv_sec, (int) tp.tv_nsec);

    rc = clock_gettime(CLOCK_THREAD_CPUTIME_ID, &tp);
    assert(rc == 0);
    printf("[%10"PRId64".%09d] clock_gettime (CLOCK_THREAD_CPUTIME_ID)\n", (__int64) tp.tv_sec, (int) tp.tv_nsec);
    
    rc = clock_nanosleep(CLOCK_REALTIME, 0, &request, &remain);
    assert(rc == 0);

    rc = clock_gettime(CLOCK_REALTIME, &tp);
    assert(rc == 0);
    printf("[%10"PRId64".%09d] clock_gettime (CLOCK_REALTIME)\n", (__int64) tp.tv_sec, (int) tp.tv_nsec);

    rc = clock_gettime(CLOCK_MONOTONIC, &tp);
    assert(rc == 0);
    printf("[%10"PRId64".%09d] clock_gettime (CLOCK_MONOTONIC)\n", (__int64) tp.tv_sec, (int) tp.tv_nsec);

    rc = clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &tp);
    assert(rc == 0);
    printf("[%10"PRId64".%09d] clock_gettime (CLOCK_PROCESS_CPUTIME_ID)\n", (__int64) tp.tv_sec, (int) tp.tv_nsec);

    rc = clock_gettime(CLOCK_THREAD_CPUTIME_ID, &tp);
    assert(rc == 0);
    printf("[%10"PRId64".%09d] clock_gettime (CLOCK_THREAD_CPUTIME_ID)\n", (__int64) tp.tv_sec, (int) tp.tv_nsec);

}

double sub_and_div(const struct timespec *t1, const struct timespec *t2, const struct timespec *r)
{
    __int64 diff = (t2->tv_sec - t1->tv_sec) * POW10_9 + (t2->tv_nsec - t1->tv_nsec);
    return diff / (double) (r->tv_sec * POW10_9 + r->tv_nsec);
}

void test_clock_getres(char *name, int id)
{
    int rc;
    double d;
    struct timespec tp, t1, t2;

    rc = clock_getres(id, &tp);
    assert(rc == 0);
    printf("%s resolution: %d.%09d sec\n", name, (int) tp.tv_sec, (int) tp.tv_nsec);

    rc = clock_gettime(id, &t1);
    assert(rc == 0);
    printf("%s time: %d.%09d sec\n", name, (int) t1.tv_sec, (int) t1.tv_nsec);

    if (id == CLOCK_REALTIME || id == CLOCK_MONOTONIC) {
        struct timespec request = {1, 0};
        clock_nanosleep(CLOCK_REALTIME, 0, &request, NULL);
    } else {
        long i;
        for (i = 0; i < 100000000; i++) {
            rand();
        }
    }

    rc = clock_gettime(id, &t2);
    assert(rc == 0);
    printf("%s time: %d.%09d sec\n", name, (int) t2.tv_sec, (int) t2.tv_nsec);

    d = sub_and_div(&t1, &t2, &tp);
    printf("sub_and_div: %7.3lf\n", d);
    printf("\n");
}

void test_clock_settime()
{
    int rc;
    struct timespec tp, request = { 1, 0 }, remain;

    rc = clock_gettime(CLOCK_REALTIME, &tp);
    assert(rc == 0);
    printf("[%10"PRId64".%09d] clock_gettime (CLOCK_REALTIME)\n", (__int64) tp.tv_sec, (int) tp.tv_nsec);
    
    rc = clock_settime(CLOCK_MONOTONIC, &tp);
    assert(rc == -1 && (errno == EINVAL));
    
    rc = clock_settime(CLOCK_PROCESS_CPUTIME_ID, &tp);
    assert(rc == -1 && (errno == EINVAL));
    
    rc = clock_settime(CLOCK_THREAD_CPUTIME_ID, &tp);
    assert(rc == -1 && (errno == EINVAL));
    
    rc = clock_settime(CLOCK_REALTIME, &tp);
    assert(rc == 0 || (errno == EPERM));

    rc = clock_gettime(CLOCK_REALTIME, &tp);
    assert(rc == 0);
    printf("[%10"PRId64".%09d] clock_gettime (CLOCK_REALTIME)\n", (__int64) tp.tv_sec, (int) tp.tv_nsec);
}

void test_clock_nanosleep()
{
    int rc;
    struct timespec tp, request = { 1, 0 }, remain;

    rc = clock_nanosleep(CLOCK_MONOTONIC, 0, &request, &remain);
    assert(rc == -1 && errno == EINVAL);

    rc = clock_nanosleep(CLOCK_PROCESS_CPUTIME_ID, 0, &request, &remain);
    assert(rc == -1 && errno == EINVAL);

    rc = clock_nanosleep(CLOCK_THREAD_CPUTIME_ID, 0, &request, &remain);
    assert(rc == -1 && errno == EINVAL);

    rc = clock_gettime(CLOCK_REALTIME, &tp);
    assert(rc == 0);
    printf("[%10"PRId64".%09d] clock_gettime (CLOCK_REALTIME)\n", (__int64) tp.tv_sec, (int) tp.tv_nsec);
    
    rc = clock_nanosleep(CLOCK_REALTIME, 0, &request, &remain);
    assert(rc == 0);

    rc = clock_gettime(CLOCK_REALTIME, &tp);
    assert(rc == 0);
    printf("[%10"PRId64".%09d] clock_gettime (CLOCK_REALTIME)\n", (__int64) tp.tv_sec, (int) tp.tv_nsec);

    request.tv_sec = tp.tv_sec + 1;
    request.tv_nsec = 0;

    rc = clock_nanosleep(CLOCK_REALTIME, TIMER_ABSTIME, &request, &remain);
    assert(rc == 0);

    rc = clock_gettime(CLOCK_REALTIME, &tp);
    assert(rc == 0);
    printf("[%10"PRId64".%09d] clock_gettime (CLOCK_REALTIME)\n", (__int64) tp.tv_sec, (int) tp.tv_nsec);
}

extern int __cdecl getntptimeofday(struct timespec *tp, struct timezone *tz);

__int64 timespec_diff_as_ms(struct timespec *__old, struct timespec *__new)
{
    return (__new->tv_sec - __old->tv_sec) * POW10_3
         + (__new->tv_nsec - __old->tv_nsec) / POW10_6;
}

unsigned __stdcall start_address(void *dummy)
{
    int counter = 0;
    struct timespec request = { 1, 0 }, remain;

    while (counter < 5) {
        int rc = nanosleep(&request, &remain);
        if (rc != 0) {
            printf("nanosleep interrupted, remain %d.%09d sec.\n",
                (int) remain.tv_sec, (int) remain.tv_nsec);
        } else {
            printf("nanosleep succeeded.\n");
        }

        counter ++;
    }

    return 0;
}

void WINAPI usr_apc(ULONG_PTR dwParam)
{
    long *index = (long *) dwParam;
    printf("running apc %ld\n", *index);
}

void test_apc()
{
    long i, rc, data[5];
    HANDLE thread;

    thread = (HANDLE) _beginthreadex(NULL, 0, start_address, NULL, 0, NULL);
    if (thread == NULL) {
        exit(1);
    }

    for (i = 0; i < 5; i++) {
        data[i] = i;
        Sleep(250 + rand() % 250);
        rc = QueueUserAPC(usr_apc, thread, (ULONG_PTR) & data[i]);
        if (rc == 0) {
            printf("QueueUserAPC failed: %ld\n", GetLastError());
            exit(1);
        }
    }

    rc = WaitForSingleObject(thread, INFINITE);
    if (rc != WAIT_OBJECT_0) {
        printf("WaitForSingleObject failed with %ld: %ld\n", rc, GetLastError());
        exit(1);
    }
}

int main() {
    int rc;
    struct timespec tp, tp2, request = { 1, 0 }, remain;

    test_clock_gettime();

    test_clock_getres("          CLOCK_REALTIME", CLOCK_REALTIME);
    test_clock_getres("         CLOCK_MONOTONIC", CLOCK_MONOTONIC);
    test_clock_getres("CLOCK_PROCESS_CPUTIME_ID", CLOCK_PROCESS_CPUTIME_ID);
    test_clock_getres(" CLOCK_THREAD_CPUTIME_ID", CLOCK_THREAD_CPUTIME_ID);

    test_clock_settime();

    test_clock_nanosleep();

    getntptimeofday(&tp, NULL);
    rc = nanosleep(&request, &remain);
    getntptimeofday(&tp2, NULL);

    if (rc != 0) {
        printf("remain: %d.%09d\n", (int) remain.tv_sec, (int) remain.tv_nsec);
    }

    printf("%d.%09d\n", (int) tp.tv_sec, (int) tp.tv_nsec);
    printf("%d.%09d\n", (int) tp2.tv_sec, (int) tp2.tv_nsec);
    printf("sleep %d ms\n\n", (int) timespec_diff_as_ms(&tp, &tp2));

    test_apc();

    return 0;
}
