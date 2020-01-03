/*
 * Reformatting to include DOI as aspatial field
 * Also curtail excessive number of decimals in coordinates
 * This was used ONCE to update all existing files on Oct-24.
 * We keep this file in the archive as a reference of what was done.
 *
 * Paul Wessel, Oct. 2014
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <ctype.h>

int main (int argc, char **argv)
{
	char line[BUFSIZ] = {""}, c, var[7][256], doi[BUFSIZ] = {"N/A"};
	int k, rec = 0, nv;
	double x, y;
	if (argc == 2 && argv[1] && strlen(argv[1])) strcpy (doi, argv[1]);
	while (fgets (line, BUFSIZ, stdin)) {
		rec++;
		line[strlen(line)-1] = '\0';
		if (line[0] != '#') {	/* Data records, reformat */
			nv = sscanf (line, "%lg %lg", &x, &y);
			x = rint (x / 0.00001) * 0.00001;	/* No more than 5 decimals, basta */
			y = rint (y / 0.00001) * 0.00001;	/* No more than 5 decimals, basta */
			printf ("%.8g\t%.8g\n", x, y);
		}
		else if (strncmp (line, "# @", 3U)) {	/* Pass other comment records as they are */
			puts (line);
		}
		else {	/* Special OGR records */
			switch (line[3]) {
				case 'N':
					printf ("# @NChron|AnomalyEnd|AnomEndQua|CruiseName|Reference|DOI|GeeK2007|IDMethod\n");
					break;
				case 'T':
					printf ("# @Tstring|string|integer|string|string|string|double|string\n");
					break;
				case 'D':
					nv = sscanf (&line[4], "%[^|]|%[^|]|%[^|]|%[^|]|%[^|]|%[^|]|%[^\0]", var[0], var[1], var[2], var[3], var[4], var[5], var[6]);
					if (nv != 7) {
						fprintf (stderr, "Error: Did not get 7 items in D record at line %d\n", rec);
					}
					else {	/* Output 8 fields */
						printf ("# @D%s", var[0]);
						for (k = 1; k <= 4; k++) printf ("|%s", var[k]);
						printf ("|%s", doi);	/* Add the DOI */
						for (k = 5; k <= 6; k++) printf ("|%s", var[k]);
						printf ("\n");
					}
					break;
				default:
					puts (line);
					break;
			}
		}
	}
	exit (0);
}