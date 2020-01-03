#!/bin/bash
. gmt_shell_functions.sh

get_tag() {	# Returns things like DZ, FZ, FZLC, etc
	basename $1 ".txt" | awk -F_ '{print $NF}'
}
get_author() {	# Returns full author name and affiliation
	tag=`get_tag $1`
	awk -F'\t' '{if ($1 == "'$tag'") print $2}' ${TOP}/SF_Digitizers.txt
}

cd ..
TOOL=`ls gmt-gsfml-*-src.tar.bz2`
cd SFDATA
grep -v '^#' SF_Digitizers.txt | cut -f1 > dig.lis
day=`date +%Y-%m-%d`
now=`date +"%e %B, %Y"`
name=GSFML_SF
TOP=`pwd`
DIR=SF	# Where we will place all files
# Actual URL we will use:
TOP_URL=http://www.soest.hawaii.edu/PT/GSFML
URL=${TOP_URL}/SF/DATA

# 1. Make the SFDATA web directory
TO=$TOP/$DIR
DATA=$TO/DATA
rm -rf $TO
mkdir -p $DATA

# 2. Make the index.html file for this dir
cat << EOF > $TO/index.html
<HTML>
<!--  Created $now  -->
<TITLE>Global Seafloor Fabric</TITLE>
<BODY bgcolor="#f5fff5">
<CENTER><H2>Global Seafloor Fabric</H2>
<H4>PIs: P. Wessel (SOEST, U of Hawaii) and R. D. M&uuml;ller (U of Sydney)<BR>
Contributors: K. Matthews (U of Sydney), J. Whittaker (U of Tasmania), R. Myhill (U Bayreuth), M. T. Chandler (U of Hawaii)<BR>

<H5>Updated $now</H5>
<IMG SRC="../FZ.png" ALT="North Atlantic Fracture Zone" width="600">
</CENTER>
<HR>
<H3>What is this site?</H3>
This is a collection of seafloor fabric lineations, including fracture zones, extinct ridges, V-anomalies,
discordant zones, and propagating rifts.
<HR>
<H3>Available Data</H3>
The latest snapshot of the sea floor fabric data base can be found here in three different file formats:
<OL>
	<LI><img src="GMT.png"><A HREF="${URL}/GSFML_SF.tbz"> OGR/GMT multisegment files (as bzipped tarball)</A>.
	<LI><img src="KMZ.png"><A HREF="${URL}/GSFML_SF.kmz"> KMZ Google Earth files</A>.
	<LI><img src="ZIP.png"><A HREF="${URL}/GSFML_SF.zip"> ESRI Shapefile files (as zipped archive)</A>.
</OL>
EOF
if [ -s $TOP/SF_news.html ]; then
	cat $TOP/SF_news.html >> $TO/index.html
fi
cat << EOF >> $TO/index.html
<HR>
<H3>Available Software</H3>
The software used to refine seafloor fabric traces from guide points and VGG grids and to convert Chron names to actual
ages using magnetic timescales is available as a custom GMT 5.x supplement.
Thus, you must install <A HREF="http://gmt.soest.hawaii.edu"> GMT</A> (5.2 or later) before building
the GSFML supplement.  After GMT 5.x is installed and in your path you can
download the <A HREF="${TOP_URL}/$TOOL"> GSFML supplement for GMT 5.x</A>
and follow the build instructions in the README.gsfml file.  Once installed the three GSFML modules are available via
the gmt executable (and the four bash scripts will be in your executable path).
<HR>
<H3>Wish to contribute?</H3>
See <A HREF="${TOP_URL}/contribute.html" target="_blank">GSFML Participation Instructions</A>.
<HR>
<H3>References</H3>
<OL>
	<LI>Matthews, K. J., R. D. M&uuml;ller, P. Wessel, and J. M. Whittaker (2011),
		The tectonic fabric of the ocean basins,
		<I><A HREF="http://dx.doi.org/doi:10.1029/2011JB008413" target="_blank"> J. Geophys. Res., 116(B12109)</A></I>.
		The data set analyzed in this paper is a snapshot of the database  as of 2011 and has been preserved on the
		<A HREF="ftp://ftp.earthbyte.org/earthbyte/Seafloor_Tectonic_Fabric">EarthByte ftp site</A>.</LI>
	<LI>Wessel, P., K. J. Matthews, R. D. M&uuml;ller, A. Mazzoni, J. M. Whittaker,
		  R. Myhill, and M. T. Chandler (2015), Semiautomatic fracture zone tracking,
		  <I><A HREF="http://dx.doi.org/10.1002/2015gc005853" target="_blank"> Geochemistry, Geophysics, Geosystems, doi:10.1002/2015GC005853</A></I>.
		This article discusses the Fracture zone tracking software which is available as a GMT 5.2 supplement.</LI>
	
</OL>
<HR>
<I>Maintained by <a href="mailto:pwessel@hawaii.edu?Subject=GSFML%20Project" target="_top">Paul Wessel</a></I><BR>
<table border=0 cellspacing=2 cellpadding=2 >
  <col align="center">
  <tr>
  <td align="left"><A HREF="http://www.soest.hawaii.edu" target="_blank"> <IMG SRC="../../soest_uhm_transp.png" BORDER=0 ALT="SOEST"></A></td>
  <td align="right"><A HREF="http://www.earthbyte.org" target="_blank"> <IMG SRC="../EarthByte_webaddress_transp.png"  WIDTH="50%" BORDER=0 ALT="EarthByte"></A></td>
  </tr>
</table>
</BODY>
</HTML>
EOF

# Place png files
cp ../ADMIN/ZIP.png $DIR
cp ../ADMIN/KMZ.png $DIR
cp ../ADMIN/GMT.png $DIR
chmod -R og+r $TO

# 3. Make the data distribution files for this dir

grep -v '^#' SF_Digitizers.txt > authors.lis
cat << EOF > t.html
This is a $day snapshot of the Global Seafloor Fabric and Magnetic Lineation
data base [SF component].  The contributors to this release are:<p><ol>
EOF
awk '{printf "<li>%s</li>\n", $0 }' authors.lis >> t.html
echo "</ol>" >> t.html
mv t.html $DATA

# First compile all the txt version of the features

echo "Build $name GMT txt data files"
while read DIR; do
	for X in FZ FZLC PR ER DZ VANOM UNCV; do
	#for X in FZ; do
		(ls $DIR/${X}_${DIR}_*.txt > /tmp/$$.lis) 2> /dev/null
		if [ -s /tmp/$$.lis ]; then	# Got some files. Add all lines from one author to a single author file, and append that to the type file
			cat $DIR/${X}_${DIR}_*.txt > $DATA/${name}_${X}_${DIR}.txt
			#cat $DATA/${name}_${X}_${DIR}.txt >> $DATA/${name}_${X}.txt
		fi
	done		
done < dig.lis

# OK, given these txt version we can build the others

echo "Convert $name GMT txt data to OGR/GMT, KML, and SHP formats"

cat << EOF > /tmp/cpt
FZ	red
FZLC	orange
PR	yellow
ER	cyan
DZ	green
VANOM	magenta
UNCV	white
EOF

first=1
cd $DATA
rm -f total.lis
mkdir -p GMT KMZ SHP
gmt gmt2kml -Fl -W1p,${color} /dev/null -Dt.html -T${NAME} > KMZ/top.kml
for X in FZ FZLC PR ER DZ VANOM UNCV; do
#for X in FZ; do
	color=`grep $X /tmp/cpt | cut -f2 | head -1`
	(ls ${name}_${X}_*.txt | awk -F. '{print $1}' > /tmp/$$.lis) 2> /dev/null
	n=`gmt_nrecords /tmp/$$.lis`
	let rec=0
	while read prefix; do
		let rec=rec+1
		if [ $first -eq 1 ]; then
			OK="-K"
			D="-Dt.html"
		elif [ $X = UNCV ] && [ $rec -eq $n ]; then
			OK="-O"
		else
			OK="-O -K"
			D=""
		fi
		tag=`get_tag $prefix.txt`
		author=`get_author $prefix.txt`
		cat <<- EOF > x.html
		The Global Seafloor Fabric and Magnetic Lineation Project<br>
		Feature type: $X.   Contribution by $tag [$author].<br>
		See <a href="${TOP_URL}"> GSLML home page</a>
		EOF
		gmt convert $prefix.txt -fg -aI=ID:string,L=Name:string,T=Author:string+GLINE > $prefix.gmt
		gmt 2kml -Fl -W1p,${color} $prefix.gmt -T"$X-${tag}"/"$author" -Dx.html > KMZ/$prefix.kml
		gmt 2kml -Fl -W1p,${color} $prefix.gmt -T"$X-${tag}"/"$author" $D $OK >> KMZ/${name}.kml
		rm -f $prefix.txt ?.html
		ogr2ogr -f "ESRI shapefile" $prefix.shp $prefix.gmt
		mv $prefix.gmt GMT
		first=0
		echo $prefix.txt >> total.lis
	done < /tmp/$$.lis
done
mv total.lis ~
# Create one dir SHP with all shapefiles
mv *.* SHP
cd SHP; chmod og+r *; cd ..
zip -r ${name}.zip SHP
# Create one dir KMZ with all KML files
cd KMZ
chmod og+r *
zip -r ${name}.kmz ${name}.kml
mv ${name}.kmz ..
cd ..
# Create one dir GMT with all GMT/OGR files
cd GMT; chmod og+r *; cd ..
tar cjvf ${name}.tbz GMT
# Now make one file per data type
mv -f SHP SHP_all
mv -f GMT GMT_all
mv -f KMZ KMZ_all
for X in FZ FZLC PR ER DZ VANOM UNCV; do
	mkdir SHP GMT KMZ
	mv SHP_all/*_${X}_*.* SHP
	zip -r ${name}_${X}.zip SHP
	mv KMZ_all/*_${X}_*.* KMZ
	zip -r ${name}_${X}.kmz KMZ
	mv GMT_all/*_${X}_*.* GMT
	tar cjvf ${name}_${X}.tbz GMT
	rm -rf SHP KMZ GMT
done
rm -rf SHP_all GMT_all KMZ_all
chmod og+r ${name}.kmz ${name}.tbz ${name}.zip ${name}_*.kmz ${name}_*.tbz ${name}_*.zip
cd $TOP
rm -f dig.lis ?.html authors.lis /tmp/$$.lis /tmp/cpt
