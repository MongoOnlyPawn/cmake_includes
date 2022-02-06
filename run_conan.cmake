#! run_conan
# Runs the conan package manager to install dependencies.
macro (run_conan)

    message(STATUS "run_conan")

    set(conanCmakeVersion "0.16.1")
    set(conanBaseUrl "https://raw.githubusercontent.com/conan-io/cmake-conan")
    set(conanUrl "${conanBaseUrl}/v${conanCmakeVersion}/conan.cmake")

    if (NOT CONAN_EXPORTED)
        # Download automatically, you can also just copy the conan.cmake file
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

        # set(
        #   bincraftersUrl
        #   https://bincrafters.jfrog.io/artifactory/api/conan/api/public-conan)
        #
        # conan_add_remote(
        #     NAME
        #     bincrafters
        #     URL
        #     ${bincraftersUrl})

        conan_cmake_configure(GENERATORS cmake)

        conan_cmake_autodetect(settings)

        conan_cmake_install(
            PATH_OR_REFERENCE .
            PROFILE default
            BUILD missing
            REMOTE conan-center
            SETTINGS ${settings})

    endif ()

    include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)

    # https://docs.conan.io/en/latest/integrations/build_system/cmake/
    # cmake_generator.html#targets-approach
    conan_basic_setup(TARGETS)

    # conan_cmake_run(
    #     REQUIRES
    #     ${CONAN_EXTRA_REQUIRES}
    #     catch2/2.12.1
    #     OPTIONS
    #     ${CONAN_EXTRA_OPTIONS}
    #     BASIC_SETUP
    #     CMAKE_TARGETS
    #     BUILD
    #     missing)



endmacro ()
