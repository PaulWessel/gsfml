#!/bin/sh
#
# Read the ${DIG}_dup.txt and make plots of each conflict

if [ $# -ne 3 ]; then
        echo "Usage: fz_compare.sh CLASS DIG SUB" >&2
        echo "  CLASS is one of FZ|FZLC|DZ|VANOM|UNCV|PR" >&2
        echo "  DIG is author abbreviation for this digitizer" >&2
        echo "  SUB is the number of this digitizers submission" >&2
        exit 1
fi

# Assign input arguments
CLASS=$1
DIG=$2
SUB=`echo $3 | awk '{printf "%.4.4d\n", $1}'`

if [ ! -f ${CLASS}_${DIG}_trial.txt ]; then
        echo "Cannot find ${CLASS}_${DIG}_trial.txt (fz_dupchecker.sh not run?)" >&2
        exit 1
fi
	
if [ ! -f ${CLASS}_${DIG}_reference.txt ]; then
        echo "Cannot find ${CLASS}_${DIG}_reference.txt (fz_dupchecker.sh not run?)" >&2
        exit 1
fi
	
if [ ! -f ${DIG}_dup.txt ]; then
        echo "Cannot find ${DIG}_dup.txt (fz_dupchecker.sh not run?)" >&2
        exit 1
fi
	
if [ ! -f ${CLASS}_${DIG}_reference.lst ]; then
        echo "Cannot find ${CLASS}_${DIG}_reference.lst (fz_dupchecker.sh not run?)" >&2
        exit 1
fi
	
# Pull out the important segment info and stats from ${DIG}_dup.txt

awk '{printf "%s %s %s %s %s %s\n", $1, $9, $20, $30, $33, $36}' ${DIG}_dup.txt > ${DIG}_dup_summary.txt

# Process each of the conflicts and make a simple Mercator plot
# Lightblue, fat lines are the reference, thin red the new data

while read kind S Sp d c s; do
	IDS=`echo $S | awk '{printf "%.4.4d\n", $1}'`
	IDSp=`echo $Sp | awk '{printf "%.4.4d\n", $1}'`
	line=`expr $Sp + 1`
	orig_file=`sed -n ${line}p ${CLASS}_${DIG}_reference.lst`
	R=`cat ${CLASS}_${DIG}_${SUB}-${IDS}.txt $orig_file | minmax -I2 -fg`
	if [ $kind = "-" ]; then
		type=subset
	elif [ $kind = "+" ]; then
		type=superset
	elif [ $kind = "~" ]; then
		type=revision
	else
		type=unknown
	fi
	echo "Make DUP_${IDS}-${IDSp}.ps" >&2
	pscoast $R -JM6.5i+ -P -K -B2:."${CLASS}_${DIG}_${SUB}_${IDS}.txt may be a $type of $orig_file":WSne -Gblack -Xc -Yc -U"d = $d c = $c s = $s" --FONT_TITLE=14p > DUP_${IDS}-${IDSp}.ps
	psxy -R -J -O -K $orig_file -W4p,lightgray >> DUP_${IDS}-${IDSp}.ps
	psxy -R -J -O ${CLASS}_${DIG}_${SUB}-${IDS}.txt -W0.25p >> DUP_${IDS}-${IDSp}.ps
done < ${DIG}_dup_summary.txt
echo "Convert all PS to PDF and merge into a single file ${DIG}_${SUB}.pdf" >&2
ps2raster -V -TF -F${DIG}_${SUB}.pdf DUP_*-*.ps
rm -f DUP_*-*.ps
