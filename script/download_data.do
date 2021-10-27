***********************************************************************************
** download data files by running the following code.
***********************************************************************************
* primary source files -- you can run the entire analysis starting with these 2 files.
copy "https://www.dropbox.com/s/45kedxzgpnx300t/cobbgwin_clean.dta?dl=0" "$DATA/in/cobbgwin_clean.dta", replace 
copy "https://www.dropbox.com/s/t7lcj82217v8es6/TempPanelData2cjw.dta?dl=0" "$DATA/in/TempPanelData2cjw.dta", replace 


* cleaned data files
copy "https://www.dropbox.com/s/zt4nx8v86hifudo/cfg_clean_crosssection.dta?dl=0" "$DATA/clean/cfg_clean_crosssection.dta", replace
copy "https://www.dropbox.com/s/sebwklvxod6h7yk/cfg_clean_crosssection2.dta?dl=0" "$DATA/clean/cfg_clean_crosssection2.dta", replace
copy "https://www.dropbox.com/s/rhe2sq6owxdhgck/cfg_clean_panel.dta?dl=0" "$DATA/clean/cfg_clean_panel.dta", replace
copy "https://www.dropbox.com/s/k42nm2i6lzjs2fx/cfg_clean_panel2.dta?dl=0" "$DATA/clean/cfg_clean_panel2.dta", replace
copy "https://www.dropbox.com/s/pl1xsdcgj4l08yp/cfg_clean_tomatch.dta?dl=0" "$DATA/clean/cfg_clean_tomatch.dta", replace
copy "https://www.dropbox.com/s/s03itonmyhrvqyq/cfg_matched_crosssection.dta?dl=0" "$DATA/clean/cfg_matched_crosssection.dta", replace
copy "https://www.dropbox.com/s/16aq1jpbtc1ai4m/cfg_matched_panel.dta?dl=0" "$DATA/clean/cfg_matched_panel.dta", replace

