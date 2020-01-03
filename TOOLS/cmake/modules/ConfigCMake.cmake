#
# $Id: ConfigCMake.cmake 10119 2012-05-19 08:08:25Z fwobbe $
#
# Useful CMake variables.
#
# There are three configuration files:
#   1) "ConfigDefault.cmake" - is version controlled and used to add new default
#      variables and set defaults for everyone.
#   2) "ConfigUser.cmake" in the source tree - is not version controlled
#      (currently listed in svn:ignore property) and used to override defaults on
#      a per-user basis.
#   3) "ConfigUser.cmake" in the build tree - is used to override
#      "ConfigUser.cmake" in the source tree.
#
# NOTE: If you want to change CMake behaviour just for yourself then copy
#      "ConfigUserTemplate.cmake" to "ConfigUser.cmake" and then edit
#      "ConfigUser.cmake" (not "ConfigDefault.cmake" or "ConfigUserTemplate.cmake").
#
include ("${CMAKE_SOURCE_DIR}/cmake/ConfigDefault.cmake")

# If "ConfigUser.cmake" doesn't exist then create one for convenience.
if (EXISTS "${CMAKE_SOURCE_DIR}/cmake/ConfigUser.cmake")
	include ("${CMAKE_SOURCE_DIR}/cmake/ConfigUser.cmake")
endif (EXISTS "${CMAKE_SOURCE_DIR}/cmake/ConfigUser.cmake")

# If you've got a 'ConfigUser.cmake' in the build tree then that overrides the
# one in the source tree.
if (EXISTS "${CMAKE_BINARY_DIR}/cmake/ConfigUser.cmake")
	include ("${CMAKE_BINARY_DIR}/cmake/ConfigUser.cmake")
endif (EXISTS "${CMAKE_BINARY_DIR}/cmake/ConfigUser.cmake")

###########################################################
# Do any needed processing of the configuration variables #
###########################################################

# Build type
if (NOT CMAKE_BUILD_TYPE)
	set (CMAKE_BUILD_TYPE Release)
endif (NOT CMAKE_BUILD_TYPE)

if (CMAKE_BUILD_TYPE MATCHES "Debug|RelWithDebInfo")
	set (DEBUG_BUILD TRUE)
endif (CMAKE_BUILD_TYPE MATCHES "Debug|RelWithDebInfo")

# Get date
try_run (_exit_today _compiled_today
	${CMAKE_BINARY_DIR}/CMakeTmp
	${CMAKE_MODULE_PATH}/today.c
	CMAKE_FLAGS
	RUN_OUTPUT_VARIABLE _today)

if (NOT _compiled_today OR _exit_today EQUAL -1)
	message (WARNING "Date not implemented, please file a bug report.")
	set(_today "1313;13;13;Undecember")
endif (NOT _compiled_today OR _exit_today EQUAL -1)

list(GET _today 0 YEAR)
list(GET _today 1 MONTH)
list(GET _today 2 DAY)
list(GET _today 3 MONTHNAME)
list(GET _today 0 1 2 DATE)
string (REPLACE ";" "-" DATE "${DATE}")
set (_today)

# reset list of extra license files
set (CUSTOM_EXTRA_LICENSE_FILES)

# location of GNU license files
set (COPYING_GPL ${CUSTOM_SOURCE_DIR}/COPYINGv3)
set (COPYING_LGPL ${CUSTOM_SOURCE_DIR}/COPYING.LESSERv3)

# Install path for CUSTOM binaries, headers and libraries
include (GNUInstallDirs) # defines CMAKE_INSTALL_LIBDIR (lib/lib64)
if (CUSTOM_INSTALL_MONOLITHIC)
	set (CUSTOM_LIBDIR ${CMAKE_INSTALL_LIBDIR})
else (CUSTOM_INSTALL_MONOLITHIC)
	set (CUSTOM_LIBDIR ${CMAKE_INSTALL_LIBDIR}/gmt${CUSTOM_INSTALL_NAME_SUFFIX}/lib)
endif (CUSTOM_INSTALL_MONOLITHIC)

# use, i.e. don't skip the full RPATH for the build tree
set (CMAKE_SKIP_BUILD_RPATH FALSE)

# when building, don't use the install RPATH already
# (but later on when installing)
set (CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)

# the RPATH to be used when installing
set (CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/${CUSTOM_LIBDIR}")

# make executables relocatable on supported platforms
#if (UNIX AND NOT CYGWIN)
#	# find relative libdir from executable dir
#	file (RELATIVE_PATH _rpath /${CUSTOM_BINDIR} /${CUSTOM_LIBDIR})
#	# remove trailing /
#	string (REGEX REPLACE "/$" "" _rpath "${_rpath}")
#	if (APPLE)
#		# relative RPATH on osx
#		set (CMAKE_INSTALL_NAME_DIR @loader_path/${_rpath})
#	else (APPLE)
#		# relative RPATH on Linux, Solaris, etc.
#		set (CMAKE_INSTALL_RPATH "\$ORIGIN/${_rpath}")
#	endif (APPLE)
#endif (UNIX AND NOT CYGWIN)

# add the automatically determined parts of the RPATH
# which point to directories outside the build tree to the install RPATH
set (CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

# Make GNU and Intel C compiler default to C99
if (CMAKE_C_COMPILER_ID MATCHES "(GNU|Intel)" AND NOT CMAKE_C_FLAGS MATCHES "-std=")
	set (CMAKE_C_FLAGS "-std=gnu99 ${CMAKE_C_FLAGS}")
endif ()

# vim: textwidth=78 noexpandtab tabstop=2 softtabstop=2 shiftwidth=2
