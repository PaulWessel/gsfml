#!/bin/sh
#
# Makes a global Mercator map of VGG and all digitized fabric
# and magnetic pics registered to date
# at full original datagrid resolution (1 arc min)
now=`date +"%e %B, %Y"`
VERSION=1.0
VGGVER=24
DPI=600
map=GSFML_map
ps=$map.ps
cat << EOF > /tmp/cpt
FZ	red
FZLC	orange
PR	yellow
ER	cyan
DZ	green
VANOM	magenta
UNCV	white
EOF
# We work on a copy of the release in a tmp dir
SFDIR=../SFDATA/SF/DATA
MLDIR=../MLDATA/ML/DATA
DIR=/tmp/GSFML
mkdir -p $DIR
tar xjf $SFDIR/GSFML_SF.tbz -C $DIR

# Since scale of 0.1 is not applied we change the cpt instead
#makecpt -Cgray -T-60/60/5 -Z > z.cpt
gmt makecpt -Cgray -T-600/600/50 -Z > z.cpt
gmt set PROJ_ELLIPSOID Sphere
#gmt psbasemap -R0/420/-144/144 -Glightgray -Jx0.1i -Y0.5i -P --PS_MEDIA=44ix31.4i -K > $ps
if [ ! -f ${map}_image.ps.bz2 ]; then
	VGG=`gmt which curv.${VGGVER}.1.img`
	# 2. Make fake GMT grid header to use with img files. The 144
	#    comes from LAT2IMG(80.738).  We use dd to get the header
	#    which has size 892 bytes.
	gmt grdmath -R0/360/-144/144 -I1m -r 0 = t.bs=bs; dd if=t.bs of=h.b count=1 bs=892
	# Prepend the header to each img file and make new GMT grids.
	# My img files are the default big-endian so I must swab first.
	# (If swabbing is not needed then just cat the original files)
	cp h.b vgg.i2; dd if=$VGG of=tmp conv=swab; cat tmp >> vgg.i2
	gmt grdimage vgg.i2=bs -Cz.cpt -Jx0.1i -Y0.5i -P --PS_MEDIA=44ix31.4i -K > ${map}_image.ps
	gmt grdimage vgg.i2=bs -R0/60/-144/144 -Cz.cpt -Jx0.1i -X36i -O -K >> ${map}_image.ps
	bzip2 -9 ${map}_image.ps
	rm -f vgg.i2 h.b tmp t.bs
fi
bzip2 -dc ${map}_image.ps.bz2 > $ps

for X in FZ FZLC PR ER DZ VANOM UNCV; do
	color=`grep $X /tmp/cpt | cut -f2 | head -1`
	# plot SF lines
	ls $DIR/GMT/GSFML_SF_${X}_*.gmt > t.lis
	while read file; do
		gmt psxy $file -R0/360/-80.738/80.738 -Jm0.1i -X-36i -O -K -Wfaint,$color >> $ps
		gmt psxy $file -R0/60/-80.738/80.738 -Jm0.1i  -X36i  -O -K -Wfaint,$color >> $ps
	done < t.lis
	# plot SF guide points
	while read file; do
		gmt psxy $file -R0/360/-80.738/80.738 -Jm0.1i -X-36i -O -K -Sc0.015i -Gblue >> $ps
		gmt psxy $file -R0/60/-80.738/80.738  -Jm0.1i -X36i  -O -K -Sc0.015i -Gblue >> $ps
	done < t.lis
done
# Plot magnetic picks using a colorscale
gmt makecpt -Crainbow -T0/160/5 -Z > mag.cpt
#ls $DIR/GSFML_ML_*.gmt > t.lis
#while read file; do
#	mlconverter $file | gmt psxy -R0/360/-80.738/80.738 -Jm0.1i -X-36i -O -K -St0.015i -Cmag.cpt >> $ps
#	mlconverter $file | gmt psxy -R0/60/-80.738/80.738  -Jm0.1i -X36i  -O -K -St0.015i -Cmag.cpt >> $ps
#done < t.lis
gmt psxy $MLDIR/GSFML.global.picks.gmt -a2=GeeK2007 -R0/360/-80.738/80.738 -Jm0.1i -X-36i -O -K -St0.015i -Cmag.cpt >> $ps
gmt psxy $MLDIR/GSFML.global.picks.gmt -a2=GeeK2007 -R0/60/-80.738/80.738  -Jm0.1i -X36i  -O -K -St0.015i -Cmag.cpt >> $ps
# plot continents
gmt pscoast -R0/360/-80.738/80.738 -Jm0.1i -X-36i -O -K -B60f30WSN -Gnavajowhite4 -Wfaint -A1000 -Dh >> $ps
gmt pscoast -R0/60/-80.738/80.738  -Jm0.1i -X36i  -O -K -B60f30ESN -Gnavajowhite4 -Wfaint -A1000 -Dh >> $ps
# Do legend
gmt pslegend -Dg60/-80.738+w5i/2.6i+jBR+o0.5i/0.5i -R -J -F+i+ggray -O -K --FONT_ANNOT_PRIMARY=20p << EOF >> $ps
H 24 Helvetica GSFML Map Legend
D 0.2i 1p
G 0.1i
N 2
S 0.4i - 0.6i - 2.5p,red 1i FZ
S 0.4i - 0.6i - 2.5p,orange 1i FZLC
S 0.4i - 0.6i - 2.5p,yellow 1i PR
S 0.4i - 0.6i - 2.5p,cyan 1i ER
S 0.4i - 0.6i - 2.5p,green 1i DZ
S 0.4i - 0.6i - 2.5p,magenta 1i VANOM
S 0.4i - 0.6i - 2.5p,white 1i UNCV
S 0.4i - 0.6i - 2.5p,gray 1i 
D 0.2i 1p
S 0.4i c 0.2i blue 0.25p 1i SF Guide
S 0.4i t 0.2i yellow 0.25p 1i ML Pick
EOF
# Trailer
echo "0 -80.738 GSFML v $VERSION [$now]" | gmt pstext -R0/360/-80.738/80.738 -Jm0.1i -X-36i -Dj0.5i/0.5i -F+jLB+f48p,Helvetica,black -O -K >> $ps
gmt psscale -Cmag.cpt -Dx7i/3i+w12i/0.25i+h -O -K -Bx10 -By+lMa -F+pthicker+ggray --FONT_ANNOT_PRIMARY=20p,Helvetica,black >> $ps
gmt psxy -R -J -O -T >> $ps
#gmt psconvert -Tj -E$DPI $ps -V -A
#mv ${map}.jpg ${map}_full.jpg
gmt psconvert -Tf $ps -V -A -P
gmt psconvert -Tj -E30 $ps -V -A
mv ${map}.jpg ${map}_small.jpg
open ${map}.pdf
rm -rf $ps z.cpt mag.cpt $DIR gmt.conf t.lis
