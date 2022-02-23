/*
  * Copyright (c) 2015-2022 by P. Wessel
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
 */

/* gsfml_module.h declares the prototypes for gsfml module functions
 * that extends the GMT API.  It also declares prototypes for
 * gsfml module information functions such as listing names
 * and purpose strings.
 */

#pragma once
#ifndef _GMT_GSFML_MODULE_H
#define _GMT_GSFML_MODULE_H

#ifdef __cplusplus /* Basic C++ support */
extern "C" {
#endif

/* Declaration modifiers for DLL support (MSC et al) */
#include "declspec.h"

/* Prototypes of all modules in the GMT gsfml library */
EXTERN_MSC int GMT_fzanalyzer (void *API, int mode, void *args);
EXTERN_MSC int GMT_fzblender (void *API, int mode, void *args);
EXTERN_MSC int GMT_mlconverter (void *API, int mode, void *args);

/* Pretty print all modules in the GMT gsfml library and their purposes */
EXTERN_MSC void gmt_gsfml_module_show_all (void *API);
/* List all modules in the GMT gsfml library to stdout */
EXTERN_MSC void gmt_gsfml_module_list_all (void *API);
/* Functions called by GMT_Encode_Options so developers can get information about a module */
EXTERN_MSC const char * gmt_gsfml_module_keys (void *API, char *candidate);
EXTERN_MSC const char * gmt_gsfml_module_group (void *API, char *candidate);

#ifdef __cplusplus
}
#endif

#endif /* !_GMT_GSFML_MODULE_H */
