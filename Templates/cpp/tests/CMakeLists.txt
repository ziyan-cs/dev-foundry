add_executable(${PROJECT_NAME}_tests test_smoke.cpp)

target_compile_features(${PROJECT_NAME}_tests PRIVATE cxx_std_20)

target_include_directories(${PROJECT_NAME}_tests
  PRIVATE
    ${PROJECT_SOURCE_DIR}/include
)

project_enable_warnings(${PROJECT_NAME}_tests)

add_test(NAME ${PROJECT_NAME}.smoke COMMAND ${PROJECT_NAME}_tests)
