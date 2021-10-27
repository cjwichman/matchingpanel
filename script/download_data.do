***********************************************************************************
** download data files by running the following code.
**********************************************************************************
set more off


* download zipped file with all data files and unzip.
* Make sure this is ends up in the first level of your "~/matchingpanel/" directory (e.g., "~/matchingpanel/data/")
copy "https://caseyjwichman.com/data/matchingpaneldata.zip" "data.zip", replace
unzipfile "data.zip", replace

