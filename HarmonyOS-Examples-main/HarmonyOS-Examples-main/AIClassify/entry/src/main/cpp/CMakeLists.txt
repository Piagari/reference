# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(native_demo)

# 是否开启npu推理，默认是不开启, 如果需要开启，将下面的注释取消掉
# add_definitions(-DUSE_NNRT=1)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)
# set(CMAKE_C_STANDARD 11)

add_library(entry SHARED ms_lite.c)
target_link_libraries(entry PUBLIC mindspore_lite_ndk)
target_link_libraries(entry PUBLIC hilog_ndk.z)
# target_link_libraries(entry PUBLIC rawfile.z)
# target_link_libraries(entry PUBLIC ace_napi.z)