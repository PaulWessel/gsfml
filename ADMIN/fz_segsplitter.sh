#!/bin/bash
#
# Takes a multiseg file and splits it into individual segment files,
# then adds a cvs ID header and segment header to each one
# Requires GMT 5 (gmtspatial)

if [ $# -ne 4 ]; then
        echo "Usage: fz_segsplitter.sh FILE CLASS DIG SUB" >&2
        echo "  FILE is the multisegment file with all the traces" >&2
        echo "  CLASS is one of FZ|FZLC|DZ|VANOM|UNCV|PR|ER" >&2
        echo "  DIG is directory abbreviation for this submitter" >&2
        echo "  SUB is the number of this digitizers submission" >&2
        exit 1
fi

# Assign input arguments
FILE=$1
CLASS=$2
DIG=$3
SUB=`echo $4 | awk '{printf "%.4.4d\n", $1}'`

echo "1. Extract individual FZ segments" >&2
gmtconvert $FILE -D${CLASS}_${DIG}_${SUB}-%4.4d.tmp
echo "2. Prepend CVS tag and segment header" >&2
for file in ${CLASS}_${DIG}_${SUB}-*.tmp; do
	label=`basename $file .tmp`
	echo "# \$Id\$" > ${label}.txt
	gmtconvert -L $file | awk '{printf "> -I%s %s -T%s\n", "'${label}'", substr($0,3), "'${DIG}'"}' >> ${label}.txt
	cat $file | grep -v '>' >> ${label}.txt
done
echo "3. Clean up" >&2
rm -f ${CLASS}_${DIG}_${SUB}-*.tmp
