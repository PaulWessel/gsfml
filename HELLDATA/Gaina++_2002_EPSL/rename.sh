# Rename script to rename from Gaina et al., 2002,EPSL files to our naming convention
# No doc file present, we create a simple 
# readme.${REF}.txt
# which just list the full reference.
#
# Run this script from the top HELLDATA directory
REF=Gaina++_2002_EPSL
#-------------------
FROM=${REF}
TO=$1/${REF}
mkdir -p $TO

# NAM-EUR
cp $FROM/a5_hel  $TO/NAM-EUR.5.final.data.${REF}.pick
cp $FROM/a6_hel  $TO/NAM-EUR.6.final.data.${REF}.pick
cp $FROM/a13_hel $TO/NAM-EUR.13.final.data.${REF}.pick
cp $FROM/a18_hel $TO/NAM-EUR.18.final.data.${REF}.pick
cp $FROM/a20_hel $TO/NAM-EUR.20.final.data.${REF}.pick
cp $FROM/a21_hel $TO/NAM-EUR.21.final.data.${REF}.pick
cp $FROM/a22_hel $TO/NAM-EUR.22.final.data.${REF}.pick
cp $FROM/a25_hel $TO/NAM-EUR.25.final.data.${REF}.pick
cp $FROM/a31_hel $TO/NAM-EUR.31.final.data.${REF}.pick
cp $FROM/a33_hel $TO/NAM-EUR.33.final.data.${REF}.pick
cp $FROM/a34_hel $TO/NAM-EUR.34.final.data.${REF}.pick

cat << EOF > $TO/readme.${REF}.txt
The Global Seafloor Fabric and Magnetic Lineation Data Base Project
		http://www.soest.hawaii.edu/PT/GSFML

README file for the ${REF} directory.

These files contain data constraining the published relative plate motion model for
North America (NAM) relative to fixed Eurasia (EUR) for the listed chrons.
The data are suitable as input to the modeling program hellinger1.f.
The full reference to the publication is

http://dx.doi.org/10.1016/S0012-821X(02)00499-5

Gaina, C., Roest, W. R., and Müller, R. D., 2002, Late Cretaceous Cenozoic deformation
of northeast Asia: Earth and Planetary Science Letters, v. 197, p. 273-286.
EOF
