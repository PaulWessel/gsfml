#	README file for HELLDATA
# P. Wessel, January 6, 2014


This is a staging directory for building the final HELL files.
It contains the original submissions received from researchers.
These are stored in the various reference-directories, e.g.
   Cande++_2010_GJI, Gaina++_1998_JGR, etc.
In case something stupid happens we can go back to these and
regenerate the derived files should a bug be found or we decide
to make changes to the final formats.

These are the steps taken when we receive a new contribution:

1. Determine a suitable reference name [author(s)_year_journal],
   create a new directory in HELLDATA by that name,
   and put the original material there.  This directory is then
   added to subversion.  If the author also provides the full ML
   picks then make sure the same reference abbreviation is used.
2. Add a rename.sh script to this dir that handles the translation
   from the users contributed files to the standardized naming
   convention used on the HELL site.  Because the steps may differ
   depending on the submission we just start with one of the other
   rename.sh script and customize it to the new submission.
3. Add a info.txt file which contains which ocean the data pertains
   to and the complete reference.  See other info.txt files for the
   correct format.  This info is used in generating the web tables.
   Make sure to add and commit all these files.

The raw repository data in HELLDATA is used to build the final HELL
sub-site with its data products.
To regenerate all the files in the HELL directory you run
build_HELL_site.sh from inside the HELLDATA directory.  This produces
a new HELL dir with html and data files.  The top-level Makefile
also has targets that can be used instead:

	make HELL	: will create the HELL directory
	make place_hell	: will copy this directory to the web server.
