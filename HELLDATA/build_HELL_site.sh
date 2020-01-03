#!/bin/bash
#
# Script to build the HELL portion of the GSFML website
now=`date +"%e %B, %Y"`
TOP=`pwd`
DIR=HELL	# Where we will place all files
URL=http://www.soest.hawaii.edu/PT/GSFML/HELL/DATA

# 1. Make the HELL web directory
rm -rf $DIR
mkdir -p $DIR

# 2. Make the index.html file for this dir
cat << EOF > $DIR/index.html
<HTML>
<!--  Created $now  -->
<TITLE>Published Magnetic Picks and Parameters for Tectonic Reconstructions</TITLE>
<BODY bgcolor="#fff5f5">
<CENTER><H2>Published Magnetic Picks and Parameters for Tectonic Reconstruction</H2>
<H4>PIs: P. Wessel (SOEST, U of Hawaii) and R. D. M&uuml;ller (U of Sydney)<BR>
Contributors: M. Seton (U of Sydney), J. Whittaker (U of Tasmania), S. Williams (U of Sydney), N. Wright (U of Sydney)<BR>
S. C. Cande (Scripps Institution of Oceanography), J. Stock (Caltech), C. Gaina (U. Oslo), R. Granot (Ben Gurion U.)<BR></H4>
<H5>Updated $now</H5>
<IMG SRC="../HELL.png" ALT="North Atlantic Fracture Zone" width="600">
</CENTER>
<HR>
<H3>What is this site?</H3>
This is a collection of published magnetic anomaly and fracture zone picks, organized as input files
to the "hellinger" program.  Both input and output files are provided, including the parameter
files, so that users may completely reproduce the published rotations.  For more information, see<P>
Seton, M., J. Whittaker, P. Wessel, R. D. M&uuml;ller, C. DeMets, S. Merkouriev, S. Cande,
C. Gaina, G. Eagles, R. Granot, J. Stock, N. Wright, S. Williams, 2014,
	Community infrastructure and repository for marine magnetic identifications,
	<I>Geochemistry, Geophysics, Geosystems</I>, <A HREF="http://dx.doi.org/10.1002/2013GC005176" target="_blank"><img src="DOI.png" ALT="DOI lookup"> DOI:10.1002/2013GC005176</A>

<HR>
EOF
if [ -s $TOP/HELL_news.html ]; then
	cat $TOP/HELL_news.html >> $DIR/index.html
fi
cat << EOF >> $DIR/index.html
<H3>Alphabetical List of Publications with Data</H3>
The data are organized on a per publication basis.  All files released in support of a particular
publication have been collected in individual zip files and are available below. Click
<img src="ZIP.png" ALT="ZIP download"></A> to download a zip archive and use <img src="DOI.png" ALT="DOI lookup"></A>
to look up the article at the publisher.  In addition to a global compilation archive, individual files are organized per ocean basin.<P>
EOF

# 3. Create the reformatted files, make zip file, delete reformatted files
# a) Find list of all dirs
find . -name '*_*_*' -type d -maxdepth 1 -print | awk '{print substr($1,3)}' > dir.lis

# First build the files.
while read dir; do
	echo "Rebuild dir $DIR/$dir"
	sh $dir/rename.sh $DIR/DATA
	cp file_format.txt $DIR/DATA/$dir
done < dir.lis
# Make global zip
cd $TOP
zip -rq9 GSFML.Global.hellinger.zip $DIR/DATA
mv GSFML.Global.hellinger.zip $DIR/DATA
cat <<- EOF >> $DIR/index.html
<H3>Global Reconstruction Data:</H3>
<table border=1 cellspacing=2 cellpadding=4 bgcolor="#eeffee" bordercolor="black" width="800">
<tr>
<td>DOI</td>
  <td>ZIP</td>
  <td>Description</td>
</tr>
<tr>
	<td>N/A</td>
	<td><A HREF="$URL/GSFML.Global.hellinger.zip"><img src="ZIP.png" ALT="ZIP download"</A></td>
	<td>The complete global compilation to date.</td>
</tr>
</table>
<P>
EOF
# Make individual zips
while read dir; do
	cd $DIR/DATA
	zip -rq9 GSFML.$dir.hellinger.zip $dir
	cd ../..
	rm -rf $DIR/DATA/$dir
done < dir.lis

# 4. Create the website table
for ocean in "Atlantic Ocean" "Indian Ocean" "Pacific Ocean" "Marginal Basins"; do
	echo "Find data for $ocean"
	cat <<- EOF >> $DIR/index.html
	<H3>$ocean Reconstruction Data:</H3>
	<table border=1 cellspacing=2 cellpadding=4 bgcolor="#eeffee" bordercolor="black" width="800">
	<tr>
	  <td>DOI</td>
	  <td>ZIP</td>
	  <td>Complete Citation</td>
	</tr>
	EOF
	while read dir; do
		this_ocean=`grep ocean $dir/info.txt | awk -F'|' '{print $2}'`
		if [ "$this_ocean" == "$ocean" ]; then
			echo "Doing ref $dir"
			this_ref=`grep ref $dir/info.txt | awk -F'|' '{print $2}'`
			this_doi=`grep dx.doi.org $dir/rename.sh`
			cat <<- EOF >> $DIR/index.html
			<tr>
			  <td><A HREF="$this_doi" target="_blank"><img src="DOI.png" ALT="DOI lookup"></A></td>
			  <td><A HREF="$URL/GSFML.$dir.hellinger.zip"><img src="ZIP.png" ALT="ZIP download"></A></td>
			  <td>$this_ref
			  </td>
			</tr>
			EOF
		fi
	done < dir.lis
	cat <<- EOF >> $DIR/index.html
	</table>
	EOF
done
rm -f dir.lis
cat << EOF >> $DIR/index.html

<HR>
<H3>Reconstruction Software</H3>
The data files provided are designed to be used with software developed by Ted Chang and co-workers [1].  The latest
version can be downloaded as a <A HREF="http://www.soest.hawaii.edu/PT/Chang.zip">zip archive</A>.
<HR>
<H3>References</H3>
<OL>
	<LI>Kirkwood, B. H., Royer, J.-Y., Chang, T. C., and Gordon, R. G., 1999,
		Statistical tools for estimating and combining finite rotations and their uncertainties,
		<I>Geophysical Journal International, v. 137, no. 2</I>, p. 408-428.
		<A HREF="http://dx.doi.org/10.1046/j.1365-246X.1999.00787.x" target="_blank"><img src="DOI.png" ALT="DOI lookup"></A>
		</LI>
</OL>
<HR>
<I>Maintained by <a href="mailto:pwessel@hawaii.edu?Subject=GSFML%20Project" target="_top">Paul Wessel</a></I><BR>
<table border=0 cellspacing=2 cellpadding=2 >
  <col align="center">
  <tr>
  <td align="left"><A HREF="http://www.soest.hawaii.edu" target="_blank"> <IMG SRC="../soest_uhm_transp.png" BORDER=0 ALT="SOEST"></A></td>
  <td align="right"><A HREF="http://www.earthbyte.org" target="_blank"> <IMG SRC="../EarthByte_webaddress_transp.png"  WIDTH="50%" BORDER=0 ALT="EarthByte"></A></td>
  </tr>
</table>
</BODY>
</HTML>
EOF

# Place png files
cp ../ADMIN/DOI.png $DIR
cp ../ADMIN/ZIP.png $DIR
chmod -R og+r $DIR
