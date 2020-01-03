#!/bin/sh
#	$Id$
# Read list of files to be updated and do the processing

if [ $# -ne 1 ]; then
        echo "Usage: fz_update.sh list"
        echo "  list is a list with new and old file pairs"
        exit 1
fi

# Assign input arguments
LIST=$1
if [ ! -f ${LIST} ]; then
        echo "Cannot find ${LIST}"
        exit 1
fi
	
while read new old; do
	echo "Update $old with content from $new"
	head -n 2 $old > tmp.txt
	tail -n +3 $new >> tmp.txt
	mv -f tmp.txt $old
done < $LIST
echo "You must now svn commit the changes"
