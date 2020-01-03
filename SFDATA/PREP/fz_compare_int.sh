#!/bin/sh
#	$Id: fz_compare.sh,v 1.7 2010/08/19 22:13:47 myself Exp $
# Read the ${DIG}_dup.txt and make plots of each conflict

if [ $# -ne 2 ]; then
        echo "Usage: fz_compare.sh DIG submission"
        echo "  DIG is directory abbreviation for this digitizer"
        exit 1
fi

# Assign input arguments
DIG=$1
SUB=`echo $2 | awk '{printf "%.4.4d\n", $1}'`

if [ ! -f FZ_${DIG}_trial.txt ]; then
        echo "Cannot find FZ_${DIG}_trial.txt (fz_dupchecker.sh not run?)"
        exit 1
fi
	
if [ ! -f ${DIG}_dup.txt ]; then
        echo "Cannot find ${DIG}_dup.txt (fz_dupchecker.sh not run?)"
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
	R=`cat FZ_${DIG}_${SUB}-${IDS}.txt FZ_${DIG}_${SUB}-${IDSp}.txt | minmax -I2 -fg`
	if [ $kind = "-" ]; then
		type=subset
	elif [ $kind = "+" ]; then
		type=superset
	elif [ $kind = "~" ]; then
		type=revision
	else
		type=unknown
	fi
	echo "Make DUP_${IDS}-${IDSp}.ps"
	pscoast $R -JM6.5i+ -P -K -B2:."FZ_${DIG}_${SUB}_${IDS}.txt may be a $type of FZ_${DIG}_${SUB}-${IDSp}.txt":WSne -Gblack -Xc -Yc -U"d = $d c = $c s = $s" --FONT_TITLE=14p > DUP_${IDS}-${IDSp}.ps
	psxy -R -J -O -K FZ_${DIG}_${SUB}-${IDSp}.txt -W4p,lightgray >> DUP_${IDS}-${IDSp}.ps
	psxy -R -J -O FZ_${DIG}_${SUB}-${IDS}.txt -W0.25p >> DUP_${IDS}-${IDSp}.ps
done < ${DIG}_dup_summary.txt
echo "Convert all PS to PDF and merge into a single file ${DIG}_${SUB}.pdf"
ps2raster -V -TF -F${DIG}_${SUB}.pdf DUP_*-*.ps
rm -f DUP_*-*.ps
