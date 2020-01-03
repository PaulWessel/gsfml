# Rename script to rename from ${REF} files to our naming convention
# A readme file is present, we create a simple 
# readme.${REF}.txt
# which just list the full reference.
#
# Run this script from the top HELLDATA directory
REF=Whittaker++_2007_Science
#-------------------
FROM=${REF}
TO=$1/${REF}
mkdir -p $TO

# Hellinger input files
cp $FROM/C20o/C20.hell $TO/ANT-AUS.C20o.final.data.${REF}.pick
cp $FROM/C21y/C21.hell $TO/ANT-AUS.C21y.final.data.${REF}.pick
cp $FROM/C24o/C24.hell $TO/ANT-AUS.C24o.final.data.${REF}.pick
cp $FROM/C27y/C27.hell $TO/ANT-AUS.C27y.final.data.${REF}.pick
cp $FROM/C31o/C31.hell $TO/ANT-AUS.C31o.final.data.${REF}.pick
cp $FROM/C32y/C32.hell $TO/ANT-AUS.C32y.final.data.${REF}.pick
cp $FROM/C33o/C33.hell $TO/ANT-AUS.C33o.final.data.${REF}.pick
cp $FROM/C34y/C34.hell $TO/ANT-AUS.C34y.final.data.${REF}.pick
cp $FROM/QZB/QZB.hell  $TO/ANT-AUS.QZB.final.data.${REF}.pick
# Hellinger model files
cp $FROM/C20o/C20.hell_par $TO/ANT-AUS.C20o.final.model.${REF}.txt
cp $FROM/C21y/C21.hell_par $TO/ANT-AUS.C21y.final.model.${REF}.txt
cp $FROM/C24o/C24.hell_par $TO/ANT-AUS.C24o.final.model.${REF}.txt
cp $FROM/C27y/C27.hell_par $TO/ANT-AUS.C27y.final.model.${REF}.txt
cp $FROM/C31o/C31.hell_par $TO/ANT-AUS.C31o.final.model.${REF}.txt
cp $FROM/C32y/C32.hell_par $TO/ANT-AUS.C32y.final.model.${REF}.txt
cp $FROM/C33o/C33.hell_par $TO/ANT-AUS.C33o.final.model.${REF}.txt
cp $FROM/C34y/C34.hell_par $TO/ANT-AUS.C34y.final.model.${REF}.txt
cp $FROM/QZB/QZB.hell_par  $TO/ANT-AUS.QZB.final.model.${REF}.txt
# Hellinger residual files
cp $FROM/C20o/C20.hell_res $TO/ANT-AUS.C20o.final.residual.${REF}.txt
cp $FROM/C21y/C21.hell_res $TO/ANT-AUS.C21y.final.residual.${REF}.txt
cp $FROM/C24o/C24.hell_res $TO/ANT-AUS.C24o.final.residual.${REF}.txt
cp $FROM/C27y/C27.hell_res $TO/ANT-AUS.C27y.final.residual.${REF}.txt
cp $FROM/C31o/C31.hell_res $TO/ANT-AUS.C31o.final.residual.${REF}.txt
cp $FROM/C32y/C32.hell_res $TO/ANT-AUS.C32y.final.residual.${REF}.txt
cp $FROM/C33o/C33.hell_res $TO/ANT-AUS.C33o.final.residual.${REF}.txt
cp $FROM/C34y/C34.hell_res $TO/ANT-AUS.C34y.final.residual.${REF}.txt
cp $FROM/QZB/QZB.hell_res  $TO/ANT-AUS.QZB.final.residual.${REF}.txt
# Hellinger lower boundary files
cp $FROM/C20o/bound_low $TO/ANT-AUS.C20o.final.lowerbound.${REF}.txt
cp $FROM/C21y/bound_low $TO/ANT-AUS.C21y.final.lowerbound.${REF}.txt
cp $FROM/C24o/bound_low $TO/ANT-AUS.C24o.final.lowerbound.${REF}.txt
cp $FROM/C27y/bound_low $TO/ANT-AUS.C27y.final.lowerbound.${REF}.txt
cp $FROM/C31o/bound_low $TO/ANT-AUS.C31o.final.lowerbound.${REF}.txt
cp $FROM/C32y/bound_low $TO/ANT-AUS.C32y.final.lowerbound.${REF}.txt
cp $FROM/C33o/bound_low $TO/ANT-AUS.C33o.final.lowerbound.${REF}.txt
cp $FROM/C34y/bound_low $TO/ANT-AUS.C34y.final.lowerbound.${REF}.txt
cp $FROM/QZB/bound_low  $TO/ANT-AUS.QZB.final.lowerbound.${REF}.txt
# Hellinger upper boundary files
cp $FROM/C20o/bound_up $TO/ANT-AUS.C20o.final.upperbound.${REF}.txt
cp $FROM/C21y/bound_up $TO/ANT-AUS.C21y.final.upperbound.${REF}.txt
cp $FROM/C24o/bound_up $TO/ANT-AUS.C24o.final.upperbound.${REF}.txt
cp $FROM/C27y/bound_up $TO/ANT-AUS.C27y.final.upperbound.${REF}.txt
cp $FROM/C31o/bound_up $TO/ANT-AUS.C31o.final.upperbound.${REF}.txt
cp $FROM/C32y/bound_up $TO/ANT-AUS.C32y.final.upperbound.${REF}.txt
cp $FROM/C33o/bound_up $TO/ANT-AUS.C33o.final.upperbound.${REF}.txt
cp $FROM/C34y/bound_up $TO/ANT-AUS.C34y.final.upperbound.${REF}.txt
cp $FROM/QZB/bound_up  $TO/ANT-AUS.QZB.final.upperbound.${REF}.txt
# Hellinger confidence region files
cp $FROM/C20o/boundary_f $TO/ANT-AUS.C20o.final.confregion.${REF}.txt
cp $FROM/C21y/boundary_f $TO/ANT-AUS.C21y.final.confregion.${REF}.txt
cp $FROM/C24o/boundary_f $TO/ANT-AUS.C24o.final.confregion.${REF}.txt
cp $FROM/C27y/boundary_f $TO/ANT-AUS.C27y.final.confregion.${REF}.txt
cp $FROM/C31o/boundary_f $TO/ANT-AUS.C31o.final.confregion.${REF}.txt
cp $FROM/C32y/boundary_f $TO/ANT-AUS.C32y.final.confregion.${REF}.txt
cp $FROM/C33o/boundary_f $TO/ANT-AUS.C33o.final.confregion.${REF}.txt
cp $FROM/C34y/boundary_f $TO/ANT-AUS.C34y.final.confregion.${REF}.txt
cp $FROM/QZB/boundary_f  $TO/ANT-AUS.QZB.final.confregion.${REF}.txt
# Hellinger command files
cp $FROM/C20o/hell.com $TO/ANT-AUS.C20o.final.command.${REF}.txt
cp $FROM/C21y/hell.com $TO/ANT-AUS.C21y.final.command.${REF}.txt
cp $FROM/C24o/hell.com $TO/ANT-AUS.C24o.final.command.${REF}.txt
cp $FROM/C27y/hell.com $TO/ANT-AUS.C27y.final.command.${REF}.txt
cp $FROM/C31o/hell.com $TO/ANT-AUS.C31o.final.command.${REF}.txt
cp $FROM/C32y/hell.com $TO/ANT-AUS.C32y.final.command.${REF}.txt
cp $FROM/C33o/hell.com $TO/ANT-AUS.C33o.final.command.${REF}.txt
cp $FROM/C34y/hell.com $TO/ANT-AUS.C34y.final.command.${REF}.txt
cp $FROM/QZB/hell.com  $TO/ANT-AUS.QZB.final.command.${REF}.txt


cp $FROM/READMe.txt $TO/description.${REF}.txt
cat << EOF > $TO/readme.${REF}.txt
The Global Seafloor Fabric and Magnetic Lineation Data Base Project
		http://www.soest.hawaii.edu/PT/GSFML

README file for the ${REF} directory.

Note: The files with chron tag "QZB" is discussed in their paper, with tentative timing of 96 Ma.

These files contain data constraining the published relative plate motion model for
Australia (AUS) relative to fixed Antarctica (ANT) for the listed chrons.
The data are suitable as input to the modeling program hellinger1.f.
The authors have also provided supporting documentation in the file
description.${REF}.txt.

The full reference to the publication is

http://dx.doi.org/10.1126/science.1143769

Whittaker, J. M., Muller, R. D., Leitchenkov, G., Stagg, H., Sdrolias, M., Gaina, C.,
and Goncharov, A., 2007, Major Australian-Antarctic Plate Reorganization at Hawaiian-Emperor
Bend Time: Science, v. 318, no. 5847, p. 83-86.
EOF
