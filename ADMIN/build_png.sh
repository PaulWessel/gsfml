#!/bin/bash
# Build the various KML PNG png images
# Open in Photoshop, change width to 38 pixels, then enlarge canvas in y-dir to 14
echo 0 0 @%34%\\344@%% PNG | gmt pstext -R-1/1/-0.5/0.5 -Jx1i -F+f36p,Helvetica-Bold,red -P > PNG.ps
gmt psconvert -P -A -TG PNG.ps
echo 0 0 @%34%\\344@%% ZIP | gmt pstext -R-1/1/-0.5/0.5 -Jx1i -F+f36p,Helvetica-Bold,blue -P > ZIP.ps
gmt psconvert -P -A -TG ZIP.ps
echo 0 0 @%34%\\344@%% KML | gmt pstext -R-1/1/-0.5/0.5 -Jx1i -F+f36p,Helvetica-Bold,darkgreen -P > KML.ps
gmt psconvert -P -A -TG KML.ps
echo 0 0 @%34%\\344@%% KMZ | gmt pstext -R-1/1/-0.5/0.5 -Jx1i -F+f36p,Helvetica-Bold,darkgreen -P > KMZ.ps
gmt psconvert -P -A -TG KMZ.ps
echo 0 0 @%34%\\344@%% GMT | gmt pstext -R-1/1/-0.5/0.5 -Jx1i -F+f36p,Helvetica-Bold,red -P > GMT.ps
gmt psconvert -P -A -TG GMT.ps
echo 0 0 @%34%\\344@%% DOI | gmt pstext -R-1/1/-0.5/0.5 -Jx1i -F+f36p,Helvetica-Bold,black -P > DOI.ps
gmt psconvert -P -A -TG DOI.ps
rm -f ???.ps
