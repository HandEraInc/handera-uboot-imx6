/*
 * Copyright (C) 2012 Freescale Semiconductor, Inc.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <config.h>
#include <asm/arch/mx6.h>

#ifdef	CONFIG_FLASH_HEADER
#ifndef CONFIG_FLASH_HEADER_OFFSET
# error "Must define the offset of flash header"
#endif

#define CPU_2_BE_32(l) \
       ((((l) & 0x000000FF) << 24) | \
	(((l) & 0x0000FF00) << 8)  | \
	(((l) & 0x00FF0000) >> 8)  | \
	(((l) & 0xFF000000) >> 24))

#define MXC_DCD_ITEM(i, addr, val)   \
dcd_node_##i:                        \
        .word CPU_2_BE_32(addr) ;     \
        .word CPU_2_BE_32(val)  ;     \

.section ".text.flasheader", "x"
	b	_start
	.org	CONFIG_FLASH_HEADER_OFFSET

ivt_header:       .word 0x402000D1 /* Tag=0xD1, Len=0x0020, Ver=0x40 */
app_code_jump_v:  .word _start
reserv1:          .word 0x0
dcd_ptr:          .word dcd_hdr
boot_data_ptr:	  .word boot_data
self_ptr:         .word ivt_header
#ifdef CONFIG_SECURE_BOOT
app_code_csf:     .word __hab_data
#else
app_code_csf:     .word 0x0
#endif
reserv2:          .word 0x0

boot_data:        .word TEXT_BASE
#ifdef CONFIG_SECURE_BOOT
image_len:        .word __hab_data_end - TEXT_BASE + CONFIG_FLASH_HEADER_OFFSET
#else
image_len:        .word _end_of_copy  - TEXT_BASE + CONFIG_FLASH_HEADER_OFFSET
#endif
plugin:           .word 0x0

dcd_hdr:          .word 0x40E001D2 /* Tag=0xD2, Len=59*8 + 4 + 4, Ver=0x40 */
write_dcd_cmd:    .word 0x04DC01CC /* Tag=0xCC, Len=59*8 + 4, Param=0x04 */

/* DCD */

MXC_DCD_ITEM(1, IOMUXC_BASE_ADDR + 0x774, 0x000C0000)
MXC_DCD_ITEM(2, IOMUXC_BASE_ADDR + 0x754, 0x00000000)

MXC_DCD_ITEM(3, IOMUXC_BASE_ADDR + 0x4ac, 0x00000030)
MXC_DCD_ITEM(4, IOMUXC_BASE_ADDR + 0x4b0, 0x00000030)

MXC_DCD_ITEM(5, IOMUXC_BASE_ADDR + 0x464, 0x00000030)
MXC_DCD_ITEM(6, IOMUXC_BASE_ADDR + 0x490, 0x00000030)
MXC_DCD_ITEM(7, IOMUXC_BASE_ADDR + 0x74c, 0x00000030)

MXC_DCD_ITEM(8, IOMUXC_BASE_ADDR + 0x494, 0x00000030)

MXC_DCD_ITEM(9, IOMUXC_BASE_ADDR + 0x4a0, 0x00000000)

MXC_DCD_ITEM(10, IOMUXC_BASE_ADDR + 0x4b4, 0x00000030)
MXC_DCD_ITEM(11, IOMUXC_BASE_ADDR + 0x4b8, 0x00000030)
MXC_DCD_ITEM(12, IOMUXC_BASE_ADDR + 0x76c, 0x00000030)

MXC_DCD_ITEM(13, IOMUXC_BASE_ADDR + 0x750, 0x00020000)

MXC_DCD_ITEM(14, IOMUXC_BASE_ADDR + 0x4bc, 0x00000030)
MXC_DCD_ITEM(15, IOMUXC_BASE_ADDR + 0x4c0, 0x00000030)
MXC_DCD_ITEM(16, IOMUXC_BASE_ADDR + 0x4c4, 0x00000030)
MXC_DCD_ITEM(17, IOMUXC_BASE_ADDR + 0x4c8, 0x00000030)

MXC_DCD_ITEM(18, IOMUXC_BASE_ADDR + 0x760, 0x00020000)

MXC_DCD_ITEM(19, IOMUXC_BASE_ADDR + 0x764, 0x00000030)
MXC_DCD_ITEM(20, IOMUXC_BASE_ADDR + 0x770, 0x00000030)
MXC_DCD_ITEM(21, IOMUXC_BASE_ADDR + 0x778, 0x00000030)
MXC_DCD_ITEM(22, IOMUXC_BASE_ADDR + 0x77c, 0x00000030)

MXC_DCD_ITEM(23, IOMUXC_BASE_ADDR + 0x470, 0x00000030)
MXC_DCD_ITEM(24, IOMUXC_BASE_ADDR + 0x474, 0x00000030)
MXC_DCD_ITEM(25, IOMUXC_BASE_ADDR + 0x478, 0x00000030)
MXC_DCD_ITEM(26, IOMUXC_BASE_ADDR + 0x47c, 0x00000030)

MXC_DCD_ITEM(27, MMDC_P0_BASE_ADDR + 0x800, 0xA1390003)

MXC_DCD_ITEM(28, MMDC_P0_BASE_ADDR + 0x80c, 0x001F001F)
MXC_DCD_ITEM(29, MMDC_P0_BASE_ADDR + 0x810, 0x001F001F)

MXC_DCD_ITEM(30, MMDC_P0_BASE_ADDR + 0x83c, 0x42190219)
MXC_DCD_ITEM(31, MMDC_P0_BASE_ADDR + 0x840, 0x017B0177)
MXC_DCD_ITEM(32, MMDC_P0_BASE_ADDR + 0x848, 0x4B4D4E4D)
MXC_DCD_ITEM(33, MMDC_P0_BASE_ADDR + 0x850, 0x3F3E2D36)

MXC_DCD_ITEM(34, MMDC_P0_BASE_ADDR + 0x81c, 0x33333333)
MXC_DCD_ITEM(35, MMDC_P0_BASE_ADDR + 0x820, 0x33333333)
MXC_DCD_ITEM(36, MMDC_P0_BASE_ADDR + 0x824, 0x33333333)
MXC_DCD_ITEM(37, MMDC_P0_BASE_ADDR + 0x828, 0x33333333)

MXC_DCD_ITEM(38, MMDC_P0_BASE_ADDR + 0x8b8, 0x00000800)

MXC_DCD_ITEM(39, MMDC_P0_BASE_ADDR + 0x004, 0x0002002D)
MXC_DCD_ITEM(40, MMDC_P0_BASE_ADDR + 0x008, 0x00333030)
MXC_DCD_ITEM(41, MMDC_P0_BASE_ADDR + 0x00c, 0x3F435313)
MXC_DCD_ITEM(42, MMDC_P0_BASE_ADDR + 0x010, 0xB66E8B63)
MXC_DCD_ITEM(43, MMDC_P0_BASE_ADDR + 0x014, 0x01FF00DB)
MXC_DCD_ITEM(44, MMDC_P0_BASE_ADDR + 0x018, 0x00001740)

MXC_DCD_ITEM(45, MMDC_P0_BASE_ADDR + 0x01c, 0x00008000)
MXC_DCD_ITEM(46, MMDC_P0_BASE_ADDR + 0x02c, 0x000026d2)

MXC_DCD_ITEM(47, MMDC_P0_BASE_ADDR + 0x030, 0x00431023)
MXC_DCD_ITEM(48, MMDC_P0_BASE_ADDR + 0x040, 0x00000017)

MXC_DCD_ITEM(49, MMDC_P0_BASE_ADDR + 0x000, 0x83190000)

MXC_DCD_ITEM(50, MMDC_P0_BASE_ADDR + 0x01c, 0x04008032)
MXC_DCD_ITEM(51, MMDC_P0_BASE_ADDR + 0x01c, 0x00008033)
MXC_DCD_ITEM(52, MMDC_P0_BASE_ADDR + 0x01c, 0x00048031)
MXC_DCD_ITEM(53, MMDC_P0_BASE_ADDR + 0x01c, 0x05208030)
MXC_DCD_ITEM(54, MMDC_P0_BASE_ADDR + 0x01c, 0x04008040)

MXC_DCD_ITEM(55, MMDC_P0_BASE_ADDR + 0x020, 0x00005800)
MXC_DCD_ITEM(56, MMDC_P0_BASE_ADDR + 0x818, 0x00011117)

MXC_DCD_ITEM(57, MMDC_P0_BASE_ADDR + 0x004, 0x0002556d)
MXC_DCD_ITEM(58, MMDC_P0_BASE_ADDR + 0x404, 0x00011006)

MXC_DCD_ITEM(59, MMDC_P0_BASE_ADDR + 0x01c, 0x00000000)

#endif
