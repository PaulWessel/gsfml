#
# $Id: CMakeLists.txt 11838 2013-06-28 06:49:32Z pwessel $
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
# Contact info: www.generic-mapping-tools.org
#-------------------------------------------------------------------------------
#
# 1. To modify the cmake process: Edit your cmake/ConfigUser.cmake file
# 2. To add more modules: Edit CUSTOM_PROGS_SRCS below.
# 3. Edit this: LIB_STRING="GMT FZ: Tools for the GSFML project"

# This is src/CMakeLists.txt
#

# ==> Modules in this custom library [add the ones you have]:
set (CUSTOM_PROGS_SRCS gsfml_config.h fz_analysis.h fzanalyzer.c
	fzblender.c mlconverter.c Chron_Normal.h Chron_Reverse.h
	Geek2007n.h Geek2007r.h CK1995n.h CK1995r.h GST2004n.h GST2004r.h
	GST2012n.h GST2012r.h)
#=========================================================================
# Most likely no changes below here

include (ManageString)

# Include CREATE_DEBUG_SYM macro
include (CreateDebugSym)

# On Windows do not prefix the DLLs with the 'lib' prefix
if (WIN32)
	set(LIB_PREFIX "")
else (WIN32)
	set(LIB_PREFIX "lib")
endif (WIN32)

# Find libraries
message (STATUS "Searching dependent libraries. This may take a few minutes...")
find_package (GMT REQUIRED)
include_directories (${GMT_INCLUDE_DIR})
find_package (NETCDF REQUIRED)
include_directories (${NETCDF_INCLUDE_DIR})
# libcurl is required since 5.4
find_package (CURL REQUIRED)
include_directories (${CURL_INCLUDE_DIRS})

find_package (GDAL)
if (GDAL_FOUND)
	set (HAVE_GDAL TRUE CACHE INTERNAL "System has GDAL")
	include_directories (${GDAL_INCLUDE_DIR})
	list (APPEND GMT_OPTIONAL_LIBRARIES ${GDAL_LIBRARIES})
endif (GDAL_FOUND)

#find_package (Threads)

# check for math and POSIX functions
include(ConfigureChecks)
# Configure version
configure_file (gsfml_config.h.in gsfml_config.h)
configure_file (config.mk.in config.mk)
configure_file (fz_funcs.sh.in fz_funcs.sh)

include_directories (${CUSTOM_SOURCE_DIR}/src)
include_directories (${CMAKE_CURRENT_BINARY_DIR})
#include_directories (${PROJECT_BINARY_DIR})
set(CMAKE_INCLUDE_CURRENT_DIR TRUE)

# Support glue code for the modules:
set (CUSTOM_LIB_SRCS ${CMAKE_PROJECT_NAME}_glue.c)

# lib targets
set (CUSTOM_LIBS gsfmllib)

# gsfmllib
set (CMAKE_SHARED_MODULE_SUFFIX .so)
add_library (gsfmllib MODULE
	${CUSTOM_LIB_SRCS}
	${CUSTOM_PROGS_SRCS})

target_link_libraries (gsfmllib
	${GMT_LIBRARIES}
	${CMAKE_THREAD_LIBS_INIT})

if (HAVE_M_LIBRARY)
	# link the math library
	target_link_libraries (gsfmllib m)
endif (HAVE_M_LIBRARY)

set_target_properties (gsfmllib
	PROPERTIES
	OUTPUT_NAME ${CMAKE_PROJECT_NAME}
	RUNTIME_OUTPUT_NAME ${CMAKE_PROJECT_NAME}
	LIBRARY_OUTPUT_DIRECTORY plugins
	RUNTIME_OUTPUT_DIRECTORY plugins
	PREFIX ""
	LINK_FLAGS "${USER_CUSTOMLIB_LINK_FLAGS}"
	DEFINE_SYMBOL "LIBRARY_EXPORTS")

# If a renaming of the custom dll has been set in ConfigUser.cmake
if (WIN32 AND CUSTOM_CUSTOM_RENAME)
	set_target_properties (gsfmllib PROPERTIES RUNTIME_OUTPUT_NAME ${CUSTOM_CUSTOM_RENAME})
endif ()

# generate Mac debugging symbols
create_debug_sym (${CUSTOM_LIBS})

# temporary hack
if (NOT CUSTOM_INSTALL_MONOLITHIC)
	set (CUSTOM_MAIN_NAME ${CMAKE_PROJECT_NAME}${CUSTOM_INSTALL_NAME_SUFFIX})
else (NOT CUSTOM_INSTALL_MONOLITHIC)
	set (CUSTOM_MAIN_NAME ${CMAKE_PROJECT_NAME})
endif (NOT CUSTOM_INSTALL_MONOLITHIC)


install (CODE "
execute_process (
	COMMAND ${CMAKE_COMMAND} -E copy_if_different
	\"${CMAKE_CURRENT_SOURCE_DIR}/fzinformer\"
	\"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/${CUSTOM_BINDIR}/fzinformer${CUSTOM_INSTALL_NAME_SUFFIX}\")
execute_process (
	COMMAND ${CMAKE_COMMAND} -E copy_if_different
	\"${CMAKE_CURRENT_SOURCE_DIR}/fzmapper\"
	\"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/${CUSTOM_BINDIR}/fzmapper${CUSTOM_INSTALL_NAME_SUFFIX}\")
execute_process (
	COMMAND ${CMAKE_COMMAND} -E copy_if_different
	\"${CMAKE_CURRENT_SOURCE_DIR}/fzmodeler\"
	\"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/${CUSTOM_BINDIR}/fzmodeler${CUSTOM_INSTALL_NAME_SUFFIX}\")
execute_process (
	COMMAND ${CMAKE_COMMAND} -E copy_if_different
	\"${CMAKE_CURRENT_SOURCE_DIR}/fzprofiler\"
	\"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/${CUSTOM_BINDIR}/fzprofiler${CUSTOM_INSTALL_NAME_SUFFIX}\")
")
# add the install targets
install (TARGETS ${CUSTOM_LIBS}
	ARCHIVE DESTINATION ${CUSTOM_LIBDIR}
	COMPONENT Runtime
	LIBRARY DESTINATION ${CUSTOM_LIBDIR}
	COMPONENT Runtime
	RUNTIME DESTINATION ${CUSTOM_BINDIR}
	COMPONENT Runtime)

if (WIN32 AND _debug_build)
	# install program database files
	set (_pdb_files)
	foreach (_target ${LIB_PREFIX}${CUSTOM_CUSTOM_RENAME})
		list (APPEND _pdb_files "${CMAKE_CURRENT_BINARY_DIR}/${_target}.pdb")
	endforeach ()
	install (FILES ${_pdb_files}
		DESTINATION ${CUSTOM_BINDIR}
		COMPONENT Runtime)
endif (WIN32 AND _debug_build)

# this prints out the final version of the compiler/linker flags
string (TOUPPER "${CMAKE_BUILD_TYPE}" CMAKE_BUILD_TYPE_UPPER)
string(REGEX REPLACE "[ ]+" " " _using_cflags ${CMAKE_C_FLAGS} " "
	${CMAKE_C_FLAGS_${CMAKE_BUILD_TYPE_UPPER}})
message (STATUS "Using CFLAGS = '${_using_cflags}'")

# vim: textwidth=78 noexpandtab tabstop=2 softtabstop=2 shiftwidth=2
