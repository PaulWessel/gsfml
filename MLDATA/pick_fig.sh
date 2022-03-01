#!/bin/bash
# Makes a small map showing the picks for this .gmt file
. gmt_shell_functions.sh
D=$1
ps=$D.ps
WESN=(`gmt info -I1 $D -fg -C`)
C=`gmt math -Q ${WESN[0]} ${WESN[1]} ADD 2 DIV =`
gmt makecpt -Crainbow -T0/160/5 -Z > mag.cpt
if [ ${WESN[3]} -eq 90 ]; then
	R=-R${WESN[0]}/${WESN[1]}/${WESN[2]}/90
	J=-JA$C/90/6i+
	B=-BWSne
	y=-0.35i
elif [ ${WESN[2]} -eq -90 ]; then
	R=-R${WESN[0]}/${WESN[1]}/-90/${WESN[3]}
	J=-JA$C/-90/6i+
	B=-BWNse
	y=-0.25i
else
	R=-R${WESN[0]}/${WESN[1]}/${WESN[2]}/${WESN[3]}
	J=-JM6i+
	B=-BWNse
	y=-0.25i
fi
gmt pscoast $R $J -Baf $B -Gblack -Da -Slightgray -K --FORMAT_GEO_MAP=dddF > $ps
gmt psxy -R -J -O -K @ridge.txt -W0.5p >> $ps
gmt psxy $D -a2=GeeK2007 -R -J -O -K -Sc0.1c -Cmag.cpt >> $ps
W=`gmt_map_width -R -J`
X=`gmt math -Q $W 2 DIV =`
L=`gmt math -Q $W 0.85 MUL =`
gmt psscale -Cmag.cpt -D${X}c/${y}/${L}c/0.15ih -O -K -Bxaf -By+lMa >> $ps
gmt psxy -R -J -O -T >> $ps
gmt psconvert $ps -Tg -E100 -P -A
rm -f $ps mag.cpt gmt.history
echo "Created $ps and ripped to PNG"
