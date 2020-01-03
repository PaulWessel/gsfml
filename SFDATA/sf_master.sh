#!/bin/sh
# Create a new version of the master SF table

grep -v '^#' SF_Digitizers.txt > /tmp/$$.dig
cat << EOF > SF_Master.txt
# Created by fz_master.sh
# Contains a current list of all seafloor fabric segment files from all submitters
# These have been checked and are all unique within each submitter
#
# file	version	date	west	east	south	north
EOF
while read DIR stuff; do
	echo "Examining directory $DIR"
	(ls $DIR/*_${DIR}_*.txt > /tmp/$$.lis) 2> /dev/null
	while read file; do
		wesn=`minmax $file -fg -C`
		version=`head -1 $file | awk '{print $4}'`
		date=`head -1 $file | awk '{printf "%sT%s\n", $5, $6}' | tr '/' '-'`
		echo "$file $version $date $wesn" >> SF_Master.txt
	done < /tmp/$$.lis
done < /tmp/$$.dig
rm -f /tmp/$$.*
