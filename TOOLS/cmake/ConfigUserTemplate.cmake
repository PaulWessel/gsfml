#
# ConfigUserTemplate.cmake 11801 2013-06-24 21:19:31Z pwessel
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

## Use this file to override variables in 'ConfigDefault.cmake' on a per-user basis.
## First copy 'ConfigUserTemplate.cmake' to 'ConfigUser.cmake', then edit 'ConfigUser.cmake'.
## 'ConfigUser.cmake' is not version controlled (currently listed in svn:ignore property)
##
## Note: CMake considers an empty string, "FALSE", "OFF", "NO", or any string ending
## in "-NOTFOUND" to be false. (This happens to be case-insensitive, so "False",
## "off", "no", and "something-NotFound" are all false.) Other values are true. Thus
## it matters not whether you use TRUE and FALSE, ON and OFF, or YES and NO for your
## booleans.

## Basic setup begins here. All settings are optional. In most cases, setting
## CMAKE_INSTALL_PREFIX should be all you need to do in order to build GMT with
## reasonable defaults enabled.

##
## Section 1: Setting up PATHs
##

# 1a) Installation path (usually defaults to /usr/local) [auto]:
#set (CMAKE_INSTALL_PREFIX "prefix_path")

# 1b) Set location of GMT (can be root directory, path to header file or path to gmt-config) [auto]:
#set (GMT_ROOT "gmt_install_prefix")

##
## Section 2: Advanced tweaking
##

# 2a) Set build type can be: empty, Debug, Release, RelWithDebInfo or MinSizeRel [Release]:
#set (CMAKE_BUILD_TYPE Debug)

# 2b) Extra debugging for developers:
#add_definitions(-DDEBUG)
#set (CMAKE_C_FLAGS "-Wall -Wdeclaration-after-statement") # recommended even for release build
#set (CMAKE_C_FLAGS "-Wextra ${CMAKE_C_FLAGS}")            # extra warnings
#set (CMAKE_C_FLAGS_DEBUG -ggdb3)                          # gdb debugging symbols
#set (CMAKE_C_FLAGS_RELEASE "-ggdb3 -O2 -Wuninitialized")  # check uninitialized variables
#set (CMAKE_LINK_DEPENDS_DEBUG_MODE TRUE)                  # debug link dependencies

# 2c) This is for GCC on Solaris to avoid "relocations remain against
# allocatable but non-writable sections" problems:
#set (USER_GMTLIB_LINK_FLAGS -mimpure-text)

# 2d) This may be needed to enable strdup and extended math functions
# with GCC and Suncc on Solaris:
#set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D__EXTENSIONS__")

# 2e) Do not warn when building with Windows SDK or Visual Studio Express:
#set (CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_NO_WARNINGS ON)

# 2f) If want to rename the DLLs to something else than the default (e.g. to append the bitness - Windows only)
# if (WIN32)
#	set (BITAGE 32)
#	# Detect if we are building a 32 or 64 bits version
#	if (CMAKE_SIZEOF_VOID_P EQUAL 8)
#		set(BITAGE 64)
#	endif ()
#	set (CUSTOM_DLL_RENAME custom_w${BITAGE})
# endif(WIN32)

# vim: textwidth=78 noexpandtab tabstop=2 softtabstop=2 shiftwidth=2
