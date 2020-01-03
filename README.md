# Global Seafloor Fabric and Magnetic Lineations (GSFML) Project

This information is for those who wish to look around and use GSFML.
It is mostly for gurus as regular users can obtain data from the
GSFML website and install supplemental tools from GMT.

To check out the GSFML project from the subversion server, run

git clone https://github.com/PaulWessel/gsfml.git

Files:
README.md:	This file.
Makefile:	Used to run top-level commands like building and deleting
		    releases in zip, tar, kmz formats.

Directories (More information can be found in README.<dir> in each directory)
ADMIN:		Use for the GSFML administrator to deal with the ftp and website
		    as well as in the processing of new data submitted for inclusion
		    in one of the three data bases.
TOOLS:		Contains the GMT5.2 gsfml supplement used to analyze and manipulate
			both FZ and ML data.
FZDATA:		Holds the repository FZ databases and release-building scripts.
MLDATA:		Holds the repository ML databases and release-building scripts.
HELLDATA:	Holds the repository HELL databases and release-building scripts.
