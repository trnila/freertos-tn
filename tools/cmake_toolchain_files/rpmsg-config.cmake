add_library(rpmsg_lite
  "${M4SDK_PATH}/middleware/multicore/rpmsg_lite/lib/include/platform/imx8mq_m4/rpmsg_platform.h"
  "${M4SDK_PATH}/middleware/multicore/rpmsg_lite/lib/rpmsg_lite/porting/platform/imx8mq_m4/rpmsg_platform.c"
  "${M4SDK_PATH}/middleware/multicore/rpmsg_lite/lib/rpmsg_lite/porting/environment/rpmsg_env_freertos.c"
  "${M4SDK_PATH}/middleware/multicore/rpmsg_lite/lib/include/rpmsg_env.h"
  "${M4SDK_PATH}/middleware/multicore/rpmsg_lite/lib/include/rpmsg_queue.h"
  "${M4SDK_PATH}/middleware/multicore/rpmsg_lite/lib/rpmsg_lite/rpmsg_queue.c"
  "${M4SDK_PATH}/middleware/multicore/rpmsg_lite/lib/include/rpmsg_lite.h"
  "${M4SDK_PATH}/middleware/multicore/rpmsg_lite/lib/include/rpmsg_ns.h"
  "${M4SDK_PATH}/middleware/multicore/rpmsg_lite/lib/include/llist.h"
  "${M4SDK_PATH}/middleware/multicore/rpmsg_lite/lib/include/rpmsg_default_config.h"
  "${M4SDK_PATH}/middleware/multicore/rpmsg_lite/lib/include/virtio_ring.h"
  "${M4SDK_PATH}/middleware/multicore/rpmsg_lite/lib/include/virtqueue.h"
  "${M4SDK_PATH}/middleware/multicore/rpmsg_lite/lib/include/rpmsg_compiler.h"
  "${M4SDK_PATH}/middleware/multicore/rpmsg_lite/lib/common/llist.c"
  "${M4SDK_PATH}/middleware/multicore/rpmsg_lite/lib/rpmsg_lite/rpmsg_lite.c"
  "${M4SDK_PATH}/middleware/multicore/rpmsg_lite/lib/rpmsg_lite/rpmsg_ns.c"
  "${M4SDK_PATH}/middleware/multicore/rpmsg_lite/lib/virtio/virtqueue.c"
)

target_include_directories(rpmsg_lite
  PUBLIC
    ${M4SDK_PATH}/middleware/multicore/rpmsg_lite/lib/include
    ${M4SDK_PATH}/middleware/multicore/rpmsg_lite/lib/include/platform/imx8mq_m4
)

target_link_libraries(rpmsg_lite mcuxpressosdk freertos)
