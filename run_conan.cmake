#! run_conan
# Runs the conan package manager to install dependencies.
macro (run_conan)

    message(STATUS "run_conan")

    set(conanCmakeVersion "0.18.1")
    set(conanBaseUrl "https://raw.githubusercontent.com/conan-io/cmake-conan")
    set(conanUrl "${conanBaseUrl}/${conanCmakeVersion}/conan.cmake")

    if (NOT CONAN_EXPORTED)
        if (NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
            message(STATUS "Downloading conan.cmake from ${conanUrl}")
            file(DOWNLOAD "${conanUrl}" "${CMAKE_BINARY_DIR}/conan.cmake")
        endif ()

        include(${CMAKE_BINARY_DIR}/conan.cmake)

        conan_add_remote(
            NAME
            conan-center
            URL
            https://center.conan.io)

        set(
            jfrogUrl
            "https://jivehelix.jfrog.io/artifactory/api/conan")

        conan_add_remote(
            NAME
            jivehelix
            URL
            "${jfrogUrl}/default-conan-local")

        if (CONAN_CMAKE_PROFILE)
            conan_cmake_install(
                PATH_OR_REFERENCE .
                PROFILE ${CONAN_CMAKE_PROFILE}
                BUILD missing)
        else ()
            conan_cmake_autodetect(settings)

            conan_cmake_install(
                PATH_OR_REFERENCE .
                BUILD missing
                SETTINGS ${settings})
        endif ()

    endif ()

    include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)

    # https://docs.conan.io/en/latest/integrations/build_system/cmake/
    # cmake_generator.html#targets-approach
    conan_basic_setup(TARGETS)

endmacro ()
