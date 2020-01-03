/*
 * Enforcerer for consistent MLDATA format.  If the order of the metadata
 * is not in the expected order we shuffle the columns on output.  Also
 * we will warn if any metadata is blank.  If run with the -d option it will
 * just tell us if the order needs shuffling and count metadata blanks but
 * not write new data on output [Default writes correct file].  If run with
 * -D it will not print anything but return the number of missing metadata
 * as the exit status.
 * We check for corect Chron names, correct Geek2007 values, accept only
 * y, c, o as end.
 * As of OCt, 2014 we now expect a DOI field after the reference.
 * Paul Wessel, Oct. 2014
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <ctype.h>

#define N_VAR	8

#define CHRON_COL	0
#define END_COL		1
#define QUAL_COL	2
#define REF_COL		4
#define DOI_COL		5
#define AGE_COL		6
#define METHOD_COL	7

#define ML_NORMAL	0
#define ML_REVERSE	1
#define ML_YOUNG	0
#define ML_OLD		1

struct ML_CHRON {	/* Holds chron and young/old ages */
	double young, old;
};

int ML_lookup (char *chron, char *names[])
{
	int k = 0;
	while (names[k] && strcmp (chron, names[k])) k++;
	return (names[k] ? k : -1);
}

int main (int argc, char **argv)
{
	int n_tot = 0, n_chron = 0, n_end = 0, n_ref = 0, n_qual = 0, n_meth = 0, n_bad = 0, n_alt = 0, version, region, proj = 0;
	int n_lax = 0, n_age = 0, n_age_c = 0, n_cm = 0, n_nopolar = 0, n_y = 0, n_x = 0, n_uscore, n_space, quality;
	int k, p, nv, nt, nd, start, stop, polarity, out = 1, verbose = 1, rec = 0, set = 0, order[N_VAR] = {-1, -1, -1, -1, -1, -1, -1, -1};
	char line[BUFSIZ] = {""}, c;
	char *want[N_VAR] = {"Chron", "AnomalyEnd", "AnomEndQua", "CruiseName", "Reference", "DOI", "GeeK2007", "IDMethod"};
	char *want_alt[N_VAR] = {"Chron", "AnomalyEnd", "AnomEndQua", "CruiseName", "Reference", "DOI", "GeeK07", "IDMethod"};
	char *type[N_VAR] = {"string", "string", "integer", "string", "string", "string", "double", "string"};
	char *dset[5] = {"Unknown", "Atlantic", "Indian", "MarginalBasins", "Pacific"};
	char var[N_VAR][256], tmp[256], *file = NULL, *nfile = "stdin", *q = NULL, **Cname[2] = {NULL, NULL}, **Cname2[2] = {NULL, NULL};
	FILE *fp = stdin;
	struct ML_CHRON *M[2] = {NULL, NULL};
	double age, chron_age, x, y;
	static char *Chron_Normal[] = {
#include "../TOOLS/src/Chron_Normal.h"
	};
	static char *Chron_Reverse[] = {
#include "../TOOLS/src/Chron_Reverse.h"
	};
	static char *Chron_Normal2[] = {
#include "../TOOLS/src/Chron_Normal2.h"
	};
	static char *Chron_Reverse2[] = {
#include "../TOOLS/src/Chron_Reverse2.h"
	};
	static struct ML_CHRON Geek2007n[] = {
#include "../TOOLS/src/Geek2007n.h"
	};
	static struct ML_CHRON Geek2007r[] = {
#include "../TOOLS/src/Geek2007r.h"
	};
	
	Cname[ML_NORMAL] = Chron_Normal;	/* Set pointer to the two timescale chron nwith strict names */
	Cname[ML_REVERSE] = Chron_Reverse;
	Cname2[ML_NORMAL] = Chron_Normal2;	/* Set pointer to the two timescale chron with uppercase/no period/hyphen names */
	Cname2[ML_REVERSE] = Chron_Reverse2;
	M[ML_NORMAL]  = Geek2007n;	
	M[ML_REVERSE] = Geek2007r;
	for (k = 1; k < argc; k++) {
		if (!strcmp (argv[k], "-d")) out = 0;
		else if (!strcmp (argv[k], "-D")) out = verbose = 0;
		else file = argv[k];
	}
	if (file && (fp = fopen (file, "r")) == NULL) {
		fprintf (stderr, "enforcerer: Error: Could not open file %s\n", file);
		exit (-1);
	}
	if (file) {	/* Strip off directory in message */
		for (k = strlen (file); k > 0 && file[k] != '/'; k--);
		nfile = &file[k];
		if (strstr (file, "Atlantic"))
			set = 1;
		else if (strstr (file, "Indian"))
			set = 2;
		else if (strstr (file, "Marginal"))
			set = 3;
		else if (strstr (file, "Pacific"))
			set = 4;
	}
	while (fgets (line, BUFSIZ, fp)) {
		rec++;
		line[strlen(line)-1] = '\0';
		if (line[0] != '#') {	/* Data record */
			sscanf (line, "%lg %lg", &x, &y);
			if (fabs (y) > 90.0) n_y++;
			if (x < -180.0 || x >= 360.0) n_x++;
			while (x > +180.0) x -= 360.0;
			while (x < -180.0) x += 360.0;
			if (out) {	/* Only use max 5 decimals ~ 1 m resolution */
				x = rint (x / 0.00001) * 0.00001;	/* No more than 5 decimals, basta */
				y = rint (y / 0.00001) * 0.00001;	/* No more than 5 decimals, basta */
				printf ("%.8g\t%.8g\n", x, y);
			}
		}
		else if (strncmp (line, "# @", 3U)) {
			if (out) puts (line);
		}
		else {
			switch (line[3]) {
				case 'V':
					puts (line);
					version = 1; break;
				case 'R':
					puts (line);
					region = 1; break;
				case 'J':
					puts (line);
					proj++; break;
				case 'N':
					nv = sscanf (&line[4], "%[^|]|%[^|]|%[^|]|%[^|]|%[^|]|%[^|]|%[^|]|%[^\0]", var[0], var[1], var[2], var[3], var[4], var[5], var[6], var[7]);
					if (nv != N_VAR) { fprintf (stderr, "enforcerer: ERROR [%s->%s]: Bad @N record: Did not find all %d expected items\n", dset[set], nfile, N_VAR); exit (-1);}
					for (k = 0; k < N_VAR; k++) {
						for (p = 0; p < N_VAR; p++) {
							if (!strcasecmp (want[k], var[p]))
								order[k] = p, p = N_VAR;	/* Success, mark order */
							else if (!strcasecmp (want_alt[k], var[p])) {	/* Also OK, but replace with main names */
								order[k] = p, p = N_VAR;
								strcpy (var[p], want_alt[k]);
								n_alt++;
							}
						}
					}
					for (k = 0; k < N_VAR; k++) if (order[k] == -1) {fprintf (stderr, "enforcerer: ERROR [%s->%s]: @N record does not have all required items\n", dset[set], nfile); exit (-1);}
					for (k = p = 0; k < N_VAR; k++) if (order[k] != k) p++;
					if (p && verbose) fprintf (stderr, "enforcerer: Warning [%s->%s]: Must shuffle %d fields:", dset[set], nfile, p); 
					for (k = 0; k < N_VAR; k++) if (k != order[k] && verbose) fprintf (stderr, " %d -> %d", k, order[k]);
					if (p && verbose) fprintf (stderr, "\n");
					if (out) {
						printf ("# @N%s", want[0]);
						for (k = 1; k < N_VAR; k++) printf ("|%s", want[k]);
						printf ("\n");
					}
					break;
				case 'T':
					nt = sscanf (&line[4], "%[^|]|%[^|]|%[^|]|%[^|]|%[^|]|%[^|]|%[^|]|%[^\0]", var[0], var[1], var[2], var[3], var[4], var[5], var[6], var[7]);
					if (nt != nv) { fprintf (stderr, "enforcerer: ERROR [%s->%s]: Bad @T record: Did not find all %d expected items\n", dset[set], nfile, N_VAR); exit (-1);}
					for (k = p = 0; k < N_VAR; k++) {
						if (strcasecmp (type[k], var[order[k]])) {
							if (verbose) fprintf (stderr, "enforcerer: Warning [%s->%s]: Bad @T record: Found type %s but expected %s\n", dset[set], nfile, var[order[k]], type[k]);
							p++;
						}
					}
					if (out) {
						printf ("# @T%s", type[0]);
						for (k = 1; k < N_VAR; k++) printf ("|%s", type[k]);
						printf ("\n");
					}
					break;
				case 'D':
					for (k = 4, nd = 1; k < strlen (line); k++) if (line[k] == '|') nd++;
					if (nd != N_VAR) { fprintf (stderr, "enforcerer: ERROR [%s->%s]: Bad @D record (line %d): Only found %d of %d expected items\n", dset[set], nfile, rec, nd, N_VAR); exit (-1);}
					stop = 3;
					for (k = nt = 0; k < N_VAR; k++) {
						start = stop + 1;
						stop = start;
						while (line[stop] && line[stop] != '|') stop++;
						if (stop > start)
							strncpy (var[k], &line[start], stop-start);
						else
							nt++;
						var[k][stop-start] = '\0';
					}
					if (nt && verbose) fprintf (stderr, "enforcerer: Warning [%s->%s]: Found %d blank metadata fields in line %d\n", dset[set], nfile, nt, rec);
					n_tot += nt;
					if (!(var[order[CHRON_COL]][0] == 'C' || var[order[CHRON_COL]][0] == 'M')) {	/* Chron does not start with C or M, insert C */
						n_chron++;
						strcpy (tmp, var[order[CHRON_COL]]);
						sprintf (var[order[CHRON_COL]], "C%s", tmp);
					}
					else if (var[order[CHRON_COL]][0] == 'c')	/* Fix lower case chron letters */
						var[order[CHRON_COL]][0] = 'C';
					else if (var[order[CHRON_COL]][0] == 'm')
						var[order[CHRON_COL]][0] = 'M';
					c = var[order[CHRON_COL]][strlen(var[order[CHRON_COL]])-1];
					if (c == 'r' || c == 'R') 
						polarity = ML_REVERSE;
					else if (c == 'n' || c == 'N') 
						polarity = ML_NORMAL;
					else {	/* Assume it is a normal chron */
						polarity = ML_NORMAL;
						n_nopolar++;
						strcat (var[order[CHRON_COL]], "n");
					}
					k = ML_lookup (var[order[CHRON_COL]], Cname[polarity]);	/* Try exact name standard */
					if (k == -1) {	/* Could not find a matching entry */
						char chron[16];
						k = p = 0; while ((c = var[order[CHRON_COL]][k++])) if (!(c == '.' || c == '-')) chron[p++] = toupper (c);
						chron[p] = 0;
						k = ML_lookup (chron, Cname2[polarity]);	/* Try lax standard */
						if (k >= 0) {	/* OK, found the match, replace with strict nomenclature  */
							strcpy (var[order[CHRON_COL]], Cname[polarity][k]);
							n_lax++;
						}
						else {	/* Unrecognized */
							n_bad++;
							if (verbose) fprintf (stderr, "enforcerer: Error [%s->%s]: Could not uniquely determine correct name for Chron %s\n", dset[set], nfile, var[order[CHRON_COL]]);
						}
					}
					if (!strchr ("cmyo", var[order[END_COL]][0])) {	/* Not recognized end */
						n_end++;
					}
					else if (var[order[END_COL]][0] == 'm') {	/* Replace m with c for clarity */
						var[order[END_COL]][0] = 'c';
						n_cm++;
					}
					age = atof (var[order[AGE_COL]]);
					if (k != -1) {	/* Found the chron */
						if (strchr ("yo", var[order[END_COL]][0])) {	/* Is either y or o: check if time matches GeeK2007 */
							age = rint (age / 0.001) * 0.001;	/* No more than 3 decimals, basta */
							chron_age = (var[order[END_COL]][0] == 'y') ? M[polarity][k].young :  M[polarity][k].old;
							if (fabs (age - chron_age) > 0.0001) {
								if (verbose) fprintf (stderr, "enforcerer: Warning [%s->%s]: Recorded age (%g) does not match GeeK2007 scale for Chron %s (%g)\n", dset[set], nfile, age, var[order[CHRON_COL]], chron_age);
								age = chron_age;
								n_age++;
							}
						}
						else if (var[order[END_COL]][0] == 'c') {	/* Center of anomaly; compute and compare */
							age = rint (age / 0.0001) * 0.0001;	/* No more than 4 decimals, basta */
							chron_age = 0.5 * (M[polarity][k].young + M[polarity][k].old);
							chron_age = rint (chron_age / 0.0001) * 0.0001;	/* No more than 4 decimals, basta */
							if (fabs (age - chron_age) > 0.0001) {
								if (verbose) fprintf (stderr, "enforcerer: Warning [%s->%s]: Recorded age (%g) does not match GeeK2007 scale for center of Chron %s (%g)\n", dset[set], nfile, age, var[order[CHRON_COL]], chron_age);
								age = chron_age;
								n_age_c++;
							}
						}
					}
					else	
						age = rint (age / 0.001) * 0.001;	/* No more than 3 decimals, basta */
					quality = (int)rint (atof (var[order[QUAL_COL]]));
					if (quality < 1 || quality > 3) {
						if (verbose) fprintf (stderr, "enforcerer: Error [%s->%s]: Quality of end assignment (%d) not in 1-3 range\n", dset[set], nfile, quality);
						n_qual++;
					}
					else
						sprintf (var[order[QUAL_COL]], "%d", quality);
						
					for (k = n_uscore = n_space = 0; var[order[REF_COL]][k]; k++) {
						if (var[order[REF_COL]][k] == '_') n_uscore++;
						if (var[order[REF_COL]][k] == ' ') n_space++;
					}
					if (n_uscore != 2 || n_space) n_ref++;
					/* Print out age, possibly with fewer decimals or updated GeeK2007 age */
					sprintf (var[order[AGE_COL]], "%g", age);
					if (strlen (var[order[METHOD_COL]]) == 0) {	/* Blank method, assume magnetic anomaly, but warn */
						strcpy (var[order[METHOD_COL]], "\"Magnetic Anomaly\"");
						n_meth++;
					}
					else if (!strcmp (var[order[METHOD_COL]], "magnetic_anomaly"))
						strcpy (var[order[METHOD_COL]], "\"Magnetic Anomaly\"");
					else if (!strcmp (var[order[METHOD_COL]], "magnetic_profile"))
						strcpy (var[order[METHOD_COL]], "\"Magnetic Anomaly\"");
					else if (!strcmp (var[order[METHOD_COL]], "abyssal_hill"))
						strcpy (var[order[METHOD_COL]], "\"Abyssal Hill\"");
					if (out) {
						printf ("# @D%s", var[order[0]]);
						for (k = 1; k < N_VAR; k++) printf ("|%s", var[order[k]]);
						printf ("\n");
					}
					break;
				default:
					if (out) puts (line);
					break;
			}
		}
	}
	if (!version) fprintf (stderr, "enforcerer: Error [%s->%s]: No version OGR line found in this file\n", dset[set], nfile);
	if (!region) fprintf (stderr, "enforcerer: Error [%s->%s]: No region OGR line found in this file\n", dset[set], nfile);
	if (!proj) fprintf (stderr, "enforcerer: Error [%s->%s]: No proj OGR lines found in this file\n", dset[set], nfile);
	if (n_tot && verbose)   fprintf (stderr, "enforcerer: Warning [%s->%s]: Found %d blank metadata fields in this file\n", dset[set], nfile, n_tot);
	if (n_chron && verbose) fprintf (stderr, "enforcerer: Warning [%s->%s]: Found %d Chron strings with missing leading C|M [C]\n", dset[set], nfile, n_chron);
	if (n_lax && verbose)   fprintf (stderr, "enforcerer: Warning [%s->%s]: Found %d lax Chron strings were replaced with strict nomenclature\n", dset[set], nfile, n_lax);
	if (n_bad && verbose)   fprintf (stderr, "enforcerer: Warning [%s->%s]: Found %d Chron strings that could not be matched with time scale entries\n", dset[set], nfile, n_bad);
	if (n_age && verbose)   fprintf (stderr, "enforcerer: Warning [%s->%s]: Found %d Chron strings that did not match GeeK2007 ages\n", dset[set], nfile, n_age);
	if (n_age_c && verbose) fprintf (stderr, "enforcerer: Warning [%s->%s]: Found %d Chron centers that did not match GeeK2007 center ages\n", dset[set], nfile, n_age_c);
	if (n_end && verbose)   fprintf (stderr, "enforcerer: Warning [%s->%s]: Found %d AnomalyEnd letters not being one of c,m,y,o\n", dset[set], nfile, n_end);
	if (n_cm && verbose)    fprintf (stderr, "enforcerer: Warning [%s->%s]: Found %d AnomalyEnd letters set to m, changed to c instead\n", dset[set], nfile, n_cm);
	if (n_nopolar && verbose) fprintf (stderr, "enforcerer: Warning [%s->%s]: Found %d Chron strings without trailing polarity, assumed Normal\n", dset[set], nfile, n_nopolar);
	if (n_qual && verbose)  fprintf (stderr, "enforcerer: Warning [%s->%s]: Found %d Anomaly quality indicator not being in 1-3 range\n", dset[set], nfile, n_qual);
	if (n_ref && verbose)   fprintf (stderr, "enforcerer: Warning [%s->%s]: Found %d Reference strings containing spaces and not underscores\n", dset[set], nfile, n_ref);
	if (n_meth && verbose)  fprintf (stderr, "enforcerer: Warning [%s->%s]: Found %d blank IDMethod strings; we assume \"Magnetic Anomaly\"\n", dset[set], nfile, n_meth);
	if (n_y && verbose)     fprintf (stderr, "enforcerer: Warning [%s->%s]: Found %d data records with latitudes out of range\n", dset[set], nfile, n_y);
	if (n_alt && verbose)   fprintf (stderr, "enforcerer: Warning [%s->%s]: Found %d @N records with altername names (replaced)\n", dset[set], nfile, n_alt);
	if (file) fclose (fp);
	exit (n_tot);
}