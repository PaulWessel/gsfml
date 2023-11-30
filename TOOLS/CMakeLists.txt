#
# Copyright (c) 1991-2023 by the GMT Team (https://www.generic-mapping-tools.org/team.html)
# See LICENSE.TXT file for copying and redistribution conditions.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation; version 3 or any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# Contact info: http://www.soest.hawaii.edu/PT/GSFML
#-------------------------------------------------------------------------------
#
# To modify the cmake process: Edit your cmake/ConfigUser.cmake file
#
# To build out-of-source do (example):
#
#	mkdir build
#	cd build
#	cmake [-DCMAKE_INSTALL_PREFIX=custom] [-DCMAKE_BUILD_TYPE=RelWithDebInfo] ..
#
# CMAKE_BUILD_TYPE can be: empty, Debug, Release, RelWithDebInfo or MinSizeRel
#
# cmake creates a new file cmake/ConfigUser.cmake if it does not already
# exist. You can configure additional options there.
#

## Section 0: Define project name
project (gsfml)

#------------------------------------------------------------------------
# Make sure the user doesn't play dirty with symlinks
get_filename_component (srcdir "${CMAKE_SOURCE_DIR}" REALPATH)
get_filename_component (bindir "${CMAKE_BINARY_DIR}" REALPATH)

# Disallow in-source builds
if (${srcdir} STREQUAL ${bindir})
	message(FATAL_ERROR "In-source builds are not allowed. "
	"Please create a directory and run cmake from there, passing the path "
	"to this source directory as the last argument. This process created "
	"the file `CMakeCache.txt' and the directory `CMakeFiles' in ${srcdir}. "
	"Please remove them.")
endif (${srcdir} STREQUAL ${bindir})

# Use NEW behavior with newer CMake releases
foreach (p
		CMP0025 # CMake 3.0: Compiler id for Apple Clang is now AppleClang
		CMP0026 # CMake 3.0: Disallow use of the LOCATION target property
		CMP0058 # CMake 3.3: Ninja requires custom command byproducts to be explicit
		CMP0074	# CMake 3.12: find_package uses PackageName_ROOT variables
		CMP0115 # CMake 3.20: Source file extensions must be explicit.
		)
	if (POLICY ${p})
		cmake_policy (SET ${p} NEW)
	endif()
endforeach()

# Use OLD behavior with newer CMake releases
foreach(p
		CMP0026 # CMake 3.0: Disallow use of the LOCATION target property
		)
	if(POLICY ${p})
		cmake_policy(SET ${p} OLD)
	endif()
endforeach()

# Define minimum CMake version required
cmake_minimum_required (VERSION 2.8.12)

# Where to find our CMake modules (this variable is visible in subdirectories).
set (CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules/"
	CACHE INTERNAL "Location of our custom CMake modules." FORCE)

# Include configuration options (default options and options overridden by user).
include (ConfigCMake)

# Find UNIX commands
include (FindUnixCommands)

# Add subdirectories
add_subdirectory (src)
add_subdirectory (cmake/dist) # make distribution bundles (always last)
get_property(GMT_CUSTOM_LIB_PATH TARGET gsfmllib PROPERTY LOCATION)
GET_FILENAME_COMPONENT (GMT_CUSTOM_LIB_NAME ${GMT_CUSTOM_LIB_PATH} NAME)

# Configuration done
message(
	"*  Locations:\n"              
	"*  GMT library found       : ${GMT_LIBRARY}\n"
	"*  GMT include dir found   : ${GMT_INCLUDE_DIR}\n"
	"*  Project name            : ${CMAKE_PROJECT_NAME}\n"
	"*  Plug-in library         : ${GMT_CUSTOM_LIB_NAME}\n"
	"*  Installing plug-in in   : ${CMAKE_INSTALL_PREFIX}\n")

# vim: textwidth=78 noexpandtab tabstop=2 softtabstop=2 shiftwidth=2
