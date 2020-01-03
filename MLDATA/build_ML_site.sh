#!/bin/bash
#
now=`date +"%e %B, %Y"`
TOP=`pwd`
# Script to build the ML portion of the GSFML website
DIR=ML	# Where we will place all files
# Actual URL we will use:
#URL=http://www.soest.hawaii.edu/PT/GSFML/ML/DATA
#URL2=http://www.soest.hawaii.edu/PT/GSFML/ML/IMG
URL=DATA
URL2=IMG

# 1. Make the MLDATA web directory
TO=$TOP/$DIR
DATA=$TO/DATA
IMG=$TO/IMG
rm -rf $TO
mkdir -p $DATA
mkdir -p $IMG
# 2. Make the index.html file for this dir
cat << EOF > $TO/index.html
<HTML>
<!--  Created $now  -->
<TITLE>Published Magnetic Picks for Tectonic Reconstructions</TITLE>
<BODY bgcolor="#f5f5ff">
<CENTER><H2>Published Magnetic Picks for Tectonic Reconstruction</H2>
<H4>PIs: P. Wessel (SOEST, U of Hawaii) and R. D. M&uuml;ller (U of Sydney)<BR>
Contributors: M. Seton (U of Sydney), J. Whittaker (U of Tasmania), S. Williams (U of Sydney), N. Wright (U of Sydney)<BR>
C. DeMets (U of Wisconsin), S. Merkouriev (Russian Acad. Sci.), S. C. Cande (Scripps Institution of Oceanography), C. Gaina (U. Oslo),
G. Eagles (Alfred Wegener Inst.), R. Granot (Ben Gurion U.), J. Stock (Caltech)<BR></H4>

<H5>Updated $now</H5>
<IMG SRC="../ML.png" ALT="North Atlantic Fracture Zone" width="600">
</CENTER>
<HR>
<H3>What is this site?</H3>
This is a collection of published magnetic anomaly and fracture zone picks.  For more information, see<P>
Seton, M., J. Whittaker, P. Wessel, R. D. M&uuml;ller, C. DeMets, S. Merkouriev, S. Cande,
C. Gaina, G. Eagles, R. Granot, J. Stock, N. Wright, S. Williams, 2014,
	Community infrastructure and repository for marine magnetic identifications,
	<I>Geochemistry, Geophysics, Geosystems, 5(4)</I>, 1629-1641, <A HREF="http://dx.doi.org/10.1002/2013GC005176" target="_blank"><img src="DOI.png" ALT="DOI lookup"> DOI:10.1002/2013GC005176</A>
<HR>
EOF
if [ -s $TOP/ML_news.html ]; then
	cat $TOP/ML_news.html >> $TO/index.html
fi

# 3. Create the reformatted files, make zip file, delete reformatted files
# a) Find list of all dirs

for ocean in AtlanticOcean IndianOcean Marginal_BackarcBasins PacificOcean; do
	echo "Process dir $TOP/$ocean"
	cd $TOP/$ocean
	ls *.gmt > files.lis
	mkdir -p $DATA/$ocean
	mkdir -p $IMG/$ocean
	# Make the OGR header line first
	echo "# @VGMT1.0 @GPOINT" > $DATA/$ocean/GSFML.$ocean.picks.gmt
	# Determine the region for this combined file
	cat *.gmt | grep -v '#' | gmt info -fg -I- | sed -e 's/-R/# @R/g' >> $DATA/$ocean/GSFML.$ocean.picks.gmt
	# Continue to build the OGR header
	cat <<- EOF >> $DATA/$ocean/GSFML.$ocean.picks.gmt
	# @Jp"+proj=longlat +datum=WGS84 +no_defs "
	# @Jw"GEOGCS[\"GCS_WGS_1984\",DATUM[\"WGS_1984\",SPHEROID[\"WGS_84\",6378137.0,298.257223563]],PRIMEM[\"Greenwich\",0.0],UNIT[\"Degree\",0.0174532925199433]]"
	# @NChron|AnomalyEnd|AnomEndQua|CruiseName|Reference|DOI|GeeK2007|IDMethod
	# @Tstring|string|integer|string|string|string|double|string
	# FEATURE_DATA
	EOF
	while read name; do
		# Strip off the first 5 lines so only data section is appended
		sed -e '1,/FEATURE_DATA/d' $name >> $DATA/$ocean/GSFML.$ocean.picks.gmt
		prefix=`basename $name ".gmt"`
		cp -f $name $DATA/$ocean/GSFML.$prefix.picks.gmt
	done < files.lis
	cp -f readme.* $DATA/$ocean
	rm -f files.lis
done
# Make the OGR header line first
echo "# @VGMT1.0 @GPOINT" > $DATA/GSFML.global.picks.gmt
# Determine the latitute range for the global file, setting longitude range to -180/180
latrange=`cat *.gmt | grep -v '#' | gmt info -fg -C -o2,3 --IO_COL_SEPARATOR=/`
echo "# @R-180/180/$latrange" >> $DATA/GSFML.global.picks.gmt
# Append everything but skipping first 2 lines from Atlantic (the OGR header and @R line)
sed -e '1,/# @R/d' $DATA/AtlanticOcean/GSFML.AtlanticOcean.picks.gmt >> $DATA/GSFML.global.picks.gmt
for ocean in IndianOcean Marginal_BackarcBasins PacificOcean; do
	sed -e '1,/FEATURE_DATA/d' $DATA/$ocean/GSFML.$ocean.picks.gmt >> $DATA/GSFML.global.picks.gmt
done
cd $DATA
for ocean in AtlanticOcean IndianOcean Marginal_BackarcBasins PacificOcean; do
	echo "Make other formats for files in dir $DIR/$ocean"
	cd $ocean
	ls *.gmt > files.lis
	while read name; do
		prefix=`basename $name ".gmt"`
		mkdir -p $prefix
		cp -f $name $prefix
		cd $prefix
		ogr2ogr -f "ESRI Shapefile" $prefix.shp $name
		zip -rq9 ../$prefix.zip $prefix.{shp,shx,dbf,prj,xml,sbn,sbx}
		cd ..
		rm -rf $prefix
		ogr2ogr -f "KML" $prefix.kml $name
	done < files.lis
	rm -f files.lis
	cd ..
done
# Make the global compilation
mkdir -p global
cp -f GSFML.global.picks.gmt global
cd global
ogr2ogr -f "ESRI Shapefile" GSFML.global.picks.shp GSFML.global.picks.gmt
zip -rq9 ../GSFML.global.picks.zip GSFML.global.picks.{shp,shx,dbf,prj,xml,sbn,sbx}
cd ..
rm -rf global
ogr2ogr -f "KML" GSFML.global.picks.kml GSFML.global.picks.gmt
cd $TOP

cat << EOF > list.txt
AtlanticOcean	Atlantic Ocean
IndianOcean	Indian Ocean
PacificOcean	Pacific Ocean
Marginal_BackarcBasins	Marginal Basins
EOF

# 4. Create the website table

cat << EOF >> $TO/index.html
<H3>Alphabetical List of Publications with Data</H3>
The data are organized per ocean basin and offers basin-wide compilations as well as files per reference.
The magnetic pick data are distributed in three file formats:
<OL>
<LI><img src="ZIP.png"><B> ESRI Shapefiles</B>.  These can be ingested by most GIS tools.
<LI><img src="GMT.png"><B> GMT/OGR ASCII tables</B>.  These can be used by GMT and other tools.
<LI><img src="KML.png"><B> KML files</B>.  These can be read by Google Earth and similar tools.
</OL>

Click on the corresponding logos to download, use <img src="DOI.png" ALT="DOI lookup"></A>
to look up the article at the publisher, and use <img src="PNG.png" ALT="PNG map"></A>
to see a PNG map of a particular data set.<P>

<H3>Global Compilations of Reconstruction Data:</H3>
<table border=1 cellspacing=2 cellpadding=4 bgcolor="#eeffee" bordercolor="black" width="800">
<tr>
  <td>Format</td>
  <td>Description</td>
</tr>
<tr>
	<td><A HREF="$URL/GSFML.global.picks.zip"><img src="ZIP.png" ALT="ZIP download"></A></td>
	<td>Global compilation as one shapefile</td>
</tr>
<tr>
	<td><A HREF="$URL/GSFML.global.picks.kml"><img src="KML.png" ALT="KML download"></A></td>
	<td>Global compilation as one KML file</td>
</tr>
<tr>
	<td><A HREF="$URL/GSFML.global.picks.gmt"><img src="GMT.png" ALT="GMT download"></A></td>
	<td>Global compilation as one GMT/OGR file</td>
</tr>
</table>
<P>
<H3>Regional Compilations of Reconstruction Data:</H3>
<table border=1 cellspacing=2 cellpadding=4 bgcolor="#eeffee" bordercolor="black" width="800">
<tr>
  <td>ZIP</td>
  <td>KML</td>
  <td>GMT</td>
  <td>Region</td>
</tr>
EOF
while read ocean name; do
	cat <<- EOF >> $TO/index.html
	<tr>
	  <td><A HREF="$URL/$ocean/GSFML.$ocean.picks.zip"><img src="ZIP.png" ALT="ZIP download"></A></td>
	  <td><A HREF="$URL/$ocean/GSFML.$ocean.picks.kml"><img src="KML.png" ALT="KML download"></A></td>
	  <td><A HREF="$URL/$ocean/GSFML.$ocean.picks.gmt"><img src="GMT.png" ALT="GMT download"></A></td>
	  <td>All published magnetic picks for the $name
	  </td>
	</tr>
	EOF
done < list.txt

cat <<- EOF >> $TO/index.html
</table>
<P>
EOF

while read ocean name; do
	cd $DATA/$ocean
	ls *.gmt | egrep -v 'Ocean|Basin' > files.lis
	N=`cat files.lis | wc -l | awk '{printf "%d\n", $1}'`
	echo "Find data for $ocean"
	cat <<- EOF >> $TO/index.html
	<H3>$name Reconstruction Data ($N individual publications):</H3>
	<table border=1 cellspacing=2 cellpadding=4 bgcolor="#eeffee" bordercolor="black" width="800">
	<tr>
	  <td>DOI</td>
	  <td>PNG</td>
	  <td>ZIP</td>
	  <td>KML</td>
	  <td>GMT</td>
	  <td>Complete Citation</td>
	</tr>
	EOF
	while read name; do
		prefix=`basename $name ".gmt"`
		sh $TOP/pick_fig.sh $name
		mv ${name}.png $IMG/$ocean
		dir=`echo $name | awk -F. '{print $2}'`
		echo "Doing ref for $dir"
		this_ref=`grep $dir $TOP/$ocean/References.txt | awk -F'|' '{print $2}'`
		this_doi=`grep $dir $TOP/$ocean/References.txt | awk -F'|' '{print $3}'`
		if [ -f readme.$dir.txt ]; then
			MORE="<A HREF=\"$URL/$ocean/readme.$dir.txt\"> [readme]</A>"
		elif [ -f readme.$dir.doc ]; then
			MORE="<A HREF=\"$URL/$ocean/readme.$dir.doc\"> [readme]</A>"
		else
			MORE=""
		fi
		cat <<- EOF >> $TO/index.html
		<tr>
		EOF
		if [ "X${this_doi}" = "X" ]; then	# No DOI available
			cat <<- EOF >> $TO/index.html
			<td><img src="DOI.png" ALT="DOI not available"></A></td>
			EOF
		else
			cat <<- EOF >> $TO/index.html
			<td><A HREF="http://dx.doi.org/$this_doi" target="_blank"><img src="DOI.png" ALT="DOI lookup"></A></td>
			EOF
		fi
		cat <<- EOF >> $TO/index.html
		  <td><A HREF="$URL2/$ocean/$name.png"><img src="PNG.png" ALT="PNG map"></A></td>
		  <td><A HREF="$URL/$ocean/$prefix.zip"><img src="ZIP.png" ALT="ZIP download"></A></td>
		  <td><A HREF="$URL/$ocean/$prefix.kml"><img src="KML.png" ALT="KML download"></A></td>
		  <td><A HREF="$URL/$ocean/$prefix.gmt"><img src="GMT.png" ALT="GMT download"></A></td>
		  <td>${this_ref}${MORE}
		  </td>
		</tr>
		EOF
	done < files.lis
	rm -f files.lis
	cd ..
	cat <<- EOF >> $TO/index.html
	</table>
	EOF
done < list.txt
cd $TOP
rm -f list.txt
cat << EOF >> $TO/index.html

<HR>
<H3>Data Format</H3>

All formats contain the same information.  The name of the file derives from the
publication and uses the format <I>author(s)_year_journal.extension</I>, where
extensions are .shp, .gmt, and .kml.
Because ESRI shapefiles actually consists of several separate files per dataset
we distribute these in zip archives instead, hence these files are called *.zip.
<P>
The data files contain these observations:<BR>

lon, lat:	The location of the magnetic pick.
<P>
The data files also contain these aspatial data:
<HR>
<table border=0 cellspacing=2 cellpadding=4 width="800">
<tr>
  <b>
  <td>Name</td>
  <td>Description</td>
  </b>
</tr>
<tr><td>Chron:</td><td>The chron name [e.g., C13n]</td></tr>
<tr><td>AnomalyEnd:</td><td>End of anomaly being picked, i.e., young (y), old (o),
		or center (c).</td></tr>
<tr><td>AnomEndQua:</td><td>Confidence in the anomaly end assignment.  Ranges from
		1 = anomaly end clearly listed in the original paper;
		2 = some problem exist from original paper but there is
		    confidence in the anomaly end assignment
		3 = anomaly end unclear in the original paper and the end
		    has been inferred by the data assembler.</td></tr>
<tr><td>CruiseName:</td><td>Cruise name designation (NGDC) if known, otherwise N/A.</td></tr>
<tr><td>Reference:</td><td>The publication reference [e.g., Cande++_1988_JGR]</td></tr>
<tr><td>DOI:</td><td>The DOI of the publication, if known, otherwise N/A</td></tr>
<tr><td>GeeK2007:</td><td>The assigned age based on the Gee and Kent [2007] time scale.
		Note: Other time scales can be used via the Chron name.</td></tr>
<tr><td>IDMethod:</td><td>Typically "Magnetic Anomaly" but could be other identifiers
		such as "Abyssal Hill".</td></tr>
</table>
<HR>
If you prefer to assemble your data using Arcinfo then you may consider this
<A HREF="../MagPick_Database_GSFML.zip">GSFML template for magnetic pics</A>.
<H3>Additional Information</H3>
Some individual publications are also accompanied by a readme file (ASCII text or Word format) that provides additional
information about data processing, parameters, etc. A link to these are given at the end of each reference,
if available. Much of this information is also given in the actual publications.
<P>
<I>Maintained by <a href="mailto:pwessel@hawaii.edu?Subject=GSFML%20Project" target="_top">Paul Wessel</a></I><BR>
<table border=0 cellspacing=2 cellpadding=2 >
  <col align="center">
  <tr>
    <td align="left"><A HREF="http://www.soest.hawaii.edu" target="_blank"> <IMG SRC="../soest_uhm_transp.png" BORDER=0 ALT="SOEST"></A></td>
    <td align="right"><A HREF="http://www.earthbyte.org" target="_blank"> <IMG SRC="../EarthByte_webaddress.png"  WIDTH="50%" BORDER=0 ALT="EarthByte"></A></td>
  </tr>
</table>
</BODY>
</HTML>
EOF

# Place png files
#cp ../ADMIN/PNG.png $DIR
cp ../ADMIN/ZIP.png $DIR
cp ../ADMIN/KML.png $DIR
cp ../ADMIN/GMT.png $DIR
cp ../ADMIN/DOI.png $DIR
cp ../ADMIN/PNG.png $DIR
chmod -R og+r $TO
