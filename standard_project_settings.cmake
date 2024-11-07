set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD 20)

if (NOT MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -ftemplate-backtrace-limit=0")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fmessage-length=120")
endif ()

# Link this 'library' to set the c++ standard / compile-time options
# requested
add_library(project_options INTERFACE)
# target_compile_features(project_options INTERFACE cxx_std_20)

# Link this 'library' to use the warnings specified in
# set_compiler_warnings.cmake
add_library(project_warnings INTERFACE)

# standard compiler warnings
include(${CMAKE_CURRENT_LIST_DIR}/set_compiler_warnings.cmake)
set_compiler_warnings(project_warnings)

# sanitizer options if supported by compiler
include(${CMAKE_CURRENT_LIST_DIR}/enable_sanitizers.cmake)
enable_sanitizers(project_options)

# allow for static analysis options
include(${CMAKE_CURRENT_LIST_DIR}/static_analyzers.cmake)

if (ENABLE_PCH)
    # This sets a global PCH parameter, each project will build its own PCH,
    # which is a good idea if any #define's change consider breaking this out
    # per project as necessary
    target_precompile_headers(
        project_options
        INTERFACE
        <vector>
        <string>
        <map>
        <utility>)
endif ()

# Set a default build type if none was specified
if (NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    message(
        STATUS "Setting build type to 'RelWithDebInfo' as none was specified.")
    set(CMAKE_BUILD_TYPE
        RelWithDebInfo
        CACHE STRING "Choose the type of build." FORCE)
endif ()

if (NOT CMAKE_CONFIGURATION_TYPES)
    # Set the possible values of build type for cmake-gui, ccmake
    set_property(
        CACHE
        CMAKE_BUILD_TYPE
        PROPERTY
        STRINGS
        "Debug"
        "Release"
        "MinSizeRel"
        "RelWithDebInfo")
endif ()

find_program(CCACHE ccache)

if (CCACHE)
    message("using ccache")
    set(CMAKE_CXX_COMPILER_LAUNCHER ${CCACHE})
else ()
    message("ccache not found cannot use")
endif ()

# Generate compile_commands.json to make it easier to work with clang based
# tools
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if (ENABLE_IPO)
    include(CheckIPOSupported)
    check_ipo_supported(RESULT result OUTPUT output)
    if (result)
        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
    else ()
        message(SEND_ERROR "IPO is not supported: ${output}")
    endif ()
endif ()


if (MSVC)
	set(windowed WIN32)
elseif (APPLE)
	set(windowed MACOSX_BUNDLE)
endif ()
