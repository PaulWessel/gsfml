#-------------------------------------------------------------------------------
#
#	Makefile for gsfml/TOOLS directory
#	
#	This makefile builds and installs the GSFML supplement.
#
#	Author:	Paul Wessel, SOEST, University of Hawaii
#
#	Date:	01-DEC-2023
#-------------------------------------------------------------------------------

help::
		@grep '^#!' Makefile | cut -c3-
#!---------------- MAKE HELP FOR GSFML USERS ----------------
#!
#!make <target>, where <target> can be:
#!
#!config    : Create build dir and run cmake only
#!all       : Run configuration and build plugin and scripts
#!install   : Install GSFML shell scripts and plugin into gmt install directories
#!uninstall : Remove  GSFML shell scripts and plugin from gmt install directories
#!clean     : Remove local build directory
#!

config:
		mkdir -p build
		(cd build; cmake -DCMAKE_INSTALL_PREFIX=gsfml -DCMAKE_BUILD_TYPE=Release ..)

all:		config
		(cd build; make -j`gmt --show-cores` install)

install:
		/usr/bin/install build/src/fz_funcs.sh `gmt --show-bindir`
		/usr/bin/install src/fzinformer src/fzmapper src/fzmodeler src/fzprofiler `gmt --show-bindir`
		/usr/bin/install build/gsfml/lib/gmt/lib/gsfml.so `gmt --show-plugindir`

uninstall:
		rm -f `gmt --show-plugindir`/gsfml.so
		rm -f `gmt --show-bindir`/{fz_funcs.sh,fzinformer,fzmapper,fzmodeler,fzprofiler}

clean::	spotless

spotless::
	rm -rf build
