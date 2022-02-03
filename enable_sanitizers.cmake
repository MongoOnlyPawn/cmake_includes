#! enable_sanitizers
# Create options for sanitizers, and create compiler options.
function (enable_sanitizers targetName)

    if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES
                                                ".*Clang")
        option(ENABLE_COVERAGE "Enable coverage reporting for gcc/clang" FALSE)

        if (ENABLE_COVERAGE)
            target_compile_options(project_options INTERFACE --coverage -O0 -g)
            target_link_libraries(project_options INTERFACE --coverage)
        endif ()

        set(sanitizers "")

        option(ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" FALSE)
        if (ENABLE_SANITIZER_ADDRESS)
            list(APPEND sanitizers "address")
        endif ()

        option(ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" FALSE)
        if (ENABLE_SANITIZER_MEMORY)
            list(APPEND sanitizers "memory")
        endif ()

        option(ENABLE_SANITIZER_UNDEFINED_BEHAVIOR
               "Enable undefined behavior sanitizer" FALSE)
        if (ENABLE_SANITIZER_UNDEFINED_BEHAVIOR)
            list(APPEND sanitizers "undefined")
        endif ()

        option(ENABLE_SANITIZER_THREAD "Enable thread sanitizer" FALSE)
        if (ENABLE_SANITIZER_THREAD)
            list(APPEND sanitizers "thread")
        endif ()

        list(
            JOIN
            sanitizers
            ","
            listOfSanitizers)

    endif ()

    if (listOfSanitizers)
        if (NOT
            "${listOfSanitizers}"
            STREQUAL
            "")
            target_compile_options(${targetName}
                                   INTERFACE -fsanitize=${listOfSanitizers})
            target_link_libraries(${targetName}
                                  INTERFACE -fsanitize=${listOfSanitizers})
        endif ()
    endif ()

endfunction ()
