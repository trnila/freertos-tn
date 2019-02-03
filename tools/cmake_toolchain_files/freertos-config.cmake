set(COMMON_FLAGS "${COMMON_FLAGS} -DFSL_RTOS_FREE_RTOS")

add_library(freertos
  "${M4SDK_PATH}/rtos/freertos/Source/include/croutine.h"
  "${M4SDK_PATH}/rtos/freertos/Source/include/event_groups.h"
  "${M4SDK_PATH}/rtos/freertos/Source/include/FreeRTOS.h"
  "${M4SDK_PATH}/rtos/freertos/Source/include/list.h"
  "${M4SDK_PATH}/rtos/freertos/Source/include/mpu_wrappers.h"
  "${M4SDK_PATH}/rtos/freertos/Source/include/portable.h"
  "${M4SDK_PATH}/rtos/freertos/Source/include/projdefs.h"
  "${M4SDK_PATH}/rtos/freertos/Source/include/queue.h"
  "${M4SDK_PATH}/rtos/freertos/Source/include/semphr.h"
  "${M4SDK_PATH}/rtos/freertos/Source/include/StackMacros.h"
  "${M4SDK_PATH}/rtos/freertos/Source/include/stdint.readme"
  "${M4SDK_PATH}/rtos/freertos/Source/include/task.h"
  "${M4SDK_PATH}/rtos/freertos/Source/include/timers.h"
  "${M4SDK_PATH}/rtos/freertos/Source/include/deprecated_definitions.h"
  "${M4SDK_PATH}/rtos/freertos/Source/include/freertos_tasks_c_additions.h"
  "${M4SDK_PATH}/rtos/freertos/Source/croutine.c"
  "${M4SDK_PATH}/rtos/freertos/Source/list.c"
  "${M4SDK_PATH}/rtos/freertos/Source/queue.c"
  "${M4SDK_PATH}/rtos/freertos/Source/readme.txt"
  "${M4SDK_PATH}/rtos/freertos/Source/tasks.c"
  "${M4SDK_PATH}/rtos/freertos/Source/timers.c"
  "${M4SDK_PATH}/rtos/freertos/Source/event_groups.c"
  "${M4SDK_PATH}/rtos/freertos/Source/portable/readme.txt"
  "${M4SDK_PATH}/rtos/freertos/Source/portable/GCC/ARM_CM4F/fsl_tickless_generic.h"
  "${M4SDK_PATH}/rtos/freertos/Source/portable/GCC/ARM_CM4F/fsl_tickless_systick.c"
  "${M4SDK_PATH}/rtos/freertos/Source/portable/GCC/ARM_CM4F/port.c"
  "${M4SDK_PATH}/rtos/freertos/Source/portable/GCC/ARM_CM4F/portmacro.h"
  "${M4SDK_PATH}/rtos/freertos/Source/portable/MemMang/heap_4.c"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_i2c_freertos.h"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_i2c_freertos.c"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_ecspi_freertos.h"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_ecspi_freertos.c"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_uart_freertos.h"
  "${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_uart_freertos.c"
)

target_include_directories(freertos
  PUBLIC
    ${M4SDK_PATH}/boards/pico-8m-m4/skel/
    ${M4SDK_PATH}/rtos/freertos/Source/portable/GCC/ARM_CM4F
    ${M4SDK_PATH}/rtos/freertos/Source/include
)

target_link_libraries(freertos mcuxpressosdk)
