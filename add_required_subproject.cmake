#! add_required_subproject
# Ensures that nested dependencies are only added once.
# \arg: projectName the name of the subproject to add.
#
# Note: For this feature to work, subprojects must declare a target with the
# same name as the folder. This may be used for prototyping, but the preferred
# method of managing dependencies is conan.
macro (add_required_subproject projectName)
    if (NOT TARGET ${projectName})
        add_subdirectory(${projectName})
    endif ()
endmacro ()
