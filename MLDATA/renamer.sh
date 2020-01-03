#!/bin/bash
# Given Nicky's zip file, do the following:
# 1. Remove all *.lock files
# 2. Rename files from GSFML.<tag>.picks.* to <tag>.*
# 3. Move files out of their dirs and delete those dirs.
# This way the files have the same name and organization
# as the files in the repository.

if [ $# -ne 2 ]; then
	echo "usage: renamer.sh indir outdir" >&2
	exit
fi
DIR=$1	# Where we look for dirs with files
OUT=$2	# Where we place revised files
TOP=`pwd`
mkdir -p $OUT
cd $DIR
cat << EOF > $TOP/d.lis
Atlantic AtlanticOcean
Indian IndianOcean
Marginal Marginal_BackarcBasins
Pacific PacificOcean
EOF
while read dirshort dir; do
	cd $DIR
	echo "Process dir $dir"
	cp -r $dirshort $TOP/$OUT
	mv $TOP/$OUT/$dirshort $TOP/$OUT/$dir 
	cd $TOP/$OUT/$dir
	# Remove any lock files
	find . -name '*.lock' -exec rm -f {} \;
	# Get list of subdirectories (one for each dataset)
	ls -d *.picks > $TOP/sub.lis
	while read name; do	# Move files out and delete sub dir
		mv -f $name/* .
		rm -rf $name
	done < $TOP/sub.lis
	# Now all files are in top subdir (i.e. Atlantic).  Rename the files
	ls GSFML.* > $TOP/file1.lis
	ls GSFML.* | sed -e 's/\.picks//g'| sed -e 's/GSFML\.//g' > $TOP/file2.lis
	paste $TOP/file1.lis $TOP/file2.lis | awk '{printf "mv -f %s %s\n", $1, $2}' | sh -s
done < $TOP/d.lis
cd $TOP
rm -f file1.lis file2.lis sub.lis d.lis reformatter
rm -rf reformatter.dSYM

