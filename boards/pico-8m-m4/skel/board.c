/*
 * The Clear BSD License
 * Copyright 2017 NXP
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted (subject to the limitations in the disclaimer below) provided
 * that the following conditions are met:
 *
 * o Redistributions of source code must retain the above copyright notice, this list
 *   of conditions and the following disclaimer.
 *
 * o Redistributions in binary form must reproduce the above copyright notice, this
 *   list of conditions and the following disclaimer in the documentation and/or
 *   other materials provided with the distribution.
 *
 * o Neither the name of the copyright holder nor the names of its
 *   contributors may be used to endorse or promote products derived from this
 *   software without specific prior written permission.
 *
 * NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE GRANTED BY THIS LICENSE.
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

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
    CLOCK_EnableClock(kCLOCK_Uart3);
    DbgConsole_Init(BOARD_DEBUG_UART_BASEADDR, BOARD_DEBUG_UART_BAUDRATE, DEBUG_CONSOLE_DEVICE_TYPE_IUART, uartClkSrcFreq);

}
/* Initialize MPU, configure non-cacheable memory */
void BOARD_InitMemory(void)
{

    extern uint32_t __CACHE_REGION_START[];
    extern uint32_t __CACHE_REGION_SIZE[];
    uint32_t cacheStart = (uint32_t)__CACHE_REGION_START;
    uint32_t size = (uint32_t)__CACHE_REGION_SIZE;
    uint32_t i = 0;
    /* Make sure outstanding transfers are done. */
    __DMB();
    /* Disable the MPU. */
    MPU->CTRL = 0;

    /* configure full access to TCMU + peripherals, etc ~512M - 2^29 */
    MPU->RBAR = (0x20000000U & MPU_RBAR_ADDR_Msk) | MPU_RBAR_VALID_Msk | (0 << MPU_RBAR_REGION_Pos);
    MPU->RASR = (0x3 << MPU_RASR_AP_Pos) | (28 << MPU_RASR_SIZE_Pos) | MPU_RASR_ENABLE_Msk;

    /* configure full aceess to code TCML (128 kbytes - 2^17) */
    MPU->RBAR = (0x1FFF0000U & MPU_RBAR_ADDR_Msk) | MPU_RBAR_VALID_Msk | (1 << MPU_RBAR_REGION_Pos);
    MPU->RASR = (0x3 << MPU_RASR_AP_Pos) | (16 << MPU_RASR_SIZE_Pos) | MPU_RASR_ENABLE_Msk;

    /* configure access to rpmsg in DDR (1 MB - 2^20) */
    MPU->RBAR = (0xB8000000 & MPU_RBAR_ADDR_Msk) | MPU_RBAR_VALID_Msk | (2 << MPU_RBAR_REGION_Pos);
    MPU->RASR = (0x3 << MPU_RASR_AP_Pos) | (19 << MPU_RASR_SIZE_Pos) | MPU_RASR_ENABLE_Msk;

    /* enable MemManage handlers */
    SCB->SHCSR |= SCB_SHCSR_MEMFAULTENA_Msk;
    /* enable mpu */
    MPU->CTRL = MPU_CTRL_ENABLE_Msk;

    /* Memory barriers to ensure subsequence data & instruction
    * transfers using updated MPU settings.
    */
    __DSB();
    __ISB();
}

void BOARD_RdcInit(void)
{
    /* This function would configure M4 core run at domain 1 and enable the PLL clock sources used to domain 1.*/
    /* Move M4 core to specific RDC domain 1 */
    rdc_domain_assignment_t assignment = {0};
    
    assignment.domainId = BOARD_DOMAIN_ID;
    RDC_SetMasterDomainAssignment(RDC, kRDC_Master_M4,&assignment);
    /*
       The M4 core is running at domain 1, now enable the PLL clock sources to domain 1
    */
    CLOCK_ControlGate(kCLOCK_SysPll1Gate,kCLOCK_ClockNeededAll); /* Enabel SysPLL1 to Domain 1 */
    CLOCK_ControlGate(kCLOCK_SysPll2Gate,kCLOCK_ClockNeededAll); /* Enable SysPLL2 to Domain 1 */
    CLOCK_ControlGate(kCLOCK_SysPll3Gate,kCLOCK_ClockNeededAll); /* Enable SysPLL3 to Domain 1 */
    CLOCK_ControlGate(kCLOCK_AudioPll1Gate,kCLOCK_ClockNeededAll); /* Enable AudioPLL1 to Domain 1 */
    CLOCK_ControlGate(kCLOCK_AudioPll2Gate,kCLOCK_ClockNeededAll); /* Enable AudioPLL2 to Domain 1 */
    CLOCK_ControlGate(kCLOCK_VideoPll1Gate,kCLOCK_ClockNeededAll); /* Enable VideoPLL1 to Domain 1 */
    CLOCK_ControlGate(kCLOCK_SysPll1Div3Gate,kCLOCK_ClockNeededAll); /* Enable SysPLL1Div3 to Domain 1 */
    CLOCK_ControlGate(kCLOCK_SysPll1Div6Gate,kCLOCK_ClockNeededAll); /* Enable SysPLL1Div6 to Domain 1 */

}

__attribute__((weak)) void HardFault_Handler(void) {
    printf("hard fault\r\n");
    for(;;);
}


__attribute__((weak)) void MemManage_Handler(void) {
    // [0] - fetch from non-executable location
    // [1] - load/store from non-accessible location
    uint32_t cfsr    = SCB->CFSR;

    uint32_t mmfar = SCB->MMFAR; // address of location that generated memmanage fault
    uint32_t bfar    = SCB->BFAR;    // address of location that generated busfault

    printf("MemManage fault\r\n");
    printf("cfsr = %x\r\n", cfsr);
    printf("mmfar = %x\r\n", mmfar);
    printf("bfar = %x\r\n", bfar);
    for(;;);
}
