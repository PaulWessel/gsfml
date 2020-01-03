#!/bin/sh
#
# Create the three links GSFML.kml, GSFML_shapefiles.zip, GSFML_gmtfiles.tbz
# Delete old links
rm -f GSFML_gmtfiles.tbz GSFML_shapefiles.zip GSFML.kmz
# Set the new links
ln -s GSFML_20??-??-??_gmtfiles.tbz GSFML_gmtfiles.tbz
ln -s GSFML_20??-??-??_shapefiles.zip GSFML_shapefiles.zip
ln -s GSFML_20??-??-??.kmz GSFML.kmz
