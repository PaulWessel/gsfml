# Rename script to rename from Granot and Dyment, 2018, Nat. Comm. files to our naming convention
# Maria provided everything so just rename and/or copy files.
#
# Run this script from the top HELLDATA directory
REF=Granot+Dyment_2018_NatComms
#-------------------
FROM=${REF}
TO=$1/${REF}
mkdir -p $TO

# Do a stupid cat since build_hell.sh can grep for the DOI in rename.sh
cat << EOF > /dev/null
http://dx.doi.org/10.1038/s41467-018-05270-w
EOF
# AUS-ANT-MB
cp $FROM/AUS-ANT-MBL.8o.data.Granot+Dyment_2018_NatComms.pick $TO/AUS-ANT-MBL.8o.final.data.${REF}.pick
# MCQ-AN
cp $FROM/MCQ-ANT.3ay.data.Granot+Dyment_2018_NatComms.pick $TO/MCQ-ANT.3ay.final.data.${REF}.pick
# Just duplicate readme
cp $FROM/readme.Granot+Dyment_2018_NatComms.txt $TO/readme.${REF}.txt
