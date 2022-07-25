/* $Id$ */
/*
 * Copyright (C) 2008-2011 Teluu Inc. (http://www.teluu.com)
 * Copyright (C) 2003-2008 Benny Prijono <benny@prijono.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

/**
 * \page page_strerror_c Samples: Print out error message
 *
 * This file is pjsip-apps/src/samples/strerror.c
 *
 * \includelineno strerror.c
 */

#include <pjlib-util.h>
#include <pjlib.h>
#include <pjmedia.h>
#include <pjnath.h>
#include <pjsip.h>
#include <pjsip/sip_parser.h>
#include <pjsip_simple.h>

#ifndef __AFL_FUZZ_TESTCASE_LEN
ssize_t fuzz_len;
#define __AFL_FUZZ_TESTCASE_LEN fuzz_len
unsigned char fuzz_buf[1024000];
#define __AFL_FUZZ_TESTCASE_BUF fuzz_buf
#define __AFL_FUZZ_INIT() void sync(void)
#define __AFL_LOOP(x)                                                          \
  ((fuzz_len = read(0, fuzz_buf, sizeof(fuzz_buf))) > 0 ? 1 : 0)
#define __AFL_INIT() sync()
#endif

__AFL_FUZZ_INIT();

/*
 * main()
 */
int main(int argc, char *argv[]) {
#ifdef __AFL_HAVE_MANUAL_CONTROL
  __AFL_INIT();
#endif

  unsigned char *buf = __AFL_FUZZ_TESTCASE_BUF;

  while (__AFL_LOOP(10000)) {
    puts("loop\n");

    int len = __AFL_FUZZ_TESTCASE_LEN;

    if (len < 8)
      continue;

    pj_caching_pool cp;
    pjmedia_endpt *med_ept;
    pjsip_endpoint *sip_ept;
    pj_log_set_level(3);

    pj_init();
    pjlib_util_init();
    pj_caching_pool_init(&cp, &pj_pool_factory_default_policy, 0);
    pjnath_init();
//    pjmedia_endpt_create(&cp.factory, NULL, 0, &med_ept);
    pjsip_endpt_create(&cp.factory, "localhost", &sip_ept);
    pjsip_evsub_init_module(sip_ept);
    pj_pool_t *pool = pj_pool_create(&cp.factory, "test", 4096, 4096, NULL);
    assert(pool != NULL);

    __attribute__((unused)) volatile pjsip_msg *msg =
        pjsip_parse_msg(pool, buf, len, NULL);

    pjsip_endpt_destroy(sip_ept);
    pj_pool_release(pool);
    pj_shutdown();
  }

  return 0;
}
