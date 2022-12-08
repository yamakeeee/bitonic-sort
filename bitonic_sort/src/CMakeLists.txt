cmake_minimum_required(VERSION 2.8)
project(MyCudaProject CXX)

# For CUDA
find_package(CUDA REQUIRED)
if(CUDA_FOUND)
    message("Cuda version: " ${CUDA_VERSION})
    CUDA_ADD_EXECUTABLE(main
        main.cu
    )
endif()

target_link_libraries(main time_measure)
