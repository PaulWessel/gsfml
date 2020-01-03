#!/bin/sh
# $Id: fz_dupchecker.sh,v 1.9 2011/04/19 22:33:13 myself Exp $
# Check if the new submission contains duplicates within itself
# and if it contains revisions to FZ segments already in the
# database from a prior submission by this submitter.
# Requires GMT 5 (gmtspatial)
# Set this to be top-level SF DATA dir
SFDATA=/Users/pwessel/UH/RESEARCH/CVSPROJECTS/gsfml/SFDATA

DLIM=+d10k	# 10 km max separation
CLIM=+c0.05+p	# Ratio of 5%; only count inside points
DLIM=+d5k	# 10 km max separation
CLIM=+c0.02+p	# Ratio of 2%; only count inside points

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

gmt convert ${CLASS}_${DIG}_${SUB}-*.txt > ${CLASS}_${DIG}_trial.txt
ls ${CLASS}_${DIG}_${SUB}-*.txt > ${CLASS}_${DIG}_trial.lst

echo "1. Look for duplicates within new submission" >&2

# Use 10 km limit on min distance and closeness ${CLIM}
gmt gmtspatial ${CLASS}_${DIG}_trial.txt -D${DLIM}${CLIM} -fg -V > ${DIG}_dup.txt

if [ -s ${DIG}_dup.txt ]; then
	echo "Found some potential duplicates within submission. Examine manually" >&2
	echo "Command was: gmt gmtspatial ${CLASS}_${DIG}_trial.txt -D${DLIM}${CLIM} -fg -V" >&2
	echo "" >&2
	cat ${DIG}_dup.txt >&2
	exit
else
	echo "No duplicates found within submission." >&2
fi

echo "2. Look for revisions within submission" >&2

# Convert all prior submissions by this submitter to a single file ${CLASS}_${DIG}_reference.txt

(ls ${SFDATA}/$DIG/${CLASS}_${DIG}_*-*.txt > ${CLASS}_${DIG}_reference.lst) 2> /dev/null
if [ ! -s ${CLASS}_${DIG}_reference.lst ]; then
	echo "No earlier files found"
	exit
fi

gmt convert ${SFDATA}/$DIG/${CLASS}_${DIG}_*-*.txt > ${CLASS}_${DIG}_reference.txt

# Again, set 10 km limit on min distance and closeness of ${CLIM}

gmt gmtspatial ${CLASS}_${DIG}_trial.txt -D+f${CLASS}_${DIG}_reference.txt${DLIM}${CLIM} -fg -Vl > ${DIG}_dup.txt
if [ -s ${DIG}_dup.txt ]; then
	echo "Found some potential updated versions within submission. Examine manually" >&2
	echo "Command was: gmt gmtspatial ${CLASS}_${DIG}_trial.txt -D+f${CLASS}_${DIG}_reference.txt${DLIM}${CLIM} -fg -Vl" >&2
	echo "" >&2
	cat ${DIG}_dup.txt >&2
	# Generate lists of files to add and files to update
	# First grep records starting with N as those are the lines not present in the database and hence new entries:
	grep '^N' ${DIG}_dup.txt | awk '{printf "%dp\n", $7+1}' > tmp.lis
	rm -f new_traces.lis
	while read line; do
		sed -n ${line} ${CLASS}_${DIG}_trial.lst >> new_traces.lis
	done < tmp.lis
	# Then get anything but those and exact duplicates, and add 1 to segment numbers to get record number in ${CLASS}_${DIG}_reference.lst
	egrep -v 'exact|^N' ${DIG}_dup.txt | awk '{printf "%dp\n", $18+1}' > tmp.lis
	# Then print just those records which are original files to be modified
	rm -f old.lis
	while read line; do
		sed -n ${line} ${CLASS}_${DIG}_reference.lst >> old.lis
	done < tmp.lis
	# Finally, print the filenames with the revised information
	egrep -v 'exact|^N' ${DIG}_dup.txt | awk '{printf "%dp\n", $7+1}' > tmp.lis
	rm -f new.lis
	while read line; do
		sed -n ${line} ${CLASS}_${DIG}_trial.lst >> new.lis
	done < tmp.lis
	paste new.lis old.lis > revised_traces.lis
	rm -f tmp.lis old.lis new.lis
fi
