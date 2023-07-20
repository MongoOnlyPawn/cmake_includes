set(
    GIT_REVISION_SCRIPT
    "${CMAKE_CURRENT_LIST_DIR}/git_revision.cmake"
    CACHE
    INTERNAL
    "")

set(
    templateFile 
    "${CMAKE_CURRENT_LIST_DIR}/git_revision.h.in"
    CACHE
    INTERNAL
    "")


#! add_version_header
# Adds prebuild step to generate git_version.h
macro (add_version_header targetName)

    add_custom_target(
        ${targetName}-GetGitRevision
        COMMAND ${CMAKE_COMMAND}
            -DsourceDirectory="${CMAKE_CURRENT_SOURCE_DIR}"
            -DoutputDirectory="${CMAKE_CURRENT_BINARY_DIR}"
            -DtemplateFile="${templateFile}"
            -P "${GIT_REVISION_SCRIPT}"
        COMMENT "Retrieving git revision information...")

    add_dependencies(${targetName} ${targetName}-GetGitRevision)

    # for generated git_revision.h
    target_include_directories(
        ${targetName}
        PRIVATE
        ${CMAKE_CURRENT_BINARY_DIR})

endmacro ()
