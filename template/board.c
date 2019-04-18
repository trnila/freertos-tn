/*
 * Copyright 2017-2018 NXP
 * All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include <stdio.h>
#include "fsl_common.h"
#include "fsl_debug_console.h"
#include "board.h"
#include "fsl_rdc.h"
#include "fsl_iomuxc.h"
#include "pin_mux.h"
#include "fsl_clock.h"
/*******************************************************************************
 * Variables
 ******************************************************************************/

/*******************************************************************************
 * Code
 ******************************************************************************/
/* Initialize debug console. */
void BOARD_InitDebugConsole(void)
{
	uint32_t uartClkSrcFreq = BOARD_DEBUG_UART_CLK_FREQ;

	CLOCK_SetRootMux(kCLOCK_RootUart3, kCLOCK_UartRootmuxSysPll1Div10); /* Set UART source to SysPLL1 Div10 80MHZ */
	CLOCK_SetRootDivider(kCLOCK_RootUart3, 1U, 1U);                  /* Set root clock to 80MHZ/ 1= 80MHZ */   
	CLOCK_EnableClock(kCLOCK_Uart3);

	DbgConsole_Init(BOARD_DEBUG_UART_INSTANCE, BOARD_DEBUG_UART_BAUDRATE, DEBUG_CONSOLE_DEVICE_TYPE_UART, uartClkSrcFreq);

	IOMUXC_SetPinMux(IOMUXC_UART3_RXD_UART3_RX, 0U);
	IOMUXC_SetPinConfig(IOMUXC_UART3_RXD_UART3_RX,
			IOMUXC_SW_PAD_CTL_PAD_DSE(6U) |
			IOMUXC_SW_PAD_CTL_PAD_SRE(1U) |
			IOMUXC_SW_PAD_CTL_PAD_PUE_MASK);
	IOMUXC_SetPinMux(IOMUXC_UART3_TXD_UART3_TX, 0U);
	IOMUXC_SetPinConfig(IOMUXC_UART3_TXD_UART3_TX,
			IOMUXC_SW_PAD_CTL_PAD_DSE(6U) |
			IOMUXC_SW_PAD_CTL_PAD_SRE(1U) |
			IOMUXC_SW_PAD_CTL_PAD_PUE_MASK);
}

/* Initialize MPU, configure non-cacheable memory */
void BOARD_InitMemory(void)
{
	/* Make sure outstanding transfers are done. */
	__DMB();
	/* Disable the MPU. */
	MPU->CTRL = 0;

	/* configure full access to TCMU (128 kbytes)- 2^17 */
	MPU->RBAR = (0x20000000U & MPU_RBAR_ADDR_Msk) | MPU_RBAR_VALID_Msk | (0 << MPU_RBAR_REGION_Pos);
	MPU->RASR = MPU_RASR_ENABLE_Msk
		| (0x3 << MPU_RASR_AP_Pos)
		| (1 << MPU_RASR_TEX_Pos)
		| (1 << MPU_RASR_XN_Pos) // not executable
		|(ARM_MPU_REGION_SIZE_128KB << MPU_RASR_SIZE_Pos);

	/* configure full aceess to code TCML (128 kbytes - 2^17) */
	MPU->RBAR = (0x1FFF0000U & MPU_RBAR_ADDR_Msk) | MPU_RBAR_VALID_Msk | (1 << MPU_RBAR_REGION_Pos);
	MPU->RASR = MPU_RASR_ENABLE_Msk
		| (0x3 << MPU_RASR_AP_Pos)
		| (1 << MPU_RASR_TEX_Pos)
		| (ARM_MPU_REGION_SIZE_128KB << MPU_RASR_SIZE_Pos);

	/* configure full access to peripherals 16 MB (last 4 MB is reserved) - 2^24 */
	MPU->RBAR = (0x30000000U & MPU_RBAR_ADDR_Msk) | MPU_RBAR_VALID_Msk | (2 << MPU_RBAR_REGION_Pos);
	MPU->RASR = MPU_RASR_ENABLE_Msk
		| (0x3 << MPU_RASR_AP_Pos)
		| (1 << MPU_RASR_XN_Pos) // not executable
		| (ARM_MPU_REGION_SIZE_16MB << MPU_RASR_SIZE_Pos);

	/* configure access to rpmsg in DDR (1 MB - 2^20) */
	MPU->RBAR = (0xB8000000 & MPU_RBAR_ADDR_Msk) | MPU_RBAR_VALID_Msk | (3 << MPU_RBAR_REGION_Pos);
	MPU->RASR = MPU_RASR_ENABLE_Msk
		| (0x3 << MPU_RASR_AP_Pos)
		| (1 << MPU_RASR_XN_Pos) // not executable
		| (1 << MPU_RASR_S_Pos) // shareable with linux cores
		| (ARM_MPU_REGION_SIZE_1MB << MPU_RASR_SIZE_Pos);


	/* enable MemManage handlers */
	SCB->SHCSR |= SCB_SHCSR_MEMFAULTENA_Msk;
	/* enable mpu and enable MPU for privileged mode also */
	MPU->CTRL = MPU_CTRL_ENABLE_Msk;

	/* Memory barriers to ensure subsequence data & instruction
	 * transfers using updated MPU settings.
	 */
	__DSB();
	__ISB();
}

void BOARD_RdcInit(void)
{
	/* Move M4 core to specific RDC domain 1 */
	rdc_domain_assignment_t assignment = {0};

	assignment.domainId = BOARD_DOMAIN_ID;
	RDC_SetMasterDomainAssignment(RDC, kRDC_Master_M4, &assignment);
	/*
	 *  The M4 core is running at domain 1, enable clock gate for Iomux to run at domain 1.
	 */
	CLOCK_EnableClock(kCLOCK_Iomux0);
	CLOCK_EnableClock(kCLOCK_Iomux1);
	CLOCK_EnableClock(kCLOCK_Iomux2);
	CLOCK_EnableClock(kCLOCK_Iomux3);
	CLOCK_EnableClock(kCLOCK_Iomux4);
	/*
	 *  The M4 core is running at domain 1, enable the PLL clock sources to domain 1.
	 */
	CLOCK_ControlGate(kCLOCK_SysPll1Gate, kCLOCK_ClockNeededAll);   /* Enabel SysPLL1 to Domain 1 */
	CLOCK_ControlGate(kCLOCK_SysPll2Gate, kCLOCK_ClockNeededAll);   /* Enable SysPLL2 to Domain 1 */
	CLOCK_ControlGate(kCLOCK_SysPll3Gate, kCLOCK_ClockNeededAll);   /* Enable SysPLL3 to Domain 1 */
	CLOCK_ControlGate(kCLOCK_AudioPll1Gate, kCLOCK_ClockNeededAll); /* Enable AudioPLL1 to Domain 1 */
	CLOCK_ControlGate(kCLOCK_AudioPll2Gate, kCLOCK_ClockNeededAll); /* Enable AudioPLL2 to Domain 1 */
	CLOCK_ControlGate(kCLOCK_VideoPll1Gate, kCLOCK_ClockNeededAll); /* Enable VideoPLL1 to Domain 1 */
}

__attribute__((weak)) void HardFault_Handler(void) {
	printf("hard fault\r\n");
	for(;;);
}

__attribute__((weak)) void MemManage_Handler(void) {
	asm(
			"tst lr, #0b0100\n"
			"ite eq\n"
			"mrseq r0, msp\n"
			"mrsne r0, psp\n"
			"b handle_memmanage"
	);
}

void handle_memmanage(uint32_t* regs) {
	// [0] - fetch from non-executable location
	// [1] - load/store from non-accessible location
	uint32_t cfsr    = SCB->CFSR;

	uint32_t mmfar = SCB->MMFAR; // address of location that generated memmanage fault
	uint32_t bfar    = SCB->BFAR;    // address of location that generated busfault

	printf("\r\nMemManage fault\r\n");
	printf("cfsr  = %8lx ", cfsr);
	printf("mmfar = %8lx ", mmfar);
	printf(" bfar = %8lx\r\n", bfar);
	printf("   pc = %8lx ", regs[6]);
	printf("   sp = %8lx ", regs[8]);
	printf("   lr = %8lx\r\n", regs[5]);
	printf("   r0 = %8lx ", regs[0]);
	printf("   r1 = %8lx ", regs[1]);
	printf("   r2 = %8lx ", regs[2]);
	printf("r3 = %8lx ", regs[3]);
	printf("r12 = %8lx\r\n", regs[4]);
	for(;;);
}
