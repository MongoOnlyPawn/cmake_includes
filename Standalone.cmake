include(${CMAKE_CURRENT_LIST_DIR}/StandardProjectSettings.cmake)

# Link this 'library' to set the c++ standard / compile-time options requested
add_library(project_options INTERFACE)
target_compile_features(project_options INTERFACE cxx_std_17)

set(CMAKE_CXX_STANDARD 17)

if(MSVC)
    # Force MSVC to conform to the standard
    # https://devblogs.microsoft.com/cppblog/msvc-now-correctly-reports-__cplusplus/
    add_compile_options(/Zc:__cplusplus)
endif()

if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
    option(
        ENABLE_BUILD_WITH_TIME_TRACE
        "Enable -ftime-trace to generate time tracing .json files on clang"
        OFF)

    if (ENABLE_BUILD_WITH_TIME_TRACE)
        add_compile_definitions(project_options INTERFACE -ftime-trace)
    endif()
endif()

option(BUILD_SHARED_LIBS "Enable compilation of shared libraries" OFF)
option(ENABLE_TESTING "Enable Test Builds" ON)
 
# Link this 'library' to use the warnings specified in CompilerWarnings.cmake
add_library(project_warnings INTERFACE)

# standard compiler warnings
include(${CMAKE_CURRENT_LIST_DIR}/CompilerWarnings.cmake)
set_project_warnings(project_warnings)

# sanitizer options if supported by compiler
include(${CMAKE_CURRENT_LIST_DIR}/Sanitizers.cmake)
enable_sanitizers(project_options)

# enable doxygen
include(${CMAKE_CURRENT_LIST_DIR}/Doxygen.cmake)
enable_doxygen()

# allow for static analysis options
include(${CMAKE_CURRENT_LIST_DIR}/StaticAnalyzers.cmake)

include(${CMAKE_CURRENT_LIST_DIR}/Conan.cmake)
run_conan()

option(ENABLE_PCH "Enable Precompiled Headers" OFF)
if(ENABLE_PCH)
    # This sets a global PCH parameter, each project will build its own PCH,
    # which is a good idea if any #define's change
    # consider breaking this out per project as necessary 
    target_precompile_headers(
        project_options
        INTERFACE
        <vector>
        <string>
        <map>
        <utility>)
endif()

option(RECURSIVE_BUILD_TESTS "Build tests of all subprojects" OFF)
