The ADMIN directory is where we massage incoming KML- or shape-files to TXT.
For Fracture zone and other tectonic lineaments we can only handle files from
one individual submitter at the time since files are stored in directories for
each submitter.  At the end of the preparation step we wish to have individual
files (one per feature) that starts with a new CVS header and has one
multisegment header that contain 3 segment flags: Feature ID, Label, and Author.
E.g.,

# $Id: README.TXT 200 2013-11-28 20:55:51Z pwessel $
> -L"Mendocino" -IFZ-KM-01-1216 -T"Kara Matthews, U of Sydney"
-96.4606063982  -14.3396468994
-95.8249063982  -14.6403468994
...

------------------------------------------------
In the following, note these abbreviations:
CLASS:	Feature type and one of FZ|LCFZ|DZ|VANOM|UNCV|PR|ER
DIG:	The author abbreviation for this digitizer
SUB:	The number of this digitizers submission (1 is first)

This is the PREP process:

1. Convert to TXT

a) KML data
   Start by using fz_reformatter.sh to reformat the KML submission into a standard
   GMT text datafile.  This will will be called <CLASS>_<DIG>_raw.txt and should be
   examined to make sure the conversion worked.  There might be problems if the
   file is not a Google Earth KML or has been messed with manually.  There might
   also be issues that derive from limitations in kml2gmt.  The usage of fz_reformatter.sh
   is
   
   fz_reformatter.sh KMLfile DIG
   
   where KMLfile is the submitted file (in ../KML) and DIG is the abbreviation of
   the person that digitized these lines (e.g., PW).
b) Shapefiles
   This processing might depend on what is in the shapefiles.
   First run fz_shp2gmt.sh to convert OGR/GMT format.  Then, here are possible tasks:
   1) Changed plate id from double to int (remove .000000 and change type to integer)
   2) added Kara as the AUTHOR value
   3) Let the metadata be called PLATEID and AUTHOR
   4) Convert to GMT txt format (gmtconvert file -aZ=PLATEID,T=AUTHOR)

After this step we may or may not have all the metadata.  E.g., Plate ID may be missing
if the data were digitized in Google Earth; we will alter do processing to add this data.

2. Split FZ strands into individual segments

We use fz_segsplitter.sh to break the raw submission file into individual FZ segments
that each has their separate CVS tags in the 1st record comment line.  We do this
because further processing may reveal that some of the segments are duplicates or
slight revisions to features already recorded.  The syntax is

fz_segsplitter.sh FILE CLASS DIG SUB

where FILE is the raw file from the previous step, DIG the digitizer abbreviation, and
SUB a running number (starting at 1 for DIG's first submission).

3. Check for duplicates

We use fz_dupchecker.sh to determine (a) if some of the submitted FZ segments contain
any duplicates (exact or approximate) and if we pass that test we determine (b) if the
new segments duplicate features already submitted to the database by the same submitter
at a previous occasion.  For approximate duplicates we also consider if the new feature
is a subset or superset of the old feature.  The information will be returned via the
file <DIG>_dup.txt.  The syntax is

fz_dupchecker.sh CLASS DIG SUB

where CLASS, DIG and SUB are the same as in the segsplitter case.

4. Examine the duplicate cases

Use fz_compare.sh to make plots of the cases of duplication reported via the <DIG>_dup.txt
file.  These files will let you determine the status of these contested segments:

1) The submission is clearly more extensive and appears a better selection for this feature
2) The submission is an exact replicate of what is already in the database
3) The submission is a revision to what is in the database.

Depending on status we take the following actions:

1) We move the older feature from the DBASE/<DIG> directory to DBASE/OBSOLETE
   [This requires a cvs remove and a cvs add].  We make an entry in the Changelog
   file inside OBSOLETE as to why this feature was moved here.  The newer feature will
   be added as a NEW entry
2) The new feature is simply deleted and the submitter is notified by email.
3) We will simply update the database with these newer coordinates (version number will
   then increase.)

5. Update the database

We first move any existing features that were flagged into the OBSOLETE directory.
All the files that were not flagged as duplicates will be coped to DBASE/<DIG>
and these will be added via cvs add.  Finally, all new segments that are revisions
will be renamed to their existing name, then moved to DBASE/<DIG>.
The cvs commit will then check in new files and update the revised ones.

The master table of all segments needs to be updated, with new segments being added and
revision having their entries updated.  We do this by simply creating a new master table
based on the contents of the various DIG directories.

Naming: Files will be called <CLASS>_<DIG>_xxxx-yyyy.txt, where
<DIG> is the sub-directory associated with the digitizer
xxxx is the submission number for the digitizer
yyyy is a running number within the current submission.

FOR MAGNETIC LINEATIONS:

So far these files have come via shapefiles which we convert to text using ogr2ogr,
The resulting OGR/GMT files are then stored in the database.

FOR HELLINGER FILES:

Go into HELL_orig and follow past action.  These are the raw submitted files.
To rebuild all HELL distribution files run rename_all.sh from HELL_orig; this
puts the rebuilt files under the HELL directory.


