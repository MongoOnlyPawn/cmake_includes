#! define_project_once
# \arg: projectName The name of the project
#
# Define this as a macro so that the return statement, if necessary, will return
# control to the parent directory.
macro (define_project_once projectName)

    if (NOT ${ARGC} EQUAL 1)
        message(FATAL "Usage: define_project_once(<project-name>)")
    endif ()

    if ((DEFINED ${projectName}_SOURCE_DIR)
        AND (NOT
            ${projectName}_SOURCE_DIR
             STREQUAL
             CMAKE_CURRENT_SOURCE_DIR
            ))

        message(
            "Ignoring ${projectName} in ${CMAKE_CURRENT_SOURCE_DIR}. "
            "Already added: ${${projectName}_SOURCE_DIR}")

        return()
    endif ()

endmacro ()
