#!/bin/bash
#
# Script to convert incoming shapefiles to OGR for storing in database
# It now expects incoming arcGIS filenames to be of the format
#	[GSFML.]<reftag>[.picks].{dbf,prj,sbn,sbx,shp,shx}
# We also copy any files containing "readme" in its name.

if [ $# -ne 2 ]; then
	echo "usage: shp2gmt indir outdir" >&2
	exit
fi
FROM=$1	# Where we look for incoming dirs with files
TO=$2	# Where to write the output OGR files

if [ ! -d $FROM ]; then
	echo "shp2gmt Error: Directory $FROM does not exist" >&2
	exit
fi

mkdir -p $TO
if [ ! -d $TO ]; then
	echo "shp2gmt Error: Directory $TO could not be created" >&2
	exit
fi

# Compile our enforcerer tool
gcc enforcerer.c -g -o enforcerer
# Find list of all dirs
TOP=`pwd`
cd $FROM
find . -type d -print | sed -e s'B\./BBg' > $TOP/d.lis
cat $TOP/d.lis
while read dir; do
	cd $FROM
	echo "Process dir $dir"
	if [ "$dir" = "." ]; then
		out=$TOP/$TO
	else
		cd $dir
		out=$TOP/$TO/$dir
		mkdir -p $out
	fi
	ls *.shp > $TOP/files.lis
	while read name; do
		prefix=`basename $name ".shp"`
		ogr2ogr -mapFieldType Integer64=Integer -f "OGR_GMT" $out/$prefix.gmt $name
		newname=`echo $prefix | awk -F. '{ if (NF == 3 && $1 == "GSFML" && $3 == "picks") {printf "%s\n", $2} else print $0}'`
		mv -f $out/$prefix.gmt $out/$newname.gmt_raw
		$TOP/enforcerer $out/$newname.gmt_raw > $out/$newname.gmt
	done < $TOP/files.lis
	cp -f *readme* $out
done < $TOP/d.lis
cd $TOP
rm -f d.lis files.lis enforcerer
rm -rf enforcerer.dSYM
echo "These are the IDMethod items found in this submission:"
find $TO -name '*.gmt' -exec grep '@D' {} \; | awk -F'|' '{print $NF}' | sort -u
echo " "
echo "Here are IDMethod items already in the database:"
echo " "
grep "@D" {AtlanticOcean,IndianOcean,Marginal_BackarcBasins,PacificOcean}/*.gmt | awk -F'|' '{print $NF}' | sort -u
