#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "Heffte::Heffte" for configuration ""
set_property(TARGET Heffte::Heffte APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(Heffte::Heffte PROPERTIES
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libheffte.so.2.4.1"
  IMPORTED_SONAME_NOCONFIG "libheffte.so.2"
  )

list(APPEND _cmake_import_check_targets Heffte::Heffte )
list(APPEND _cmake_import_check_files_for_Heffte::Heffte "${_IMPORT_PREFIX}/lib/libheffte.so.2.4.1" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
