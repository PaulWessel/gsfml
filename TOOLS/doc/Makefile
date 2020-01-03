#-------------------------------------------------------------------------------
#  $Id: Makefile 422 2017-05-05 22:44:09Z pwessel $
#
#	Guru Makefile for gsfml/TOOLS/doc directory
#	
#	!!! THIS MAKEFILE IS FOR GSFML DEVELOPERS ONLY !!!
#
#	This makefile generates UNIX man pages and their PDF versions.
#
#	Author:	Paul Wessel, SOEST, University of Hawaii
#
#	Date:		5-MAY-2017
#-------------------------------------------------------------------------------

MANTXT	= fzanalyzer.txt fzblender.txt fzinformer.txt fzmapper.txt fzmodeler.txt fzprofiler.txt mlconverter.txt
MAN1	= $(MANTXT:.txt=.1)
MANPDF	= $(MAN1:.1=.1.pdf)

SUFFIXES:       .1 .3 .5 .txt

pdf:	$(MAN1)
	for i in $(MAN1); do \
		groff -man $$i > $$i.ps; \
		ps2pdf $$i.ps; \
		rm -f $$i.ps; \
		echo "Built $$i.pdf" ;\
	done
	gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=GSFML.pdf $(MANPDF)
	echo "All GSFML man PDF pages are now in GSFML.pdf"

doc:	pdf
	mkdir -p ../share/doc/man  ../share/doc/pdf
	cp *.pdf ../share/doc/pdf
	cp *.1 ../share/doc/man

clean:
	rm -f *.1 *.1.pdf GSFML.pdf

spotless:	clean

%.1 %.3 %.5:	%.txt
	@cp -f $< junk.c
	cpp -w -P -nostdinc -I$(GMTHOME5)/sandbox/olddocs/txt -DMANDATE=`date +%Y-%b-%d` -I../src -I../build/src junk.c | egrep -v '^#|^$$' > $@
	@rm -f junk.c
