#!/bin/sh
#	$Id: fz_reformatter.sh,v 1.4 2011/04/19 22:33:13 myself Exp $
# We convert an incoming KML file to TXT

if [ $# -ne 3 ]; then
        echo "Usage: fz_reformatter.sh KMLFILE CLASS DIG" >&2
        echo "  FILE is the KML file with all the FZs" >&2
        echo "  CLASS is one of FZ|FZLC|DZ|VANOM|UNCV|PR" >&2
        echo "  DIG is directory abbreviation for this submitter" >&2
        exit 1
fi

# Assign input arguments
FILE=$1
CLASS=$2
DIG=$3

gmt kml2gmt $FILE > ${CLASS}_${DIG}_raw.txt
echo "Created ${CLASS}_${DIG}_raw.txt - Examine for proper formatting" >&2
