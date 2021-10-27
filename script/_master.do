*********************************************************************************
** 	Replication code for:
** 	"A cautionary tale on using panel data estimators to measure program impacts"
** 	Casey Wichman & Paul Ferraro
** 	Economics Letters, 2017
**  	(code/data produced in Stata 14)
**
** 	Notes: 
**	--Not the prettiest, but gets the job done.
**	--Email wichman@gatech.edu if anything breaks.
*********************************************************************************


clear all
set more off


*********************************************************************************
** update directory
global dir = "~/Dropbox/matchingpanel/"
cd $dir
*********************************************************************************




* 0) Download data sets from embedded Dropbox links. Adjust file paths in .do file if necessary
	// Note: data can be downloaded directly from https://caseyjwichman.com/data/matchingpaneldata.zip
	// Just make sure that ends up as "/data/" in the first level of your directory.
do "script/download_data.do"


* 1) Assemble Cobb, Gwinnett, and Fulton County data
do "script/clean_data.do"


* 2) Run matching code in R 
	// Make sure to update the directory in the maha_match_CFG.R file.
	// Note: generating balance tables with bs=1000 takes a while to run.
	// Setting bs=0 works fine if you only want the matching results and 
	// don't care about bootstrapped balance test statistics.

******************************************************************
*******              run matching in R!!!!            ************
*******           run "maha_match_CFG.R" in R         ************
******************************************************************


* 3) Combine matched samples with clean data sets. Matched samples are identified via sample weights.
do "script/merge_matches_cfg.do"


* 4) Creates summary statistics and regression results in EL paper.
do "script/make_regressions.do"




