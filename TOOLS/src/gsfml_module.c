/*
 * $Id: gsfml_module.c 429 2018-07-01 00:54:37Z pwessel $
 *
 * Copyright (c) 2015-20120 by P. Wessel
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
 * gsfml_module.c populates the local array g_gsfml_module
 * with parameters such as name, group and purpose strings.
 * This file also contains the following convenience function to
 * display all module purposes:
 *
 * This function will be called by gmt --help :
 *   void gmtlib_gsfml_module_show_all (void *API);
 * This function will be called by gmt --showmodules :
 *   void gmtlib_gsfml_module_list_all (void *API);
 * These functions are used by GMT_Encode_Options [API] :
 *   const char * gmtlib_gsfml_module_group (void *API, char *candidate);
 *   const char * gmtlib_gsfml_module_keys (void *API, char *candidate);
 */

#include "gmt.h"
#include "gsfml_config.h"
#include "gsfml_module.h"
#include <string.h>

#ifndef GMT_UNUSED
#define GMT_UNUSED(x) (void)(x)
#endif

/* Sorted array with information for all gsfml modules */

/* name, library, and purpose for each module */
struct Gmt_moduleinfo {
	const char *name;             /* Program name */
	const char *component;        /* Component (core, supplement, custom) */
	const char *purpose;          /* Program purpose */
	const char *keys;             /* Program option info for external APIs */
};

static struct Gmt_moduleinfo g_gsfml_module[] = {
	{"fzanalyzer", "gsfml", "Analysis of fracture zones using crossing profiles", "<DI,>DO"},
	{"fzblender", "gsfml", "Produce a smooth blended fracture zone trace", "<DI,>DO"},
	{"mlconverter", "gsfml", "Convert chrons to ages using selected magnetic timescale", "<DI,>DO"},
	{NULL, NULL, NULL, NULL} /* last element == NULL detects end of array */
};

/* Pretty print all GMT gsfml module names and their purposes */
void gmtlib_gsfml_module_show_all (void *V_API) {
	unsigned int module_id = 0;
	char message[256];
	GMT_Message (V_API, GMT_TIME_NONE, "\n=== " "GMT gsfml: Tools for the GSFML project" " ===\n", GSFML_PACKAGE_VERSION);
	while (g_gsfml_module[module_id].name != NULL) {
		if (module_id == 0 || strcmp (g_gsfml_module[module_id-1].component, g_gsfml_module[module_id].component)) {
			/* Start of new supplemental group */
			sprintf (message, "\nModule name:     Purpose of %s module:\n", g_gsfml_module[module_id].component);
			GMT_Message (V_API, GMT_TIME_NONE, message);
			GMT_Message (V_API, GMT_TIME_NONE, "----------------------------------------------------------------\n");
		}
	sprintf (message, "%-16s %s\n",
		g_gsfml_module[module_id].name, g_gsfml_module[module_id].purpose);
		GMT_Message (V_API, GMT_TIME_NONE, message);
		++module_id;
	}
}

/* Produce single list on stdout of all GMT gsfml module names for gmt --show-modules */
void gmtlib_gsfml_module_list_all (void *API) {
	unsigned int module_id = 0;
	GMT_UNUSED(API);
	while (g_gsfml_module[module_id].name != NULL) {
		printf ("%s\n", g_gsfml_module[module_id].name);
		++module_id;
	}
}

/* Lookup module id by name, return option keys pointer (for external API developers) */
const char *gmtlib_gsfml_module_keys (void *API, char *candidate) {
	int module_id = 0;
	gmt_M_unused(API);

	/* Match actual_name against g_module[module_id].name */
	while (g_gsfml_module[module_id].name != NULL &&
	       strcmp (candidate, g_gsfml_module[module_id].name))
		++module_id;

	/* Return Module keys or NULL */
	return (g_gsfml_module[module_id].keys);
}

/* Lookup module id by name, return group char name (for external API developers) */
const char *gmtlib_gsfml_module_group (void *API, char *candidate) {
	int module_id = 0;
	gmt_M_unused(API);

	/* Match actual_name against g_module[module_id].name */
	while (g_gsfml_module[module_id].name != NULL &&
	       strcmp (candidate, g_gsfml_module[module_id].name))
		++module_id;

	/* Return Module keys or NULL */
	return (g_gsfml_module[module_id].component);
}
