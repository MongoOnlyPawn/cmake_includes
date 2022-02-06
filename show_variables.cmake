#! Print out all variables visible to CMake in the current list.
macro (show_variables)

    message("\n\n********** Defined Variables **********")
    get_cmake_property(variableName VARIABLES)
    list (SORT variableName)

    foreach (variableName ${variableName})
        message(STATUS "${variableName}=${${variableName}}")
    endforeach()

    message("\n****************************************\n")

endmacro ()
