#!/bin/bash
#
# Script to convert all existing *.gmt files to the new format
# where the doi is included among the aspatial fields.
# This is presumably a one-time deal since going forwards we
# expect new files to come with dois.  We did the one-time
# job on Oct-22-2014 so this is just kept as documentation of
# what we did.  Paul Wessel.

if [ $# -ne 2 ]; then
	echo "usage: newformat indir outdir" >&2
	exit
fi
FROM=$1	# Where we look for incoming dirs with files
TO=$2	# Where to write the output modified files

mkdir -p $TO

# Find list of all dirs
gcc reformatter.c -g -o reformatter
TOP=`pwd`
cd $FROM
cat << EOF > $TOP/d.lis
AtlanticOcean
IndianOcean
Marginal_BackarcBasins
PacificOcean
EOF
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
	ls *.gmt > $TOP/files.lis
	while read name; do
		prefix=`basename $name ".gmt"`
		DOI=`grep $prefix References.txt | awk -F'|' '{if (substr($3,1,4) == "doi:") {print substr($3,5,length($3)-4)} else {print $3}}'`
		echo "Add DOI [$DOI] to $name"
		$TOP/reformatter $DOI < $name > $out/$name
	done < $TOP/files.lis
done < $TOP/d.lis
cd $TOP
rm -f d.lis files.lis
