# Rename script to rename from Muller et al., 1999, Caribbean chapter files to our naming convention
# No doc file present, we create a simple 
# readme.${REF}.txt
# which just list the full reference.
#
# Run this script from the top HELLDATA directory
REF=Muller++_1999_SedBasinWorld
#-------------------
FROM=${REF}
TO=$1/${REF}
mkdir -p $TO

# NAM-AFR
cp $FROM/Catl_Satl_mag_fz_picks/catl.05  $TO/NAM-AFR.C5.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/catl.06  $TO/NAM-AFR.C6.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/catl.08  $TO/NAM-AFR.C8.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/catl.13  $TO/NAM-AFR.C13.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/catl.18  $TO/NAM-AFR.C18.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/catl.20  $TO/NAM-AFR.C20.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/catl.21  $TO/NAM-AFR.C21.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/catl.22  $TO/NAM-AFR.C22.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/catl.24  $TO/NAM-AFR.C24.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/catl.25  $TO/NAM-AFR.C25.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/catl.30  $TO/NAM-AFR.C30.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/catl.32  $TO/NAM-AFR.C32.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/catl.33o $TO/NAM-AFR.C33o.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/catl.33y $TO/NAM-AFR.C33y.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/catl.34  $TO/NAM-AFR.34.final.data.${REF}.pick
# SAM-AFR

cp $FROM/Catl_Satl_mag_fz_picks/satl.05  $TO/SAM-AFR.5.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/satl.06  $TO/SAM-AFR.6.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/satl.08  $TO/SAM-AFR.8.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/satl.13  $TO/SAM-AFR.13.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/satl.18  $TO/SAM-AFR.18.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/satl.21  $TO/SAM-AFR.21.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/satl.24  $TO/SAM-AFR.24.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/satl.25  $TO/SAM-AFR.25.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/satl.30  $TO/SAM-AFR.30.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/satl.32  $TO/SAM-AFR.32.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/satl.33o $TO/SAM-AFR.33o.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/satl.33y $TO/SAM-AFR.33y.final.data.${REF}.pick
cp $FROM/Catl_Satl_mag_fz_picks/satl.34  $TO/SAM-AFR.34.final.data.${REF}.pick

cat << EOF > $TO/readme.${REF}.txt
The Global Seafloor Fabric and Magnetic Lineation Data Base Project
		http://www.soest.hawaii.edu/PT/GSFML

README file for the ${REF} directory.

These files contain data constraining the published relative plate motion model for
Africa (AFR) relative to fixed North (NAM) and South (SAM) America for the listed chrons.
The data are suitable as input to the modeling program hellinger1.f.
The full reference to the publication is

http://dx.doi.org/10.1016/S1874-5997(99)80036-7

Müller, R. D., Royer, J.-Y., Cande, S. C., Roest, W. R., and Maschenkov, S., 1999,
Chapter 2: New constraints on the Late Cretaceous/Tertiary plate tectonic evolution of the Caribbean,
in Mann, P., ed., Sedimentary Basins of the World, Volume 4, Elsevier, p. 33-59.
EOF
