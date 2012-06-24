/*
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
 * @file wlsb.h
 * @brief Window-based Least Significant Bits (W-LSB) encoding
 * @author Didier Barvaux <didier.barvaux@toulouse.viveris.com>
 * @author David Moreau from TAS
 * @author The hackers from ROHC for Linux
 */

#ifndef WLSB_H
#define WLSB_H

#include "interval.h" /* for rohc_lsb_shift_t */

#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>


/// Default window width for W-LSB encoding
#define C_WINDOW_WIDTH 4

/* The definition of the W-LSB encoding object is private */
struct c_wlsb;


/*
 * Public function prototypes:
 */

struct c_wlsb * c_create_wlsb(const size_t bits,
                              const size_t window_width,
                              const rohc_lsb_shift_t p);
void c_destroy_wlsb(struct c_wlsb *s);

void c_add_wlsb(struct c_wlsb *const wlsb,
                const uint16_t sn,
                const uint32_t value);

bool wlsb_get_k_16bits(const struct c_wlsb *const wlsb,
                       const uint16_t value,
                       size_t *const bits_nr);
bool wlsb_get_k_32bits(const struct c_wlsb *const wlsb,
                       const uint32_t value,
                       size_t *const bits_nr);

void c_ack_sn_wlsb(struct c_wlsb *s, const uint16_t sn);

int c_sum_wlsb(struct c_wlsb *s);
int c_mean_wlsb(struct c_wlsb *s);

#endif

