# Script to rename Cande et al, 2010 original files to our naming convention
# We manually open/save the doc file to docx using the new name
# Cande2010DataFileDescription.doc -> description.Cande++_2010_GJI.docx
#
# Steve had 5 different scenarios so we make 5 directories
# Run this script from the top HELLDATA directory
REF=Cande++_2010_GJI
#-------------------
FROM=${REF}
TO=$1/${REF}
mkdir -p $TO

mkdir -p $TO/all $TO/basic $TO/withcarlsberg $TO/withnubia $TO/withswirfzs
cp $FROM/description.${REF}.docx $TO
# First to his data files
cp $FROM/InputFiles/all/anom20o.tj.withboth8.points $TO/all/SOM-ANT-IND.C20o.all.data.${REF}.pick
cp $FROM/InputFiles/all/anom20y.tj.withboth8.points $TO/all/SOM-ANT-IND.C20y.all.data.${REF}.pick
cp $FROM/InputFiles/all/anom21o.tj.withboth8.points $TO/all/SOM-ANT-IND.C21o.all.data.${REF}.pick
cp $FROM/InputFiles/all/anom21y.tj.withboth8.points $TO/all/SOM-ANT-IND.C21y.all.data.${REF}.pick
cp $FROM/InputFiles/all/anom22o.tj.withboth8.points $TO/all/SOM-ANT-IND.C22o.all.data.${REF}.pick
cp $FROM/InputFiles/all/anom23o.tj.withboth8.points $TO/all/SOM-ANT-IND.C23o.all.data.${REF}.pick
cp $FROM/InputFiles/all/anom24o.tj.withboth8.points $TO/all/SOM-ANT-IND.C24o.all.data.${REF}.pick
cp $FROM/InputFiles/all/anom25y.tj.withboth8.points $TO/all/SOM-ANT-IND.C25y.all.data.${REF}.pick
cp $FROM/InputFiles/all/anom26y.tj.withboth8.points $TO/all/SOM-ANT-IND.C26y.all.data.${REF}.pick
cp $FROM/InputFiles/basic/anom13o.tj.nocarl2.points $TO/basic/SOM-ANT-IND.C13o.basic.data.${REF}.pick
cp $FROM/InputFiles/basic/anom18o.tj.nocarl2.points $TO/basic/SOM-ANT-IND.C18o.basic.data.${REF}.pick
cp $FROM/InputFiles/basic/anom20o.tj.nocarl2.points $TO/basic/SOM-ANT-IND.C20o.basic.data.${REF}.pick
cp $FROM/InputFiles/basic/anom20y.tj.nocarl2.points $TO/basic/SOM-ANT-IND.C20y.basic.data.${REF}.pick
cp $FROM/InputFiles/basic/anom21o.tj.nocarl2.points $TO/basic/SOM-ANT-IND.C21o.basic.data.${REF}.pick
cp $FROM/InputFiles/basic/anom21y.tj.nocarl2.points $TO/basic/SOM-ANT-IND.C21y.basic.data.${REF}.pick
cp $FROM/InputFiles/basic/anom22o.tj.nocarl2.points $TO/basic/SOM-ANT-IND.C22o.basic.data.${REF}.pick
cp $FROM/InputFiles/basic/anom23o.tj.nocarl2.points $TO/basic/SOM-ANT-IND.C23o.basic.data.${REF}.pick
cp $FROM/InputFiles/basic/anom24o.tj.nocarl2.points $TO/basic/SOM-ANT-IND.C24o.basic.data.${REF}.pick
cp $FROM/InputFiles/basic/anom25y.tj.nocarl2.points $TO/basic/SOM-ANT-IND.C25y.basic.data.${REF}.pick
cp $FROM/InputFiles/basic/anom26y.tj.nocarl2.points $TO/basic/SOM-ANT-IND.C26y.basic.data.${REF}.pick
cp $FROM/InputFiles/basic/anom27y.tj.nocarl2.points $TO/basic/SOM-ANT-IND.C27y.basic.data.${REF}.pick
cp $FROM/InputFiles/basic/anom28y.tj.nocarl2.points $TO/basic/SOM-ANT-IND.C28y.basic.data.${REF}.pick
cp $FROM/InputFiles/basic/anom29o.tj.nocarl2.points $TO/basic/SOM-ANT-IND.C29o.basic.data.${REF}.pick
cp $FROM/InputFiles/withcarlsberg/anom20o.tj.withcarl2.points $TO/withcarlsberg/SOM-ANT-IND.C20o.withcarlsberg.data.${REF}.pick
cp $FROM/InputFiles/withcarlsberg/anom20y.tj.withcarl2.points $TO/withcarlsberg/SOM-ANT-IND.C20y.withcarlsberg.data.${REF}.pick
cp $FROM/InputFiles/withcarlsberg/anom21o.tj.withcarl2.points $TO/withcarlsberg/SOM-ANT-IND.C21o.withcarlsberg.data.${REF}.pick
cp $FROM/InputFiles/withcarlsberg/anom21y.tj.withcarl2.points $TO/withcarlsberg/SOM-ANT-IND.C21y.withcarlsberg.data.${REF}.pick
cp $FROM/InputFiles/withcarlsberg/anom22o.tj.withcarl2.points $TO/withcarlsberg/SOM-ANT-IND.C22o.withcarlsberg.data.${REF}.pick
cp $FROM/InputFiles/withcarlsberg/anom23o.tj.withcarl2.points $TO/withcarlsberg/SOM-ANT-IND.C23o.withcarlsberg.data.${REF}.pick
cp $FROM/InputFiles/withcarlsberg/anom24o.tj.withcarl2.points $TO/withcarlsberg/SOM-ANT-IND.C24o.withcarlsberg.data.${REF}.pick
cp $FROM/InputFiles/withcarlsberg/anom25y.tj.withcarl2.points $TO/withcarlsberg/SOM-ANT-IND.C25y.withcarlsberg.data.${REF}.pick
cp $FROM/InputFiles/withcarlsberg/anom26y.tj.withcarl2.points $TO/withcarlsberg/SOM-ANT-IND.C26y.withcarlsberg.data.${REF}.pick
cp $FROM/InputFiles/withnubia/anom20o.tj.withnubia5.points $TO/withnubia/SOM-ANT-IND.C20o.withnubia.data.${REF}.pick
cp $FROM/InputFiles/withnubia/anom20y.tj.withnubia5.points $TO/withnubia/SOM-ANT-IND.C20y.withnubia.data.${REF}.pick
cp $FROM/InputFiles/withnubia/anom21o.tj.withnubia5.points $TO/withnubia/SOM-ANT-IND.C21o.withnubia.data.${REF}.pick
cp $FROM/InputFiles/withnubia/anom21y.tj.withnubia5.points $TO/withnubia/SOM-ANT-IND.C21y.withnubia.data.${REF}.pick
cp $FROM/InputFiles/withnubia/anom22o.tj.withnubia5.points $TO/withnubia/SOM-ANT-IND.C22o.withnubia.data.${REF}.pick
cp $FROM/InputFiles/withnubia/anom23o.tj.withnubia5.points $TO/withnubia/SOM-ANT-IND.C23o.withnubia.data.${REF}.pick
cp $FROM/InputFiles/withnubia/anom24o.tj.withnubia5.points $TO/withnubia/SOM-ANT-IND.C24o.withnubia.data.${REF}.pick
cp $FROM/InputFiles/withnubia/anom25y.tj.withnubia5.points $TO/withnubia/SOM-ANT-IND.C25y.withnubia.data.${REF}.pick
cp $FROM/InputFiles/withnubia/anom26y.tj.withnubia5.points $TO/withnubia/SOM-ANT-IND.C26y.withnubia.data.${REF}.pick
cp $FROM/InputFiles/withnubia/anom27y.tj.withnubia5.points $TO/withnubia/SOM-ANT-IND.C27y.withnubia.data.${REF}.pick
cp $FROM/InputFiles/withnubia/anom28y.tj.withnubia5.points $TO/withnubia/SOM-ANT-IND.C28y.withnubia.data.${REF}.pick
cp $FROM/InputFiles/withnubia/anom29o.tj.withnubia5.points $TO/withnubia/SOM-ANT-IND.C29o.withnubia.data.${REF}.pick
cp $FROM/InputFiles/withswirfzs/anom20o.tj.withbain4.points $TO/withswirfzs/SOM-ANT-IND.C20o.withswirfzs.data.${REF}.pick
cp $FROM/InputFiles/withswirfzs/anom20y.tj.withbain4.points $TO/withswirfzs/SOM-ANT-IND.C20y.withswirfzs.data.${REF}.pick
cp $FROM/InputFiles/withswirfzs/anom21o.tj.withbain4.points $TO/withswirfzs/SOM-ANT-IND.C21o.withswirfzs.data.${REF}.pick
cp $FROM/InputFiles/withswirfzs/anom21y.tj.withbain4.points $TO/withswirfzs/SOM-ANT-IND.C21y.withswirfzs.data.${REF}.pick
cp $FROM/InputFiles/withswirfzs/anom22o.tj.withbain4.points $TO/withswirfzs/SOM-ANT-IND.C22o.withswirfzs.data.${REF}.pick
cp $FROM/InputFiles/withswirfzs/anom23o.tj.withbain4.points $TO/withswirfzs/SOM-ANT-IND.C23o.withswirfzs.data.${REF}.pick
cp $FROM/InputFiles/withswirfzs/anom24o.tj.withbain4.points $TO/withswirfzs/SOM-ANT-IND.C24o.withswirfzs.data.${REF}.pick
cp $FROM/InputFiles/withswirfzs/anom25y.tj.withbain4.points $TO/withswirfzs/SOM-ANT-IND.C25y.withswirfzs.data.${REF}.pick
cp $FROM/InputFiles/withswirfzs/anom26y.tj.withbain4.points $TO/withswirfzs/SOM-ANT-IND.C26y.withswirfzs.data.${REF}.pick
cp $FROM/InputFiles/withswirfzs/anom27y.tj.withbain4.points $TO/withswirfzs/SOM-ANT-IND.C27y.withswirfzs.data.${REF}.pick
cp $FROM/InputFiles/withswirfzs/anom28y.tj.withbain4.points $TO/withswirfzs/SOM-ANT-IND.C28y.withswirfzs.data.${REF}.pick
cp $FROM/InputFiles/withswirfzs/anom29o.tj.withbain4.points $TO/withswirfzs/SOM-ANT-IND.C29o.withswirfzs.data.${REF}.pick
# Next do his model files.  Here we have an issue that each file says which data file was used but those names are now changed.
# E.g., it might say 
# ./withcarlsberg/anom20o.tj_par12: Results from Hellinger3 using anom20o.tj.25.points
# We generate a sed file to replace this on the fly with the renamed file:
find $FROM/PARfiles -name '*.tj_par*' -exec grep -H "Hellinger3" {} \; | tr '/.' '  ' | awk '{printf "sX%s.tj.%s.pointsXSOM-ANT-IND.C%s.%s.data.${REF}.pickXg\n", $16, $18, substr($16,5), $10}' > sed.job
sed -f sed.job $FROM/PARfiles/all/anom20o.tj_par12 > $TO/all/ANT-IND.C20o.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom20o.tj_par13 > $TO/all/SOM-IND.C20o.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom20o.tj_par23 > $TO/all/SOM-ANT.C20o.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom20y.tj_par12 > $TO/all/ANT-IND.C20y.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom20y.tj_par13 > $TO/all/SOM-IND.C20y.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom20y.tj_par23 > $TO/all/SOM-ANT.C20y.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom21o.tj_par12 > $TO/all/ANT-IND.C21o.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom21o.tj_par13 > $TO/all/SOM-IND.C21o.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom21o.tj_par23 > $TO/all/SOM-ANT.C21o.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom21y.tj_par12 > $TO/all/ANT-IND.C21y.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom21y.tj_par13 > $TO/all/SOM-IND.C21y.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom21y.tj_par23 > $TO/all/SOM-ANT.C21y.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom22o.tj_par12 > $TO/all/ANT-IND.C22o.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom22o.tj_par13 > $TO/all/SOM-IND.C22o.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom22o.tj_par23 > $TO/all/SOM-ANT.C22o.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom23o.tj_par12 > $TO/all/ANT-IND.C23o.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom23o.tj_par13 > $TO/all/SOM-IND.C23o.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom23o.tj_par23 > $TO/all/SOM-ANT.C23o.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom24o.tj_par12 > $TO/all/ANT-IND.C24o.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom24o.tj_par13 > $TO/all/SOM-IND.C24o.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom24o.tj_par23 > $TO/all/SOM-ANT.C24o.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom25y.tj_par12 > $TO/all/ANT-IND.C25y.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom25y.tj_par13 > $TO/all/SOM-IND.C25y.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom25y.tj_par23 > $TO/all/SOM-ANT.C25y.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom26y.tj_par12 > $TO/all/ANT-IND.C26y.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom26y.tj_par13 > $TO/all/SOM-IND.C26y.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/all/anom26y.tj_par23 > $TO/all/SOM-ANT.C26y.all.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom13o.tj_par12 > $TO/basic/ANT-IND.C13o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom13o.tj_par13 > $TO/basic/SOM-IND.C13o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom13o.tj_par23 > $TO/basic/SOM-ANT.C13o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom18o.tj_par12 > $TO/basic/ANT-IND.C18o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom18o.tj_par13 > $TO/basic/SOM-IND.C18o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom18o.tj_par23 > $TO/basic/SOM-ANT.C18o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom20o.tj_par12 > $TO/basic/ANT-IND.C20o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom20o.tj_par13 > $TO/basic/SOM-IND.C20o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom20o.tj_par23 > $TO/basic/SOM-ANT.C20o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom20y.tj_par12 > $TO/basic/ANT-IND.C20y.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom20y.tj_par13 > $TO/basic/SOM-IND.C20y.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom20y.tj_par23 > $TO/basic/SOM-ANT.C20y.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom21o.tj_par12 > $TO/basic/ANT-IND.C21o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom21o.tj_par13 > $TO/basic/SOM-IND.C21o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom21o.tj_par23 > $TO/basic/SOM-ANT.C21o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom21y.tj_par12 > $TO/basic/ANT-IND.C21y.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom21y.tj_par13 > $TO/basic/SOM-IND.C21y.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom21y.tj_par23 > $TO/basic/SOM-ANT.C21y.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom22o.tj_par12 > $TO/basic/ANT-IND.C22o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom22o.tj_par13 > $TO/basic/SOM-IND.C22o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom22o.tj_par23 > $TO/basic/SOM-ANT.C22o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom23o.tj_par12 > $TO/basic/ANT-IND.C23o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom23o.tj_par13 > $TO/basic/SOM-IND.C23o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom23o.tj_par23 > $TO/basic/SOM-ANT.C23o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom24o.tj_par12 > $TO/basic/ANT-IND.C24o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom24o.tj_par13 > $TO/basic/SOM-IND.C24o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom24o.tj_par23 > $TO/basic/SOM-ANT.C24o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom25y.tj_par12 > $TO/basic/ANT-IND.C25y.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom25y.tj_par13 > $TO/basic/SOM-IND.C25y.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom25y.tj_par23 > $TO/basic/SOM-ANT.C25y.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom26y.tj_par12 > $TO/basic/ANT-IND.C26y.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom26y.tj_par13 > $TO/basic/SOM-IND.C26y.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom26y.tj_par23 > $TO/basic/SOM-ANT.C26y.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom27y.tj_par12 > $TO/basic/ANT-IND.C27y.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom27y.tj_par13 > $TO/basic/SOM-IND.C27y.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom27y.tj_par23 > $TO/basic/SOM-ANT.C27y.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom28y.tj_par12 > $TO/basic/ANT-IND.C28y.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom28y.tj_par13 > $TO/basic/SOM-IND.C28y.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom28y.tj_par23 > $TO/basic/SOM-ANT.C28y.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom29o.tj_par12 > $TO/basic/ANT-IND.C29o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom29o.tj_par13 > $TO/basic/SOM-IND.C29o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/basic/anom29o.tj_par23 > $TO/basic/SOM-ANT.C29o.basic.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom20o.tj_par12 > $TO/withcarlsberg/ANT-IND.C20o.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom20o.tj_par13 > $TO/withcarlsberg/SOM-IND.C20o.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom20o.tj_par23 > $TO/withcarlsberg/SOM-ANT.C20o.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom20y.tj_par12 > $TO/withcarlsberg/ANT-IND.C20y.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom20y.tj_par13 > $TO/withcarlsberg/SOM-IND.C20y.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom20y.tj_par23 > $TO/withcarlsberg/SOM-ANT.C20y.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom21o.tj_par12 > $TO/withcarlsberg/ANT-IND.C21o.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom21o.tj_par13 > $TO/withcarlsberg/SOM-IND.C21o.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom21o.tj_par23 > $TO/withcarlsberg/SOM-ANT.C21o.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom21y.tj_par12 > $TO/withcarlsberg/ANT-IND.C21y.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom21y.tj_par13 > $TO/withcarlsberg/SOM-IND.C21y.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom21y.tj_par23 > $TO/withcarlsberg/SOM-ANT.C21y.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom22o.tj_par12 > $TO/withcarlsberg/ANT-IND.C22o.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom22o.tj_par13 > $TO/withcarlsberg/SOM-IND.C22o.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom22o.tj_par23 > $TO/withcarlsberg/SOM-ANT.C22o.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom23o.tj_par12 > $TO/withcarlsberg/ANT-IND.C23o.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom23o.tj_par13 > $TO/withcarlsberg/SOM-IND.C23o.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom23o.tj_par23 > $TO/withcarlsberg/SOM-ANT.C23o.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom24o.tj_par12 > $TO/withcarlsberg/ANT-IND.C24o.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom24o.tj_par13 > $TO/withcarlsberg/SOM-IND.C24o.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom24o.tj_par23 > $TO/withcarlsberg/SOM-ANT.C24o.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom25y.tj_par12 > $TO/withcarlsberg/ANT-IND.C25y.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom25y.tj_par13 > $TO/withcarlsberg/SOM-IND.C25y.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom25y.tj_par23 > $TO/withcarlsberg/SOM-ANT.C25y.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom26y.tj_par12 > $TO/withcarlsberg/ANT-IND.C26y.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom26y.tj_par13 > $TO/withcarlsberg/SOM-IND.C26y.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withcarlsberg/anom26y.tj_par23 > $TO/withcarlsberg/SOM-ANT.C26y.withcarlsberg.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom20o.tj_par12 > $TO/withnubia/ANT-IND.C20o.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom20o.tj_par13 > $TO/withnubia/SOM-IND.C20o.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom20o.tj_par23 > $TO/withnubia/SOM-ANT.C20o.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom20y.tj_par12 > $TO/withnubia/ANT-IND.C20y.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom20y.tj_par13 > $TO/withnubia/SOM-IND.C20y.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom20y.tj_par23 > $TO/withnubia/SOM-ANT.C20y.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom21o.tj_par12 > $TO/withnubia/ANT-IND.C21o.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom21o.tj_par13 > $TO/withnubia/SOM-IND.C21o.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom21o.tj_par23 > $TO/withnubia/SOM-ANT.C21o.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom21y.tj_par12 > $TO/withnubia/ANT-IND.C21y.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom21y.tj_par13 > $TO/withnubia/SOM-IND.C21y.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom21y.tj_par23 > $TO/withnubia/SOM-ANT.C21y.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom22o.tj_par12 > $TO/withnubia/ANT-IND.C22o.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom22o.tj_par13 > $TO/withnubia/SOM-IND.C22o.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom22o.tj_par23 > $TO/withnubia/SOM-ANT.C22o.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom23o.tj_par12 > $TO/withnubia/ANT-IND.C23o.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom23o.tj_par13 > $TO/withnubia/SOM-IND.C23o.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom23o.tj_par23 > $TO/withnubia/SOM-ANT.C23o.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom24o.tj_par12 > $TO/withnubia/ANT-IND.C24o.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom24o.tj_par13 > $TO/withnubia/SOM-IND.C24o.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom24o.tj_par23 > $TO/withnubia/SOM-ANT.C24o.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom25y.tj_par12 > $TO/withnubia/ANT-IND.C25y.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom25y.tj_par13 > $TO/withnubia/SOM-IND.C25y.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom25y.tj_par23 > $TO/withnubia/SOM-ANT.C25y.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom26y.tj_par12 > $TO/withnubia/ANT-IND.C26y.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom26y.tj_par13 > $TO/withnubia/SOM-IND.C26y.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withnubia/anom26y.tj_par23 > $TO/withnubia/SOM-ANT.C26y.withnubia.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom20o.tj_par12 > $TO/withswirfzs/ANT-IND.C20o.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom20o.tj_par13 > $TO/withswirfzs/SOM-IND.C20o.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom20o.tj_par23 > $TO/withswirfzs/SOM-ANT.C20o.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom20y.tj_par12 > $TO/withswirfzs/ANT-IND.C20y.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom20y.tj_par13 > $TO/withswirfzs/SOM-IND.C20y.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom20y.tj_par23 > $TO/withswirfzs/SOM-ANT.C20y.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom21o.tj_par12 > $TO/withswirfzs/ANT-IND.C21o.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom21o.tj_par13 > $TO/withswirfzs/SOM-IND.C21o.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom21o.tj_par23 > $TO/withswirfzs/SOM-ANT.C21o.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom21y.tj_par12 > $TO/withswirfzs/ANT-IND.C21y.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom21y.tj_par13 > $TO/withswirfzs/SOM-IND.C21y.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom21y.tj_par23 > $TO/withswirfzs/SOM-ANT.C21y.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom22o.tj_par12 > $TO/withswirfzs/ANT-IND.C22o.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom22o.tj_par13 > $TO/withswirfzs/SOM-IND.C22o.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom22o.tj_par23 > $TO/withswirfzs/SOM-ANT.C22o.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom23o.tj_par12 > $TO/withswirfzs/ANT-IND.C23o.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom23o.tj_par13 > $TO/withswirfzs/SOM-IND.C23o.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom23o.tj_par23 > $TO/withswirfzs/SOM-ANT.C23o.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom24o.tj_par12 > $TO/withswirfzs/ANT-IND.C24o.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom24o.tj_par13 > $TO/withswirfzs/SOM-IND.C24o.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom24o.tj_par23 > $TO/withswirfzs/SOM-ANT.C24o.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom25y.tj_par12 > $TO/withswirfzs/ANT-IND.C25y.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom25y.tj_par13 > $TO/withswirfzs/SOM-IND.C25y.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom25y.tj_par23 > $TO/withswirfzs/SOM-ANT.C25y.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom26y.tj_par12 > $TO/withswirfzs/ANT-IND.C26y.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom26y.tj_par13 > $TO/withswirfzs/SOM-IND.C26y.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom26y.tj_par23 > $TO/withswirfzs/SOM-ANT.C26y.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom27y.tj_par12 > $TO/withswirfzs/ANT-IND.C27y.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom27y.tj_par13 > $TO/withswirfzs/SOM-IND.C27y.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom27y.tj_par23 > $TO/withswirfzs/SOM-ANT.C27y.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom28y.tj_par12 > $TO/withswirfzs/ANT-IND.C28y.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom28y.tj_par13 > $TO/withswirfzs/SOM-IND.C28y.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom28y.tj_par23 > $TO/withswirfzs/SOM-ANT.C28y.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom29o.tj_par12 > $TO/withswirfzs/ANT-IND.C29o.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom29o.tj_par13 > $TO/withswirfzs/SOM-IND.C29o.withswirfzs.model.${REF}.txt
sed -f sed.job $FROM/PARfiles/withswirfzs/anom29o.tj_par23 > $TO/withswirfzs/SOM-ANT.C29o.withswirfzs.model.${REF}.txt

# we create a simple readme.${REF}.txt to
# list the full reference and point to his description document

cat << EOF > $TO/readme.${REF}.txt
The Global Seafloor Fabric and Magnetic Lineation Data Base Project
		http://www.soest.hawaii.edu/PT/GSFML

README file for the ${REF} directory.

The subdirectories all basic withcarlsberg withnubia withswirfzs contain data and model results
for the relative motions between Somalia (SOM), Antarctica (ANT) and India (IND).  The authors have
also provided supporting documentation in the file description.Cande++_2010_JGR.docx.
The data are suitable as input to the modeling program hellinger3.f.
The full reference to the publication is

http://dx.doi.org/10.1111/j.1365-246X.2010.04737.x

Cande, S. C., Patriat, P., and Dyment, J., 2010, Motion between the Indian, Antarctic and African
plates in the early Cenozoic: Geophys. J. Int., v. 183, p. 127-149.
EOF
rm -f sed.job
