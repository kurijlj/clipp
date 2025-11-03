# =============================================================================
# A CMake library script for the `set_compiler_flags' function
# =============================================================================

# ============================================================================
#
# 2025-11-03 Ljubomir Kurij <ljubomir_kurij@proton.me>
#
# * Updated Intel compiler flags to include optimization report generation
#
# 2025-09-21 Ljubomir Kurij <ljubomir_kurij@proton.me>
#
# * Created.
#
# ============================================================================

# -----------------------------------------------------------------------------
# Function to set compiler flags based on compiler and build type
# -----------------------------------------------------------------------------
function (set_compiler_flags)
  # Check which compiler is being used and set flags accordingly
  if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    # -------------------------------------------------------------------------
    # Clang-specific flags
    # -------------------------------------------------------------------------
    set (DEBUG_FLAGS
      "-g3 -O0 -fno-omit-frame-pointer -Wall -Wextra -Wpedantic"
      )
    set (RELEASE_FLAGS
      "-O3 -DNDEBUG -march=native -fvectorize -flto"
      )
    set (MINSIZEREL_FLAGS
      "-Os -DNDEBUG -ffunction-sections -fdata-sections -flto"
      )
    set (RELWITHDEBINFO_FLAGS
      "-O2 -g -DNDEBUG -march=native -fvectorize"
      )
    set (MINSIZEREL_LINKER_FLAGS
      "-Wl,--gc-sections -Wl,--strip-all"
      )
      
  elseif (CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    # -------------------------------------------------------------------------
    # GNU-specific flags
    # -------------------------------------------------------------------------
    set (DEBUG_FLAGS
      "-g3 -O0 -fno-omit-frame-pointer -Wall -Wextra -Wpedantic"
      )
    set (RELEASE_FLAGS
      "-O3 -DNDEBUG -march=native -ftree-vectorize -flto"
      )
    set (MINSIZEREL_FLAGS
      "-Os -DNDEBUG -ffunction-sections -fdata-sections -flto"
      )
    set (RELWITHDEBINFO_FLAGS
      "-O2 -g -DNDEBUG -march=native -ftree-vectorize"
      )
    set (MINSIZEREL_LINKER_FLAGS
      "-Wl,--gc-sections -Wl,--strip-all"
      )
      
  elseif (CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
    # -------------------------------------------------------------------------
    # MSVC-specific flags
    # -------------------------------------------------------------------------
    set (DEBUG_FLAGS
      "/Zi /Od /Ob0 /MDd /W4 /permissive- /RTC1"
      )
    set (RELEASE_FLAGS
      "/O2 /MD /DNDEBUG /GL /fp:fast"
      )
    set (MINSIZEREL_FLAGS
      "/O1 /MD /DNDEBUG /GL"
      )
    set (RELWITHDEBINFO_FLAGS
      "/O2 /Zi /MD /DNDEBUG"
      )
    set (MINSIZEREL_LINKER_FLAGS
      "/OPT:REF /OPT:ICF /LTCG"
      )
      
  elseif(CMAKE_CXX_COMPILER_ID MATCHES "Intel"
    OR CMAKE_CXX_COMPILER_ID MATCHES "IntelLLVM"
    )
    # -------------------------------------------------------------------------
    # Intel-specific flags
    # -------------------------------------------------------------------------

    # Debugging info, no optimization, all warnings
    set(DEBUG_FLAGS
      "-g3 -O0 -Wall -Wextra"
      )

    # Optimize for maximum speed, enable interprocedural optimization,
    # generate optimization report
    set(RELEASE_FLAGS
      "-O3 -DNDEBUG -xHost -ipo -qopt-report=3"
      )
    string(APPEND
      RELEASE_FLAGS
      " -qopt-report-file=optimization_report.yaml"
      )

    # Optimize for size, enable interprocedural optimization,
    # generate optimization report
    set(MINSIZEREL_FLAGS
      "-Os -DNDEBUG -ipo -qopt-report=3"
      )
    string(APPEND
      MINSIZEREL_FLAGS
      " -qopt-report-file=optimization_report.yaml"
      )
    set(MINSIZEREL_LINKER_FLAGS
      "-Wl,--gc-sections -Wl,--strip-all"
      )

    # Moderate optimization with debugging info, enable interprocedural
    # optimization, generate optimization report
    set(RELWITHDEBINFO_FLAGS
      "-O2 -g -DNDEBUG -xHost -ipo -qopt-report=3"
      )
    string(APPEND
      RELWITHDEBINFO_FLAGS
      " -qopt-report-file=optimization_report.yaml"
      )
  endif()
  
  # Apply the flags to the appropriate CMake variables with PARENT_SCOPE
  # to make them available in the parent scope
  set(CMAKE_CXX_FLAGS_DEBUG "${DEBUG_FLAGS}" PARENT_SCOPE)
  set(CMAKE_CXX_FLAGS_RELEASE "${RELEASE_FLAGS}" PARENT_SCOPE)
  set(CMAKE_CXX_FLAGS_MINSIZEREL "${MINSIZEREL_FLAGS}" PARENT_SCOPE)
  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${RELWITHDEBINFO_FLAGS}" PARENT_SCOPE)
  
  if(DEFINED MINSIZEREL_LINKER_FLAGS)
    set(CMAKE_EXE_LINKER_FLAGS_MINSIZEREL "${MINSIZEREL_LINKER_FLAGS}" PARENT_SCOPE)
  endif()
endfunction()

# End of `set_compiler_flags.cmake'
