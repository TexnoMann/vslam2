cmake_minimum_required(VERSION 2.4.6)

project(vslam2)

IF (NOT CMAKE_BUILD_TYPE)
    SET(CMAKE_BUILD_TYPE Release)
ENDIF ()

add_definitions(-std=c++14)

LIST(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/ORB_SLAM3_ROS/cmake)

find_package(catkin REQUIRED COMPONENTS
        rosbag
        roscpp
        std_msgs
        cv_bridge
        image_transport
        tf
        tf2_geometry_msgs
        tf2_ros
        sensor_msgs
        message_generation)

find_package(OpenCV 4 REQUIRED)
if (NOT OpenCV_FOUND)
    message(FATAL_ERROR "OpenCV > 4.4 not found.")
endif ()

find_package(Eigen3 3.1.0 REQUIRED)
find_package(Sophus REQUIRED)

#find_package(Pangolin REQUIRED  PATHS /home/vuong/Code/local_lib) origin
find_package(Pangolin REQUIRED)

find_package(DBoW2 REQUIRED)
if (DBoW2_FOUND)
    MESSAGE("DBOW2 at: " ${dbow2_catkin_INCLUDE_DIRS})
    MESSAGE("DBOW2 Libs at: " ${dbow2_catkin_LIBRARIES})
endif ()

find_package(g2o REQUIRED)
if (g2o_FOUND)
    MESSAGE("g2o at: " ${g2o_INCLUDE_DIRS})
    MESSAGE("g2o Libs at: " ${g2o_LIBRARIES})
endif ()

find_package(TBB REQUIRED)
message(STATUS "Found TBB ${TBB_VERSION_MAJOR}.${TBB_VERSION_MINOR} (interface version ${TBB_INTERFACE_VERSION}) headers in: ${TBB_INCLUDE_DIRS}")
if (TBB_INTERFACE_VERSION LESS 11004)
    # enable global_control header for earlier TBB versions (Ubuntu 16.04, 18.04)
    add_definitions(-DTBB_PREVIEW_GLOBAL_CONTROL)
endif ()

set(TORCH_PATH "/home/wfram/GCNv2_SLAM/Thirdparty/pytorch/torch/share/cmake/Torch")
message("TORCH_PATH: " ${TORCH_PATH})

set(TORCH_CXX_FLAGS "-D_GLIBCXX_USE_CXX11_ABI=0")

if (TORCH_PATH)
    message("TORCH_PATH set to: ${TORCH_PATH}")
    set(Torch_DIR ${TORCH_PATH})
else ()
    message(FATAL_ERROR "Need to specify Torch path, e.g., pytorch/torch/share/cmake/Torch ")
endif ()

find_package(Torch REQUIRED)
message(STATUS "Torch version is: ${Torch_VERSION}")
if (Torch_VERSION GREATER 1.0.1)
    message(STATUS "Torch version is newer than v1.0.1, will use new api")
    add_definitions(-DTORCH_NEW_API)
endif ()

set(LIBS_ROS
        ${DBoW2_LIBRARY}
        ${g2o_LIBRARY}
        ${PROJECT_SOURCE_DIR}/ORB_SLAM3/lib/libORB_SLAM3.so
        ${OpenCV_LIBS}
        ${catkin_LIBRARIES}
        ${Sophus_LIBRARIES}
        -lboost_system
        -lcrypto
        ${Pangolin_LIBRARIES}
        ${TBB_LIBRARIES}
        ${TORCH_LIBRARIES}
        -lfmt
        )

catkin_package(
        CATKIN_DEPENDS roscpp rospy std_msgs cv_bridge image_transport tf sensor_msgs message_runtime
        LIBRARIES ${PROJECT_NAME}
)
add_library(${PROJECT_NAME} SHARED
        ORB_SLAM3_ROS/src/utils/Utils.cpp
        ORB_SLAM3_ROS/include/utils/Utils.h
        ORB_SLAM3_ROS/include/viewer.h
        ORB_SLAM3_ROS/src/viewer.cpp
        )
target_link_libraries(${PROJECT_NAME}
        ${LIBS_ROS}
        )
include_directories(
        ${Sophus_INCLUDE_DIRS}
        ${catkin_INCLUDE_DIRS}
        ${PROJECT_SOURCE_DIR}/ORB_SLAM3
        ${PROJECT_SOURCE_DIR}/ORB_SLAM3/include
        ${PROJECT_SOURCE_DIR}/ORB_SLAM3/include/CameraModels
        ${PROJECT_SOURCE_DIR}/ORB_SLAM3_ROS
        ${PROJECT_SOURCE_DIR}/ORB_SLAM3_ROS/include
        ${PROJECT_SOURCE_DIR}/ORB_SLAM3_ROS/include/Utils
        ${g2o_INCLUDE_DIR}
        ${DBoW2_INCLUDE_DIR}
        ${Pangolin_INCLUDE_DIRS}
        ${TBB_INCLUDE_DIR}
)

#add_executable(${PROJECT_NAME}_stereo_inertial
#        ORB_SLAM3_ROS/src/ros_stereo_inertial.cc
#        ORB_SLAM3_ROS/src/node.cpp ORB_SLAM3_ROS/include/node.h)
#
#target_link_libraries(${PROJECT_NAME}_stereo_inertial
#        ${LIBS_ROS}
#        ${PROJECT_NAME}
#        )
#add_executable(${PROJECT_NAME}_stereo_inertial_new
#        ORB_SLAM3_ROS/src/ros_stereo_inertial_new.cpp
#        ORB_SLAM3_ROS/src/node.cpp ORB_SLAM3_ROS/include/node.h)
#
#target_link_libraries(${PROJECT_NAME}_stereo_inertial_new
#        ${LIBS_ROS}
#        ${PROJECT_NAME}
#        )
add_executable(${PROJECT_NAME}_mono
        ORB_SLAM3_ROS/src/ros_mono.cpp
        ORB_SLAM3_ROS/src/node.cpp ORB_SLAM3_ROS/include/node.h)

target_link_libraries(${PROJECT_NAME}_mono
        ${LIBS_ROS}
        ${PROJECT_NAME}
        )
#add_executable(${PROJECT_NAME}_mono_old
#        ORB_SLAM3_ROS/src/ros_mono.cpp
#        ORB_SLAM3_ROS/src/node.cpp ORB_SLAM3_ROS/include/node.h)
#
#target_link_libraries(${PROJECT_NAME}_mono_old
#        ${LIBS_ROS}
#        ${PROJECT_NAME}
#        )
add_executable(${PROJECT_NAME}_mono_inertial
        ORB_SLAM3_ROS/src/ros_mono_inertial.cpp
        ORB_SLAM3_ROS/src/node.cpp ORB_SLAM3_ROS/include/node.h)

target_link_libraries(${PROJECT_NAME}_mono_inertial
        ${LIBS_ROS}
        ${PROJECT_NAME}
        )
#add_executable(${PROJECT_NAME}_stereo
#        ORB_SLAM3_ROS/src/ros_stereo.cc
#        ORB_SLAM3_ROS/src/node.cpp ORB_SLAM3_ROS/include/node.h)
#
#target_link_libraries(${PROJECT_NAME}_stereo
#        ${LIBS_ROS}
#        ${PROJECT_NAME}
#        )
# add_executable(${PROJECT_NAME}_stereo_offline
#         ORB_SLAM3_ROS/src/ros_stereo_offline.cc
#         ORB_SLAM3_ROS/src/node.cpp ORB_SLAM3_ROS/include/node.h)

# target_link_libraries(${PROJECT_NAME}_stereo_offline
#         ${LIBS_ROS}
#         ${PROJECT_NAME}
#         )
#add_executable(${PROJECT_NAME}_stereo_inertial_offline_new
#        ORB_SLAM3_ROS/src/ros_stereo_inertial_offline_new.cc
#        ORB_SLAM3_ROS/src/node.cpp ORB_SLAM3_ROS/include/node.h)
#
#target_link_libraries(${PROJECT_NAME}_stereo_inertial_offline_new
#        ${LIBS_ROS}
#        ${PROJECT_NAME}
#        )

#add_executable(${PROJECT_NAME}_mono_inertial_offline_new
#        ORB_SLAM3_ROS/src/ros_mono_inertial_offline_new.cc
#        ORB_SLAM3_ROS/src/node.cpp ORB_SLAM3_ROS/include/node.h)
#
#target_link_libraries(${PROJECT_NAME}_mono_inertial_offline_new
#        ${LIBS_ROS}
#        ${PROJECT_NAME}
#        )

add_executable(imu_rls ORB_SLAM3_ROS/src/imu_rls.cpp)
target_link_libraries(imu_rls ${catkin_LIBRARIES} ${EIGEN3_LIBS})

add_executable(imu_sliding_average ORB_SLAM3_ROS/src/imu_sliding_average.cpp)
target_link_libraries(imu_sliding_average ${catkin_LIBRARIES} ${EIGEN3_LIBS})
