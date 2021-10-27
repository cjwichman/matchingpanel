* Make regression results for Wichman & Ferraro (Econ Letters, 2017)


set more off



use "data/clean/cfg_matched_panel.dta", clear

g t1post = treat1*post
g t3post = treat3*post

sort id yrmonth
xtset id yrmonth

egen t = group(yrmonth)
tab t
g t_cobb = 0
replace t_cobb = t if cobb==1
g t_gwin = 0
replace t_gwin = t if gwin==1
g t_fulton = 0
replace t_fulton = t if fulton==1
g t_cf = 0
replace t_cf = t if cobb==1 | fulton==1

tab t_cobb if treatment<5, gen(tt_c)
tab t_gwin if treatment==5, gen(tt_g)
tab t_fulton if treatment==6, gen(tt_f)

* false treatment dummy
g falset = 0
replace falset=1 if treatment==6 & post==1

* seasonal vars
g summer=0
replace summer=1 if (yrmonth>=200605 & yrmonth<=200608) | (yrmonth>=200705 & yrmonth<=200708)
g fall=0
replace fall=1 if (yrmonth>=200609 & yrmonth<=200612) | (yrmonth>=200709 & yrmonth<=200712)

* cobb summer
g summer_c = 0
replace summer_c=summer if treatment<5
* gwinnett summer
g summer_g = 0
replace summer_g=summer if treatment==5
* fulton summer
g summer_f = 0
replace summer_f=summer if treatment==6

* cobb fall
g fall_c = 0
replace fall_c=fall if treatment<5
* gwinnett fall
g fall_g = 0
replace fall_g=fall if treatment==5
* fulton fall
g fall_f = 0
replace fall_f=fall if treatment==6


gen season=.
	replace season=1 if yrmonth>=200605 & yrmonth<=200608
	replace season=2 if yrmonth>=200609 & yrmonth<=200612
	replace season=3 if yrmonth>=200701 & yrmonth<=200704
	replace season=4 if yrmonth>=200705 & yrmonth<=200708
	replace season=5 if yrmonth>=200709

g season_c=0
replace season_c=season if treatment<5		
g season_g=0
replace season_g=season if treatment==5
g season_f=0
replace season_f=season if treatment==6

g post_c=0
replace post_c=post if treatment<5
g post_g=0
replace post_g=post if treatment==5
g post_f=0
replace post_f=post if treatment==6		
	
	
	
	
	

*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
* EL TABLE 1 -- Descriptive stats
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*** Water consumption by seasons
tab treatment if treatment!=2, summarize(mayoct06)
tab treatment if treatment!=2, summarize(marmay07)
*** Tax assessor data
tab treatment if treatment!=2, summarize(fairmktvalue)
tab treatment if treatment!=2, summarize(ageofhome)
tab treatment if treatment!=2, summarize(acres)
*** Census variables
tab treatment if treatment!=2, summarize(pct_edu)
tab treatment if treatment!=2, summarize(pct_pov)
tab treatment if treatment!=2, summarize(percapincome)
tab treatment if treatment!=2, summarize(pct_rent)
tab treatment if treatment!=2, summarize(pct_white)

	
	
	
	
	
	
	
	
	
	
	
	


	
	
	
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
* EL TABLE 2 -- Replication results
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

*Add time fixed effects:
global tt = " "


*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
* EL TABLE 2 -- Panel A
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
/* SOCIAL COMP TREATMENT */		

* EXPERIMENTAL
xtreg water t3post post $tt ///
	if treatment==3 | treatment==4, fe robust	
outreg2 using "results/tab2a_t3_cfg.xls", excel dec(3) ctitle("exp") replace		
disp _b[t3post]
*  -.34591788
disp _se[t3post]
* .04801474


* pooled
xtreg water t3post post $tt ///
	if treatment==3 | treatment==5 | treatment==6, fe robust
outreg2 using "results/tab2a_t3_cfg.xls", excel dec(3) ctitle("pooled")	
local b1 = -.34591788 
local s1 = .04801474
local b2 = _b[t3post]
local s2 = _se[t3post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = -2.5473104
* p = .01085568

* trimmed
xtreg water t3post post $tt  ///
	if treatment==3 | treatment==5 | treatment==6 & p3_trim==1, fe robust	
outreg2 using "results/tab2a_t3_cfg.xls", excel dec(3) ctitle("trim") 	
local b1 = -.34591788 
local s1 = .04801474
local b2 = _b[t3post]
local s2 = _se[t3post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = -2.6642514
* p = .00771599
	
* matched, without calipers
xtreg water t3post post $tt  [fweight=w_t3_nocal] ///
	if treatment==3 | treatment==5 | treatment==6 , fe robust		
outreg2 using "results/tab2a_t3_cfg.xls", excel dec(3) ctitle("nocal") 	
local b1 = -.34591788 
local s1 = .04801474
local b2 = _b[t3post]
local s2 = _se[t3post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = -2.2717736
* p = .02310019
	
* matched, with calipers=SD
xtreg water t3post post $tt [fweight=w_t3_cal] ///
	if treatment==3 | treatment==5 | treatment==6 , fe robust		
outreg2 using "results/tab2a_t3_cfg.xls", excel dec(3) ctitle("caliper") 	
local b1 = -.34591788 
local s1 = .04801474
local b2 = _b[t3post]
local s2 = _se[t3post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = -2.9658116
* p = .00301885







*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
* EL TABLE 2 -- Panel B
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
/* INFORMATION TREATMENT */		

* EXPERIMENTAL
xtreg water t1post post $tt  ///
	if treatment==1 | treatment==4, fe robust	
outreg2 using "results/tab2b_t1_cfg.xls", excel dec(3) ctitle("exp") replace		
disp _b[t1post]
* -.01162435
disp _se[t1post]
* .05477785
		

*** EL RESULTS -- PANEL B
* pooled
xtreg water t1post post $tt ///
	if treatment==1 | treatment==5 | treatment==6, fe robust
outreg2 using "results/tab2b_t1_cfg.xls", excel dec(3) ctitle("pooled")	
local b1 = -.01162435
local s1 = .05477785
local b2 = _b[t1post]
local s2 = _se[t1post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = -2.2131675
* p = .0268861
	

* trimmed
xtreg water t1post post $tt ///
	if treatment==1 | treatment==5 | treatment==6 & p1_trim==1, fe robust	
outreg2 using "results/tab2b_t1_cfg.xls", excel dec(3) ctitle("trim")	
local b1 = -.01162435
local s1 = .05477785
local b2 = _b[t1post]
local s2 = _se[t1post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = -2.3510757
* p = .01871923
	
	
* matched, without calipers
xtreg water t1post post $tt [fweight=w_t1_nocal] ///
	if treatment==1 | treatment==5 | treatment==6 , fe robust	
outreg2 using "results/tab2b_t1_cfg.xls", excel dec(3) ctitle("nocal")	
local b1 = -.01162435
local s1 = .05477785
local b2 = _b[t1post]
local s2 = _se[t1post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = -2.3864838
* p = .01701036
	
	
* matched, with calipers=SD
xtreg water t1post post $tt [fweight=w_t1_cal] ///
	if treatment==1 | treatment==5 | treatment==6 , fe robust		
outreg2 using "results/tab2b_t1_cfg.xls", excel dec(3) ctitle("caliper")	
local b1 = -.01162435
local s1 = .05477785
local b2 = _b[t1post]
local s2 = _se[t1post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = -1.9564564
* p = .05041142
	
	







*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
* EL TABLE A.3 -- Panel A -- Fulton Co. Only
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
*** SOCIAL COMPARISON
	
* experimental
xtreg water t3post post $tt  ///
	if treatment==3 | treatment==4, fe robust
outreg2 using "results/tabA3a_t3t6.xls", excel dec(3) ctitle("exp") replace
	

* fulton==treatment==6
xtreg water t3post post $tt ///
	if treatment==3 | treatment==6, fe robust
outreg2 using "results/tabA3a_t3t6.xls", excel dec(3) ctitle("full")
local b1 = -.34591788 
local s1 = .04801474
local b2 = _b[t3post]
local s2 = _se[t3post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = 6.8808926
* p = 5.948e-12
	
xtreg water t3post post $tt ///
	if treatment==3 | treatment==6 & p3_trim_t6==1, fe robust	
outreg2 using "results/tabA3a_t3t6.xls", excel dec(3) ctitle("trim")	
local b1 = -.34591788 
local s1 = .04801474
local b2 = _b[t3post]
local s2 = _se[t3post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = 5.1786528
* p = 2.235e-07
	
	
xtreg water t3post post $tt [fweight=w_t3t6_nocal] ///
	if treatment==3 | treatment==6 , fe robust		
outreg2 using "results/tabA3a_t3t6.xls", excel dec(3) ctitle("nocal")
local b1 = -.34591788 
local s1 = .04801474
local b2 = _b[t3post]
local s2 = _se[t3post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = .92905439
* p = .3528609
	
xtreg water t3post post $tt [fweight=w_t3t6_cal] ///
	if treatment==3 | treatment==6 , fe robust		
outreg2 using "results/tabA3a_t3t6.xls", excel dec(3) ctitle("caliper")
local b1 = -.34591788 
local s1 = .04801474
local b2 = _b[t3post]
local s2 = _se[t3post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = .49161193
* p = .62299371






*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
* EL TABLE A.3 -- Panel B -- Fulton Co. Only
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
*** INFORMATION TREATMENT 

	
* experimental
xtreg water t1post post $tt  ///
	if treatment==1 | treatment==4, fe robust
outreg2 using "results/tabA3b_t1t6.xls", excel dec(3) ctitle("exp") replace
	
* fulton==treatment==6
xtreg water t1post post $tt  ///
	if treatment==1 | treatment==6, fe robust
outreg2 using "results/tabA3b_t1t6.xls", excel dec(3) ctitle("full")
local b1 = -.01162435
local s1 = .05477785
local b2 = _b[t1post]
local s2 = _se[t1post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = 6.4146218
* p = 1.412e-10
	
xtreg water t1post post $tt ///
	if treatment==1 | treatment==6 & p1_trim_t6==1, fe robust	
outreg2 using "results/tabA3b_t1t6.xls", excel dec(3) ctitle("trim")	
local b1 = -.01162435
local s1 = .05477785
local b2 = _b[t1post]
local s2 = _se[t1post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = 4.735678
* p = 2.183e-06
	
xtreg water t1post post $tt [fweight=w_t1t6_nocal] ///
	if treatment==1 | treatment==6 , fe robust		
outreg2 using "results/tabA3b_t1t6.xls", excel dec(3) ctitle("nocal")
local b1 = -.01162435
local s1 = .05477785
local b2 = _b[t1post]
local s2 = _se[t1post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = 1.1604458
* p = .24586734
	
xtreg water t1post post $tt  [fweight=w_t1t6_cal] ///
	if treatment==1 | treatment==6 , fe robust		
outreg2 using "results/tabA3b_t1t6.xls", excel dec(3) ctitle("caliper")	
local b1 = -.01162435
local s1 = .05477785
local b2 = _b[t1post]
local s2 = _se[t1post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = .86139815
* p = .3890188












*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
* EL TABLE A.4 -- Panel A -- Gwinnett Co. Only
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
*** SOCIAL COMPARISON

*Add time fixed effects:
global tt = " "


* experimental
xtreg water t3post post $tt ///
	if treatment==3 | treatment==4, fe robust
outreg2 using "results/tabA4a_t3t5.xls", excel dec(3) ctitle("exp") replace
	
	
* gwinnett==treatment==5
xtreg water t3post post $tt ///
	if treatment==3 | treatment==5, fe robust
outreg2 using "results/tabA4a_t3t5.xls", excel dec(3) ctitle("full")	
local b1 = -.34591788 
local s1 = .04801474
local b2 = _b[t3post]
local s2 = _se[t3post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = -7.1053177
* p = 1.200e-12
	
xtreg water t3post post $tt ///
	if treatment==3 | treatment==5 & p3_trim_t5==1, fe robust	
outreg2 using "results/tabA4a_t3t5.xls", excel dec(3) ctitle("trim")
local b1 = -.34591788 
local s1 = .04801474
local b2 = _b[t3post]
local s2 = _se[t3post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = -6.8959218
* p = 5.352e-12
	
	
xtreg water t3post post $tt [fweight=w_t3t5_nocal] ///
	if treatment==3 | treatment==5, fe robust	
outreg2 using "results/tabA4a_t3t5.xls", excel dec(3) ctitle("nocal")
local b1 = -.34591788 
local s1 = .04801474
local b2 = _b[t3post]
local s2 = _se[t3post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = -3.9445964
* p = .00007993

xtreg water t3post post $tt [fweight=w_t3t5_cal] ///
	if treatment==3 | treatment==5, fe robust		
outreg2 using "results/tabA4a_t3t5.xls", excel dec(3) ctitle("caliper")	
local b1 = -.34591788 
local s1 = .04801474
local b2 = _b[t3post]
local s2 = _se[t3post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = -4.3094898
* p = .00001636





*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
* EL TABLE A.4 -- Panel B -- Gwinnett Co. Only
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
*** INFORMATION TREATMENT 


* experimental
xtreg water t1post post $tt ///
	if treatment==1 | treatment==4, fe robust
outreg2 using "results/tabA4b_t1t5.xls", excel dec(3) ctitle("exp") replace
	
* gwinnett==treatment==5
xtreg water t1post post $tt ///
	if treatment==1 | treatment==5, fe robust
outreg2 using "results/tabA4b_t1t5.xls", excel dec(3) ctitle("full")
local b1 = -.01162435
local s1 = .05477785
local b2 = _b[t1post]
local s2 = _se[t1post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = -6.1251582
* p = 9.059e-10
	
xtreg water t1post post $tt ///
	if treatment==1 | treatment==5 & p1_trim_t5==1, fe robust	
outreg2 using "results/tabA4b_t1t5.xls", excel dec(3) ctitle("trim")
local b1 = -.01162435
local s1 = .05477785
local b2 = _b[t1post]
local s2 = _se[t1post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = -5.9550975
* p = 2.599e-09

	
xtreg water t1post post $tt [fweight=w_t1t5_nocal] ///
	if treatment==1 | treatment==5 , fe robust	
outreg2 using "results/tabA4b_t1t5.xls", excel dec(3) ctitle("nocal")
local b1 = -.01162435
local s1 = .05477785
local b2 = _b[t1post]
local s2 = _se[t1post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = -4.0679375
* p = .00004743

xtreg water t1post post $tt [fweight=w_t1t5_cal] ///
	if treatment==1 | treatment==5 , fe robust		
outreg2 using "results/tabA4b_t1t5.xls", excel dec(3) ctitle("caliper")	
local b1 = -.01162435
local s1 = .05477785
local b2 = _b[t1post]
local s2 = _se[t1post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = -3.6691339
* p = .00024337













*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
* EL TABLE A.5 -- Panel A -- sensitivity
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

* Sensitivity:
* matched, with calipers=0.5*SD
xtreg water t3post post $tt [fweight=w_t3_cal50] ///
	if treatment==3 | treatment==5 | treatment==6 , fe robust	
outreg2 using "results/tabA5a_t3_cfg.xls", excel dec(3) ctitle("cal=0.5") 	
local b1 = -.34591788 
local s1 = .04801474
local b2 = _b[t3post]
local s2 = _se[t3post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = -3.6343825
* p = .00027865
	
	
* matched, with calipers=0.25*SD	
xtreg water t3post post $tt [fweight=w_t3_cal25] ///
	if treatment==3 | treatment==5 | treatment==6 , fe robust		
outreg2 using "results/tabA5a_t3_cfg.xls", excel dec(3) ctitle("cal=0.25") 		
local b1 = -.34591788 
local s1 = .04801474
local b2 = _b[t3post]
local s2 = _se[t3post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = -2.2568407
* p = .02401803
	
	
* matched, with calipers=SD, no pre-treatment water use
xtreg water t3post post $tt [fweight=w_t3_calnpt] ///
	if treatment==3 | treatment==5 | treatment==6 , fe robust		
outreg2 using "results/tabA5a_t3_cfg.xls", excel dec(3) ctitle("cal=1, npretreat") 		
local b1 = -.34591788 
local s1 = .04801474
local b2 = _b[t3post]
local s2 = _se[t3post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = -1.8196059
* p = .06881905




*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
* EL TABLE A.5 -- Panel B -- sensitivity
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

* Sensitivity:
* matched, with calipers=0.5*SD
xtreg water t1post post $tt [fweight=w_t1_cal50] ///
	if treatment==1 | treatment==5 | treatment==6 , fe robust	
outreg2 using "results/tabA5b_t1_cfg.xls", excel dec(3) ctitle("cal=0.5")		
local b1 = -.01162435
local s1 = .05477785
local b2 = _b[t1post]
local s2 = _se[t1post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = -1.9336854
* p = .05315181
	
	
* matched, with calipers=0.25*SD	
xtreg water t1post post $tt [fweight=w_t1_cal25] ///
	if treatment==1 | treatment==5 | treatment==6 , fe robust	
outreg2 using "results/tabA5b_t1_cfg.xls", excel dec(3) ctitle("cal=0.25")		
local b1 = -.01162435
local s1 = .05477785
local b2 = _b[t1post]
local s2 = _se[t1post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = 1.4219407
* p = .15504346
	
	
* matched, with calipers=SD, no pre-treatment water use
xtreg water t1post post $tt [fweight=w_t1_calnpt] ///
	if treatment==1 | treatment==5 | treatment==6 , fe robust	
outreg2 using "results/tabA5b_t1_cfg.xls", excel dec(3) ctitle("cal=1, npretreat")		
local b1 = -.01162435
local s1 = .05477785
local b2 = _b[t1post]
local s2 = _se[t1post]
local num = `b1' - `b2'
local den = (`s1'^2 + `s2'^2)^0.5
local z = `num' / `den'
local p=2*(1-normal(abs(`z')))
disp `z'	
disp `p'
* z = -1.8769556
* p = .06052418


