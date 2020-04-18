#
# $Id: CMakeLists.txt 11838 2013-06-28 06:49:32Z pwessel $
#
# Copyright (c) 1991-2020 by GMT Team (https://www.generic-mapping-tools.org/team.html)
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
# SUPPL_NAME [required]
#	name of the supplement package. It can be different from the directory name.
set (SUPPL_NAME gsfml)

# SUPPL_PROGS_SRCS [required]
#	list of C source codes for supplemental modules
set (SUPPL_PROGS_SRCS gsfml_config.h fz_analysis.h fzanalyzer.c
	fzblender.c mlconverter.c Chron_Normal.h Chron_Reverse.h
	Geek2007n.h Geek2007r.h CK1995n.h CK1995r.h GST2004n.h GST2004r.h)

# SUPPL_LIB_SRCS [required]
#	list of C source codes for supplemental library
set (SUPPL_LIB_SRCS ${SUPPL_PROGS_SRCS} gsfml_module.c)

# SUPPL_HEADERS [optional]
#	header files. Will be installed if BUILD_DEVELOPER is TRUE
#set (SUPPL_HEADERS meca.h utilmeca.h sacio.h)

# SUPPL_EXAMPLE_FILES [optional]
#	README and other example files
#set (SUPPL_EXAMPLE_FILES README.gsfml)

# SUPPL_EXAMPLE_PROGS [optional]
#	example scripts
#set (SUPPL_EXAMPLE_PROGS test1.sh test2.sh)

# SUPPL_LIB_NAME [optional]
#	name of the supplement library.
#	If not set, the supplement package will be built into GMT's supplements.so.
set (SUPPL_LIB_NAME gsfml)

# GSFML SPECIFIC SETTINGS

set (GSFML_PACKAGE_VERSION "2.0.0")

configure_file (gsfml_config.h.in gsfml_config.h)
configure_file (fz_funcs.sh.in fz_funcs.sh)

# Install Bourne scripts to share/tools
install (PROGRAMS fzinformer fzmapper fzmodeler fzprofiler
	${CMAKE_CURRENT_BINARY_DIR}/fz_funcs.sh
	DESTINATION ${GMT_DATADIR}/tools
	COMPONENT Runtime)
