#!/bin/sh
#
# Check if the new submission contains duplicates within itself
# and if it contains revisions to FZ segments already in the
# database from a prior submission by this submitter.
# Requires GMT 5 (gmtspatial)

DLIM=+d10k	# 10 km max separation
CLIM=+c0.05+p	# Ratio of 5%; only count inside points

if [ $# -ne 3 ]; then
        echo "Usage: fz_dupchecker.sh CLASS DIG SUB" >&2
        echo "  CLASS is one of FZ|FZLC|DZ|VANOM|UNCV|PR" >&2
        echo "  DIG is directory abbreviation for this digitizer" >&2
        echo "  SUB is the number of this digitizers submission" >&2
        exit 1
fi

# Assign input arguments
CLASS=$1
DIG=$2
SUB=`echo $3 | awk '{printf "%.4.4d\n", $1}'`

# Convert all the individual FZ segment to a trial multisegment file ${CLASS}_${DIG}_trial.txt

gmtconvert ${CLASS}_${DIG}_${SUB}-*.txt > ${CLASS}_${DIG}_trial.txt

echo "1. Look for duplicates within new submission" >&2

# Use 10 km limit on min distance and closeness ${CLIM}
gmtspatial ${CLASS}_${DIG}_trial.txt -D${DLIM}${CLIM} -fg -V > ${DIG}_dup.txt

if [ -s ${DIG}_dup.txt ]; then
	echo "Found some potential duplicates within submission. Examine manually" >&2
	echo "" >&2
	cat ${DIG}_dup.txt >&2
	exit
else
	echo "No duplicates found within submission." >&2
fi

echo "2. Look for revisions within submission" >&2

# Convert all prior submissions by this submitter to a single file ${CLASS}_${DIG}_reference.txt

(ls ../DBASE/$DIG/${CLASS}_${DIG}_*-*.txt > ${CLASS}_${DIG}_reference.lst) 2> /dev/null
if [ ! -s ${CLASS}_${DIG}_reference.lst ]; then
	echo "No earlier files found"
	exit
fi

gmtconvert ../DBASE/$DIG/${CLASS}_${DIG}_*-*.txt > ${CLASS}_${DIG}_reference.txt

# Again, set 10 km limit on min distance and closeness of ${CLIM}

gmtspatial ${CLASS}_${DIG}_trial.txt -D+f${CLASS}_${DIG}_reference.txt${DLIM}${CLIM} -fg -V3 > ${DIG}_dup.txt
if [ -s ${DIG}_dup.txt ]; then
	echo "Found some potential updated versions within submission. Examine manually" >&2
	echo "" >&2
	cat ${DIG}_dup.txt >&2
	exit
fi
