# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "")
  file(REMOVE_RECURSE
  "/home/dllab/Desktop/trustcore_vivado/vitis/platform/psu_cortexa53_0/crypto_test/bsp/include/sleep.h"
  "/home/dllab/Desktop/trustcore_vivado/vitis/platform/psu_cortexa53_0/crypto_test/bsp/include/xiltimer.h"
  "/home/dllab/Desktop/trustcore_vivado/vitis/platform/psu_cortexa53_0/crypto_test/bsp/include/xtimer_config.h"
  "/home/dllab/Desktop/trustcore_vivado/vitis/platform/psu_cortexa53_0/crypto_test/bsp/lib/libxiltimer.a"
  )
endif()
