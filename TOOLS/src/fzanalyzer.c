/*
 * $Id: fzanalyzer.c 429 2018-07-01 00:54:37Z pwessel $
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
 * fzanalyzer analyses a series of profiles across fracture zones
 *
 * Author:	Paul Wessel
 * Date:	5-MAY-2017 (Requires GMT >= 5.2)
 */

#define THIS_MODULE_NAME	"fzanalyzer"
#define THIS_MODULE_LIB		"gsfml"
#define THIS_MODULE_PURPOSE	"Analysis of fracture zones using crossing profiles"
#define THIS_MODULE_KEYS	"<DI,>DO"
#define THIS_MODULE_NEEDS       ""
#define THIS_MODULE_OPTIONS	"-Vb:hios>"

#include "gmt_dev.h"
#include "fz_analysis.h"

#define DEF_FZ_GAP	5.0	/* Half-width of FZ gap centered on d0 where we ignore ages in fitting a + b(d-d0) + c*H(d-d0) */

#define FZ_G0	0
#define FZ_G1	1
#define FZ_G2	2

#define N_REQUIRED_COLS	7

struct FZMODELER_CTRL {
	struct In {
		unsigned int active;
		char *file;
	} In;
	struct A {	/* -A<min_asymmetry>/<max_asymmetry>/<inc_asymmetry> */
		unsigned int active;
		double min, max, inc;
	} A;
	struct C {	/* -C<min_compression>/<max_compression>/<inc_compression> */
		unsigned int active;
		double min, max, inc;
	} C;
	struct D {	/* -Dcorr_width */
		unsigned int active;
		double corr_width;
	} D;
	struct F {	/* -F<fzlines> */
		unsigned int active;
		char *file;
	} F;
	struct I {	/* -I<FZ>[/<profile>] */
		unsigned int active;
		int64_t fz;
		int profile;
	} I;
	struct S {	/* -S */
		unsigned int active;
		int mode;	/* 0 = bash/sh, 1 = csh/tcsh syntax */
	} S;
	struct T {	/* -T<tag> */
		unsigned int active;
		char *prefix;
	} T;
	struct W {	/* -W<min_width>/<max_width>/<inc_width> */
		unsigned int active;
		double min, max, inc;
	} W;
};

#define N_SHAPES	3	/* Number of shapes to blend (G0, G1, and G2) */

/* Named indices for the results array for one profile */

#define BEST_MODEL_B	0	/* Entry for the asymmetry parameter m [0,1] */
#define BEST_WAY_B	1	/* Entry for the normal or reversed profile model (-1 means negative distance side is the old side in Pacific FZ model) */
#define BEST_FZLOC_B	2	/* Entry for the distance of the FZ crossing */
#define BEST_WIDTH_B	3	/* Entry for the best model FZ width w */
#define BEST_FLANK_B	4	/* Entry for the best model flank relative amplitude (> 0) */
#define BEST_AMPLT_B	5	/* Entry for the best model peak-to-trough amplitude (> 0) */
#define BEST_VARMD_B	6	/* Entry for the best model variance reduction [0-100%] */
#define BEST_INTER_B	7	/* Entry for the best model intercept */
#define BEST_SLOPE_B	8	/* Entry for the best model linear slope */
#define BEST_FSTAT_B	9	/* Entry for the best model F statistic */
#define BEST_FZLOC_T	10	/* As BEST_FZLOC_B but for asymmetry = 0 */
#define BEST_WIDTH_T	11	/* As BEST_WIDTH_B but for asymmetry = 0  */
#define BEST_FLANK_T	12	/* As BEST_FLANK_B but for asymmetry = 0  */
#define BEST_AMPLT_T	13	/* As BEST_AMPLT_B but for asymmetry = 0  */
#define BEST_VARMD_T	14	/* As BEST_VARMD_B but for asymmetry = 0  */
#define BEST_INTER_T	15	/* As BEST_INTER_B but for asymmetry = 0  */
#define BEST_SLOPE_T	16	/* As BEST_SLOPE_B but for asymmetry = 0  */
#define BEST_FSTAT_T	17	/* As BEST_FSTAT_B but for asymmetry = 0  */
#define BEST_WIDTH_D	18	/* Entry for best data FZ width */
#define BEST_AMPLT_D	19	/* Entry for best data peak/trough amplitude  */
#define BEST_XD_1	20	/* Entry for the raw data 1-sigma left side point longitude */
#define BEST_XD_M	21	/* Entry for the raw data longitude at FZ crossing  */
#define BEST_XD_2	22	/* Entry for the raw data 1-sigma right side point longitude */
#define BEST_YD_1	23	/* Entry for the raw data 1-sigma left side point latitude */
#define BEST_YD_M	24	/* Entry for the raw data latitude at FZ crossing */
#define BEST_YD_2	25	/* Entry for the raw data 1-sigma right side point latitude */
#define BEST_ZD_1	26	/* Entry for the raw data 1-sigma left side point data value */
#define BEST_ZD_M	27	/* Entry for the raw data data value at FZ crossing **/
#define BEST_ZD_2	28	/* Entry for the raw data 1-sigma right side point data value */
#define BEST_XT_1	29	/* Entry for the blend model 1-sigma left side point longitude */
#define BEST_XT_M	30	/* Entry for the blend model longitude at FZ crossing  */
#define BEST_XT_2	31	/* Entry for the blend model 1-sigma right side point longitude */
#define BEST_YT_1	32	/* Entry for the blend model 1-sigma left side point latitude */
#define BEST_YT_M	33	/* Entry for the blend model latitude at FZ crossing */
#define BEST_YT_2	34	/* Entry for the blend model 1-sigma right side point latitude */
#define BEST_ZT_1	35	/* Entry for the blend model 1-sigma left side point data value */
#define BEST_ZT_M	36	/* Entry for the blend model data value at FZ crossing **/
#define BEST_ZT_2	37	/* Entry for the blend model 1-sigma right side point data value */
#define BEST_XB_1	38	/* Entry for the blend model 1-sigma left side point longitude */
#define BEST_XB_M	39	/* Entry for the blend model longitude at FZ crossing  */
#define BEST_XB_2	40	/* Entry for the blend model 1-sigma right side point longitude */
#define BEST_YB_1	41	/* Entry for the blend model 1-sigma left side point latitude */
#define BEST_YB_M	42	/* Entry for the blend model latitude at FZ crossing */
#define BEST_YB_2	43	/* Entry for the blend model 1-sigma right side point latitude */
#define BEST_ZB_1	44	/* Entry for the blend model 1-sigma left side point data value */
#define BEST_ZB_M	45	/* Entry for the blend model data value at FZ crossing **/
#define BEST_ZB_2	46	/* Entry for the blend model 1-sigma right side point data value */
#define BEST_XE_1	47	/* Entry for the blend model [maximum slope] 1-sigma left side point longitude */
#define BEST_XE_M	48	/* Entry for the blend model [maximum slope] longitude at FZ crossing  */
#define BEST_XE_2	49	/* Entry for the blend model [maximum slope] 1-sigma right side point longitude */
#define BEST_YE_1	50	/* Entry for the blend model [maximum slope] 1-sigma left side point latitude */
#define BEST_YE_M	51	/* Entry for the blend model [maximum slope] latitude at FZ crossing */
#define BEST_YE_2	52	/* Entry for the blend model [maximum slope] 1-sigma right side point latitude */
#define BEST_ZE_1	53	/* Entry for the blend model [maximum slope] 1-sigma left side point data value */
#define BEST_ZE_M	54	/* Entry for the blend model [maximum slope] data value at FZ crossing **/
#define BEST_ZE_2	55	/* Entry for the blend model [maximum slope] 1-sigma right side point data value */
#define N_RESULTS	56	/* Big enough to hold all the BEST_* values */

/* Named indices for cross-section traces */

#define N_CROSS_COLS	9	/* Number of output columns (below) for cross profiles */
#define XPOS_X	0	/* Longitudes along cross profile */
#define XPOS_Y	1	/* Latitudes along cross profile */
#define XPOS_D	2	/* Distances along cross profile */
#define XPOS_A	3	/* Azimuths along cross profile */
#define XPOS_Z	4	/* Data values along cross profile */
#define XPOS_C	5	/* Crustal ages (C) along cross profile */
#define XPOS_S	6	/* Distances to nearest FZ along cross profile */
#define XPOS_T	7	/* Best-fitting Trough model (incl. trend) along cross profile */
#define XPOS_B	8	/* Best-fitting Blend model (incl. trend) along cross profile */

#include "fz_analysis.h"

#define LOC_DATA	0	/* Array id for location of minimum data value (the data trough) */
#define LOC_TROUGH	1	/* Array id for location of fZ for m = 0 (the model trough for Atlantic signal) */
#define LOC_BLEND_T	2	/* Array id for location of trough in fZ for best m (the model FZ location for optimal blend signal) */
#define LOC_BLEND_E	3	/* Array id for location of max slope in fZ for best m (the model FZ location for optimal blend signal) */

typedef void (*PFV) (double *d, int nd, double d0, double width, int way, double *vgg);

/* The synthetic FZ model is a blend of three Gaussian functions G0, G1, and G2:
	model = A * [ a * G1 + (1 - a) * (c * G2 - G0)] + m + qx
	The (G0 + c * G2) is the symmetric part (c controls amount of compression [0-1]) and
	G1 is the asymmetric part.  The amount of asymmetry in the model is given
	by the asymmetry parameter a (0-1).  We also model a linear trend m + qx.
*/

static void fzanalyzer_FZ_gaussian0 (double *d, int nd, double d0, double width, int i, double *vgg)
{	/* G0: Fake VGG signal over a trough [The "Atlantic" signal]. Here,
	 * d0 is position of FZ (the trough) and width is the Gaussian width.
	 * The signal is normalized to give unit amplitude.
	 * way is not used here since the signal is symmetric, so we call it i instead
	 * so we can used it for something else and shut up compiler warnings.
	 */
	double i_s, z, f;
	f = M_SQRT2;
	i_s = f / width;	/* s = w/f; here we use 1/s to avoid division below */
	for (i = 0; i < nd; i++) {
		z = (d[i] - d0) * i_s;	/* Normalized distance */
		vgg[i] = exp (-z * z);
	}
}

static void fzanalyzer_FZ_gaussian1 (double *d, int nd, double d0, double width, int way, double *vgg)
{	/* G1: Fake VGG signal over an isostatic edge [The "Pacific" signal]. Here,
	 * d0 is position of FZ (steepest VGG gradient) and width is the peak-to-trough distance.
	 * The signal is normalized to give unit peak-to-trough amplitude.
	 * way is -1 or +1 and signals which side is young (we reflect the profile left/right)
	 * way == +1 means the left side of the profile (negative d values) is the old side.
	 */
	int i;
	double i_s, z, f, i_A;
	f = M_SQRT2;
	i_s = f / width;			/* s = w/f; here we use 1/s to avoid division below */
	i_A = 1.0 / (M_SQRT2 * exp (-0.5));	/* Amplitude scaling; again inverted to avoid division in loop */
	for (i = 0; i < nd; i++) {
		z = (d[i] - d0) * i_s;	/* Normalized distance */
		if (way == -1) z = -z;	/* Since we reflect signal about the d0 axis */
		vgg[i] = z * exp (-z * z) * i_A;
	}
}

static void fzanalyzer_FZ_gaussian2 (double *d, int nd, double d0, double width, int i, double *vgg)
{	/* G2: Fake VGG signal over an FZ in compression (which raises bulges). Here,
	 * d0 is position of FZ (the trough) and width is the Gaussian width.
	 * The signal is normalized to give unit peak-to-trough amplitude.
	 * way is not used here since the signal is symmetric, so we call it i instead
	 * so we can used it for something else and shut up compiler warnings.
	 */
	double i_s, z, f, i_A;
	f = M_SQRT2;
	i_s = f / width;	/* s = w/f; here we use 1/s to avoid division below */
	i_A = M_E;		/* Amplitude scaling; again inverted to avoid division in loop */
	for (i = 0; i < nd; i++) {
		z = (d[i] - d0) * i_s;	/* Normalized distance */
		z *= z;	/* z Squared */
		vgg[i] = z * exp (-z) * i_A;
	}
}

static void fzanalyzer_FZ_blendmodel (double *G0, double *G1, double *G2, double *combo, int n, double a, double c, double A)
{	/* Blend the two models using a (0-1), and c (>=0), normalize, then scale to given amplitude A */
	int i;
	double one_minus_a, min = DBL_MAX, max = -DBL_MAX, scale;
	one_minus_a = 1.0 - a;
	for (i = 0; i < n; i++) {
		combo[i] =  a * G1[i] + one_minus_a * (c * G2[i] - G0[i]);	/* a blend */
		if (combo[i] < min) min = combo[i];
		if (combo[i] > max) max = combo[i];
	}
	scale = A / (max - min);
	for (i = 0; i < n; i++) combo[i] *= scale;
}

static int fzanalyzer_FZ_solution (struct GMT_CTRL *GMT, double *dist, double *data, double d0, double *model, int n, double *par)
{	/* LS solution for par[0] + par[1]*(dist-d0) + par[2] * model, ignoring NaNs */
	int i, m;
	double d, N[9];

	gmt_M_memset (N, 9, double);	/* The 3x3 normal equation matrix */
	gmt_M_memset (par, 3, double);	/* The 3x1 solution vector */
	for (i = m = 0; i < n; i++) {	/* Build up N */
		if (gmt_M_is_dnan (data[i])) continue;	/* Skip data points that are NaN */
		d = dist[i] - d0;
		N[1] += d;
		N[2] += model[i];
		N[4] += d * d;
		N[5] += d * model[i];
		N[8] += model[i] * model[i];
		par[0] += data[i];
		par[1] += d * data[i];
		par[2] += data[i] * model[i];
		m++;
	}
	/* Finalize N for this 3x3 problem */
	N[0] = (double)m;	N[3] = N[1];	N[6] = N[2]; N[7] = N[5];
	return (gmt_gaussjordan (GMT, N, 3U, par));	/* Return solution via par */
}

static double fzanalyzer_FZ_get_variance (double *z, int n)
{	/* Compute sum of squares, skipping NaNs */
	int i;
	double var = 0.0;
	for (i = 0; i < n; i++) if (!gmt_M_is_dnan (z[i])) var += z[i] * z[i];
	return (var);
}

static void fzanalyzer_FZ_residuals (double *dist, double *data, double d0, double *model, double *residual, int n, double par[])
{	/* Return residuals after removing best-fitting FZ shape */
	int i;
	for (i = 0; i < n; i++) residual[i] = data[i] - (par[0] + par[1] * (dist[i] - d0) + par[2] * model[i]);
}

static void fzanalyzer_FZ_trend (double *x, double *y, int n, double *intercept, double *slope, int remove)
{	/* Fits a LS line, but ignore points with NaNs in y[] */
	double sum_x, sum_xx, sum_y, sum_xy, xx, dx = 0.0;
	int i, m, equidistant = 0;
	
	sum_x = sum_xx = sum_y = sum_xy = 0.0;
	if (x == NULL) {	/* If there are no x-values we assume dx is passed via intercept */
		equidistant = 1;
		dx = *intercept;
	}
	for (i = m = 0; i < n; i++) {
		if (gmt_M_is_dnan (y[i])) continue;
		xx = (equidistant) ? dx*i : x[i];
		sum_x  += xx;
		sum_xx += xx*xx;
		sum_y  += y[i];
		sum_xy += xx*y[i];
		m++;
	}
	
	*intercept = (sum_y*sum_xx - sum_x*sum_xy) / (m*sum_xx - sum_x*sum_x);
	*slope = (m*sum_xy - sum_x*sum_y) / (m*sum_xx - sum_x*sum_x);
	
	if (remove) {
		for (i = 0; i < n; i++) {
			xx = (equidistant) ? dx*i : x[i];
			y[i] -= (*intercept + (*slope) * xx);
		}
	}
}

static int fzanalyzer_FZ_fit_model (struct GMT_CTRL *GMT, double *d, double *vgg, int n, double corridor, double *width, int n_widths, double *asym, int n_asym, double *comp, int n_comp, double *results, PFV *FZshape)
{
	/* d	   = distance along crossing profile in km, with d = 0 the nominal FZ location given by digitized line.
	 * vgg	   = observed (resampled) VGG along crossing profile, possibly with NaNs at end.
	 * n	   = number of points in the profile (including any NaNs)
	 * corridor = half-width of the central corridor in which we try to adjust the FZ location
	 * widths  = array with signal widths to try
	 * asym    = array with asymmetry parameters to try
	 * comp    = array with compression parameters to try
	 * results = array with parameters determined below
	 *
	 * Take observed VGG cross-profile, detrend it, and then try to fit
	 * a theoretical profile by shifting FZ position horizontally and
	 * adjusting the width of the signal.  We do this for a blend of two models, and
	 * keep track of the best blend overall. In the end we return which
	 * model that fit best, its variance reduction (in %), and the parameters. */
	
	int col0, w, m, ic, row, way, n_sing = 0, n_fits = 0, got_trough;
	double *d_vgg = NULL, *res = NULL, *predicted_vgg = NULL, *vgg_comp[N_SHAPES] = {NULL, NULL, NULL};
	double min_var_b, min_var_t, var_model, intercept, slope, var_data, F, par[3];
	
	/* The algorithms used below anticipate that vgg may have NaNs and thus skip those */
	
	/* First find a LS trend and remove it from vgg */
	
	d_vgg = gmt_M_memory (GMT, NULL, n, double);
	res = gmt_M_memory (GMT, NULL, n, double);
	for (m = 0; m < N_SHAPES; m++) vgg_comp[m] = gmt_M_memory (GMT, NULL, n, double);
	predicted_vgg = gmt_M_memory (GMT, NULL, n, double);
	gmt_M_memcpy (d_vgg, vgg, n, double);	/* Make copy of vgg */
	fzanalyzer_FZ_trend (d, d_vgg, n, &intercept, &slope, 1);		/* Find and remove linear trend just for data variance calculation */
	/* So trend = d * slope + intercept; the shift of FZ location does not change this calculation (i.e. d is original d) */
	
	var_data = fzanalyzer_FZ_get_variance (d_vgg, n);	/* Compute sum of squares for the detrended data */
	min_var_b = min_var_t = DBL_MAX;
	got_trough = (gmt_M_is_zero (asym[0]));
	for (way = -1; way < 2; way += 2) {	/* Must use normal and reversed model since we dont know which side is young (-1 means old is to the left or negative d) */
		for (col0 = 0; col0 < n; col0++) {	/* Search for a better fit to FZ location within +- corr km of digitized location */
			if (fabs (d[col0]) > corridor) continue;	/* Outside central corridor where we allow relocation of FZ position */
			for (w = 0; w < n_widths; w++) {	/* Search for best shape width from 20 to 100 km */
				for (m = 0; m < N_SHAPES; m++)  FZshape[m] (d, n, d[col0], width[w], way, vgg_comp[m]);
				for (ic = 0; ic < n_comp; ic++) {	/* Search for best compression factor */
					for (row = 0; row < n_asym; row++) {	/* Search for optimal asymmetry parameter asym */
						n_fits++;
						fzanalyzer_FZ_blendmodel (vgg_comp[FZ_G0], vgg_comp[FZ_G1], vgg_comp[FZ_G2], predicted_vgg, n, asym[row], comp[ic], 1.0);	/* a blend, with unit amplitude */
						if (fzanalyzer_FZ_solution  (GMT, d, vgg, d[col0], predicted_vgg, n, par)) {	/* LS solution for trend + scaled shape */
							n_sing++;
							continue;		/* Return 1 if singular */
						}
						if (par[2] < 0.0) continue;	/* Do not consider negative amplitudes since we have way to handle reversals */
						fzanalyzer_FZ_residuals (d, vgg, d[col0], predicted_vgg, res, n, par);	/* Return residuals after removing best-fitting FZ shape */
						var_model = fzanalyzer_FZ_get_variance (res, n);				/* Compute sum of squares */
						if (var_model < min_var_b) {		/* A better fit was obtained, update parameters */
							min_var_b = var_model;
							results[BEST_MODEL_B] = asym[row];
							results[BEST_WAY_B] = (double)way;
							results[BEST_FZLOC_B] = d[col0];
							results[BEST_WIDTH_B] = width[w];
							results[BEST_FLANK_B] = comp[ic];
							results[BEST_INTER_B] = par[0];
							results[BEST_SLOPE_B] = par[1];
							results[BEST_AMPLT_B] = par[2];
						}
						if (got_trough && row == 0 && var_model < min_var_t) {		/* Keep separate tabs of best trough (t = 0) model */
							min_var_t = var_model;
							results[BEST_FZLOC_T] = d[col0];
							results[BEST_WIDTH_T] = width[w];
							results[BEST_FLANK_T] = comp[ic];
							results[BEST_INTER_T] = par[0];
							results[BEST_SLOPE_T] = par[1];
							results[BEST_AMPLT_T] = par[2];
						}
					}
				}
			}
		}
	}
	F = ((var_data - min_var_b) / 4) / (min_var_b / (n - 4));		/* Compute F for best model, assuming nu = 5-1 = 4 */
	results[BEST_VARMD_B] = 100.0 * (var_data - min_var_b) / var_data;	/* Variance reduction in % */
	results[BEST_FSTAT_B] = F;
	if (got_trough) {	/* Same results for a pure through model */
		F = ((var_data - min_var_t) / 3) / (min_var_t / (n - 3));		/* Compute F for best trough model, assuming nu = 4-1 = 3 */
		results[BEST_VARMD_T] = 100.0 * (var_data - min_var_t) / var_data;	/* Variance reduction in % */
		results[BEST_FSTAT_T] = F;
	}
	else {	/* Never requested a pure through model */
		for (w = BEST_FZLOC_T; w <= BEST_FSTAT_T; w++) results[w] = GMT->session.d_NaN;
	}
	gmt_M_free (GMT, d_vgg);
	gmt_M_free (GMT, res);
	gmt_M_free (GMT, predicted_vgg);
	for (m = 0; m < N_SHAPES; m++) gmt_M_free (GMT, vgg_comp[m]);
	return ((int)irint (100.0 * n_sing / n_fits));	/* Return percentage of singular solutions as a measure of trouble */
}

static void fzanalyzer_FZ_get_envelope (struct GMT_CTRL *GMT, double *pd, double *px, double *py, double *pz, int np, double *best_loc, int k, double *results)
{	/* Find the lon/lat of the points +/- 1-sigma from the FZ-crossing */
	int il, ir;
	double sigma3, pe[3], threshold;
	
	/* First do data estimates. Here, pz[k] is the trough */
	threshold = 0.5 * pz[k];	/* Find where pz is first >= threshold on either side of k */
	for (il = k - 1; il >= 0 && pz[il] < threshold; il--);
	results[BEST_XD_1] = (il == -1) ? GMT->session.d_NaN : px[il];
	results[BEST_YD_1] = (il == -1) ? GMT->session.d_NaN : py[il];
	results[BEST_ZD_1] = (il == -1) ? GMT->session.d_NaN : pz[il];
	results[BEST_XD_M] = px[k];
	results[BEST_YD_M] = py[k];
	results[BEST_ZD_M] = pz[k];
	for (ir = k + 1; ir < np && pz[ir] < threshold; ir++);
	results[BEST_XD_2] = (ir == np) ? GMT->session.d_NaN : px[ir];
	results[BEST_YD_2] = (ir == np) ? GMT->session.d_NaN : py[ir];
	results[BEST_ZD_2] = (ir == np) ? GMT->session.d_NaN : pz[ir];
	results[BEST_WIDTH_D] = (il == -1 || ir == np) ? GMT->session.d_NaN : pd[ir] - pd[il];
	results[BEST_AMPLT_D] = 2.0 * (0.5 * (results[BEST_ZD_2] + results[BEST_ZD_1]) - results[BEST_ZD_M]);	/* Twice since we used 0.5 as threshold */
	/* Then do trough model estimates */
	sigma3 = results[BEST_WIDTH_T]/2.0;	/* Treat FZ width a fullwidth = 6sigma */
	pe[0] = best_loc[LOC_TROUGH] - sigma3;	pe[1] = best_loc[LOC_TROUGH];	pe[2] = best_loc[LOC_TROUGH] + sigma3;
	gmt_intpol (GMT, pd, px, np, 3, pe, &results[BEST_XT_1], 1);	/* Returns three longitudes starting at BEST_XT_1 location */
	gmt_intpol (GMT, pd, py, np, 3, pe, &results[BEST_YT_1], 1);	/* Returns three latitudes starting at BEST_YT_1 location  */
	gmt_intpol (GMT, pd, pz, np, 3, pe, &results[BEST_ZT_1], 1);	/* Returns three data values starting at BEST_ZT_1 location */
	/* Then do blend model (at trough) estimates */
	sigma3 = results[BEST_WIDTH_B]/2.0;	/* Treat FZ width a fullwidth = 6sigma */
	pe[0] = best_loc[LOC_BLEND_T] - sigma3;	pe[1] = best_loc[LOC_BLEND_T];	pe[2] = best_loc[LOC_BLEND_T] + sigma3;
	gmt_intpol (GMT, pd, px, np, 3, pe, &results[BEST_XB_1], 1);	/* Returns three longitudes starting at BEST_XB_1 location */
	gmt_intpol (GMT, pd, py, np, 3, pe, &results[BEST_YB_1], 1);	/* Returns three latitudes starting at BEST_YB_1 location  */
	gmt_intpol (GMT, pd, pz, np, 3, pe, &results[BEST_ZB_1], 1);	/* Returns three data values starting at BEST_ZB_1 location */
	/* Last do blend model estimates for maximum slope location */
	sigma3 = results[BEST_WIDTH_B]/2.0;	/* Treat FZ width a fullwidth = 6sigma */
	pe[0] = best_loc[LOC_BLEND_E] - sigma3;	pe[1] = best_loc[LOC_BLEND_E];	pe[2] = best_loc[LOC_BLEND_E] + sigma3;
	gmt_intpol (GMT, pd, px, np, 3, pe, &results[BEST_XE_1], 1);	/* Returns three longitudes starting at BEST_XE_1 location */
	gmt_intpol (GMT, pd, py, np, 3, pe, &results[BEST_YE_1], 1);	/* Returns three latitudes starting at BEST_YE_1 location  */
	gmt_intpol (GMT, pd, pz, np, 3, pe, &results[BEST_ZE_1], 1);	/* Returns three data values starting at BEST_ZE_1 location */
}

static int fzanalyzer_FZ_trough_location (struct GMT_CTRL *GMT, double *dist, double *vgg_obs, double *vgg_blend, int np, double corr_width, double locations[])
{	/* Return minimum locations of observed and best-blend profiles */
	int i, o_min = -1, b_min = -1;
	double vo_min = DBL_MAX, vb_min = DBL_MAX;
	for (i = 0; i < np; i++) {
		if (fabs(dist[i]) > corr_width) continue;
		if (!gmt_M_is_dnan (vgg_obs[i]) && vgg_obs[i] < vo_min) {
			vo_min = vgg_obs[i];
			o_min = i;
		}
		if (!gmt_M_is_dnan (vgg_blend[i]) && vgg_blend[i] < vb_min) {
			vb_min = vgg_blend[i];
			b_min = i;
		}
	}
	/* Return the location, or NaN if everything is NaN */
	locations[LOC_DATA] = (o_min == -1) ? GMT->session.d_NaN : dist[o_min];
	locations[LOC_BLEND_T] = (b_min == -1) ? GMT->session.d_NaN : dist[b_min];
	return (o_min);
}

static void fzanalyzer_FZ_get_ages (struct GMT_CTRL *GMT, double *dist, double *age, int np, double d0, double A[])
{	/* Return the age on left and right side of FZ.  FZ is a distance d0 */
	/* LS solution for par[0] + par[1]*(dist-d0) + par[2] * H(dist-d0), ignoring NaNs and points within DEF_FZ_GAP km of origin d0.
	 * We skip this gap since ages often spline from one side to the other and we seek to avoid fitting this ramp */
	int i, m;
	double d, H, N[9], par[3];

	gmt_M_memset (N, 9, double);	/* The 3x3 normal equation matrix */
	gmt_M_memset (par, 3, double);	/* The 3x1 solution vector */
	for (i = m = 0; i < np; i++) {	/* Build up N */
		if (gmt_M_is_dnan (age[i])) continue;	/* Skip data points that are NaN */
		d = dist[i] - d0;			/* Distance relative to origin d0 */
		if (fabs (d) < DEF_FZ_GAP) continue;	/* Skip data points within DEF_FZ_GAP km of origin */
		H = (d > 0.0) ? 1.0 : 0.0;		/* Heaviside step function (d cannot be 0.0 as per test above) */
		N[1] += d;
		N[2] += H;
		N[4] += d * d;
		N[5] += d * H;
		N[8] += H * H;
		par[0] += age[i];
		par[1] += d * age[i];
		par[2] += age[i] * H;
		m++;
	}
	if (m < 3) {	/* Nothing to do, return NaNs */
		A[0] = A[1] = GMT->session.d_NaN;
		return;
	}
	/* Finalize N for this 3x3 problem */
	N[0] = (double)m;	N[3] = N[1];	N[6] = N[2]; N[7] = N[5];
	(void) gmt_gaussjordan (GMT, N, 3U, par);
	/* In evaluating model for d = 0 the slope does not contribute */
	A[0] = par[0];		/* Age just left of FZ */
	A[1] = A[0] + par[2];	/* Age just right of FZ */
}

static void *New_Ctrl (struct GMT_CTRL *GMT) {	/* Allocate and initialize a new control structure */
	struct FZMODELER_CTRL *C;
	
	C = gmt_M_memory (GMT, NULL, 1, struct FZMODELER_CTRL);
	
	/* Initialize values whose defaults are not 0/FALSE/NULL */
	C->D.corr_width = DEF_D_WIDTH;	/* Only use center corridor */
	C->I.profile = -1;				/* Use all profiles from current FZ */
	C->C.min = DEF_L_MIN;			/* Min compression  */
	C->C.max = DEF_L_MAX;			/* Max compression */
	C->C.inc = DEF_L_INC;			/* Sampling interval for FZ compression */
	C->A.min = DEF_M_MIN;			/* Min asymmetry = Atlantic signal */
	C->A.max = DEF_M_MAX;			/* Max asymmetry = Pacific signal */
	C->A.inc = DEF_M_INC;			/* Sampling interval for FZ blend */
	C->T.prefix = strdup ("fztrack");	/* Default file prefix */
	C->W.min = DEF_W_MIN;			/* Narrowest FZ shape width to fit */
	C->W.max = DEF_W_MAX;			/* Widest FZ shape width to fit */
	C->W.inc = DEF_W_INC;			/* Sampling interval for FZ shape width */
	return (C);
}

static void Free_Ctrl (struct GMT_CTRL *GMT, struct FZMODELER_CTRL *C) {	/* Deallocate control structure */
	if (!C) return;
	if (C->In.file) free (C->In.file);	
	if (C->F.file) free (C->F.file);	
	if (C->T.prefix) free (C->T.prefix);	
	gmt_M_free (GMT, C);	
}

static int usage (struct GMTAPI_CTRL *API, int level) {
	gmt_show_name_and_purpose (API, THIS_MODULE_LIB, THIS_MODULE_NAME, THIS_MODULE_PURPOSE);
	if (level == GMT_MODULE_PURPOSE) return (GMT_NOERROR);
	GMT_Message (API, GMT_TIME_NONE, "usage: fzanalyzer <FZcrossprofiles> -F<FZlines> [-C<min>/<max>/<inc>]\n"); 
	GMT_Message (API, GMT_TIME_NONE, "\t[-A<min>/<max>/<inc>] [-D<corrwidth>] [-I<FZ>[/<profile>]]\n"); 
	GMT_Message (API, GMT_TIME_NONE, "\t[-S[c]] [-T<prefix>] [%s] [-W<min>/<max>/<inc>]\n", GMT_V_OPT);
	GMT_Message (API, GMT_TIME_NONE, "\t[%s] [%s] [%s]\n\n", GMT_colon_OPT, GMT_b_OPT, GMT_i_OPT);
	GMT_Message (API, GMT_TIME_NONE, "\t[This is GSMFL Version %s]\n", GSFML_PACKAGE_VERSION);

	if (level == GMT_SYNOPSIS) return (EXIT_FAILURE);

	GMT_Message (API, GMT_TIME_NONE, "\t<FZcrossprofiles> is a multi-segment file with (lon,lat,dist,az,data,nn,age) in the first\n");
	GMT_Message (API, GMT_TIME_NONE, "\t   7 columns.  It is obtained via grdtrack -C based on the original track lines.\n");
	GMT_Message (API, GMT_TIME_NONE, "\t-F <FZlines> is the file with resampled track lines from grdtrack -D.\n");
	GMT_Message (API, GMT_TIME_NONE, "\n\tOPTIONS:\n");
	GMT_Message (API, GMT_TIME_NONE, "\t-A specifies how FZ blend modeling between symmetric and asymmetric parts is to be done:\n");
	GMT_Message (API, GMT_TIME_NONE, "\t   <min>: Minimum asymmetry value [%g].\n", DEF_M_MIN);
	GMT_Message (API, GMT_TIME_NONE, "\t   <max>: Maximum asymmetry value [%g].\n", DEF_M_MAX);
	GMT_Message (API, GMT_TIME_NONE, "\t   <inc>: Increment used for blend search [%g].\n", DEF_M_INC);
	GMT_Message (API, GMT_TIME_NONE, "\t   To only use a single asymmetry value, only give the <min> argument.\n");
	GMT_Message (API, GMT_TIME_NONE, "\t-C specifies how FZ compression modeling is to be done:\n");
	GMT_Message (API, GMT_TIME_NONE, "\t   <min>: Minimum compression value [%g].\n", DEF_L_MIN);
	GMT_Message (API, GMT_TIME_NONE, "\t   <max>: Maximum compression value [%g].\n", DEF_L_MAX);
	GMT_Message (API, GMT_TIME_NONE, "\t   <inc>: Increment used for compression search [%g].\n", DEF_L_INC);
	GMT_Message (API, GMT_TIME_NONE, "\t   To only use a single compression value, only give the <min> argument.\n");
	GMT_Message (API, GMT_TIME_NONE, "\t-D <corrwidth>: Sets width (in km) of central cross-profile wherein FZ shifts may be sought [%g].\n", DEF_D_WIDTH);
	GMT_Message (API, GMT_TIME_NONE, "\t-I Specify a particular <FZ> id (first FZ is 0) to analyze\n");
	GMT_Message (API, GMT_TIME_NONE, "\t   [Default analyzes the cross-profiles of all FZs].\n");
	GMT_Message (API, GMT_TIME_NONE, "\t   Optionally, append the id of a particular profile in that FZ.\n");
	GMT_Message (API, GMT_TIME_NONE, "\t-S Writes out a parameter file with settings needed for Bourne scripts.\n");
	GMT_Message (API, GMT_TIME_NONE, "\t   Give -Sc to use csh/tcsh syntax instead.\n");
	GMT_Message (API, GMT_TIME_NONE, "\t-T Set file prefix for all output files [fztrack].\n");
	GMT_Option (API, "V");
	GMT_Message (API, GMT_TIME_NONE, "\t-W specifies parameters that control how FZ width is determined:\n");
	GMT_Message (API, GMT_TIME_NONE, "\t   <min>: Minimum FZ signal width (in km) for nonlinear width search [%g].\n", DEF_W_MIN);
	GMT_Message (API, GMT_TIME_NONE, "\t   <max>: Maximum FZ signal width (in km) for nonlinear width search [%g].\n", DEF_W_MAX);
	GMT_Message (API, GMT_TIME_NONE, "\t   <inc>: Increment (in km) used for width search [%g].\n", DEF_W_INC);
	GMT_Option (API, ":,b7i,.");

	return (EXIT_FAILURE);
}

static int parse (struct GMTAPI_CTRL *API, struct FZMODELER_CTRL *Ctrl, struct GMT_OPTION *options) {

	/* This parses the options provided to grdsample and sets parameters in CTRL.
	 * Any GMT common options will override values set previously by other commands.
	 * It also replaces any file names specified as input or output with the data ID
	 * returned when registering these sources/destinations with the API.
	 */

	int j, n_files = 0, n_errors = 0;
	struct GMT_OPTION *opt = NULL;
	struct GMT_CTRL *GMT = API->GMT;
	char ta[GMT_LEN64], tb[GMT_LEN64], tc[GMT_LEN64];

	for (opt = options; opt; opt = opt->next) {
		switch (opt->option) {

			case '<':	/* Skip input files */
				Ctrl->In.active = TRUE;
				if (n_files == 0) Ctrl->In.file = strdup (opt->arg);
				n_files++;
				break;

			/* Processes program-specific parameters */

			case 'A':
				Ctrl->A.active = TRUE;
				j = sscanf (opt->arg, "%[^/]/%[^/]/%s", ta, tb, tc); 
				Ctrl->A.min = atof (ta); 
				Ctrl->A.max = atof (tb); 
				Ctrl->A.inc = atof (tc);
				if (j == 1) {	/* Only gave a specific asymmetry value */
					Ctrl->A.max = Ctrl->A.min; 
					Ctrl->A.inc = 1.0;
				}
				break;
			case 'C':
				Ctrl->C.active = TRUE;
				j = sscanf (opt->arg, "%[^/]/%[^/]/%s", ta, tb, tc); 
				Ctrl->C.min = atof (ta); 
				Ctrl->C.max = atof (tb); 
				Ctrl->C.inc = atof (tc);
				if (j == 1) {	/* Only gave a specific compression value */
					Ctrl->C.max = Ctrl->C.min; 
					Ctrl->C.inc = 1.0;
				}
				break;
			case 'D':
				Ctrl->D.active = TRUE;
				Ctrl->D.corr_width = atof (opt->arg); 
				break;
			case 'F':
				Ctrl->F.active = TRUE;
				Ctrl->F.file = strdup (opt->arg);
				break;
			case 'I':	/* Just pick a single profile for analysis */
				Ctrl->I.active = TRUE;
				j = sscanf (opt->arg, "%[^/]/%s", ta, tb);
				if (j == 2) {	/* Got both FZ and profile numbers */
					Ctrl->I.fz = atoi (ta);
					Ctrl->I.profile = atoi (tb);
				}
				else
					Ctrl->I.fz = atoi (opt->arg);
				break;
			case 'S':
				Ctrl->S.active = TRUE;
				if (opt->arg[0] == 'c') Ctrl->S.mode = 1;
				break;
			case 'T':
				Ctrl->T.active = TRUE;
				free (Ctrl->T.prefix);
				Ctrl->T.prefix = strdup (opt->arg);
				break;
			case 'W':
				Ctrl->W.active = TRUE;
				sscanf (opt->arg, "%[^/]/%[^/]/%s", ta, tb, tc); 
				Ctrl->W.min = atof (ta); 
				Ctrl->W.max = atof (tb); 
				Ctrl->W.inc = atof (tc); 
				break;

			default:	/* Report bad options */
				n_errors += gmt_default_error (GMT, opt->option);
				break;
		}
	}

        if (GMT->common.b.active[GMT_IN] && GMT->common.b.ncol[GMT_IN] == 0) GMT->common.b.ncol[GMT_IN] = 7;
	n_errors += gmt_M_check_condition (GMT, !Ctrl->In.active, "GMT SYNTAX ERROR:  No input file specified\n");
	n_errors += gmt_M_check_condition (GMT, n_files > 1, "GMT SYNTAX ERROR:  Only specify one input file\n");
	n_errors += gmt_M_check_condition (GMT, Ctrl->C.active && Ctrl->C.min < 0.0, "GMT SYNTAX ERROR -C:  Values must be >= 0 (typically in 0-1 range)\n");
	n_errors += gmt_M_check_condition (GMT, Ctrl->A.active && (Ctrl->A.min < 0.0 || Ctrl->A.max > 1.0), "GMT SYNTAX ERROR -A:  Values must be 0 <= m <= 1.\n");
	n_errors += gmt_M_check_condition (GMT, !Ctrl->F.file, "GMT SYNTAX ERROR -F:  Must specify input trace file.\n");
	n_errors += gmt_M_check_condition (GMT, Ctrl->D.corr_width <= 0.0, "GMT SYNTAX ERROR -D:  Corridor width must be positive.\n");
	n_errors += gmt_M_check_condition (GMT, GMT->common.b.active[GMT_IN] && GMT->current.setting.io_header[GMT_IN], "GMT SYNTAX ERROR.  Binary input data cannot have header -h.\n");
	n_errors += gmt_M_check_condition (GMT, GMT->common.b.active[GMT_IN] && GMT->common.b.ncol[GMT_IN] < 7, "GMT SYNTAX ERROR.  Binary input data (-bi) must have at least 7 columns.\n");

	return (n_errors ? GMT_PARSE_ERROR : GMT_OK);
}

#define bailout(code) {gmt_M_free_options (mode); return (code);}
#define Return(code) {Free_Ctrl (GMT, Ctrl); gmt_end_module (GMT, GMT_cpy); bailout (code);}

int GMT_fzanalyzer (void *V_API, int mode, void *args) {
	int error = FALSE, k, start, stop, left, right;
	int n_sing, way, m;
	uint64_t n_FZ_widths, n_FZ_asym, n_FZ_comp, np_cross, n_half_cross, ii;
	uint64_t fz, ku, row, col, xseg;

	char buffer[BUFSIZ], run_cmd[BUFSIZ], add[BUFSIZ], *cmd = NULL, *file = NULL;
	
	double fz_inc, corridor_half_width, cross_length, threshold, results[N_RESULTS], best_loc[4];
	double *FZ_width = NULL, *FZ_asym = NULL, *FZ_comp = NULL, ages[2], *comp[N_SHAPES];

	PFV FZshape[N_SHAPES] = {NULL, NULL, NULL};

	struct GMT_OPTION *options = NULL;
	struct FZMODELER_CTRL *Ctrl = NULL;
	struct GMT_DATASET *Fin = NULL, *Xin = NULL;
	struct GMT_DATATABLE *F = NULL, *X = NULL;
	struct GMT_DATASEGMENT *S = NULL;
	struct GMT_CTRL *GMT = NULL, *GMT_cpy = NULL;
	struct GMTAPI_CTRL *API = gmt_get_api_ptr (V_API);	/* Cast from void to GMTAPI_CTRL pointer */
	
	/*----------------------- Standard module initialization and parsing ----------------------*/

	if (API == NULL) return (GMT_NOT_A_SESSION);
	if (mode == GMT_MODULE_PURPOSE) return (usage (API, GMT_MODULE_PURPOSE));	/* Return the purpose of program */
	options = GMT_Create_Options (API, mode, args);	if (API->error) return (API->error);	/* Set or get option list */

	if (!options || options->option == GMT_OPT_USAGE) bailout (usage (API, GMT_USAGE));	/* Return the usage message */
	if (options->option == GMT_OPT_SYNOPSIS) bailout (usage (API, GMT_SYNOPSIS));	/* Return the synopsis */

	/* Parse the program-specific arguments */

	GMT = gmt_begin_module (API, THIS_MODULE_LIB, THIS_MODULE_NAME, &GMT_cpy); /* Save current state */
	if (GMT_Parse_Common (API, THIS_MODULE_OPTIONS, options)) Return (API->error);
	Ctrl = New_Ctrl (GMT);	/* Allocate and initialize a new control structure */
	if ((error = parse (API, Ctrl, options))) Return (error);

	/*---------------------------- This is the fzanalyzer main code ----------------------------*/

	/* We know which columns are geographical */
	GMT->current.io.col_type[GMT_IN][GMT_X] = GMT->current.io.col_type[GMT_OUT][GMT_X] = GMT_IS_LON;
	GMT->current.io.col_type[GMT_IN][GMT_Y] = GMT->current.io.col_type[GMT_OUT][GMT_Y] = GMT_IS_LAT;
	GMT->current.io.col_type[GMT_OUT][POS_XDL] = GMT_IS_LON;	GMT->current.io.col_type[GMT_OUT][POS_YDL] = GMT_IS_LAT;
	GMT->current.io.col_type[GMT_OUT][POS_XD0] = GMT_IS_LON;	GMT->current.io.col_type[GMT_OUT][POS_YD0] = GMT_IS_LAT;
	GMT->current.io.col_type[GMT_OUT][POS_XDR] = GMT_IS_LON;	GMT->current.io.col_type[GMT_OUT][POS_YDR] = GMT_IS_LAT;
	GMT->current.io.col_type[GMT_OUT][POS_XTL] = GMT_IS_LON;	GMT->current.io.col_type[GMT_OUT][POS_YTL] = GMT_IS_LAT;
	GMT->current.io.col_type[GMT_OUT][POS_XT0] = GMT_IS_LON;	GMT->current.io.col_type[GMT_OUT][POS_YT0] = GMT_IS_LAT;
	GMT->current.io.col_type[GMT_OUT][POS_XTR] = GMT_IS_LON;	GMT->current.io.col_type[GMT_OUT][POS_YTR] = GMT_IS_LAT;
	GMT->current.io.col_type[GMT_OUT][POS_XBL] = GMT_IS_LON;	GMT->current.io.col_type[GMT_OUT][POS_YBL] = GMT_IS_LAT;
	GMT->current.io.col_type[GMT_OUT][POS_XB0] = GMT_IS_LON;	GMT->current.io.col_type[GMT_OUT][POS_YB0] = GMT_IS_LAT;
	GMT->current.io.col_type[GMT_OUT][POS_XBR] = GMT_IS_LON;	GMT->current.io.col_type[GMT_OUT][POS_YBR] = GMT_IS_LAT;
	GMT->current.io.col_type[GMT_OUT][POS_XEL] = GMT_IS_LON;	GMT->current.io.col_type[GMT_OUT][POS_YEL] = GMT_IS_LAT;
	GMT->current.io.col_type[GMT_OUT][POS_XE0] = GMT_IS_LON;	GMT->current.io.col_type[GMT_OUT][POS_YE0] = GMT_IS_LAT;
	GMT->current.io.col_type[GMT_OUT][POS_XER] = GMT_IS_LON;	GMT->current.io.col_type[GMT_OUT][POS_YER] = GMT_IS_LAT;
	
	/* Assign pointer array to the three basic shapes */
	FZshape[FZ_G0] = fzanalyzer_FZ_gaussian0;	FZshape[FZ_G1] = fzanalyzer_FZ_gaussian1;	FZshape[FZ_G2] = fzanalyzer_FZ_gaussian2;

	/* Read in the resampled FZ track lines */
	
	if (GMT_Init_IO (API, GMT_IS_DATASET, GMT_IS_LINE, GMT_IN, GMT_ADD_DEFAULT, 0, options) != GMT_OK) {	/* Establishes data input */
		Return (API->error);
	}
	if ((error = GMT_Begin_IO (API, GMT_IS_DATASET, GMT_IN, GMT_HEADER_ON))) Return (error);	/* Enables data input and sets access mode */
	if ((Fin = GMT_Read_Data (API, GMT_IS_DATASET, GMT_IS_FILE, GMT_IS_LINE, GMT_READ_NORMAL, NULL, Ctrl->F.file, NULL)) == NULL) Return ((error = GMT_DATA_READ_ERROR));
	F = Fin->table[0];	/* Since there is only one table */
	if (F->segment[0]->n_columns < N_REQUIRED_COLS) {	/* Trouble */
		GMT_Message (API, GMT_TIME_NONE, "GMT SYNTAX ERROR:  FZ file %s does not have the %d required columns\n", Ctrl->F.file, N_REQUIRED_COLS);
		Return (EXIT_FAILURE);
	}
	/* Read in the cross-profiles */
	
	if ((Xin = GMT_Read_Data (API, GMT_IS_DATASET, GMT_IS_FILE, GMT_IS_LINE, GMT_READ_NORMAL, NULL, Ctrl->In.file, NULL)) == NULL) Return ((error = GMT_DATA_READ_ERROR));
	X = Xin->table[0];	/* Since there is only one table */
	if (X->segment[0]->n_columns < N_REQUIRED_COLS) {	/* Trouble */
		GMT_Message (API, GMT_TIME_NONE, "GMT SYNTAX ERROR:  Cross-profile file %s does not have the %d required columns\n", Ctrl->In.file, N_REQUIRED_COLS);
		Return (EXIT_FAILURE);
	}

	if ((error = GMT_End_IO (API, GMT_IN, 0))) Return (error);	/* Disables further data input */

	/* Set up the array of trial FZ widths based on -W parameters */
	n_FZ_widths = gmt_M_get_n (GMT, Ctrl->W.min, Ctrl->W.max, Ctrl->W.inc, 0);
	FZ_width = gmt_M_memory (GMT, NULL, n_FZ_widths, double);
	for (col = 0; col < n_FZ_widths; col++) FZ_width[col] = gmt_M_col_to_x (GMT, col, Ctrl->W.min, Ctrl->W.max, Ctrl->W.inc, 0.0, n_FZ_widths);
	
	/* Set up array of asymmetry values (or 1) based on -A */
	n_FZ_asym = gmt_M_get_n (GMT, Ctrl->A.min, Ctrl->A.max, Ctrl->A.inc, 0);
	FZ_asym = gmt_M_memory (GMT, NULL, n_FZ_asym, double);
	for (col = 0; col < n_FZ_asym; col++) FZ_asym[col] = gmt_M_col_to_x (GMT, col, Ctrl->A.min, Ctrl->A.max, Ctrl->A.inc, 0.0, n_FZ_asym);
	
	/* Set up array of compression values (or 1) based on -C */
	n_FZ_comp = gmt_M_get_n (GMT, Ctrl->C.min, Ctrl->C.max, Ctrl->C.inc, 0);
	FZ_comp = gmt_M_memory (GMT, NULL, n_FZ_comp, double);
	for (col = 0; col < n_FZ_comp; col++) FZ_comp[col] = gmt_M_col_to_x (GMT, col, Ctrl->C.min, Ctrl->C.max, Ctrl->C.inc, 0.0, n_FZ_comp);
	
	/* Get resampling step size and zone width in degrees */
	
	np_cross = X->segment[0]->n_rows;			/* Since all cross-profiles have the same length */
	corridor_half_width = 0.5 * Ctrl->D.corr_width;		/* Only search for trough within this zone */
	ages[0] = ages[1] = GMT->session.d_NaN;			/* So we can report NaN if there are no ages */
	
	for (m = 0; m < N_SHAPES; m++) comp[m] = gmt_M_memory (GMT, NULL, np_cross, double);	/* Will hold normalized G0, G1, and G2 model predictions */

	cmd = GMT_Create_Cmd (API,options);
	sprintf (run_cmd, "# %s %s", GMT->init.module_name, cmd);	/* Build command line argument string */
	gmt_M_free (GMT, cmd);

	if (GMT_Init_IO (API, GMT_IS_DATASET, GMT_IS_LINE, GMT_OUT, GMT_ADD_DEFAULT, 0, options) != GMT_OK) {	/* Establishes data output */
		Return (API->error);
	}
	if ((error = GMT_Begin_IO (API, GMT_IS_DATASET, GMT_OUT, GMT_HEADER_ON))) Return (error);	/* Enables data output and sets access mode */

	GMT->current.setting.io_header[GMT_OUT] = TRUE;	/* To ensure writing of headers */
	
	/* Extend the dataset of cross profiles to hold more columns */
	gmt_adjust_dataset (GMT, Xin, N_CROSS_COLS);	/* Same table length as X, but with N_CROSS_COLS columns */
	for (ku = 0; ku < X->n_headers; ku++) free (X->header[ku]);
	if (X->n_headers) gmt_M_free (GMT, X->header);
	X->n_headers = 3;
	X->header = gmt_M_memory (GMT, NULL, X->n_headers, char *);
	X->header[0] = strdup ("# Equidistant cross-profiles normal to each FZ trace");
	X->header[1] = strdup (run_cmd);
	strcpy (buffer, "# lon\t\tlat\tdist\taz\tdata\tage\tdist2fz\tTmodel\tBmodel");
	X->header[2] = strdup (buffer);

	/* To hold the results per FZ trace.  Same number of points as the resampled trace in FZ */
	gmt_adjust_dataset (GMT, Fin, N_FZ_ANALYSIS_COLS);	/* Same table length as F, but with N_FZ_ANALYSIS_COLS columns */
	for (ku = 0; ku < F->n_headers; ku++) free (F->header[ku]);
	if (F->n_headers) gmt_M_free (GMT, F->header);
	F->n_headers = 3;
	F->header = gmt_M_memory (GMT, NULL, F->n_headers, char *);
	F->header[0] = strdup ("# Analyzed FZ traces");
	F->header[1] = strdup (run_cmd);
	F->header[2] = strdup ("# XR\t\tYR\tDR\tAR\tZR\tTL\tTR\tSD\tST\tSB\tSE\tBL\tOR\tWD\tWT\tWB\tAD\tAT\tAB\tUT\tUB\tVT\tVB\tFT\tFB\t" \
		"XDL\tXD0\tXDR\tYDL\tYD0\tYDR\tZDL\tZD0\tZDR\tXTL\tXT0\tXTR\tYTL\tYT0\tYTR\tZTL\tZT0\tZTR\tXBL\tXB0\tXBR\tYBL\t" \
		"YB0\tYBR\tZBL\tZB0\tZBR\tXEL\tXE0\tXER\tYEL\tYE0\tYER\tZEL\tZE0\tZER");

	n_half_cross = (np_cross - 1) / 2;	/* Number of points in a cross-profile on either side of the FZ (center point) */
	threshold = -0.1 * (X->segment[0]->coord[XPOS_D][1] - X->segment[0]->coord[XPOS_D][0]);	/* 10% threshold lets us skip through tiny negative FZ dist steps due to round-off */
	cross_length = X->segment[0]->coord[XPOS_D][np_cross-1] - X->segment[0]->coord[XPOS_D][0];	/* Length of a cross-profile */
	
	for (fz = xseg = 0; fz < F->n_segments; fz++) {	/* For each FZ segment */

		if (Ctrl->I.active && fz != (uint64_t)Ctrl->I.fz) {	/* Skip this FZ */
			xseg += F->segment[fz]->n_rows;		/* Must wind past all the cross-profiles for the skipped FZ */
			F->segment[fz]->mode = GMT_WRITE_SKIP;	/* Ignore on output */
			continue;
		}
		
		for (row = 0; row < F->segment[fz]->n_rows; row++, xseg++) {	/* Process all the cross-profiles for this FZ */
			S = X->segment[xseg];	/* Current cross-profile */
			if (Ctrl->I.active && Ctrl->I.profile >= 0 && row != (uint64_t)Ctrl->I.profile) {	/* Skip this profile */
				continue;
			}
			GMT_Report (API, GMT_MSG_NORMAL, "Process FZ cross-profile %s\r", S->label);
			
			/* Must determine if parts of the crossection is closer to a neighbor FZ; we then truncate the data. */
			start = stop = -1;
			for (ku = 0, left = n_half_cross - 1, right = n_half_cross + 1; ku < n_half_cross; ku++, right++, left--) {	/* March outwards from the center point which should have the smallest pn */
				if (start == -1 && !gmt_M_is_dnan (S->coord[XPOS_S][left])  && (fz_inc = S->coord[XPOS_S][left]  - S->coord[XPOS_S][left+1])  < threshold) start = left  + 1;
				if (stop  == -1 && !gmt_M_is_dnan (S->coord[XPOS_S][right]) && (fz_inc = S->coord[XPOS_S][right] - S->coord[XPOS_S][right-1]) < threshold) stop  = right - 1;
			}
			/* If neighbor FZs are too close (distances start to decrease) we find the last point with an
			 * monotonic increase in FZ distance on either side.  If there is no neighbor then start and/or
			 * stop will remain at -1. */
			if (start == -1) start = 0;
			if (stop  == -1) stop = np_cross - 1;
			/* Now set the sampled grid profile to NaN if too close to a neighbor FZ */
			for (k = 0; k < start; k++) S->coord[XPOS_Z][k] = GMT->session.d_NaN;
			for (k = np_cross-1; k > stop; k--) S->coord[XPOS_Z][k] = GMT->session.d_NaN;
			/* It is now possible that the beginning and end of the cross profile will have NaNs */
			
			/* Find best fit shift, width, and amplitude plus various quality factors */

			gmt_M_memset (results, N_RESULTS, double);
			n_sing = fzanalyzer_FZ_fit_model (GMT, S->coord[XPOS_D], S->coord[XPOS_Z], np_cross, corridor_half_width, FZ_width, n_FZ_widths, FZ_asym, n_FZ_asym, FZ_comp, n_FZ_comp, results, FZshape);
			if (n_sing) GMT_Report (API, GMT_MSG_NORMAL, "Warning: Cross profile %s generated %ld %% singular solutions\n", S->label, n_sing);
	
			/* Evaluate the best model predictions */
			FZshape[FZ_G0] (S->coord[XPOS_D], np_cross, results[BEST_FZLOC_T], results[BEST_WIDTH_T], 0, comp[FZ_G0]);	/* Just need G0 & G2 for building trough model (asymmetry = 0) */
			FZshape[FZ_G2] (S->coord[XPOS_D], np_cross, results[BEST_FZLOC_T], results[BEST_WIDTH_T], 0, comp[FZ_G2]);
			fzanalyzer_FZ_blendmodel (comp[FZ_G0], comp[FZ_G1], comp[FZ_G2], S->coord[XPOS_T], np_cross, 0.0, results[BEST_FLANK_T], results[BEST_AMPLT_T]);	/* Best trough model (T) without the linear trend */
			way = irint (results[BEST_WAY_B]);	/* Old side on negative distance (-1) or positive distances (+1) */
			for (m = 0; m < N_SHAPES; m++) FZshape[m] (S->coord[XPOS_D], np_cross, results[BEST_FZLOC_B], results[BEST_WIDTH_B], way, comp[m]);	/* Evaluate all three shapes given blend parameters */
			fzanalyzer_FZ_blendmodel (comp[FZ_G0], comp[FZ_G1], comp[FZ_G2], S->coord[XPOS_B], np_cross, results[BEST_MODEL_B], results[BEST_FLANK_B], results[BEST_AMPLT_B]);	/* Best blend (B) without the linear trend */
			m = fzanalyzer_FZ_trough_location (GMT, S->coord[XPOS_D], S->coord[XPOS_Z], S->coord[XPOS_B], np_cross, corridor_half_width, best_loc);	/* Determine the LOC_DATA and LOC_BLEND_T estimates of FZ location */
			best_loc[LOC_TROUGH] = results[BEST_FZLOC_T];		/* The 2nd best FZ location estimate is from the trough model */
			best_loc[LOC_BLEND_E] = results[BEST_FZLOC_B];		/* The 3rd best FZ location estimate is from the blend model */

			/* Determine the +/- 1-sigma corridor around the best FZ trace */
			fzanalyzer_FZ_get_envelope (GMT, S->coord[XPOS_D], S->coord[XPOS_X], S->coord[XPOS_Y], S->coord[XPOS_Z], np_cross, best_loc, m, results);
			/* Determine ages on left (d < 0) and right (d > 0) sides (if -A) */
			fzanalyzer_FZ_get_ages (GMT, S->coord[XPOS_D], S->coord[XPOS_C], np_cross, 0.0, ages);
	
			/* Copy the results for this cross-profile analysis to the output data set */
			F->segment[fz]->coord[POS_TL][row] = ages[0];			/* Crustal age to left of FZ */
			F->segment[fz]->coord[POS_TR][row] = ages[1];			/* Crustal age to right of FZ */
			F->segment[fz]->coord[POS_SD][row] = S->coord[XPOS_D][m];	/* Offset of data trough from digitized FZ location [0] */
			F->segment[fz]->coord[POS_ST][row] = results[BEST_FZLOC_T];	/* Offset of model (trough) location from digitized FZ location */
			F->segment[fz]->coord[POS_SB][row] = best_loc[LOC_BLEND_T];	/* Offset of model trough (blend) location from digitized FZ location */
			F->segment[fz]->coord[POS_SE][row] = results[BEST_FZLOC_B];	/* Offset of model (blend) location from digitized FZ location */
			F->segment[fz]->coord[POS_BL][row] = results[BEST_MODEL_B];	/* Best blend value at FZ location */
			F->segment[fz]->coord[POS_OR][row] = results[BEST_WAY_B];
			F->segment[fz]->coord[POS_WD][row] = results[BEST_WIDTH_D];	/* Best data width at FZ location */
			F->segment[fz]->coord[POS_WT][row] = results[BEST_WIDTH_T];	/* Best trough model width at FZ location */
			F->segment[fz]->coord[POS_WB][row] = results[BEST_WIDTH_B];	/* Best blend model width at FZ location */
			F->segment[fz]->coord[POS_AD][row] = results[BEST_AMPLT_D];	/* Best data amplitude at FZ location */
			F->segment[fz]->coord[POS_AT][row] = results[BEST_AMPLT_T];	/* Best trough amplitude at FZ location */
			F->segment[fz]->coord[POS_AB][row] = results[BEST_AMPLT_B];	/* Best blend amplitude at FZ location */
			F->segment[fz]->coord[POS_UT][row] = results[BEST_FLANK_T];	/* Best trough amplitude at FZ location */
			F->segment[fz]->coord[POS_UB][row] = results[BEST_FLANK_B];	/* Best blend amplitude at FZ location */
			F->segment[fz]->coord[POS_VT][row] = results[BEST_VARMD_T];	/* Best trough variance reduction at FZ location */
			F->segment[fz]->coord[POS_VB][row] = results[BEST_VARMD_B];	/* Best blend variance reduction at FZ location */
			F->segment[fz]->coord[POS_FT][row] = results[BEST_FSTAT_T];	/* Best trough F statistic at FZ location */
			F->segment[fz]->coord[POS_FB][row] = results[BEST_FSTAT_B];	/* Best blend F statistic at FZ location */
			for (ii = BEST_XD_1, k = POS_XDL; ii <= BEST_ZE_2; ii++, k++) F->segment[fz]->coord[k][row] = results[ii];	/* All 9 xyz triplets */

			/* Update crosstrack profiles with linear trends */
			for (ii = 0; ii < np_cross; ii++) {	/* Compute the best model fits as trend + scaled prediction shape. Note the trend requires BEST_FZLOC_B/T */
				S->coord[XPOS_T][ii] += (results[BEST_INTER_T] + results[BEST_SLOPE_T] * (S->coord[XPOS_D][ii] - results[BEST_FZLOC_T]));
				S->coord[XPOS_B][ii] += (results[BEST_INTER_B] + results[BEST_SLOPE_B] * (S->coord[XPOS_D][ii] - results[BEST_FZLOC_B]));
			}
			sprintf (add, " mb=%03.2f rv=%+2d OB=%+05.1f WB=%02g UB=%04.2f AB=%05.1f VB=%2.2d FB=%05.1f OT=%+05.1f WT=%02g UT=%04.2f AT=%05.1f VT=%2.2d FT=%05.1f OD=%+05.1f WD=%02g OE=%+05.1f",
				results[BEST_MODEL_B], way, best_loc[LOC_BLEND_T], results[BEST_WIDTH_B], results[BEST_FLANK_B], results[BEST_AMPLT_B],
				(int)irint(results[BEST_VARMD_B]), results[BEST_FSTAT_B], best_loc[LOC_TROUGH], results[BEST_WIDTH_T], results[BEST_FLANK_T],
				results[BEST_AMPLT_T], (int)irint(results[BEST_VARMD_T]), results[BEST_FSTAT_T], best_loc[LOC_DATA],
				results[BEST_WIDTH_D], best_loc[LOC_BLEND_E]);
			strcpy (buffer, S->header);
			free (S->header);
			gmt_chop (buffer);
			strcat (buffer, add);
			S->header = strdup (buffer);
		}
	}
	GMT_Report (API, GMT_MSG_NORMAL, "Process FZ cross-profile %s\n", S->label);

	/* Save crosstrack profiles and models to file */
	sprintf (buffer, "%s_cross.txt", Ctrl->T.prefix);
	file = strdup (buffer);
	if (GMT_Write_Data (API, GMT_IS_DATASET, GMT_IS_FILE, GMT_IS_LINE, 0, NULL, file, Xin) != GMT_OK) Return ((error = GMT_DATA_WRITE_ERROR));
	GMT_Destroy_Data (API, &Xin);
	free (file);

	/* Store FZ trace analysis  */
	sprintf (buffer, "%s_analysis.txt", Ctrl->T.prefix);
	file = strdup (buffer);
	if (GMT_Write_Data (API, GMT_IS_DATASET, GMT_IS_FILE, GMT_IS_LINE, 0, NULL, file, Fin) != GMT_OK) Return ((error = GMT_DATA_WRITE_ERROR));
	GMT_Destroy_Data (API, &Fin);
	free (file);

	if (Ctrl->S.active) {	/* Store parameters  */
		FILE *fp = NULL;
		char *assign = NULL, *equal = NULL, *shell[2] = {"sh/bash", "[t]cshell"};
		sprintf (buffer, "%s_par.txt", Ctrl->T.prefix);
		file = strdup (buffer);
		if ((fp = fopen (file, "w")) == NULL) {
			GMT_Report (API, GMT_MSG_NORMAL, "Syntax error:  Unable to create file %s\n", file);
			Return (EXIT_FAILURE);
		}
		GMT_Report (API, GMT_MSG_NORMAL, "Write modeling parameters script to File %s\n", file);
		assign = (Ctrl->S.mode) ? strdup ("set ") : strdup ("");
		equal  = (Ctrl->S.mode) ? strdup (" = ")  : strdup ("=");
		fprintf (fp, "%s\n", run_cmd);
		fprintf (fp, "# Parameters that may be used by %s scripts\n", shell[Ctrl->S.mode]);
		fprintf (fp, "%sCORR_WIDTH%s%g\n",	assign, equal, Ctrl->D.corr_width);
		fprintf (fp, "%sCROSS_LENGTH%s%g\n",	assign, equal, cross_length);
		fprintf (fp, "%sL_MIN%s%g\n",		assign, equal, Ctrl->C.min);
		fprintf (fp, "%sL_MAX%s%g\n",		assign, equal, Ctrl->C.max);
		fprintf (fp, "%sL_INC%s%g\n",		assign, equal, Ctrl->C.inc);
		fprintf (fp, "%sM_MIN%s%g\n",		assign, equal, Ctrl->A.min);
		fprintf (fp, "%sM_MAX%s%g\n",		assign, equal, Ctrl->A.max);
		fprintf (fp, "%sM_INC%s%g\n",		assign, equal, Ctrl->A.inc);
		fprintf (fp, "%sW_MIN%s%g\n",		assign, equal, Ctrl->W.min);
		fprintf (fp, "%sW_MAX%s%g\n",		assign, equal, Ctrl->W.max);
		fprintf (fp, "%sW_INC%s%g\n",		assign, equal, Ctrl->W.inc);
		fprintf (fp, "%sTAG%s%s\n",		assign, equal, Ctrl->T.prefix);
		fclose (fp);
		free (equal);
		free (file);
		free (assign);
	}

	if ((error = GMT_End_IO (API, GMT_OUT, 0))) Return (error);	/* Disables further data output */
	
	/* Close files and free misc. memory */
	
	for (m = 0; m < N_SHAPES; m++) gmt_M_free (GMT, comp[m]);
	gmt_M_free (GMT, FZ_width);
	gmt_M_free (GMT, FZ_asym);
	gmt_M_free (GMT, FZ_comp);

	Return (GMT_OK);
}