# Rename script to rename from Williams et al., 2011, Tectonics files to our naming convention
# No doc file present, we create a simple 
# readme.${REF}.txt
# which just list the full reference.
#
# Run this script from the top HELLDATA directory
REF=Williams++_2011_Tectonics
#-------------------
FROM=${REF}
TO=$1/${REF}
mkdir -p $TO

# C34
cp $FROM/C34/C34.hell $TO/ANT-AUS.C34y.final.data.${REF}.pick
cp $FROM/C34/C34.hell_par $TO/ANT-AUS.C34y.final.model.${REF}.txt
cp $FROM/C34/C34.hell_res $TO/ANT-AUS.C34y.final.residual.${REF}.txt
cp $FROM/C34/bound_low $TO/ANT-AUS.C34y.final.lowerbound.${REF}.txt
cp $FROM/C34/bound_up $TO/ANT-AUS.C34y.final.upperbound.${REF}.txt
cp $FROM/C34/boundary_f $TO/ANT-AUS.C34y.final.confregion.${REF}.txt
cp $FROM/C34/hell.com $TO/ANT-AUS.C34y.final.command.${REF}.txt
# Full-fit
cp $FROM/Full-fit/Fullfit.hell $TO/ANT-AUS.Full-fit.final.data.${REF}.pick
cp $FROM/Full-fit/Fullfit.hell_par $TO/ANT-AUS.Full-fit.final.model.${REF}.txt
cp $FROM/Full-fit/Fullfit.hell_res $TO/ANT-AUS.Full-fit.final.residual.${REF}.txt
cp $FROM/Full-fit/bound_low $TO/ANT-AUS.Full-fit.final.lowerbound.${REF}.txt
cp $FROM/Full-fit/bound_up $TO/ANT-AUS.Full-fit.final.upperbound.${REF}.txt
cp $FROM/Full-fit/boundary_f $TO/ANT-AUS.Full-fit.final.confregion.${REF}.txt
cp $FROM/Full-fit/hell.com $TO/ANT-AUS.Full-fit.final.command.${REF}.txt

cp $FROM/READMe.txt $TO/description.${REF}.txt

cat << EOF > $TO/readme.${REF}.txt
The Global Seafloor Fabric and Magnetic Lineation Data Base Project
		http://www.soest.hawaii.edu/PT/GSFML

README file for the ${REF} directory.

Note: The files with chron tag "Full-fit" is discussed in their paper, with tentative timing 140-160 Ma.

These files contain data constraining the published relative plate motion model for
Australia (AUS) relative to a fixed Antarctica (ANT) for the listed chrons.
The data are suitable as input to the modeling program hellinger1.f.
The full reference to the publication is

http://dx.doi.org/10.1029/2011TC002912

Williams, S. E., Whittaker, J. M., and Müller, R. D., 2011, Full-fit, palinspastic
reconstruction of the conjugate Australian-Antarctic margins: Tectonics, v. 30, no. 6, p. TC6012.
EOF
