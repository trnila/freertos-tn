enable_language(ASM)

set(M4SDK_PATH "$ENV{M4SDK_PATH}")

set(COMMON_FLAGS "${COMMON_FLAGS} -DDEBUG")
set(COMMON_FLAGS "${COMMON_FLAGS} -D__STARTUP_CLEAR_BSS")
set(COMMON_FLAGS "${COMMON_FLAGS} -D__STARTUP_INITIALIZE_NONCACHEDATA")
set(COMMON_FLAGS "${COMMON_FLAGS} -g")
set(COMMON_FLAGS "${COMMON_FLAGS} -Wall")
set(COMMON_FLAGS "${COMMON_FLAGS} -fno-common")
set(COMMON_FLAGS "${COMMON_FLAGS} -ffunction-sections")
set(COMMON_FLAGS "${COMMON_FLAGS} -fdata-sections")
set(COMMON_FLAGS "${COMMON_FLAGS} -ffreestanding")
set(COMMON_FLAGS "${COMMON_FLAGS} -fno-builtin")
set(COMMON_FLAGS "${COMMON_FLAGS} -mthumb")
set(COMMON_FLAGS "${COMMON_FLAGS} -mapcs")
set(COMMON_FLAGS "${COMMON_FLAGS} -std=gnu99")
set(COMMON_FLAGS "${COMMON_FLAGS} -mcpu=cortex-m4")
set(COMMON_FLAGS "${COMMON_FLAGS} -mfloat-abi=hard")
set(COMMON_FLAGS "${COMMON_FLAGS} -mfpu=fpv4-sp-d16")
set(COMMON_FLAGS "${COMMON_FLAGS} -DCPU_MIMX8MQ6DVAJZ")
set(COMMON_FLAGS "${COMMON_FLAGS} -O0")
set(COMMON_FLAGS "${COMMON_FLAGS} -Os")
set(COMMON_FLAGS "${COMMON_FLAGS} -MMD")
set(COMMON_FLAGS "${COMMON_FLAGS} -MP")

set(CMAKE_ASM_FLAGS "${COMMON_FLAGS}")
set(CMAKE_C_FLAGS "${COMMON_FLAGS}")
set(CMAKE_CXX_FLAGS "${COMMON_FLAGS} -fno-rtti -fno-exceptions --specs=nosys.specs")
set(CMAKE_EXE_LINKER_FLAGS "${COMMON_FLAGS} --specs=nano.specs --specs=nosys.specs -Xlinker --gc-sections -Xlinker -static -Xlinker -z -Xlinker muldefs")

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS_DEBUG} -T${M4SDK_PATH}/template/MIMX8MQ6xxxJZ_cm4_ram.ld -static")

function(add_firmware target)
  add_executable(${ARGV})
  add_custom_command(TARGET ${target} POST_BUILD COMMAND ${CMAKE_OBJCOPY} -Obinary ${EXECUTABLE_OUTPUT_PATH}/${target} ${EXECUTABLE_OUTPUT_PATH}/${target}.bin)
  add_custom_command(TARGET ${target} POST_BUILD COMMAND ${CMAKE_SIZE_UTIL}  ${EXECUTABLE_OUTPUT_PATH}/${target})
endfunction()

add_library(mcuxpressosdk  
  "${M4SDK_PATH}/template/fsl_iomuxc.h"
  "${M4SDK_PATH}/template/pin_mux.h"
  "${M4SDK_PATH}/template/board.c"
  "${M4SDK_PATH}/template/board.h"
  "${M4SDK_PATH}/template/clock_config.c"
  "${M4SDK_PATH}/template/clock_config.h"
  "${M4SDK_PATH}/template/rpmsg_config.h"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_clock.h"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_clock.c"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_common.h"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_common.c"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_rdc.h"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_rdc.c"
  "${M4SDK_PATH}/devices/MIMX8MQ6/utilities/str/fsl_str.c"
  "${M4SDK_PATH}/devices/MIMX8MQ6/utilities/str/fsl_str.h"
  "${M4SDK_PATH}/devices/MIMX8MQ6/utilities/debug_console/fsl_debug_console.c"
  "${M4SDK_PATH}/devices/MIMX8MQ6/utilities/debug_console/fsl_debug_console.h"
  "${M4SDK_PATH}/devices/MIMX8MQ6/utilities/debug_console/fsl_debug_console_conf.h"
  "${M4SDK_PATH}/components/uart/uart.h"
  "${M4SDK_PATH}/components/uart/iuart_adapter.c"
  "${M4SDK_PATH}/components/serial_manager/serial_manager.h"
  "${M4SDK_PATH}/components/serial_manager/serial_manager.c"
  "${M4SDK_PATH}/components/serial_manager/serial_port_uart.h"
  "${M4SDK_PATH}/components/serial_manager/serial_port_uart.c"
  "${M4SDK_PATH}/devices/MIMX8MQ6/system_MIMX8MQ6_cm4.c"
  "${M4SDK_PATH}/devices/MIMX8MQ6/system_MIMX8MQ6_cm4.h"
  "${M4SDK_PATH}/devices/MIMX8MQ6/gcc/startup_MIMX8MQ6_cm4.S"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_uart.h"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_uart.c"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_ecspi.h"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_ecspi.c"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_gpio.h"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_gpio.c"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_gpt.h"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_gpt.c"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_pwm.h"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_pwm.c"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_i2c.h"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_i2c.c"
  "${M4SDK_PATH}/devices/MIMX8MQ6/utilities/fsl_assert.c"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_mu.h"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_mu.c"
)
target_link_libraries(mcuxpressosdk INTERFACE c gcc nosys m)
target_include_directories(mcuxpressosdk
  PUBLIC
    ${M4SDK_PATH}/CMSIS/Include
    ${M4SDK_PATH}/devices
    ${M4SDK_PATH}/devices/MIMX8MQ6/drivers
    ${M4SDK_PATH}/devices/MIMX8MQ6
    ${M4SDK_PATH}/devices/MIMX8MQ6/utilities/io
    ${M4SDK_PATH}/devices/MIMX8MQ6/utilities/str
    ${M4SDK_PATH}/devices/MIMX8MQ6/utilities/log
    ${M4SDK_PATH}/devices/MIMX8MQ6/utilities/debug_console
    ${M4SDK_PATH}/devices/MIMX8MQ6/utilities
    ${M4SDK_PATH}/components/serial_manager
    ${M4SDK_PATH}/components/uart
    ${M4SDK_PATH}/template/
)
