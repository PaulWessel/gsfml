#-------------------------------------------------------------------------------
#
#	Guru Makefile for gsfml/TOOLS directory
#	
#	!!! THIS MAKEFILE IS FOR GSFML DEVELOPERS ONLY !!!
#
#	This makefile generates certain C include files from
#	lower-level data files available in svn.
#
#	Author:	Paul Wessel, SOEST, University of Hawaii
#
#	Date:		01-DEC-2023
#-------------------------------------------------------------------------------
sinclude build/src/config.mk
include Makefile
GNUTAR		= $(shell which gnutar || which gtar || which tar)

help::
		@grep '^#!' GNUmakefile | cut -c3-
#!---------------- MAKE HELP FOR GSFML GURUS ----------------
#!
#!update    : Get the latest GSFML source via svn
#!includes  : Create includes needed to build TOOLS
#!archive   : Create a tar ball of the TOOLS source codes
#!man       : Create UNIX and PDF versions of manpages
#!

archive:	man includes config
		cp cmake/ConfigUserTemplate.cmake cmake/ConfigUser.cmake
		cd ..; ln -s TOOLS gmt-gsfml-$(GSFML_VERSION)
		COPYFILE_DISABLE=true $(GNUTAR) --owner 0 --group 0 --mode a=rX,u=rwX -C .. \
			-cvjf ../gmt-gsfml-$(GSFML_VERSION)-src.tar.bz2 \
			gmt-gsfml-$(GSFML_VERSION)/README.gsfml gmt-gsfml-$(GSFML_VERSION)/README.CMake \
			gmt-gsfml-$(GSFML_VERSION)/CMakeLists.txt \
			gmt-gsfml-$(GSFML_VERSION)/Makefile gmt-gsfml-$(GSFML_VERSION)/src \
			gmt-gsfml-$(GSFML_VERSION)/cmake gmt-gsfml-$(GSFML_VERSION)/share
		rm -f ../gmt-gsfml-$(GSFML_VERSION)

man:
		(cd doc; $(MAKE) doc)

prep:	includes src/gsfml_glue.c

includes:	src/Chron_Normal.h src/Chron_Reverse.h src/Geek2007n.h  \
		src/Geek2007r.h src/CK1995n.h src/CK1995r.h src/GST2004n.h \
		src/GST2004r.h src/GST2012n.h src/GST2012r.h

update:
		svn update

# These builds the various include files used in TOOLS.
# Should timescales.txt be updated then the software will adapt accordingly.
# Should additional timescales be added to the file then we will need to add
# more cases below to capture the extra include files that should be made.

src/Chron_Normal.h:	../MLDATA/timescales.txt
	grep -v '^#' ../MLDATA/timescales.txt | awk '{printf "\"%s\",\n", $$1}' | sed -e s/CM/M/g > src/Chron_Normal.h
	echo NULL >> src/Chron_Normal.h
	grep -v '^#' ../MLDATA/timescales.txt | awk '{printf "\"%s\",\n", $$1}' | sed -e s/CM/M/g -e "s/\.//g" | tr 'a-z' 'A-Z' > src/Chron_Normal2.h
	echo NULL >> src/Chron_Normal2.h

src/Chron_Reverse.h:	../MLDATA/timescales.txt
	grep -v '^#' ../MLDATA/timescales.txt | awk '{printf "\"%s\",\n", $$10}' | sed -e s/CM/M/g > src/Chron_Reverse.h
	echo NULL >> src/Chron_Reverse.h
	grep -v '^#' ../MLDATA/timescales.txt | awk '{printf "\"%s\",\n", $$10}' | sed -e s/CM/M/g -e "s/\.//g" | tr 'a-z' 'A-Z' > src/Chron_Reverse2.h
	echo NULL >> src/Chron_Reverse2.h

# We use -999.0 to indicate end of the chron lists
src/Geek2007n.h:	../MLDATA/timescales.txt
	grep -v '^#' ../MLDATA/timescales.txt | awk '{printf "{ %s, %s },\n", $$2, $$3}' | sed -e sBN/AB-1.0Bg > src/Geek2007n.h
	echo { -999.0, -999.0} >> src/Geek2007n.h

src/Geek2007r.h:	../MLDATA/timescales.txt
	grep -v '^#' ../MLDATA/timescales.txt | awk '{printf "{ %s, %s },\n", $$11, $$12}' | sed -e sBN/AB-1.0Bg > src/Geek2007r.h
	echo { -999.0, -999.0} >> src/Geek2007r.h

src/CK1995n.h:	../MLDATA/timescales.txt
	grep -v '^#' ../MLDATA/timescales.txt | awk '{printf "{ %s, %s },\n", $$4, $$5}' | sed -e sBN/AB-1.0Bg > src/CK1995n.h
	echo { -999.0, -999.0} >> src/CK1995n.h

src/CK1995r.h:	../MLDATA/timescales.txt
	grep -v '^#' ../MLDATA/timescales.txt | awk '{printf "{ %s, %s },\n", $$13, $$14}' | sed -e sBN/AB-1.0Bg > src/CK1995r.h
	echo { -999.0, -999.0} >> src/CK1995r.h

src/GST2004n.h:	../MLDATA/timescales.txt
	grep -v '^#' ../MLDATA/timescales.txt | awk '{printf "{ %s, %s },\n", $$6, $$7}' | sed -e sBN/AB-1.0Bg > src/GST2004n.h
	echo { -999.0, -999.0} >> src/GST2004n.h

src/GST2004r.h:	../MLDATA/timescales.txt
	grep -v '^#' ../MLDATA/timescales.txt | awk '{printf "{ %s, %s },\n", $$15, $$16}' | sed -e sBN/AB-1.0Bg > src/GST2004r.h
	echo { -999.0, -999.0} >> src/GST2004r.h

src/GST2012n.h:	../MLDATA/timescales.txt
	grep -v '^#' ../MLDATA/timescales.txt | awk '{printf "{ %s, %s },\n", $$8, $$9}' | sed -e sBN/AB-1.0Bg > src/GST2012n.h
	echo { -999.0, -999.0} >> src/GST2012n.h

src/GST2012r.h:	../MLDATA/timescales.txt
	grep -v '^#' ../MLDATA/timescales.txt | awk '{printf "{ %s, %s },\n", $$17, $$18}' | sed -e sBN/AB-1.0Bg > src/GST2012r.h
	echo { -999.0, -999.0} >> src/GST2012r.h

src/gsfml_glue.c: FORCE
	(cd src; rm -f gsfml_glue.c; gmt --new-glue=gsfml > gsfml_glue.c)

FORCE:

clean::
	(cd doc; $(MAKE) clean)

spotless::
	rm -f src/gsfml_glue.c src/Geek2007n.h src/Geek2007r.h src/CK1995n.h src/CK1995r.h src/GST2004n.h src/GST2004r.h src/GST2012n.h \
		src/GST2012r.h src/Chron_Normal.h src/Chron_Reverse.h src/Chron_Normal2.h src/Chron_Reverse2.h src/mlconverter.h
	rm -rf build
	(cd doc; $(MAKE) spotless)
	rm -rf share
