find_package(M4SDK REQUIRED)
find_package(FreeRTOS REQUIRED)
find_package(rpmsg REQUIRED)

add_custom_command(
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/ros_lib/time.cpp
  COMMAND rosrun rosserial_rpmsg make_libraries.py ${CMAKE_CURRENT_BINARY_DIR}/
)

add_custom_target(generate_roslib 
	COMMAND rm -f ${CMAKE_CURRENT_BINARY_DIR}/ros_lib/time.cpp
	DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/ros_lib/time.cpp
)

add_library(rosserial_rpmsg ${CMAKE_CURRENT_BINARY_DIR}/ros_lib/time.cpp)
target_include_directories(rosserial_rpmsg PUBLIC ${CMAKE_CURRENT_BINARY_DIR}/ros_lib)
target_link_libraries(rosserial_rpmsg mcuxpressosdk freertos rpmsg_lite)
