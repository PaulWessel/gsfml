# Rename script to rename from Gaina et al., 1999, JGR files to our naming convention
# No doc file present, we create a simple 
# readme.${REF}.txt
# which just list the full reference.
#
# Run this script from the top HELLDATA directory
REF=Gaina++_1999_JGR
#-------------------
FROM=${REF}
TO=$1/${REF}
mkdir -p $TO

cp $FROM/a24o.yxun_hel $TO/AUS-LP.C24o.final.data.${REF}.pick
cp $FROM/a25y.yxun_hel $TO/AUS-LP.C25y.final.data.${REF}.pick
cp $FROM/a26o.yxun_hel $TO/AUS-LP.C26o.final.data.${REF}.pick
cp $FROM/a27o.yxun_hel $TO/AUS-LP.C27o.final.data.${REF}.pick

cat << EOF > $TO/readme.${REF}.txt
The Global Seafloor Fabric and Magnetic Lineation Data Base Project
		http://www.soest.hawaii.edu/PT/GSFML

README file for the ${REF} directory.

These files contain data constraining the published relative plate motion model for
the Louisiade Plateau (LP) relative to a fixed Australia (AUS) for the listed chrons.
The data are suitable as input to the modeling program hellinger1.f.
The full reference to the publication is

http://dx.doi.org/10.1029/1999JB900038

Gaina, C., Müller, R. D., Royer, J.-Y., and Symonds, P., 1999, Evolution of the
Louisiade triple junction: Journal of Geophysical Research: Solid Earth,
v. 104, no. B6, p. 12927-12939.
EOF
