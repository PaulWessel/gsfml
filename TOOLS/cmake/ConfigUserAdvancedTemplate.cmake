#
# Copyright (c) 1991-2023 by the GMT Team (https://www.generic-mapping-tools.org/team.html)
# See LICENSE.TXT file for copying and redistribution conditions.
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published by the
# Free Software Foundation; version 3 or any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License
# for more details.
#
# Contact info: www.generic-mapping-tools.org
# ----------------------------------------------------------------------------

# INSTRUCTIONS TO USERS:
#
# 1. Copy 'ConfigUserTemplate.cmake' to 'ConfigUser.cmake' and make any edits
#    related to install directory, the whereabouts of GSHHS, DCW.
# 2. If you are an advanced user who wishes to tinker with the more advanced
#    settings, then copy 'ConfigUserAdvancedTemplate.cmake' to 'ConfigUserAdvanced.cmake',
#    explore and make changes to your ConfigUserAdvanced.cmake file
#    to override variables in 'ConfigDefault.cmake' on a per-user basis.
# 3. Follow the rest of the installation instructions in BUILDING.md.
#
# 'ConfigUser.cmake' and 'ConfigUserAdvanced.cmake' are not version controlled
# (currently listed in .gitignore).
#
# Note: CMake considers an empty string, "FALSE", "OFF", "NO", or any string
# ending in "-NOTFOUND" to be false (this happens to be case-insensitive, so
# "False", "off", "no", and "something-NotFound" are all false).  Other values
# are true.  Thus it does not matter whether you use TRUE and FALSE, ON and
# OFF, or YES and NO for your booleans.

# Change these for macOS setups
# set (CMAKE_OSX_ARCHITECTURES "arm64;x86_64")
# set (CMAKE_OSX_DEPLOYMENT_TARGET "14.0")

##
## Section 1: Installation paths
##
# Set install name suffix used for directories and gmt executables [undefined]:
#set (GMT_INSTALL_NAME_SUFFIX "suffix")

# Install into traditional directory structure. Disable to install a
# distribution type directory structure (doc and share separated) [on]:
#set (GMT_INSTALL_TRADITIONAL_FOLDERNAMES OFF)

# Make executables relocatable on supported platforms (relative RPATH) [FALSE]:
#set (GMT_INSTALL_RELOCATABLE TRUE)

