********************************************************************************
*** After Matching, Clean database with weights to merge with Master Database **
********************************************************************************



**Treatment 3. Mahalanobis Matching without Calipers. Cov13**
clear
insheet using "data/matching/11042016_maha_match_nocal_t3.csv", delim(;)
keep id treatment
duplicates tag id, gen(weight)
duplicates drop id, force
gen weight2=weight+1
replace weight2 = 1 if treatment==3
drop weight
duplicates drop id, force
rename weight2 w_t3f_mahanocal_cov13_cjw
count // 18682
sort id
save "data/matching/Temp_t3f_mahanocal_cov13.dta", replace

**Treatment 3. Mahalanobis Matching with Calipers. Cov13**
clear
insheet using "data/matching/11042016_maha_match_cal_t3.csv", delim(;)
keep id treatment
duplicates tag id, gen(weight)
duplicates drop id, force
gen weight2=weight+1
replace weight2 = 1 if treatment==3
drop weight
duplicates drop id, force
rename weight2 w_t3f_mahacal_cov13_cjw
count // 18118
sort id
save "data/matching/Temp_t3f_mahacal_cov13.dta", replace

**Treatment 3. Mahalanobis Matching with Calipers=0.5 SD
clear
insheet using "data/matching/11042016_maha_match_cal50_t3.csv", delim(;)
keep id treatment
duplicates tag id, gen(weight)
duplicates drop id, force
gen weight2=weight+1
replace weight2 = 1 if treatment==3
drop weight
duplicates drop id, force
rename weight2 w_t3f_mahacal50_cov13_cjw
count // 13966
sort id
save "data/matching/Temp_t3f_mahacal50_cov13.dta", replace

**Treatment 3. Mahalanobis Matching with Calipers=0.25 SD
clear
insheet using "data/matching/11042016_maha_match_cal25_t3.csv", delim(;)
keep id treatment
duplicates tag id, gen(weight)
duplicates drop id, force
gen weight2=weight+1
replace weight2 = 1 if treatment==3
drop weight
duplicates drop id, force
rename weight2 w_t3f_mahacal25_cov13_cjw
count // 3670
sort id
save "data/matching/Temp_t3f_mahacal25_cov13.dta", replace

**Treatment 3. Mahalanobis Matching with Calipers, No pretreatment water use
clear
insheet using "data/matching/11042016_maha_match_calnpt_t3.csv", delim(;)
keep id treatment
duplicates tag id, gen(weight)
duplicates drop id, force
gen weight2=weight+1
replace weight2 = 1 if treatment==3
drop weight
duplicates drop id, force
rename weight2 w_t3f_mahacalnpt_cov13_cjw
count // 16726
sort id
save "data/matching/Temp_t3f_mahacalnpt_cov13.dta", replace





**Treatment 1. Mahalanobis Matching without calipers. Cov13**
clear
insheet using "data/matching/11042016_maha_match_nocal_t1.csv", delim(;)
keep id treatment
duplicates tag id, gen(weight)
duplicates drop id, force
gen weight2=weight+1
replace weight2 = 1 if treatment==1
drop weight
duplicates drop id, force
rename weight2 w_t1f_mahanocal_cov13_cjw
count // 18502
sort id
save "data/matching/Temp_t1f_mahanocal_cov13.dta", replace

**Treatment 1. Mahalanobis Matching with Calipers. Cov13**
clear
insheet using "data/matching/11042016_maha_match_cal_t1.csv", delim(;)
keep id treatment
duplicates tag id, gen(weight)
duplicates drop id, force
gen weight2=weight+1
replace weight2 = 1 if treatment==1
drop weight
duplicates drop id, force
rename weight2 w_t1f_mahacal_cov13_cjw
count // 17988
sort id
save "data/matching/Temp_t1f_mahacal_cov13.dta", replace

**Treatment 1. Mahalanobis Matching with Calipers == 0.5 SD
clear
insheet using "data/matching/11042016_maha_match_cal50_t1.csv", delim(;)
keep id treatment
duplicates tag id, gen(weight)
duplicates drop id, force
gen weight2=weight+1
replace weight2 = 1 if treatment==1
drop weight
duplicates drop id, force
rename weight2 w_t1f_mahacal50_cov13_cjw
count // 13827
sort id
save "data/matching/Temp_t1f_mahacal50_cov13.dta", replace

**Treatment 1. Mahalanobis Matching with Calipers == 0.25 SD
clear
insheet using "data/matching/11042016_maha_match_cal25_t1.csv", delim(;)
keep id treatment
duplicates tag id, gen(weight)
duplicates drop id, force
gen weight2=weight+1
replace weight2 = 1 if treatment==1
drop weight
duplicates drop id, force
rename weight2 w_t1f_mahacal25_cov13_cjw
count // 3478
sort id
save "data/matching/Temp_t1f_mahacal25_cov13.dta", replace

**Treatment 1. Mahalanobis Matching with Calipers, NO PRETREATMENT WATER USE
clear
insheet using "data/matching/11042016_maha_match_calnpt_t1.csv", delim(;)
keep id treatment
duplicates tag id, gen(weight)
duplicates drop id, force
gen weight2=weight+1
replace weight2 = 1 if treatment==1
drop weight
duplicates drop id, force
rename weight2 w_t1f_mahacalnpt_cov13_cjw
count // 16530
sort id
save "data/matching/Temp_t1f_mahacalnpt_cov13.dta", replace




*** oct 13, 2016
* For treat5==1
**Treatment 3. Mahalanobis Matching without Calipers. Cov13**
clear
insheet using "data/matching/11042016_maha_match_nocal_t3t5.csv", delim(;)
keep id treatment
duplicates tag id, gen(weight)
duplicates drop id, force
gen weight2=weight+1
replace weight2 = 1 if treatment==3
drop weight
duplicates drop id, force
rename weight2 w_t3t5f_mahanocal_cov13_cjw
count // 18831
sort id
save "data/matching/Temp_t3t5f_mahanocal_cov13.dta", replace

**Treatment 3. Mahalanobis Matching without Calipers. Cov13**
clear
insheet using "data/matching/11042016_maha_match_cal_t3t5.csv", delim(;)
keep id treatment
duplicates tag id, gen(weight)
duplicates drop id, force
gen weight2=weight+1
replace weight2 = 1 if treatment==3
drop weight
duplicates drop id, force
rename weight2 w_t3t5f_mahacal_cov13_cjw
count // 17830
sort id
save "data/matching/Temp_t3t5f_mahacal_cov13.dta", replace

* For treat6==1
**Treatment 3. Mahalanobis Matching without Calipers. Cov13**
clear
insheet using "data/matching/11042016_maha_match_nocal_t3t6.csv", delim(;)
keep id treatment
duplicates tag id, gen(weight)
duplicates drop id, force
gen weight2=weight+1
replace weight2 = 1 if treatment==3
drop weight
duplicates drop id, force
rename weight2 w_t3t6f_mahanocal_cov13_cjw
count // 14477
sort id
save "data/matching/Temp_t3t6f_mahanocal_cov13.dta", replace

**Treatment 3. Mahalanobis Matching without Calipers. Cov13**
clear
insheet using "data/matching/11042016_maha_match_cal_t3t6.csv", delim(;)
keep id treatment
duplicates tag id, gen(weight)
duplicates drop id, force
gen weight2=weight+1
replace weight2 = 1 if treatment==3
drop weight
duplicates drop id, force
rename weight2 w_t3t6f_mahacal_cov13_cjw
count // 9945
sort id
save "data/matching/Temp_t3t6f_mahacal_cov13.dta", replace



* For treat5==1
**Treatment 1. Mahalanobis Matching without Calipers. Cov13**
clear
insheet using "data/matching/11042016_maha_match_nocal_t1t5.csv", delim(;)
keep id treatment
duplicates tag id, gen(weight)
duplicates drop id, force
gen weight2=weight+1
replace weight2 = 1 if treatment==1
drop weight
duplicates drop id, force
rename weight2 w_t1t5f_mahanocal_cov13_cjw
count // 18649
sort id
save "data/matching/Temp_t1t5f_mahanocal_cov13.dta", replace

**Treatment 3. Mahalanobis Matching without Calipers. Cov13**
clear
insheet using "data/matching/11042016_maha_match_cal_t1t5.csv", delim(;)
keep id treatment
duplicates tag id, gen(weight)
duplicates drop id, force
gen weight2=weight+1
replace weight2 = 1 if treatment==1
drop weight
duplicates drop id, force
rename weight2 w_t1t5f_mahacal_cov13_cjw
count // 17720
sort id
save "data/matching/Temp_t1t5f_mahacal_cov13.dta", replace

* For treat6==1
**Treatment 3. Mahalanobis Matching without Calipers. Cov13**
clear
insheet using "data/matching/11042016_maha_match_nocal_t1t6.csv", delim(;)
keep id treatment
duplicates tag id, gen(weight)
duplicates drop id, force
gen weight2=weight+1
replace weight2 = 1 if treatment==1
drop weight
duplicates drop id, force
rename weight2 w_t1t6f_mahanocal_cov13_cjw
count // 14420
sort id
save "data/matching/Temp_t1t6f_mahanocal_cov13.dta", replace

**Treatment 3. Mahalanobis Matching without Calipers. Cov13**
clear
insheet using "data/matching/11042016_maha_match_cal_t1t6.csv", delim(;)
keep id treatment
duplicates tag id, gen(weight)
duplicates drop id, force
gen weight2=weight+1
replace weight2 = 1 if treatment==1
drop weight
duplicates drop id, force
rename weight2 w_t1t6f_mahacal_cov13_cjw
count // 9972
sort id
save "data/matching/Temp_t1t6f_mahacal_cov13.dta", replace








*********************************
*** Merge with Master Database **
*********************************
use "data/clean/cfg_clean_crosssection2", clear

sort id
merge m:1 id using "data/matching/Temp_t3f_mahanocal_cov13.dta"
drop if _merge==2 // 0 obs
drop _merge

sort id
merge m:1 id using "data/matching/Temp_t3f_mahacal_cov13.dta"
drop if _merge==2 // 0 obs
drop _merge

sort id
merge m:1 id using "data/matching/Temp_t3f_mahacal50_cov13.dta"
drop if _merge==2 // 0 obs
drop _merge

sort id
merge m:1 id using "data/matching/Temp_t3f_mahacal25_cov13.dta"
drop if _merge==2 // 0 obs
drop _merge

sort id
merge m:1 id using "data/matching/Temp_t3f_mahacalnpt_cov13.dta"
drop if _merge==2 // 0 obs
drop _merge


sort id
merge m:1 id using "data/matching/Temp_t1f_mahanocal_cov13.dta"
drop if _merge==2 // 0 obs
drop _merge

sort id
merge m:1 id using "data/matching/Temp_t1f_mahacal_cov13.dta"
drop if _merge==2 // 0 obs
drop _merge

sort id
merge m:1 id using "data/matching/Temp_t1f_mahacal50_cov13.dta"
drop if _merge==2 // 0 obs
drop _merge

sort id
merge m:1 id using "data/matching/Temp_t1f_mahacal25_cov13.dta"
drop if _merge==2 // 0 obs
drop _merge

sort id
merge m:1 id using "data/matching/Temp_t1f_mahacalnpt_cov13.dta"
drop if _merge==2 // 0 obs
drop _merge


* oct 13, 2016

sort id
merge m:1 id using "data/matching/Temp_t3t5f_mahanocal_cov13.dta"
drop if _merge==2 // 0 obs
drop _merge

sort id
merge m:1 id using "data/matching/Temp_t3t6f_mahanocal_cov13.dta"
drop if _merge==2 // 0 obs
drop _merge

sort id
merge m:1 id using "data/matching/Temp_t3t5f_mahacal_cov13.dta"
drop if _merge==2 // 0 obs
drop _merge

sort id
merge m:1 id using "data/matching/Temp_t3t6f_mahacal_cov13.dta"
drop if _merge==2 // 0 obs
drop _merge
sort id


merge m:1 id using "data/matching/Temp_t1t5f_mahanocal_cov13.dta"
drop if _merge==2 // 0 obs
drop _merge

sort id
merge m:1 id using "data/matching/Temp_t1t6f_mahanocal_cov13.dta"
drop if _merge==2 // 0 obs
drop _merge

sort id
merge m:1 id using "data/matching/Temp_t1t5f_mahacal_cov13.dta"
drop if _merge==2 // 0 obs
drop _merge

sort id
merge m:1 id using "data/matching/Temp_t1t6f_mahacal_cov13.dta"
drop if _merge==2 // 0 obs
drop _merge



compress
save "data/clean/cfg_matched_crosssection.dta", replace





*************************************************************************
* merge matched sample weights with panel data set
*************************************************************************
use "data/clean/cfg_clean_panel2", clear

sort id
merge m:1 id using "data/clean/cfg_matched_crosssection.dta"
count if _merge==2
drop _merge

rename w_t1f_mahanocal_cov13_cjw w_t1_nocal
rename w_t1f_mahacal_cov13_cjw w_t1_cal
rename w_t1f_mahacal50_cov13_cjw w_t1_cal50
rename w_t1f_mahacal25_cov13_cjw w_t1_cal25
rename w_t1f_mahacalnpt_cov13_cjw w_t1_calnpt

rename w_t3f_mahanocal_cov13_cjw w_t3_nocal
rename w_t3f_mahacal_cov13_cjw w_t3_cal
rename w_t3f_mahacal50_cov13_cjw w_t3_cal50
rename w_t3f_mahacal25_cov13_cjw w_t3_cal25
rename w_t3f_mahacalnpt_cov13_cjw w_t3_calnpt

rename w_t3t5f_mahanocal_cov13_cjw w_t3t5_nocal
rename w_t3t6f_mahanocal_cov13_cjw w_t3t6_nocal
rename w_t3t5f_mahacal_cov13_cjw w_t3t5_cal
rename w_t3t6f_mahacal_cov13_cjw w_t3t6_cal

rename w_t1t5f_mahanocal_cov13_cjw w_t1t5_nocal
rename w_t1t6f_mahanocal_cov13_cjw w_t1t6_nocal
rename w_t1t5f_mahacal_cov13_cjw w_t1t5_cal
rename w_t1t6f_mahacal_cov13_cjw w_t1t6_cal


recode p1_trim .=0
recode p3_trim .=0
recode w_t1_nocal .=0
recode w_t1_cal .=0
recode w_t1_cal50 .=0
recode w_t1_cal25 .=0
recode w_t1_calnpt .=0
recode w_t3_nocal .=0
recode w_t3_cal .=0
recode w_t3_cal50 .=0
recode w_t3_cal25 .=0
recode w_t3_calnpt .=0

recode p1_trim_t5  .=0
recode p1_trim_t6  .=0
recode p3_trim_t5  .=0
recode p3_trim_t6  .=0
recode w_t3t5_nocal .=0 
recode w_t3t6_nocal .=0 
recode w_t3t5_cal  .=0
recode w_t3t6_cal  .=0
recode w_t1t5_nocal .=0 
recode w_t1t6_nocal .=0 
recode w_t1t5_cal  .=0
recode w_t1t6_cal .=0


compress
save "data/clean/cfg_matched_panel.dta", replace

