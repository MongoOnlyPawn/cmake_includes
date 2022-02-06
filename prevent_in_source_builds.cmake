#! This function will prevent in-source builds
function (prevent_in_source_builds)
    # make sure the user doesn't play dirty with symlinks
    get_filename_component(sourceDir "${CMAKE_SOURCE_DIR}" REALPATH)
    get_filename_component(binaryDir "${CMAKE_BINARY_DIR}" REALPATH)

    # disallow in-source builds
    if ("${sourceDir}" STREQUAL "${binaryDir}")
        message("######################################################")
        message("Warning: in-source builds are disabled")
        message(
            "Please create a separate build directory and run cmake from there")
        message(
            "Remember to delete the spurious CMakeCache.txt "
            "in the source directory.")
        message("######################################################")

        message(FATAL_ERROR "Quitting configuration")
    endif ()
endfunction ()

prevent_in_source_builds()
