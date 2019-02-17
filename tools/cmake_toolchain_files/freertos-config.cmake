set(COMMON_FLAGS "${COMMON_FLAGS} -DFSL_RTOS_FREE_RTOS")

add_library(freertos
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/FreeRTOS/list.c"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/FreeRTOS/timers.c"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/FreeRTOS/queue.c"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/FreeRTOS/stream_buffer.c"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/FreeRTOS/event_groups.c"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/FreeRTOS/portable/MemMang/heap_4.c"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/FreeRTOS/portable/GCC/ARM_CM4F/portmacro.h"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/FreeRTOS/portable/GCC/ARM_CM4F/fsl_tickless_systick.c"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/FreeRTOS/portable/GCC/ARM_CM4F/port.c"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/FreeRTOS/tasks.c"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/include/message_buffer.h"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/include/task.h"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/include/private/list.h"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/include/private/deprecated_definitions.h"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/include/private/portable.h"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/include/private/projdefs.h"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/include/private/mpu_wrappers.h"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/include/private/stack_macros.h"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/include/event_groups.h"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/include/FreeRTOS.h"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/include/timers.h"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/include/freertos_tasks_c_additions.h"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/include/semphr.h"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/include/stream_buffer.h"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/include/queue.h"

	"${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_i2c_freertos.h"
	"${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_i2c_freertos.c"
	"${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_ecspi_freertos.h"
	"${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_ecspi_freertos.c"
	"${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_uart_freertos.h"
	"${M4SDK_PATH}/devices/MIMX8MQ6/drivers/fsl_uart_freertos.c"
	)

target_include_directories(freertos
	PUBLIC
	"${M4SDK_PATH}/boards/pico-8m-m4/skel/"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/include/"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/FreeRTOS/portable/GCC/ARM_CM4F/"
	"${M4SDK_PATH}/rtos/amazon-freertos/lib/include/private/"
)

target_link_libraries(freertos mcuxpressosdk)
