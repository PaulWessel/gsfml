# Rename script to rename from ${REF} files to our naming convention
# A readme file is present, we create a simple 
# readme.${REF}.txt
# which just list the full reference.
#
# Run this script from the top HELLDATA directory
REF=Whittaker++_2013_G3
#-------------------
FROM=${REF}
TO=$1/${REF}
mkdir -p $TO

# Hellinger input files
cp $FROM/C21/C21.hell $TO/ANT-AUS.C21y.final.data.${REF}.pick
cp $FROM/C24/C24.hell $TO/ANT-AUS.C24o.final.data.${REF}.pick
cp $FROM/C27/C27.hell $TO/ANT-AUS.C27y.final.data.${REF}.pick
cp $FROM/C31/C31.hell $TO/ANT-AUS.C31o.final.data.${REF}.pick
cp $FROM/C32/C32.hell $TO/ANT-AUS.C32y.final.data.${REF}.pick
cp $FROM/C33/C33.hell $TO/ANT-AUS.C33o.final.data.${REF}.pick
# Hellinger model files
cp $FROM/C21/C21.hell_par $TO/ANT-AUS.C21y.final.model.${REF}.txt
cp $FROM/C24/C24.hell_par $TO/ANT-AUS.C24o.final.model.${REF}.txt
cp $FROM/C27/C27.hell_par $TO/ANT-AUS.C27y.final.model.${REF}.txt
cp $FROM/C31/C31.hell_par $TO/ANT-AUS.C31o.final.model.${REF}.txt
cp $FROM/C32/C32.hell_par $TO/ANT-AUS.C32y.final.model.${REF}.txt
cp $FROM/C33/C33.hell_par $TO/ANT-AUS.C33o.final.model.${REF}.txt
# Hellinger residual files
cp $FROM/C21/C21.hell_res $TO/ANT-AUS.C21y.final.residual.${REF}.txt
cp $FROM/C24/C24.hell_res $TO/ANT-AUS.C24o.final.residual.${REF}.txt
cp $FROM/C27/C27.hell_res $TO/ANT-AUS.C27y.final.residual.${REF}.txt
cp $FROM/C31/C31.hell_res $TO/ANT-AUS.C31o.final.residual.${REF}.txt
cp $FROM/C32/C32.hell_res $TO/ANT-AUS.C32y.final.residual.${REF}.txt
cp $FROM/C33/C33.hell_res $TO/ANT-AUS.C33o.final.residual.${REF}.txt
# Hellinger lower boundary files
cp $FROM/C21/bound_low $TO/ANT-AUS.C21y.final.lowerbound.${REF}.txt
cp $FROM/C24/bound_low $TO/ANT-AUS.C24o.final.lowerbound.${REF}.txt
cp $FROM/C27/bound_low $TO/ANT-AUS.C27y.final.lowerbound.${REF}.txt
cp $FROM/C31/bound_low $TO/ANT-AUS.C31o.final.lowerbound.${REF}.txt
cp $FROM/C32/bound_low $TO/ANT-AUS.C32y.final.lowerbound.${REF}.txt
cp $FROM/C33/bound_low $TO/ANT-AUS.C33o.final.lowerbound.${REF}.txt
# Hellinger upper boundary files
cp $FROM/C21/bound_up $TO/ANT-AUS.C21y.final.upperbound.${REF}.txt
cp $FROM/C24/bound_up $TO/ANT-AUS.C24o.final.upperbound.${REF}.txt
cp $FROM/C27/bound_up $TO/ANT-AUS.C27y.final.upperbound.${REF}.txt
cp $FROM/C31/bound_up $TO/ANT-AUS.C31o.final.upperbound.${REF}.txt
cp $FROM/C32/bound_up $TO/ANT-AUS.C32y.final.upperbound.${REF}.txt
cp $FROM/C33/bound_up $TO/ANT-AUS.C33o.final.upperbound.${REF}.txt
# Hellinger confidence region files
cp $FROM/C21/boundary_f $TO/ANT-AUS.C21y.final.confregion.${REF}.txt
cp $FROM/C24/boundary_f $TO/ANT-AUS.C24o.final.confregion.${REF}.txt
cp $FROM/C27/boundary_f $TO/ANT-AUS.C27y.final.confregion.${REF}.txt
cp $FROM/C31/boundary_f $TO/ANT-AUS.C31o.final.confregion.${REF}.txt
cp $FROM/C32/boundary_f $TO/ANT-AUS.C32y.final.confregion.${REF}.txt
cp $FROM/C33/boundary_f $TO/ANT-AUS.C33o.final.confregion.${REF}.txt
# Hellinger command files
cp $FROM/C21/hell.com $TO/ANT-AUS.C21y.final.command.${REF}.txt
cp $FROM/C24/hell.com $TO/ANT-AUS.C24o.final.command.${REF}.txt
cp $FROM/C27/hell.com $TO/ANT-AUS.C27y.final.command.${REF}.txt
cp $FROM/C31/hell.com $TO/ANT-AUS.C31o.final.command.${REF}.txt
cp $FROM/C32/hell.com $TO/ANT-AUS.C32y.final.command.${REF}.txt
cp $FROM/C33/hell.com $TO/ANT-AUS.C33o.final.command.${REF}.txt


cp $FROM/READMe.txt $TO/description.${REF}.txt
cat << EOF > $TO/readme.${REF}.txt
The Global Seafloor Fabric and Magnetic Lineation Data Base Project
		http://www.soest.hawaii.edu/PT/GSFML

README file for the ${REF} directory.

These files contain data constraining the published relative plate motion model for
Australia (AUS) relative to fixed Antarctica (ANT) for the listed chrons.
The data are suitable as input to the modeling program hellinger1.f.
The full reference to the publication is

http://dx.doi.org/10.1002/ggge.20120

Whittaker, J. M., Williams, S. E., and Müller, R. D., 2013, Revised tectonic evolution of
the Eastern Indian Ocean: Geochemistry, Geophysics, Geosystems, v. 14, no. 6, p. 1891-1909.
EOF
