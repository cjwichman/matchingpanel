***********************************************************
* Design replication with panel data and 2 control groups
* Authors: Paul J. Ferraro and Casey J. Wichman
* Code written by: Casey J. Wichman
* Date: Oct 9, 2014
* Last update: 8/16/16
***********************************************************

/* This file does the following:
1) Merge Cobb, Fulton, and Gwinnett clean billing data sets
2) Clean up variables and fields to prepare for estimation
*/

clear
clear matrix
set more off





*clean up Fulton data to append to cleaned Cobb-Gwinnett data
use "data/in/TempPanelData2cjw.dta", clear // data obtained from Juan Jose
keep if group==5
keep code month prem_total water percent_report fmv acres age_hh ///
	 sf3_bg_higheduc sf3_bg_poor sf3_bg_pcincome sf3_bg_renter sf1_bg_white sf1_b_hh_avgsize

rename fmv fairmktvalue
*rename acres acres
rename age_hh ageofhome
rename sf3_bg_highedu pct_edu
rename sf3_bg_poor pct_pov
rename sf3_bg_pcincome percapincome
rename sf3_bg_renter pct_rent
rename sf1_bg_white pct_white
rename sf1_b_hh_avgsize hhsize

gen fulton=1

gen yrmonth=.
replace yrmonth=200605 if month==1
replace yrmonth=200606 if month==2
replace yrmonth=200607 if month==3
replace yrmonth=200608 if month==4
replace yrmonth=200609 if month==5
replace yrmonth=200610 if month==6
replace yrmonth=200611 if month==7
replace yrmonth=200612 if month==8
replace yrmonth=200701 if month==9
replace yrmonth=200702 if month==10
replace yrmonth=200703 if month==11
replace yrmonth=200704 if month==12
replace yrmonth=200705 if month==13
replace yrmonth=200706 if month==14
replace yrmonth=200707 if month==15
replace yrmonth=200708 if month==16
replace yrmonth=200709 if month==17

drop month

compress
save "data/temp/temp_fulton_append.dta", replace






* start with clean Cobb-Gwinnett data (better match rate than JJ's data set)
use "data/in/cobbgwin_clean.dta", clear
drop mayoct06 junnov06 marapr07 marmay07 aprmay07 junsep07 nov06feb07


* add fulton data
append using "data/temp/temp_fulton_append.dta"

replace fulton=0 if cobb==1 | gwin==1
replace route=0 if fulton==1
replace treatment=6 if fulton==1
replace treat1=0 if fulton==1
replace treat2=0 if fulton==1
replace treat3=0 if fulton==1
replace percent_report=0 if fulton==1
replace cobb=0 if fulton==1
replace gwin=0 if fulton==1

rename prem_total f_prem

sum id // max==200853
sum code // min==82028
egen code1 = group(code)
replace id = 200853 + code1 if fulton==1
drop code1 code

replace post=0 if fulton==1
replace post=1 if yrmonth>=200706

compress

sort id yrmonth
xtset id yrmonth

*** CREATE SOME WATER USE VARIABLES FOR ESTIMATION/MATCHING

* create MAY-OCT 2006 use variable for each HH
gen mo06=0
replace mo06 = 1 if yrmonth>=200605 & yrmonth<=200610
bysort id mo06: egen mo_use = sum(water)
replace mo_use=0 if mo06==0
bysort id: egen mayoct06 = max(mo_use)
drop mo06 mo_use

* create JUN-NOV 2006 use variable for each HH
gen jn06=0
replace jn06 = 1 if yrmonth>=200606 & yrmonth<=200611
bysort id jn06: egen jn_use = sum(water)
replace jn_use=0 if jn06==0
bysort id: egen junnov06 = max(jn_use)
drop jn06 jn_use

* create MAR-APR 2007 use variable for each HH
gen ma07=0
replace ma07 = 1 if yrmonth>=200703 & yrmonth<=200704
bysort id ma07: egen ma_use = sum(water)
replace ma_use=0 if ma07==0
bysort id: egen marapr07 = max(ma_use)
drop ma07 ma_use

* create MAR-MAY 2007 use variable for each HH
gen mm07=0
replace mm07 = 1 if yrmonth>=200703 & yrmonth<=200705
bysort id mm07: egen mm_use = sum(water)
replace mm_use=0 if mm07==0
bysort id: egen marmay07 = max(mm_use)
drop mm07 mm_use

* create APR-MAY 2007 use variable for each HH
gen am07=0
replace am07 = 1 if yrmonth>=200704 & yrmonth<=200705
bysort id am07: egen am_use = sum(water)
replace am_use=0 if am07==0
bysort id: egen aprmay07 = max(am_use)
drop am07 am_use

* create JUN-SEP 2007 use variable for each HH
gen js07=0
replace js07 = 1 if yrmonth>=200706 & yrmonth<=200709
bysort id js07: egen js_use = sum(water)
replace js_use=0 if js07==0
bysort id: egen junsep07 = max(js_use)
drop js07 js_use

* create NOV 2006 - FEB 2007 use variable for each HH
gen nf06=0
replace nf06 = 1 if yrmonth>=200611 & yrmonth<=200702
bysort id nf06: egen nf_use = sum(water)
replace nf_use=0 if nf06==0
bysort id: egen nov06feb07 = max(nf_use)
drop nf06 nf_use

save "data/clean/cfg_clean_panel", replace
*************************************************




	




***********************************************************************
** Create cross-section data set for pscores, trimming, and matching **
***********************************************************************
use "data/clean/cfg_clean_panel", clear

* Collapse data set for summary statistics and experimental comparisons
sort id yrmonth
collapse (first) acres fairmktvalue pct_rent hhsize pct_white pct_edu ///
	 percapincome pct_pov route treatment treat1 treat2 treat3 cobb gwin ///
	 ageofhome mayoct06 junnov06 marapr07 aprmay07 marmay07 junsep07 nov06feb07, by(id)
	
save "data/clean/cfg_clean_crosssection", replace










***********************************************************************
** Estimate optimal trimming bounds using p-scores                   **
***********************************************************************
use "data/clean/cfg_clean_crosssection", clear

*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
* summary table -- Water consumption by seasons
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tab treatment if treatment!=2, summarize(mayoct06)
tab treatment if treatment!=2, summarize(nov06feb07)
tab treatment if treatment!=2, summarize(marmay07)
tab treatment if treatment!=2, summarize(junsep07)

*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
* summary table -- Descriptive stats
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tab treatment if treatment!=2, summarize(fairmktvalue)
tab treatment if treatment!=2, summarize(ageofhome)
tab treatment if treatment!=2, summarize(acres)
tab treatment if treatment!=2, summarize(pct_edu)
tab treatment if treatment!=2, summarize(pct_pov)
tab treatment if treatment!=2, summarize(percapincome)
tab treatment if treatment!=2, summarize(pct_rent)
tab treatment if treatment!=2, summarize(pct_white)
tab treatment if treatment!=2, summarize(hhsize)


	
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*** ESTIMATE P-SCORE FOR TRIMMING ***
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
** Note: -optselect- is a user written .ado file that might not be kept up-to-date.

* Treatment 1 -- Logit
global RHS "mayoct06 marapr07 fairmktvalue ageofhome acres pct_white pct_edu pct_pov pct_rent percapincome"
logit treat1 $RHS if treatment==1 | treatment==5 | treatment==6
predict p1_log if treatment==1 | treatment==5 | treatment==6, pr
kdensity p1_log
bysort treat1: sum p1_log
* Sekhon optimal trimming bounds
* optselect p1_log
* Optimal boud = .03337832212767
local ob = 0.03337832212767
g p1_trim=.
replace p1_trim=0 if (treatment==1 | treatment==5 | treatment==6) & p1_log!=.
replace p1_trim=1 if p1_log>=`ob' & p1_log<=1-`ob'

* Treatment 1 -- Logit -- county5!
logit treat1 $RHS if treatment==1 | treatment==5
predict p1_log_t5 if treatment==1 | treatment==5, pr
kdensity p1_log_t5
bysort treat1: sum p1_log_t5
* Sekhon optimal trimming bounds
* optselect p1_log_t5
* Optimal boud = .0387129747375948
local ob = .0387129747375948
g p1_trim_t5=.
replace p1_trim_t5=0 if (treatment==1 | treatment==5) & p1_log_t5!=.
replace p1_trim_t5=1 if p1_log_t5>=`ob' & p1_log_t5<=1-`ob'

* Treatment 1 -- Logit -- county6!
logit treat1 $RHS if treatment==1 | treatment==6
predict p1_log_t6 if treatment==1 | treatment==6, pr
kdensity p1_log_t6
bysort treat1: sum p1_log_t6
* Sekhon optimal trimming bounds
* optselect p1_log_t6
* Optimal boud = .0628492769499066
local ob = .0628492769499066
g p1_trim_t6=.
replace p1_trim_t6=0 if (treatment==1 | treatment==6) & p1_log_t6!=.
replace p1_trim_t6=1 if p1_log_t6>=`ob' & p1_log_t6<=1-`ob'


* Treatment 3 -- Logit	
logit treat3 $RHS if treatment==3 | treatment==5 | treatment==6
predict p3_log if treatment==3 | treatment==5 | treatment==6, pr
kdensity p3_log
bysort treat3: sum p3_log
* Sekhon optimal trimming bounds
* optselect p3_log
* Optimal boud = .0336779508900239
local ob = 0.0336779508900239
g p3_trim=.
replace p3_trim=0 if (treatment==3 | treatment==5 | treatment==6) & p3_log!=.
replace p3_trim=1 if p3_log>=`ob' & p3_log<=1-`ob'

* Treatment 3 -- Logit -- county5!	
logit treat3 $RHS if treatment==3 | treatment==5
predict p3_log_t5 if treatment==3 | treatment==5, pr
kdensity p3_log_t5
bysort treat3: sum p3_log_t5
* Sekhon optimal trimming bounds
* optselect p3_log_t5
* Optimal boud = .038944241789478
local ob = .038944241789478
g p3_trim_t5=.
replace p3_trim_t5=0 if (treatment==3 | treatment==5) & p3_log_t5!=.
replace p3_trim_t5=1 if p3_log_t5>=`ob' & p3_log_t5<=1-`ob'

* Treatment 3 -- Logit -- county6!	
logit treat3 $RHS if treatment==3 | treatment==6
predict p3_log_t6 if treatment==3 | treatment==6, pr
kdensity p3_log_t6
bysort treat3: sum p3_log_t6
* Sekhon optimal trimming bounds
* optselect p3_log_t6
* Optimal boud = .0642998532330686
local ob = .0642998532330686
g p3_trim_t6=.
replace p3_trim_t6=0 if (treatment==3 | treatment==6) & p3_log_t6!=.
replace p3_trim_t6=1 if p3_log_t6>=`ob' & p3_log_t6<=1-`ob'

	  
compress 
save "data/clean/cfg_clean_crosssection2", replace







******************************************
* merge p-scores back with panel data
******************************************
use "data/clean/cfg_clean_panel", clear

merge m:1 id using "data/clean/cfg_clean_crosssection2"
count if _merge!=3
drop _merge

compress
save "data/clean/cfg_clean_panel2", replace








******************************
*** PREP FOR MATCHING IN R ***
******************************

use "data/clean/cfg_clean_crosssection2", clear
keep id treatment treat1 treat3 treatment p1_log p1_trim p3_log p3_trim ///
	 junsep07 mayoct06 marapr07 fairmktvalue ageofhome acres pct_white pct_edu ///
	 pct_pov pct_rent percapincome hhsize
order id treatment treat1 treat3 ///
	  junsep07 mayoct06 marapr07 fairmktvalue ageofhome acres pct_white pct_edu ///
	  pct_pov pct_rent percapincome hhsize p1_log p1_trim p3_log p3_trim, first
count if id==.
count if treatment==. 	 
count if treat1==.
count if treat3==.
count if treatment==.
count if mayoct06==.
count if marapr07==.
count if junsep07==.
count if fairmktvalue==. // 251 obs
	drop if fairmktvalue==.
count if ageofhome==. // 1 obs  				ALL MISSING DATA IN FULTON...
	drop if ageofhome==.
count if acres==. // 7 obs
	drop if acres==.
count if pct_white==.
count if pct_edu==.
count if pct_pov==.
count if pct_rent==.
count if percapincome==.
count if hhsize==.
compress
saveold "data/clean/cfg_clean_tomatch.dta", replace	v(11)




* erase files in "temp" folder
erase "data/temp/temp_fulton_append.dta"
