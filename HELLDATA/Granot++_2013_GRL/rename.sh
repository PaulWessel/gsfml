# Rename script to rename from Granot et al., 2013, GRL files to our naming convention
# No doc file present, we create a simple 
# readme.${REF}.txt
# which just list the full reference.
#
# Run this script from the top HELLDATA directory
REF=Granot++_2013_GRL
#-------------------
FROM=${REF}
TO=$1/${REF}
mkdir -p $TO

# MBL-ANT-AUS
cp $FROM/anom12o_tj_nov2010.points $TO/MBL-ANT-AUS.C12o.final.data.${REF}.pick
cp $FROM/anom13o_tj_nov2010.points $TO/MBL-ANT-AUS.C13o.final.data.${REF}.pick
cp $FROM/anom16y_tj_nov2010.points $TO/MBL-ANT-AUS.C16y.final.data.${REF}.pick
cp $FROM/anom18o_tj_nov2010.points $TO/MBL-ANT-AUS.C18o.final.data.${REF}.pick

cat << EOF > $TO/readme.${REF}.txt
The Global Seafloor Fabric and Magnetic Lineation Data Base Project
		http://www.soest.hawaii.edu/PT/GSFML

README file for the ${REF} directory.

These files contain data constraining the published relative plate motion model for
Australia (AUS, ID 1) and East Antarctiva (ANT, ID 2) relative to fixed West Antarctica (MBL)
for the listed chrons.
The data are suitable as input to the modeling program hellinger3.f

Comment from author:
The last column in all files describes the source of data - either cruise name or if the
label is number it means that it is based on aeromagnetic data from GANOVEX IX German campaign
(the number is the internal profile within the campaign - random tags I provided - doesn’t mean
anything for other people). If the tag is “FZ” it means fracture zone picking from Sandwell
gravity map vs 18.1.

The full reference to the publication is

http://dx.doi.org/10.1029/2012GL054181

Granot, R., Cande, S. C., Stock, J. M., and Damaske, D., 2013, Revised Eocene-Oligocene
kinematics for the West Antarctic rift system: Geophys. Res. Lett., v. 40, p. 279-284.
EOF
