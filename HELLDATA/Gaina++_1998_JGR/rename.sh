# Rename script to rename from Gaina et al., 1998, JGR files to our naming convention
# No doc file present, we create a simple 
# readme.${REF}.txt
# which just list the full reference.
#
# Run this script from the top HELLDATA directory
REF=Gaina++_1998_JGR
#-------------------
FROM=${REF}
TO=$1/${REF}
mkdir -p $TO

cp $FROM/an25y_help_finn $TO/AUS-LHR.C25y.final.data.${REF}.pick
cp $FROM/an26o_help_finn $TO/AUS-LHR.C26o.final.data.${REF}.pick
cp $FROM/an27o_help_finn $TO/AUS-LHR.C27o.final.data.${REF}.pick
cp $FROM/an28y_help_finn $TO/AUS-LHR.C28y.final.data.${REF}.pick
cp $FROM/an29y_help_finn $TO/AUS-LHR.C29y.final.data.${REF}.pick
cp $FROM/an30y_help_finn $TO/AUS-LHR.C30y.final.data.${REF}.pick
cp $FROM/an31y_help_finn $TO/AUS-LHR.C31y.final.data.${REF}.pick
cp $FROM/an32y_help_finn $TO/AUS-LHR.C32y.final.data.${REF}.pick
cp $FROM/an33y_help_finn $TO/AUS-LHR.C33y.final.data.${REF}.pick

cat << EOF > $TO/readme.${REF}.txt
The Global Seafloor Fabric and Magnetic Lineation Data Base Project
		http://www.soest.hawaii.edu/PT/GSFML

README file for the ${REF} directory.

These files contain data constraining the published relative plate motion model for
the Lord Howe Rise (LHR) relative to a fixed Australia (AUS) for the listed chrons.
The data are suitable as input to the modeling program hellinger1.f.
The full reference to the publication is

http://dx.doi.org/10.1029/98JB00386

Gaina, C., Müller, D. R., Royer, J.-Y., Stock, J., Hardebeck, J., and Symonds, P., 1998,
The tectonic history of the Tasman Sea: a puzzle with 13 pieces:
J. Geophys. Res., v. 103, no. B6, p. 12,413-412,433.
EOF
