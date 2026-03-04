# matching panel

These are replication files for ["A cautionary tale on using panel data estimators to measure program impacts"](https://www.sciencedirect.com/science/article/pii/S016517651630489X) by Casey Wichman and Paul Ferraro, Economics Letters, 2017.

A few notes:
* Data can be downloaded directly from [this link](https://www.dropbox.com/scl/fi/n0xvcfppqdecf0a8tyq2k/matchingpaneldata.zip?rlkey=o3elup0ujgv22myig9bjfuefk&dl=0)
  * Just make sure this ends up in the first level of your working directory (e.g., "~/matchingpanel/data/")
  * The `script/download_data.do` file will do this for you.
* Start with the `script/_master.do` file if you want to re-do the analysis start to finish.
* Matching and generating balance tables is done in R using `script/match_match_CFG.R`
* If you only care about reproducing regression results in the published paper, start with `script/make_regressions.do`

Email wichman@gatech.edu if you get lost.
