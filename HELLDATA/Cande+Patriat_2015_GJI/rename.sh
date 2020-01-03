#!/bin/bash -xv
# Script to rename Cande and Patriat, 2015 original files to our naming convention
# We manually renamed the pdf file using the new name
# CandePatriat2015DataFileDescription.pdf -> description.Cande+Patriat_2015_GJI.pdf
#
# Steve&Phillipe had 3 different scenarios so we make 3 directories.
# Comments from Maria email 3/18/2015:
# Table 2: AFR-ANT
# Table 3: ANT-IND/CAP
# Table 4: AFR-ANT-IND/CAP
# 
# "However, when I plot the data, there are some picks that exist on the
# African plate for Table 3, for example.  Yet the fig from their paper
# don't show those ones and it is squarely about ANT-IND/CAP.
# 
# I have IND/CAP because Steve calls it the Capricorn plate not Indian
# plate. For the time periods that we have picks for, it is just the Indian.
# But when computing finite rotations you need to include the recent
# Capricorn rotations so I think that's why Capricorn was chosen."
# Based on this I chose to use CAP below (not IND/CAP).

# Run this script from the top HELLDATA directory
REF=Cande+Patriat_2015_GJI
#-------------------
FROM=${REF}
TO=$1/${REF}
mkdir -p $TO

# Make the 3 subdirectories corresponding to the three tables:
# SWIR_2-platerots_Table2    ->   SWIR_Tbl2
# SEIR_2-platerots_Table3    ->   SEIR_Tbl3
# IOTJ_3-platerots_Table4    ->   IOTJ_Tbl4
mkdir -p $TO/SWIR_Tbl2 $TO/SEIR_Tbl3 $TO/IOTJ_Tbl4
# Place the description file
cp $FROM/description.${REF}.pdf $TO
# We must rename both data and model files.  Model files contain the name of the data file that was used
# but those names are now changed, e.g., it might say 
# ./SWIR_2-platerots_Table2/bestfit.swir.20o.out: Results from Hellinger1 using swir.20o.chang.points
# We generate a sed file to replace these names on the fly with the renamed file references.

# Doing SWIR (Table 2)
FDIR=SWIR_2-platerots_Table2
TDIR=SWIR_Tbl2
find $FROM/PARfiles/$FDIR -name '*.out' -exec grep -H "Hellinger1" {} \; | tr '/.' '  ' | awk '{printf "sX%s.%s.%s.outXANT-AFR.C%s.${TDIR}.data.${REF}.pickXg\n", $3, $4, $5, $5}' > sed_T2.job
for chron in 20o 21o 22o 23o 24o 26y 28y 31y 32y 33o 33y 34y; do
	cp $FROM/InputFiles/$FDIR/swir.${chron}.chang.points $TO/$TDIR/ANT-AFR.C${chron}.$TDIR.data.${REF}.pick
	sed -f sed_T2.job $FROM/PARfiles/$FDIR/bestfit.swir.${chron}.out > $TO/$TDIR/ANT-AFR.C${chron}.$TDIR.model.${REF}.txt
done
# Doing SEIR (Table 3)
FDIR=SEIR_2-platerots_Table3
TDIR=SEIR_Tbl3
find $FROM/PARfiles/$FDIR -name '*.out' -exec grep -H "Hellinger1" {} \; | tr '/.' '  ' | awk '{printf "sX%s.%s.%s.outXANT-CAP.C%s.${TDIR}.data.${REF}.pickXg\n", $3, $4, $5, $5}' > sed_T3.job
for chron in 20o 20y 21o 22o 23o 24o 25y 26y 27y 28y 29o 30y 31y 32y 33o 34y; do
	cp $FROM/InputFiles/$FDIR/seir.${chron}.chang.points $TO/$TDIR/ANT-CAP.C${chron}.$TDIR.data.${REF}.pick
	sed -f sed_T3.job $FROM/PARfiles/$FDIR/bestfit.seir.${chron}.out > $TO/$TDIR/ANT-CAP.C${chron}.$TDIR.model.${REF}.txt
done
# Doing IOTJ_3 (Table 4)
FDIR=IOTJ_3-platerots_Table4
TDIR=IOTJ_Tbl4
find $FROM/PARfiles/$FDIR -name 'tj_par*' -exec grep -H "Hellinger3" {} \; | tr '/.' '  ' | awk '{printf "sX%s.iotj.chang.pointsXAFR-ANT-CAP.C%s.${TDIR}.data.${REF}.pickXg\n", $8, substr($8,5)}' > sed_T4.job
for chron in 24o 26y 28y; do
	cp $FROM/InputFiles/$FDIR/anom${chron}.iotj.chang.points $TO/$TDIR/AFR-ANT-CAP.C${chron}.$TDIR.data.${REF}.pick
	sed -f sed_T4.job $FROM/PARfiles/$FDIR/anom${chron}/tj_par12 > $TO/$TDIR/AFR-ANT.C${chron}.$TDIR.model.${REF}.txt
	sed -f sed_T4.job $FROM/PARfiles/$FDIR/anom${chron}/tj_par13 > $TO/$TDIR/AFR-CAP.C${chron}.$TDIR.model.${REF}.txt
	sed -f sed_T4.job $FROM/PARfiles/$FDIR/anom${chron}/tj_par23 > $TO/$TDIR/ANT-CAP.C${chron}.$TDIR.model.${REF}.txt
done

# We create a simple readme.${REF}.txt to
# list the full reference and point to their description document

cat << EOF > $TO/readme.${REF}.txt
The Global Seafloor Fabric and Magnetic Lineation Data Base Project
		http://www.soest.hawaii.edu/PT/GSFML

README file for the ${REF} directory.

There are three subdirectories:  SWIR_Tbl2 SEIR_Tbl3 IOTJ_Tbl4
These contain data and model results for the relative motions between
Africa (AFR), Antarctica (ANT) and Capricorn (CAP).
The authors have also provided supporting documentation in the file
description.Cande+Patriat_2015_GJI.pdf.
Note that the files names given in that documentation differ from what
is supplied via this website since we have to ensure a systematic and
self-consistent naming scheme -- see the file file_format.txt.
Also, note that while the documentation discusses the Capricorn plate
even though for the times discussed it is basically the India (IND) plate.
For more recent times it matters, hence we uses the tag CAP throughout. 
The data are suitable as input to the modeling programd hellinger1.f and
hellinger3.f; see the website for links to these softwares.

The full reference to the publication is

http://dx.doi.org/10.1093/gji/ggu392

Cande, S. C. and P. Patriat (2015), The anticorrelated velocities of Africa and India in the Late Cretaceous
   and early Cenozoic, Geophys. J. Int., 200, 227-243.
EOF

#rm -f sed_T[234].job
