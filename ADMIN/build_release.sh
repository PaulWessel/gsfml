#!/bin/bash

name=GSFML
cat << EOF > doc.kml
<?xml version="1.0" encoding="utf-8" ?>
<kml xmlns="http://www.opengis.net/kml/2.2">
<Document>
<name>GSFML Database</name>
<description>
        <![CDATA[
 	The Global Seafloor Fabric and Magnetic Lineation Project<br>
	See <a href="http://www.soest.hawaii.edu/PT/GSFML"> GSLML home page</a>
        ]]>
</description>
EOF

cd FZDATA; build_fz_release.sh day; cd ..
cd MLDATA; build_ml_release.sh day; cd ..

cat << EOF >> doc.kml
</Document>
</kml>
EOF

# Zip up the GMT and SHP files
COPYFILE_DISABLE=true tar cjvf ${name}_gmtfiles.tbz ${name}_*.gmt
zip -r -9 ${name}_shapefiles.zip ${name}_*.{dbf,prj,shp,shx}
zip -r -9 ${name}.kmz doc.kml ${name}_*.kml
rm -f ${name}_*.{dbf,prj,shp,shx,gmt,kml} doc.kml
