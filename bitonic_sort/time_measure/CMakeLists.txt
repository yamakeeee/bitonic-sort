add_library(time_measure SHARED time_measure.cpp)

target_include_directories(
    time_measure
    PUBLIC ${PROJECT_SOURCE_DIR}/include
)
