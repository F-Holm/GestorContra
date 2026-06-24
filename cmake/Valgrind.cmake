if (ENABLE_MEMCHECK   OR 
    ENABLE_HELGRIND   OR 
    ENABLE_DRD        OR 
    ENABLE_MASSIF     OR 
    ENABLE_CACHEGRIND OR 
    ENABLE_CALLGRIND  OR 
    ENABLE_DHAT       OR 
    ENABLE_LACKEY     OR 
    ENABLE_NULGRIND)
    
    set(ENABLE_VALGRIND ON CACHE INTERNAL "Enable Valgrind")
else()
    set(ENABLE_VALGRIND OFF CACHE INTERNAL "Enable Valgrind")
endif()

if(ENABLE_VALGRIND)
    message(STATUS "Valgrind is enabled")
    find_program(VALGRIND_PATH valgrind)
    if(NOT VALGRIND_PATH)
        message(WARNING "valgrind not found")
        set(ENABLE_VALGRIND FALSE)
    endif()
else()
    message(STATUS "Valgrind is disabled")
endif()

function(AddValgrindInstrumentation target)
    if(NOT ENABLE_VALGRIND)
        return()
    endif()

    if(ENABLE_MEMCHECK)
        add_valgrind_memcheck(${target})
    endif()
    if(ENABLE_HELGRIND)
        add_valgrind_helgrind(${target})
    endif()
    if(ENABLE_DRD)
        add_valgrind_drd(${target})
    endif()
    if(ENABLE_MASSIF)
        add_valgrind_massif(${target})
    endif()
    if(ENABLE_CACHEGRIND)
        add_valgrind_cachegrind(${target})
    endif()
    if(ENABLE_CALLGRIND)
        add_valgrind_callgrind(${target})
    endif()
    if(ENABLE_DHAT)
        add_valgrind_dhat(${target})
    endif()
    if(ENABLE_LACKEY)
        add_valgrind_lackey(${target})
    endif()
    if(ENABLE_NULGRIND)
        add_valgrind_nulgrind(${target})
    endif()
endfunction()

function(add_valgrind_memcheck target)
    add_test(
        NAME "memcheck_${target}"
        COMMAND "${VALGRIND_PATH}" --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes --error-exitcode=1 "$<TARGET_FILE:${target}>"
        WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
    )
endfunction()

function(add_valgrind_helgrind target)
    add_test(
        NAME "helgrind_${target}"
        COMMAND "${VALGRIND_PATH}" --tool=helgrind --history-level=approx --error-exitcode=1 "$<TARGET_FILE:${target}>"
        WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
    )
endfunction()

function(add_valgrind_drd target)
    add_test(
        NAME "drd_${target}"
        COMMAND "${VALGRIND_PATH}" --tool=drd --check-stack-var=yes --error-exitcode=1 "$<TARGET_FILE:${target}>"
        WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
    )
endfunction()

function(add_valgrind_massif target)
    add_test(
        NAME "massif_${target}"
        COMMAND "${VALGRIND_PATH}" --tool=massif --stacks=yes --time-unit=B "$<TARGET_FILE:${target}>"
        WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
    )
endfunction()

function(add_valgrind_cachegrind target)
    add_test(
        NAME "cachegrind_${target}"
        COMMAND "${VALGRIND_PATH}" --tool=cachegrind "$<TARGET_FILE:${target}>"
        WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
    )
endfunction()

function(add_valgrind_callgrind target)
    add_test(
        NAME "callgrind_${target}"
        COMMAND "${VALGRIND_PATH}" --tool=callgrind --dump-instr=yes --collect-jumps=yes "$<TARGET_FILE:${target}>"
        WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
    )
endfunction()

function(add_valgrind_dhat target)
    add_test(
        NAME "dhat_${target}"
        COMMAND "${VALGRIND_PATH}" --tool=dhat "$<TARGET_FILE:${target}>"
        WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
    )
endfunction()

function(add_valgrind_lackey target)
    add_test(
        NAME "lackey_${target}"
        COMMAND "${VALGRIND_PATH}" --tool=lackey "$<TARGET_FILE:${target}>"
        WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
    )
endfunction()

function(add_valgrind_nulgrind target)
    add_test(
        NAME "nulgrind_${target}"
        COMMAND "${VALGRIND_PATH}" --tool=nulgrind "$<TARGET_FILE:${target}>"
        WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
    )
endfunction()
