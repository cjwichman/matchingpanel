*********************************************************************************
** 	Replication code for:
** 	"A cautionary tale on using panel data estimators to measure program effects"
** 	Casey Wichman & Paul Ferraro
** 	Economics Letters, 2017
**  	(code/data produced in Stata 14)
*********************************************************************************


clear all
set more off


*********************************************************************************
** update directory
global dir = "~/Dropbox/matchingpanel/"
global DATA = "$dir/data/"
global SCRIPT = "$dir/script/"
cd $dir
*********************************************************************************




* 0) Download data sets from embedded Dropbox links. Adjust file paths in .do file if necessary
do "$SCRIPT/download_data.do"



* 1) Assemble Cobb, Gwinnett, and Fulton County data
do "$SCRIPT/clean_data.do"


* 2)
******************************************************************
*******              run matching in R!!!!            ************
*******           run "maha_match_CFG.R" in R         ************
******************************************************************


* 3) 
do "$SCRIPT/merge_matches_cfg.do"
do "$SCRIPT/make_regressions.do"




