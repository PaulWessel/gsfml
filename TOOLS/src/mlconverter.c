/*
 * $Id: mlconverter.c 429 2018-07-01 00:54:37Z pwessel $
 *
 * Copyright (c) 2015-2020 by P. Wessel
 * See LICENSE.TXT file for copying and redistribution conditions.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; version 3 or any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * Contact info: http://www.soest.hawaii.edu/PT/GSFML
 *--------------------------------------------------------------------
 *
 * mlconverter converts chron strings and anomaly end (y|o) to age using
 * a magnetic timescale.  The input files must be the OGT/GMT-formatted
 * ML_*.gmt files distributed by the GSFML project.
 *
 * Author:	Paul Wessel
 * Date:	5-MAY-2017 (Requires GMT >= 5.2)
 */

#define THIS_MODULE_NAME	"mlconverter"
#define THIS_MODULE_LIB		"gsfml"
#define THIS_MODULE_PURPOSE	"Convert chrons to ages using selected magnetic timescale"
#define THIS_MODULE_KEYS	"<DI,>DO"
#define THIS_MODULE_NEEDS       ""
#define THIS_MODULE_OPTIONS	"-:>RVabfghior"

#include "gmt_dev.h"
#include "fz_analysis.h"

#define ML_GEEK2007	0
#define ML_CK1995	1
#define ML_GST2004	2

#define ML_NORMAL	0
#define ML_REVERSE	1
#define ML_YOUNG	0
#define ML_OLD		1

struct MLCONVERTER_CTRL {
	struct A {	/* -A */
		unsigned int active;
	} A;
	struct G {	/* -G */
		unsigned int active;
		unsigned int mode;
	} G;
	struct S {	/* -S */
		unsigned int active;
	} S;
	struct T {	/* -T[g|c|s] */
		unsigned int active;
		unsigned int mode;
	} T;
};

EXTERN_MSC int gmtlib_append_ogr_item (struct GMT_CTRL *GMT, char *name, unsigned int type, struct GMT_OGR *S);
EXTERN_MSC void gmtlib_write_ogr_header (FILE *fp, struct GMT_OGR *G);

static void *New_Ctrl (struct GMT_CTRL *GMT) {	/* Allocate and initialize a new control structure */
	struct MLCONVERTER_CTRL *C;
	
	C = gmt_M_memory (GMT, NULL, 1, struct MLCONVERTER_CTRL);
	
	/* Initialize values whose defaults are not 0/false/NULL */
	return (C);
}

static void Free_Ctrl (struct GMT_CTRL *GMT, struct MLCONVERTER_CTRL *C) {	/* Deallocate control structure */
	if (!C) return;
	gmt_M_free (GMT, C);	
}

static int usage (struct GMTAPI_CTRL *API, int level)
{
	gmt_show_name_and_purpose (API, THIS_MODULE_LIB, THIS_MODULE_NAME, THIS_MODULE_PURPOSE);
	if (level == GMT_MODULE_PURPOSE) return (GMT_NOERROR);
	GMT_Message (API, GMT_TIME_NONE, "usage: mlconverter [<ML_data>] [-A] [-G] [-S] [-Tc|g|s] [%s]\n", GMT_V_OPT);
	GMT_Message (API, GMT_TIME_NONE, "\t[This is GSMFL Version %s]\n\n", GSFML_PACKAGE_VERSION);

	if (level == GMT_SYNOPSIS) return (EXIT_FAILURE);

	GMT_Message (API, GMT_TIME_NONE, "\n\tOPTIONS:\n");
	GMT_Message (API, GMT_TIME_NONE, "\t-A Append metadata to data record as extra columns [Only write lon lat age].\n");
	GMT_Message (API, GMT_TIME_NONE, "\t-G Generate an extended OGR/GMT table by appending the crustal age.\n");
	GMT_Message (API, GMT_TIME_NONE, "\t   Append s to repair any lax chron nomenclature, if needed.\n");
	GMT_Message (API, GMT_TIME_NONE, "\t-S Strict chron nomenclature expected; report any lax use [do the best we can].\n");
	GMT_Message (API, GMT_TIME_NONE, "\t-T Select a magnetic time scale:\n");
	GMT_Message (API, GMT_TIME_NONE, "\t   g: Gee and Kent, 2007 [Default].\n");
	GMT_Message (API, GMT_TIME_NONE, "\t   s: Gradstein, 2004.\n");
	GMT_Message (API, GMT_TIME_NONE, "\t   c: Cande and Kent, 1995.\n");
	GMT_Option (API, "V,.");

	return (EXIT_FAILURE);
}

static int parse (struct GMTAPI_CTRL *API, struct MLCONVERTER_CTRL *Ctrl, struct GMT_OPTION *options) {

	/* This parses the options provided to grdsample and sets parameters in CTRL.
	 * Any GMT common options will override values set previously by other commands.
	 * It also replaces any file names specified as input or output with the data ID
	 * returned when registering these sources/destinations with the API.
	 */

	unsigned int n_files = 0, n_errors = 0;
	struct GMT_OPTION *opt = NULL;

	for (opt = options; opt; opt = opt->next) {
		switch (opt->option) {

			case '<':	/* Skip input files */
				n_files++;
				break;

			/* Processes program-specific parameters */

			case 'A':
				Ctrl->A.active = 1;
				break;
			case 'G':
				Ctrl->G.active = 1;
				if (opt->arg[0] == 's') Ctrl->G.mode = 1;
				break;
			case 'S':
				Ctrl->S.active = 1;
				break;
			case 'T':
				Ctrl->T.active = 1;
				switch (opt->arg[0]) {
					case 'g': Ctrl->T.mode = ML_GEEK2007; break;
					case 'c': Ctrl->T.mode = ML_CK1995; break;
					case 's': Ctrl->T.mode = ML_GST2004; break;
					default:
						GMT_Message (API, GMT_TIME_NONE, "Error: Not a valid time scale for option -T [%c].\n", (int)opt->arg[0]);
						n_errors++;
						break;
				}
				break;

			default:	/* Report bad options */
				n_errors += gmt_default_error (API->GMT, opt->option);
				break;
		}
	}
	
        n_errors += gmt_M_check_condition (API->GMT, Ctrl->A.active && Ctrl->G.active, "GMT SYNTAX ERROR:  Cannot use both -A and -E.\n");
	return (n_errors ? GMT_PARSE_ERROR : GMT_OK);
}

#define bailout(code) {gmt_M_free_options (mode); return (code);}
#define Return(code) {Free_Ctrl (GMT, Ctrl); gmt_end_module (GMT, GMT_cpy); bailout (code);}

struct ML_CHRON {	/* Holds chron and young/old ages */
	double young, old;
};

static int mlconverter_lookup (char *chron, char *names[])
{
	int k = 0;
	while (names[k] && strcmp (chron, names[k])) k++;
	return (names[k] ? k : -1);
}

int GMT_mlconverter (void *V_API, int mode, void *args) {
	int k, j, n_read = 0, side, polarity, error, n_lax = 0, n_bad = 0;
	bool first = true;
		
	double age, *in = NULL;
	
	EXTERN_MSC void gmt_str_toupper (char *string);
	char record[GMT_BUFSIZ], chron[16], c, **Cname[2] = {NULL, NULL}, **Cname2[2] = {NULL, NULL};
	static char *Chron_Normal[] = {
#include "Chron_Normal.h"
	};
	static char *Chron_Reverse[] = {
#include "Chron_Reverse.h"
	};
	static char *Chron_Normal2[] = {
#include "Chron_Normal2.h"
	};
	static char *Chron_Reverse2[] = {
#include "Chron_Reverse2.h"
	};
	static struct ML_CHRON Geek2007n[] = {
#include "Geek2007n.h"
	};
	static struct ML_CHRON Geek2007r[] = {
#include "Geek2007r.h"
	};
	static struct ML_CHRON CK1995n[] = {
#include "CK1995n.h"
	};
	static struct ML_CHRON CK1995r[] = {
#include "CK1995r.h"
	};
	static struct ML_CHRON GST2004n[] = {
#include "GST2004n.h"
	};
	static struct ML_CHRON GST2004r[] = {
#include "GST2004r.h"
	};
	struct ML_CHRON *M[2] = {NULL, NULL};
	struct GMT_RECORD *In = NULL, *Out = NULL;
	struct MLCONVERTER_CTRL *Ctrl = NULL;
	struct GMT_OPTION *options = NULL;
	struct GMT_CTRL *GMT = NULL, *GMT_cpy = NULL;
	struct GMTAPI_CTRL *API = gmt_get_api_ptr (V_API);	/* Cast from void to GMTAPI_CTRL pointer */
	
	/*----------------------- Standard module initialization and parsing ----------------------*/

	if (API == NULL) return (GMT_NOT_A_SESSION);
	if (mode == GMT_MODULE_PURPOSE) return (usage (API, GMT_MODULE_PURPOSE));	/* Return the purpose of program */
	options = GMT_Create_Options (API, mode, args);	if (API->error) return (API->error);		/* Set or get option list */

	if ((error = gmt_report_usage (API, options, 0, usage)) != GMT_NOERROR) bailout (error);	/* Give usage if requested */

	/* Parse the program-specific arguments */

	GMT = gmt_begin_module (API, THIS_MODULE_LIB, THIS_MODULE_NAME, &GMT_cpy); /* Save current state */
	if (GMT_Parse_Common (API, THIS_MODULE_OPTIONS, options)) Return (API->error);
	Ctrl = New_Ctrl (GMT);	/* Allocate and initialize a new control structure */
	if ((error = parse (API, Ctrl, options))) Return (error);

	/*---------------------------- This is the mlconverter main code ----------------------------*/

	switch (Ctrl->T.mode) {	/* Set pointer to selected timescale young/old tables */
		case ML_GEEK2007:
			M[ML_NORMAL]  = Geek2007n;	
			M[ML_REVERSE] = Geek2007r;
			break;	
		case ML_CK1995:
			M[ML_NORMAL]  = CK1995n;	
			M[ML_REVERSE] = CK1995r;
			break;	
		case ML_GST2004:
			M[ML_NORMAL]  = GST2004n;	
			M[ML_REVERSE] = GST2004r;
			break;
	}
	Cname[ML_NORMAL] = Chron_Normal;	/* Set pointer to the two timescale chron nwith strict names */
	Cname[ML_REVERSE] = Chron_Reverse;
	Cname2[ML_NORMAL] = Chron_Normal2;	/* Set pointer to the two timescale chron with uppercase/no period/hyphen names */
	Cname2[ML_REVERSE] = Chron_Reverse2;
	
	GMT->current.setting.io_header[GMT_OUT] = true;	/* To allow writing of headers */
	Out = gmt_new_record (GMT, Ctrl->G.active ? GMT->current.io.record.data : NULL, Ctrl->G.active ? record : NULL);
	
	/* We know which columns are geographical */
	GMT->current.io.col_type[GMT_IN][GMT_X] = GMT->current.io.col_type[GMT_OUT][GMT_X] = GMT_IS_LON;
	GMT->current.io.col_type[GMT_IN][GMT_Y] = GMT->current.io.col_type[GMT_OUT][GMT_Y] = GMT_IS_LAT;

	if ((error = GMT_Init_IO (API, GMT_IS_DATASET, GMT_IS_POINT, GMT_IN, GMT_ADD_DEFAULT, 0, options))) Return (error);	/* Register data input */
	if ((error = GMT_Init_IO (API, GMT_IS_DATASET, GMT_IS_TEXT, GMT_OUT, GMT_ADD_DEFAULT, 0, options))) Return (error);	/* Establishes data output */
	if ((error = GMT_Begin_IO (API, GMT_IS_DATASET, GMT_IN, GMT_HEADER_ON))) Return (error);	/* Enables data input and sets access mode */
	if ((error = GMT_Begin_IO (API, GMT_IS_DATASET, GMT_OUT, GMT_HEADER_ON))) Return (error);	/* Enables data output and sets access mode */

	do {	/* Keep returning records until we reach EOF */
		if ((In = GMT_Get_Record (API, GMT_READ_DATA, NULL)) == NULL) {	/* Read next record, get NULL if special case */
			if (gmt_M_rec_is_error (GMT)) 		/* Bail if there are any read errors */
				Return (GMT_RUNTIME_ERROR);
			if (gmt_M_rec_is_any_header (GMT)) 	/* Skip all headers */
				continue;
			if (gmt_M_rec_is_eof (GMT)) 		/* Reached end of file */
				break;
		}

		/* Data record to process */

		n_read++;
		in = In->data;

		if (Ctrl->G.active && first) {	/* Write out new OGR file based on the metadata and just echo the data record */
			gmtlib_append_ogr_item (GMT, "AnomalyAge", GMT_DOUBLE, GMT->current.io.OGR);
			gmtlib_write_ogr_header (API->object[API->current_item[GMT_OUT]]->fp, GMT->current.io.OGR);
			first = false;
		}
		
		/* Here we have a data record and the OGR has been parsed */

		c = GMT->current.io.OGR->tvalue[1][0];
		side = (c == 'y' || c == 'Y') ? ML_YOUNG : ML_OLD;
		c = GMT->current.io.OGR->tvalue[0][strlen(GMT->current.io.OGR->tvalue[0])-1];
		polarity = (c == 'n' || c == 'N') ? ML_NORMAL : ML_REVERSE;
		strcpy (chron, GMT->current.io.OGR->tvalue[0]);
		k = mlconverter_lookup (chron, Cname[polarity]);	/* Try exact name standard */
		if (k == -1) {	/* Did not find this.  Try again without any dots or hyphens */
			k = j = 0; while ((c = GMT->current.io.OGR->tvalue[0][k++])) if (!(c == '.' || c == '-')) chron[j++] = c;
			chron[j] = 0;
			gmt_str_toupper (chron);
			k = mlconverter_lookup (chron, Cname2[polarity]);	/* Try lax standard */
			if (k >= 0) {	/* Report the problem  */
				strcpy (chron, Cname[polarity][k]);
				if (Ctrl->S.active) {	/* Refuse to convert a lax chron */
					GMT_Report (API, GMT_MSG_NORMAL, "File has lax chron %s but standard says %s\n", GMT->current.io.OGR->tvalue[0], Cname[polarity][k]);
					k = -1;
				}
				n_lax++;
			}
		}
		if (k == -1) {	/* Did not find this either */
			age = -1.0;
			n_bad++;
			strcpy (chron, GMT->current.io.OGR->tvalue[0]);
		}
		else {
			age = (side == ML_YOUNG) ? M[polarity][k].young : M[polarity][k].old;
		}
		if (age < 0.0) age = GMT->session.d_NaN;
		
		if (Ctrl->G.active) {	/* Write out a new OGR record based on the metadata and just echo the data record */
			record[0] = 0;	/* Clean muzzle */
			strcat (record, "# @D");	/* OGR metadata record */
			record[0] = '#';	record[1] = ' ';	record[2] = 0;	/* Start a comment */
			strcat (record, (Ctrl->G.mode) ? chron : GMT->current.io.OGR->tvalue[0]);
			for (k = 1; k < 6; k++) {
				strcat (record, "|");
				strcat (record, GMT->current.io.OGR->tvalue[k]);
			}
			strcat (record, "|");
			gmt_add_to_record (GMT, record, age, GMT_Z, GMT_OUT, 0);	/* Format our output age value */
			GMT_Put_Record (API, GMT_WRITE_TABLE_HEADER, record);	/* Write this to output */
			GMT_Put_Record (API, GMT_WRITE_DATA, Out);	/* Write this to output */
		}
		else {
			record[0] = 0;	/* Clean muzzle */
			gmt_add_to_record (GMT, record, in[GMT_X], GMT_X, GMT_OUT, 2);	/* Format our longitude */
			gmt_add_to_record (GMT, record, in[GMT_Y], GMT_Y, GMT_OUT, 2);	/* Format our latitude */
			gmt_add_to_record (GMT, record, age, GMT_Z, GMT_OUT, 0);	/* Format our output age value */
			if (Ctrl->A.active) {/* Append record */
				for (k = 0; k < 6; k++) {
					strcat (record, GMT->current.setting.io_col_separator);
					strcat (record, GMT->current.io.OGR->tvalue[k]);
				}
			}
			GMT_Put_Record (API, GMT_WRITE_TEXT, Out);	/* Write this to output */
		}
	} while (true);
	
	gmt_M_free (GMT, Out);
	
	if ((error = GMT_End_IO (API, GMT_IN, 0))) Return (error);	/* Disables further data input */
	if ((error = GMT_End_IO (API, GMT_OUT, 0))) Return (error);	/* Disables further data input */
	
	GMT_Report (API, GMT_MSG_NORMAL, "Encountered a total of %ld chrons\n", n_read);
	if (n_bad) GMT_Report (API, GMT_MSG_NORMAL, "Encountered %ld chrons that could not be converted to age with current timescale\n", n_bad);
	if (n_lax) GMT_Report (API, GMT_MSG_NORMAL, "Encountered %ld chrons that failed to conform to strict chron nomenclature\n", n_lax);

	Return (EXIT_SUCCESS);
}
