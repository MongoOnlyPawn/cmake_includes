set(_DECLARE_PROJECT_DIR ${CMAKE_CURRENT_LIST_DIR} CACHE INTERNAL "")

include(${_DECLARE_PROJECT_DIR}/prevent_in_source_builds.cmake)

#! setup_project
# Configures project settings and conan dependencies.
macro (setup_project)

    if (${CMAKE_VERSION} VERSION_LESS "3.21")
        # Compute our own top-level check
        if (${CMAKE_PROJECT_NAME} STREQUAL ${PROJECT_NAME})
            set(PROJECT_IS_TOP_LEVEL TRUE)
        else ()
            set(PROJECT_IS_TOP_LEVEL FALSE)
        endif ()
    endif ()

    if (${PROJECT_IS_TOP_LEVEL})

        # if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/conanfile.py)
        #     configure_file(
        #         ${CMAKE_CURRENT_SOURCE_DIR}/conanfile.py
        #         ${CMAKE_BINARY_DIR})
        # elseif (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/conanfile.txt)
        #     configure_file(
        #         ${CMAKE_CURRENT_SOURCE_DIR}/conanfile.txt
        #         ${CMAKE_BINARY_DIR})
        # endif ()

        include(${_DECLARE_PROJECT_DIR}/top_level_options.cmake)
        include(${_DECLARE_PROJECT_DIR}/standard_project_settings.cmake)
        include(${_DECLARE_PROJECT_DIR}/add_version_header.cmake)

        if (ENABLE_TESTING)
            enable_testing()
        endif ()

        # if (NOT CONAN_EXPORTED)
        #     include(GNUInstallDirs)
        # endif ()

        # include(${_DECLARE_PROJECT_DIR}/run_conan.cmake)
        # run_conan()

    endif ()

    if (${ENABLE_UNITY})
        # Add for any project you want to apply unity builds for
        set_target_properties(${PROJECT_NAME} PROPERTIES UNITY_BUILD ON)
    endif ()

endmacro ()
