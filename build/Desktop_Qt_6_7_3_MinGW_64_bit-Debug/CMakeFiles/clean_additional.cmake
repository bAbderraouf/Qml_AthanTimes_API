# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\appAPI_athanByAdress_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appAPI_athanByAdress_autogen.dir\\ParseCache.txt"
  "appAPI_athanByAdress_autogen"
  )
endif()
