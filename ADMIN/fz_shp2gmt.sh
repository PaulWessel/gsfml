#!/bin/sh
#
# We convert an incoming shapefile to OGR/GMT

if [ $# -ne 1 ]; then
        echo "Usage: fz_shp2gmt.sh shapefile-prefix" >&2
        echo "  shapefile-prefix.shp is a shapefile with FZs" >&2
        echo "  shapefile-prefix.gmt is the resulting OGR/GMT file" >&2
        exit 1
fi

# Assign input arguments
PREFIX=$1
if [ ! -f ${PREFIX}.shp ]; then
        echo "Cannot find ${PREFIX}.shp" >&2
        exit 1
fi
	
ogr2ogr -f "OGR_GMT" ${PREFIX}.gmt ${PREFIX}.shp 
echo "Created ${PREFIX}.gmt - Examine for proper formatting" >&2
