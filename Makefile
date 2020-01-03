# Global Seafloor Fabric and Magnetic Lineations
# Makefile for SFDATA, MLDATA, and HELLDATA directories
DIR	=	/export/imina2/httpd/htdocs/PT/GSFML
HOST	=	imina.soest.hawaii.edu

help::
	@grep '^#!' Makefile | cut -c3-
#!-------------------- MAKE HELP FOR GSFML --------------------
#!
#!make <target>, where <target> can be:
#!
#!master_fs	: Update the SF master table
#!map		: Update the GSFML global map
#!build		: Build the latest SF, ML, HELL files
#!SF		: Build the latest SF site and distribution files
#!ML		: Build the latest ML site and distribution files
#!HELL		: Build the latest HELL site and distribution files
#!TOOL		: Build the latest TOOLS tarball
#!latest		: Build the latest test GSFML distribution
#!release		: Build the latest offical GSFML distribution
#!place_sf	: Place SF distribution on imina under GSFML
#!place_ml	: Place ML distribution on imina under GSFML
#!place_hell	: Place HELL distribution on imina under GSFML
#!place		: Place GSFML distribution on ftp server PT dir
#!clean		: Remove GSFML distribution from directory
#!---------------------------------------------------------------
# Build the master SFtable

master_fs:
		(cd SFDATA; sf_master.sh)

# Create the GSFML release

release:	build place map
		#ADMIN/build_release.sh day

clean:		clean_fz clean_ml

spotless:	clean
		rm -f GSFML_gmtfiles.tbz GSFML_shapefiles.zip GSFML.kmz

map:
		cd ADMIN; sh gsfml_map.sh
		scp ADMIN/GSFML_map.pdf ADMIN/GSFML_map_small.jpg $(HOST):$(DIR)

place:		place_sf place_ml place_hell

place_sf:
		ssh $(HOST) 'rm -rf $(DIR)/SF'
		cd SFDATA; scp -r SF $(HOST):$(DIR)

place_ml:
		ssh $(HOST) 'rm -rf $(DIR)/ML'
		cd MLDATA; scp -r ML $(HOST):$(DIR)

place_hell:
		ssh $(HOST) 'rm -rf $(DIR)/HELL'
		cd HELLDATA; scp -r HELL $(HOST):$(DIR)

place_tool:
		ssh $(HOST) 'rm -rf $(DIR)/gmt-gsfml-*-src.tar.bz2'
		scp -r gmt-gsfml-*-src.tar.bz2 $(HOST):$(DIR)

clean_fz:
		rm -f GSFML_SF*.*

clean_ml:
		rm -f GSFML_ML*.*

build:		SF ML HELL

SF:
		cd SFDATA; sh build_SF_site.sh

ML:
		cd MLDATA; sh build_ML_site.sh

HELL:
		cd HELLDATA; sh build_HELL_site.sh

TOOL:
		cd TOOLS; make update; make includes; make all; make archive

#place_img:
#		scp ADMIN/GSFML_map_full.jpg ftp:/export/ftp1/ftp/pub/PT
#		scp ADMIN/GSFML_map_small.jpg imina:/export/imina2/httpd/htdocs/PT/GSFML
