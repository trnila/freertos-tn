#pragma once

#include <stdint.h>
#include "rpmsg_lite.h"

struct __attribute__((packed)) fw_rsc_vdev_vring {
  uint32_t da;
  uint32_t align;
  uint32_t num;
  uint32_t notifyid;
  uint32_t reserved;
};

struct __attribute__((packed)) fw_rsc_vdev {
  uint32_t type;
  uint32_t id;
  uint32_t notifyid;
  uint32_t dfeatures;
  uint32_t gfeatures;
  uint32_t config_len;
  uint8_t status;
  uint8_t num_of_vrings;
  uint8_t reserved[2];
  struct fw_rsc_vdev_vring vring[0];
};


/* Resource table for the given remote */
struct remote_resource_table {
  unsigned int version;
  unsigned int num;
  unsigned int reserved[2];
  unsigned int offset[1 /* max number of resources */];
  /* rpmsg vdev entry */
  struct fw_rsc_vdev rpmsg_vdev;
  struct fw_rsc_vdev_vring rpmsg_vring0;
  struct fw_rsc_vdev_vring rpmsg_vring1;
} __attribute__((packed));

enum fw_resource_type {
  RSC_CARVEOUT = 0,
  RSC_DEVMEM = 1,
  RSC_TRACE = 2,
  RSC_VDEV = 3,
  RSC_LAST = 4,
  RSC_VENDOR_START = 128,
  RSC_VENDOR_END = 512,
};

struct remote_resource_table __attribute__((section(".resource_table"))) resources = {
  /* Version */
  1,
  /* Number of table entries */
  1,
  /* reserved fields */
  {0, 0,},

  /* Offsets of rsc entries */
  {
    offsetof(struct remote_resource_table, rpmsg_vdev),
  },

  /* Virtio device entry */
  {
    RSC_VDEV, 7 /* id rpmsg*/, 0, 1 /* features */, 0, 0, 0,
    2 /* two vrings - rx + tx */, {0, 0},
  },

  /* Vring rsc entry - part of vdev rsc entry */
  /* currently linux doesnt support allocating vrings on defined addresses */ 
  {0xFFFFFFFFUL /* tx - any address */, 0x1000 /* align */, 256 /* descriptors */, 1, 0},
  {0xFFFFFFFFUL /* rx - any address */, 0x1000 /* align */, 256 /* descriptors */, 2, 0},
};

struct rpmsg_lite_instance* create_rpmsg_from_resources() {
  struct rpmsg_lite_instance *rpmsg = rpmsg_lite_remote_init2(
      (void*) resources.rpmsg_vring0.da,
      (void*) resources.rpmsg_vring1.da,
      resources.rpmsg_vring0.align,
      resources.rpmsg_vring0.num,
      RPMSG_LITE_LINK_ID,
      RL_NO_FLAGS
      );
  rpmsg->link_state = 1;

  return rpmsg;
}

#if defined __cplusplus
}
#endif
