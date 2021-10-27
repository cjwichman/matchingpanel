# matching panel

These are replication files for "A cautionary tale on using panel data estimators to measure program impacts" by Casey Wichman and Paul Ferraro, Economics Letters, 2017.

A few notes:
* Data can be downloaded directly from https://caseyjwichman.com/data/matchingpaneldata.zip
** Just make sure this ends up in the first level of your working directory (e.g., "~/matchingpanel/data/")
* Start with the `script/_master.do` file if you want to re-do the analysis start to finish.
* Matching and generating balance tables is done in R using `script/match_match_CFG.R
* If you only care about reproducing regression results in the published paper, start with `script/make_regressions.do'

Email wichman@gatech.edu if you get lost.