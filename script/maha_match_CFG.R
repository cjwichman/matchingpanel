############################################################################
# Mahalanobis Matching for Preprocessing Data
# Casey J Wichman
# Last update: 11/04/2016
############################################################################

## Delete all objects from the environment
rm(list=ls(all=TRUE)) 

setwd("~/Dropbox/matchingpanel/") ## change this to your own directory
sink("results/log/BalanceLog11042016.txt")

## INITIAL COMMANDS
library(foreign)
library(rgenoud)
library(Matching)

## Read cross-sectional data for Cobb/Gwin/Fulton Matching
cgf <- read.dta("data/clean/cfg_clean_tomatch.dta")

# Covariate lists
#cov.11 <- c("mayoct06", "marapr07")
#cov.12 <- c("fairmktvalue", "ageofhome", "acres", "pct_edu", "pct_pov", "percapincome", "pct_rent", "pct_white", "hhsize")
#cov.13 <- c("mayoct06", "marapr07", "fairmktvalue", "ageofhome", "acres", "pct_edu", "pct_pov", "percapincome", "pct_rent", "pct_white", "hhsize")

## TEST WITHOUT MATCHING ON hhsize
cov.12 <- c("fairmktvalue", "ageofhome", "acres", "pct_edu", "pct_pov", "percapincome", "pct_rent", "pct_white")
cov.13 <- c("mayoct06", "marapr07", "fairmktvalue", "ageofhome", "acres", "pct_edu", "pct_pov", "percapincome", "pct_rent", "pct_white")


# Covariate to test balance
cov.1a <- c("junsep07", "mayoct06", "marapr07", "fairmktvalue", "ageofhome", "acres", "pct_edu", "pct_pov", "percapincome", "pct_rent", "pct_white")




bs <- 0  ## set bs reps equal to zero. no need for balance tables for these results

#################################################################
#####Treatment3 vs GWINNETT & FULTON Control Group (Full Sample)
#################################################################
cgf.t3 <- subset(cgf, treatment==3 | treatment==5)
#### treatment==5!

# variables for pscore estimation
tr3    <- cgf.t3$treat3
mo06   <- cgf.t3$mayoct06
ma07   <- cgf.t3$marapr07
fmv    <- cgf.t3$fairmktvalue
age    <- cgf.t3$ageofhome
acr    <- cgf.t3$acres
pedu   <- cgf.t3$pct_edu
ppov   <- cgf.t3$pct_pov
inc    <- cgf.t3$percapincome
prent  <- cgf.t3$pct_rent
pwhite <- cgf.t3$pct_white
hhsize <- cgf.t3$hhsize
#Outcome
y.t3f <- cgf.t3$junsep07
#treatment
Tr.t3f <- cgf.t3$treat3

## MAHA MATCHING BELOW
#########################
## FULL SAMPLE -> MATCHED **WITHOUT** CALIPERS
print("---treat3, matched, no caliper, GWIN---")
matcht3f.nocal <- Match(Y=y.t3f, Tr=Tr.t3f, X=cgf.t3[cov.13], Weight=2, version='fast')
summary(matcht3f.nocal)
matched.t3f.nocal <- rbind(cgf.t3[matcht3f.nocal$index.treated,], cgf.t3[matcht3f.nocal$index.control,])
write.table(matched.t3f.nocal, "data/matching/11042016_maha_match_nocal_t3t5.csv", sep=";",col.names=NA, row.names=TRUE)
balance.gwin.t3.nocal <- MatchBalance(Tr.t3f ~ as.matrix(cgf.t3[cov.1a]), nboots=bs, match.out=matcht3f.nocal, data=cgf.t3)

## FULL SAMPLE -> MATCHED **WITH** CALIPERS = 1 SD
print("---treat3, matched, caliper=1SD, GWIN---")
matcht3f.cal <- Match(Y=y.t3f, Tr=Tr.t3f, X=cgf.t3[cov.13], Weight=2, version="fast", caliper = TRUE)
summary(matcht3f.cal)
matched.t3f.cal <- rbind(cgf.t3[matcht3f.cal$index.treated,], cgf.t3[matcht3f.cal$index.control,])
write.table(matched.t3f.cal, "data/matching/11042016_maha_match_cal_t3t5.csv", sep=";",col.names=NA, row.names=TRUE)
balance.gwin.t3.cal <- MatchBalance(Tr.t3f ~ as.matrix(cgf.t3[cov.1a]), nboots=bs, match.out=matcht3f.cal)


#####################################
cgf.t3 <- subset(cgf, treatment==3 | treatment==6)
#### treatment==6!

# variables for pscore estimation
tr3    <- cgf.t3$treat3
mo06   <- cgf.t3$mayoct06
ma07   <- cgf.t3$marapr07
fmv    <- cgf.t3$fairmktvalue
age    <- cgf.t3$ageofhome
acr    <- cgf.t3$acres
pedu   <- cgf.t3$pct_edu
ppov   <- cgf.t3$pct_pov
inc    <- cgf.t3$percapincome
prent  <- cgf.t3$pct_rent
pwhite <- cgf.t3$pct_white
hhsize <- cgf.t3$hhsize
#Outcome
y.t3f <- cgf.t3$junsep07
#treatment
Tr.t3f <- cgf.t3$treat3

## MAHA MATCHING BELOW
#########################
## FULL SAMPLE -> MATCHED **WITHOUT** CALIPERS
print("---treat3, matched, no caliper, COBB---")
matcht3f.nocal <- Match(Y=y.t3f, Tr=Tr.t3f, X=cgf.t3[cov.13], Weight=2, version='fast')
summary(matcht3f.nocal)
matched.t3f.nocal <- rbind(cgf.t3[matcht3f.nocal$index.treated,], cgf.t3[matcht3f.nocal$index.control,])
write.table(matched.t3f.nocal, "data/matching/11042016_maha_match_nocal_t3t6.csv", sep=";",col.names=NA, row.names=TRUE)
balance.cobb.t3.nocal <- MatchBalance(Tr.t3f ~ as.matrix(cgf.t3[cov.1a]), nboots=bs, match.out=matcht3f.nocal, data=cgf.t3)

## FULL SAMPLE -> MATCHED **WITH** CALIPERS = 1 SD
print("---treat3, matched, caliper=1SD, COBB---")
matcht3f.cal <- Match(Y=y.t3f, Tr=Tr.t3f, X=cgf.t3[cov.13], Weight=2, version="fast", caliper = TRUE)
summary(matcht3f.cal)
matched.t3f.cal <- rbind(cgf.t3[matcht3f.cal$index.treated,], cgf.t3[matcht3f.cal$index.control,])
write.table(matched.t3f.cal, "data/matching/11042016_maha_match_cal_t3t6.csv", sep=";",col.names=NA, row.names=TRUE)
balance.cobb.t3.cal <- MatchBalance(Tr.t3f ~ as.matrix(cgf.t3[cov.1a]), nboots=bs, match.out=matcht3f.cal)




##########################################################
#####Treatment1 vs Gwinnett Control Group (Full Sample)
##########################################################
cgf.t1 <- subset(cgf, treatment==1 | treatment==5)
### TREATMENT =5!
#Outcome
y.t1f <- cgf.t1$junsep07
#treatment
Tr.t1f <- cgf.t1$treat1
## MAHA MATCHING BELOW
#########################
## FULL SAMPLE -> MATCHED **WITHOUT** CALIPERS
print("---treat1, matched, no caliper, GWIN---")
matcht1f.nocal <- Match(Y=y.t1f, Tr=Tr.t1f, X=cgf.t1[cov.13], Weight=2, version="fast")
summary(matcht1f.nocal)
matched.t1f.nocal <- rbind(cgf.t1[matcht1f.nocal$index.treated,], cgf.t1[matcht1f.nocal$index.control,])
write.table(matched.t1f.nocal, "data/matching/11042016_maha_match_nocal_t1t5.csv", sep=";",col.names=NA, row.names=TRUE)
balance.gwin.t1.nocal <- MatchBalance(Tr.t1f ~ as.matrix(cgf.t1[cov.1a]), nboots=bs, match.out=matcht1f.nocal)

#########################
## FULL SAMPLE -> MATCHED **WITH** CALIPERS = 1 SD
print("---treat1, matched, caliper=1SD, GWIN---")
matcht1f.cal <- Match(Y=y.t1f, Tr=Tr.t1f, X=cgf.t1[cov.13], Weight=2, version="fast", caliper = TRUE)
summary(matcht1f.cal)
matched.t1f.cal <- rbind(cgf.t1[matcht1f.cal$index.treated,], cgf.t1[matcht1f.cal$index.control,])
write.table(matched.t1f.cal, "data/matching/11042016_maha_match_cal_t1t5.csv", sep=";",col.names=NA, row.names=TRUE)
balance.gwin.t1.cal <- MatchBalance(Tr.t1f ~ as.matrix(cgf.t1[cov.1a]), nboots=bs, match.out=matcht1f.cal)



##########################################################
#####Treatment1 vs Gwinnett Control Group (Full Sample)
##########################################################
cgf.t1 <- subset(cgf, treatment==1 | treatment==6)
### TREATMENT =6!
#Outcome
y.t1f <- cgf.t1$junsep07
#treatment
Tr.t1f <- cgf.t1$treat1
## MAHA MATCHING BELOW
#########################
## FULL SAMPLE -> MATCHED **WITHOUT** CALIPERS
print("---treat1, matched, no caliper, COBB---")
matcht1f.nocal <- Match(Y=y.t1f, Tr=Tr.t1f, X=cgf.t1[cov.13], Weight=2, version="fast")
summary(matcht1f.nocal)
matched.t1f.nocal <- rbind(cgf.t1[matcht1f.nocal$index.treated,], cgf.t1[matcht1f.nocal$index.control,])
write.table(matched.t1f.nocal, "data/matching/11042016_maha_match_nocal_t1t6.csv", sep=";",col.names=NA, row.names=TRUE)
balance.cobb.t1.nocal <- MatchBalance(Tr.t1f ~ as.matrix(cgf.t1[cov.1a]), nboots=bs, match.out=matcht1f.nocal)

#########################
## FULL SAMPLE -> MATCHED **WITH** CALIPERS = 1 SD
print("---treat3, matched, caliper=1SD, COBB---")
matcht1f.cal <- Match(Y=y.t1f, Tr=Tr.t1f, X=cgf.t1[cov.13], Weight=2, version="fast", caliper = TRUE)
summary(matcht1f.cal)
matched.t1f.cal <- rbind(cgf.t1[matcht1f.cal$index.treated,], cgf.t1[matcht1f.cal$index.control,])
write.table(matched.t1f.cal, "data/matching/11042016_maha_match_cal_t1t6.csv", sep=";",col.names=NA, row.names=TRUE)
balance.cobb.t1.cal <- MatchBalance(Tr.t1f ~ as.matrix(cgf.t1[cov.1a]), nboots=bs, match.out=matcht1f.cal)





varname <- rep("junsep07", 40)
varname[6:10] <- rep("mayoct06", 5)
varname[11:15] <- rep("marapr07", 5)
varname[16:20] <- rep("fairmktvalue", 5)
varname[21:25] <- rep("ageofhome", 5)
varname[26:30] <- rep("acres", 5)
varname[31:35] <- rep("pct_edu", 5)
varname[36:40] <- rep("pct_pov", 5)
varname[41:45] <- rep("percapincome", 5)
varname[46:50] <- rep("pct_rent", 5)
varname[51:55] <- rep("pct_white", 5)


metric <- rep(c("Mean Difference", "Standardized Mean Difference", "Mean Raw eQQ Difference", 
                "Variance Ratio (Treat/Comp.)", "Kolmogrov-Smirnov Statistic"), 11)

outputGwinT3nocal <- data.frame(cbind(varname, metric))
for(i in 1:11){
  outputGwinT3nocal$FullSample[1+(5*(i-1))] <- balance.gwin.t3.nocal[[1]][[i]]$mean.Tr -balance.gwin.t3.nocal[[1]][[i]]$mean.Co
  outputGwinT3nocal$FullSample[2+(5*(i-1))] <- balance.gwin.t3.nocal[[1]][[i]]$sdiff
  outputGwinT3nocal$FullSample[3+(5*(i-1))] <- balance.gwin.t3.nocal[[1]][[i]]$qqsummary.raw$meandiff
  outputGwinT3nocal$FullSample[4+(5*(i-1))] <- balance.gwin.t3.nocal[[1]][[i]]$var.ratio
  outputGwinT3nocal$FullSample[5+(5*(i-1))] <- balance.gwin.t3.nocal[[1]][[i]]$ks$ks$statistic
  outputGwinT3nocal$Matching[1+(5*(i-1))] <- balance.gwin.t3.nocal[[2]][[i]]$mean.Tr -balance.gwin.t3.nocal[[2]][[i]]$mean.Co
  outputGwinT3nocal$Matching[2+(5*(i-1))] <- balance.gwin.t3.nocal[[2]][[i]]$sdiff
  outputGwinT3nocal$Matching[3+(5*(i-1))] <- balance.gwin.t3.nocal[[2]][[i]]$qqsummary.raw$meandiff
  outputGwinT3nocal$Matching[4+(5*(i-1))] <- balance.gwin.t3.nocal[[2]][[i]]$var.ratio
  outputGwinT3nocal$Matching[5+(5*(i-1))] <- balance.gwin.t3.nocal[[2]][[i]]$ks$ks$statistic
}
write.csv(outputGwinT3nocal, "results/balance/outputGwinT3nocal.csv")

outputGwinT3cal <- data.frame(cbind(varname, metric))
for(i in 1:11){
  outputGwinT3cal$FullSample[1+(5*(i-1))] <- balance.gwin.t3.cal[[1]][[i]]$mean.Tr -balance.gwin.t3.cal[[1]][[i]]$mean.Co
  outputGwinT3cal$FullSample[2+(5*(i-1))] <- balance.gwin.t3.cal[[1]][[i]]$sdiff
  outputGwinT3cal$FullSample[3+(5*(i-1))] <- balance.gwin.t3.cal[[1]][[i]]$qqsummary.raw$meandiff
  outputGwinT3cal$FullSample[4+(5*(i-1))] <- balance.gwin.t3.cal[[1]][[i]]$var.ratio
  outputGwinT3cal$FullSample[5+(5*(i-1))] <- balance.gwin.t3.cal[[1]][[i]]$ks$ks$statistic
  outputGwinT3cal$Matching[1+(5*(i-1))] <- balance.gwin.t3.cal[[2]][[i]]$mean.Tr -balance.gwin.t3.cal[[2]][[i]]$mean.Co
  outputGwinT3cal$Matching[2+(5*(i-1))] <- balance.gwin.t3.cal[[2]][[i]]$sdiff
  outputGwinT3cal$Matching[3+(5*(i-1))] <- balance.gwin.t3.cal[[2]][[i]]$qqsummary.raw$meandiff
  outputGwinT3cal$Matching[4+(5*(i-1))] <- balance.gwin.t3.cal[[2]][[i]]$var.ratio
  outputGwinT3cal$Matching[5+(5*(i-1))] <- balance.gwin.t3.cal[[2]][[i]]$ks$ks$statistic
}
write.csv(outputGwinT3cal, "results/balance/outputGwinT3cal.csv")

outputCobbT3nocal <- data.frame(cbind(varname, metric))
for(i in 1:11){
  outputCobbT3nocal$FullSample[1+(5*(i-1))] <- balance.cobb.t3.nocal[[1]][[i]]$mean.Tr -balance.cobb.t3.nocal[[1]][[i]]$mean.Co
  outputCobbT3nocal$FullSample[2+(5*(i-1))] <- balance.cobb.t3.nocal[[1]][[i]]$sdiff
  outputCobbT3nocal$FullSample[3+(5*(i-1))] <- balance.cobb.t3.nocal[[1]][[i]]$qqsummary.raw$meandiff
  outputCobbT3nocal$FullSample[4+(5*(i-1))] <- balance.cobb.t3.nocal[[1]][[i]]$var.ratio
  outputCobbT3nocal$FullSample[5+(5*(i-1))] <- balance.cobb.t3.nocal[[1]][[i]]$ks$ks$statistic
  outputCobbT3nocal$Matching[1+(5*(i-1))] <- balance.cobb.t3.nocal[[2]][[i]]$mean.Tr -balance.cobb.t3.nocal[[2]][[i]]$mean.Co
  outputCobbT3nocal$Matching[2+(5*(i-1))] <- balance.cobb.t3.nocal[[2]][[i]]$sdiff
  outputCobbT3nocal$Matching[3+(5*(i-1))] <- balance.cobb.t3.nocal[[2]][[i]]$qqsummary.raw$meandiff
  outputCobbT3nocal$Matching[4+(5*(i-1))] <- balance.cobb.t3.nocal[[2]][[i]]$var.ratio
  outputCobbT3nocal$Matching[5+(5*(i-1))] <- balance.cobb.t3.nocal[[2]][[i]]$ks$ks$statistic
}
write.csv(outputCobbT3nocal, "results/balance/outputCobbT3nocal.csv")

outputCobbT3cal <- data.frame(cbind(varname, metric))
for(i in 1:11){
  outputCobbT3cal$FullSample[1+(5*(i-1))] <- balance.cobb.t3.cal[[1]][[i]]$mean.Tr -balance.cobb.t3.cal[[1]][[i]]$mean.Co
  outputCobbT3cal$FullSample[2+(5*(i-1))] <- balance.cobb.t3.cal[[1]][[i]]$sdiff
  outputCobbT3cal$FullSample[3+(5*(i-1))] <- balance.cobb.t3.cal[[1]][[i]]$qqsummary.raw$meandiff
  outputCobbT3cal$FullSample[4+(5*(i-1))] <- balance.cobb.t3.cal[[1]][[i]]$var.ratio
  outputCobbT3cal$FullSample[5+(5*(i-1))] <- balance.cobb.t3.cal[[1]][[i]]$ks$ks$statistic
  outputCobbT3cal$Matching[1+(5*(i-1))] <- balance.cobb.t3.cal[[2]][[i]]$mean.Tr -balance.cobb.t3.cal[[2]][[i]]$mean.Co
  outputCobbT3cal$Matching[2+(5*(i-1))] <- balance.cobb.t3.cal[[2]][[i]]$sdiff
  outputCobbT3cal$Matching[3+(5*(i-1))] <- balance.cobb.t3.cal[[2]][[i]]$qqsummary.raw$meandiff
  outputCobbT3cal$Matching[4+(5*(i-1))] <- balance.cobb.t3.cal[[2]][[i]]$var.ratio
  outputCobbT3cal$Matching[5+(5*(i-1))] <- balance.cobb.t3.cal[[2]][[i]]$ks$ks$statistic
}
write.csv(outputCobbT3cal, "results/balance/outputCobbT3cal.csv")

outputGwinT1nocal <- data.frame(cbind(varname, metric))
for(i in 1:11){
  outputGwinT1nocal$FullSample[1+(5*(i-1))] <- balance.gwin.t1.nocal[[1]][[i]]$mean.Tr -balance.gwin.t1.nocal[[1]][[i]]$mean.Co
  outputGwinT1nocal$FullSample[2+(5*(i-1))] <- balance.gwin.t1.nocal[[1]][[i]]$sdiff
  outputGwinT1nocal$FullSample[3+(5*(i-1))] <- balance.gwin.t1.nocal[[1]][[i]]$qqsummary.raw$meandiff
  outputGwinT1nocal$FullSample[4+(5*(i-1))] <- balance.gwin.t1.nocal[[1]][[i]]$var.ratio
  outputGwinT1nocal$FullSample[5+(5*(i-1))] <- balance.gwin.t1.nocal[[1]][[i]]$ks$ks$statistic
  outputGwinT1nocal$Matching[1+(5*(i-1))] <- balance.gwin.t1.nocal[[2]][[i]]$mean.Tr -balance.gwin.t1.nocal[[2]][[i]]$mean.Co
  outputGwinT1nocal$Matching[2+(5*(i-1))] <- balance.gwin.t1.nocal[[2]][[i]]$sdiff
  outputGwinT1nocal$Matching[3+(5*(i-1))] <- balance.gwin.t1.nocal[[2]][[i]]$qqsummary.raw$meandiff
  outputGwinT1nocal$Matching[4+(5*(i-1))] <- balance.gwin.t1.nocal[[2]][[i]]$var.ratio
  outputGwinT1nocal$Matching[5+(5*(i-1))] <- balance.gwin.t1.nocal[[2]][[i]]$ks$ks$statistic
}
write.csv(outputGwinT1nocal, "results/balance/outputGwinT1nocal.csv")

outputGwinT1cal <- data.frame(cbind(varname, metric))
for(i in 1:11){
  outputGwinT1cal$FullSample[1+(5*(i-1))] <- balance.gwin.t1.cal[[1]][[i]]$mean.Tr -balance.gwin.t1.cal[[1]][[i]]$mean.Co
  outputGwinT1cal$FullSample[2+(5*(i-1))] <- balance.gwin.t1.cal[[1]][[i]]$sdiff
  outputGwinT1cal$FullSample[3+(5*(i-1))] <- balance.gwin.t1.cal[[1]][[i]]$qqsummary.raw$meandiff
  outputGwinT1cal$FullSample[4+(5*(i-1))] <- balance.gwin.t1.cal[[1]][[i]]$var.ratio
  outputGwinT1cal$FullSample[5+(5*(i-1))] <- balance.gwin.t1.cal[[1]][[i]]$ks$ks$statistic
  outputGwinT1cal$Matching[1+(5*(i-1))] <- balance.gwin.t1.cal[[2]][[i]]$mean.Tr -balance.gwin.t1.cal[[2]][[i]]$mean.Co
  outputGwinT1cal$Matching[2+(5*(i-1))] <- balance.gwin.t1.cal[[2]][[i]]$sdiff
  outputGwinT1cal$Matching[3+(5*(i-1))] <- balance.gwin.t1.cal[[2]][[i]]$qqsummary.raw$meandiff
  outputGwinT1cal$Matching[4+(5*(i-1))] <- balance.gwin.t1.cal[[2]][[i]]$var.ratio
  outputGwinT1cal$Matching[5+(5*(i-1))] <- balance.gwin.t1.cal[[2]][[i]]$ks$ks$statistic
}
write.csv(outputGwinT1cal, "results/balance/outputGwinT1cal.csv")

outputCobbT1nocal <- data.frame(cbind(varname, metric))
for(i in 1:11){
  outputCobbT1nocal$FullSample[1+(5*(i-1))] <- balance.cobb.t1.nocal[[1]][[i]]$mean.Tr -balance.cobb.t1.nocal[[1]][[i]]$mean.Co
  outputCobbT1nocal$FullSample[2+(5*(i-1))] <- balance.cobb.t1.nocal[[1]][[i]]$sdiff
  outputCobbT1nocal$FullSample[3+(5*(i-1))] <- balance.cobb.t1.nocal[[1]][[i]]$qqsummary.raw$meandiff
  outputCobbT1nocal$FullSample[4+(5*(i-1))] <- balance.cobb.t1.nocal[[1]][[i]]$var.ratio
  outputCobbT1nocal$FullSample[5+(5*(i-1))] <- balance.cobb.t1.nocal[[1]][[i]]$ks$ks$statistic
  outputCobbT1nocal$Matching[1+(5*(i-1))] <- balance.cobb.t1.nocal[[2]][[i]]$mean.Tr -balance.cobb.t1.nocal[[2]][[i]]$mean.Co
  outputCobbT1nocal$Matching[2+(5*(i-1))] <- balance.cobb.t1.nocal[[2]][[i]]$sdiff
  outputCobbT1nocal$Matching[3+(5*(i-1))] <- balance.cobb.t1.nocal[[2]][[i]]$qqsummary.raw$meandiff
  outputCobbT1nocal$Matching[4+(5*(i-1))] <- balance.cobb.t1.nocal[[2]][[i]]$var.ratio
  outputCobbT1nocal$Matching[5+(5*(i-1))] <- balance.cobb.t1.nocal[[2]][[i]]$ks$ks$statistic
}
write.csv(outputCobbT1nocal, "results/balance/outputCobbT1nocal.csv")

outputCobbT1cal <- data.frame(cbind(varname, metric))
for(i in 1:11){
  outputCobbT1cal$FullSample[1+(5*(i-1))] <- balance.cobb.t1.cal[[1]][[i]]$mean.Tr -balance.cobb.t1.cal[[1]][[i]]$mean.Co
  outputCobbT1cal$FullSample[2+(5*(i-1))] <- balance.cobb.t1.cal[[1]][[i]]$sdiff
  outputCobbT1cal$FullSample[3+(5*(i-1))] <- balance.cobb.t1.cal[[1]][[i]]$qqsummary.raw$meandiff
  outputCobbT1cal$FullSample[4+(5*(i-1))] <- balance.cobb.t1.cal[[1]][[i]]$var.ratio
  outputCobbT1cal$FullSample[5+(5*(i-1))] <- balance.cobb.t1.cal[[1]][[i]]$ks$ks$statistic
  outputCobbT1cal$Matching[1+(5*(i-1))] <- balance.cobb.t1.cal[[2]][[i]]$mean.Tr -balance.cobb.t1.nocal[[2]][[i]]$mean.Co
  outputCobbT1cal$Matching[2+(5*(i-1))] <- balance.cobb.t1.cal[[2]][[i]]$sdiff
  outputCobbT1cal$Matching[3+(5*(i-1))] <- balance.cobb.t1.cal[[2]][[i]]$qqsummary.raw$meandiff
  outputCobbT1cal$Matching[4+(5*(i-1))] <- balance.cobb.t1.cal[[2]][[i]]$var.ratio
  outputCobbT1cal$Matching[5+(5*(i-1))] <- balance.cobb.t1.cal[[2]][[i]]$ks$ks$statistic
}
write.csv(outputCobbT1cal, "results/balance/outputCobbT1cal.csv")



























bs <- 1000





#################################################################
#####Treatment3 vs GWINNETT & FULTON Control Group (Full Sample)
#################################################################
cgf.t3 <- subset(cgf, treatment==3 | treatment==5 | treatment==6)

# variables for pscore estimation
  tr3    <- cgf.t3$treat3
  mo06   <- cgf.t3$mayoct06
  ma07   <- cgf.t3$marapr07
  fmv    <- cgf.t3$fairmktvalue
  age    <- cgf.t3$ageofhome
  acr    <- cgf.t3$acres
  pedu   <- cgf.t3$pct_edu
  ppov   <- cgf.t3$pct_pov
  inc    <- cgf.t3$percapincome
  prent  <- cgf.t3$pct_rent
  pwhite <- cgf.t3$pct_white
  hhsize <- cgf.t3$hhsize
#Outcome
y.t3f <- cgf.t3$junsep07
#treatment
Tr.t3f <- cgf.t3$treat3

#propensity score
#lmodel <- glm(cgf.t3[treat3] ~ cgf.t3[cov.13], family=binomial)
#logit_model <- glm(tr3 ~mo06 + ma07 + fmv + age + acr 
#                  + pedu + ppov + inc + prent + pwhite + hhsize, family=binomial)
#summary(logit_model)
#ps <- logit_model$fitted

## MAHA MATCHING BELOW
#########################
## FULL SAMPLE -> MATCHED **WITHOUT** CALIPERS
print("---treat3, matched, no caliper, FULL---")
matcht3f.nocal <- Match(Y=y.t3f, Tr=Tr.t3f, X=cgf.t3[cov.13], Weight=2, version='fast')
summary(matcht3f.nocal)
matched.t3f.nocal <- rbind(cgf.t3[matcht3f.nocal$index.treated,], cgf.t3[matcht3f.nocal$index.control,])
write.table(matched.t3f.nocal, "data/matching/11042016_maha_match_nocal_t3.csv", sep=";",col.names=NA, row.names=TRUE)
balance.t3.nocal <- MatchBalance(Tr.t3f ~ as.matrix(cgf.t3[cov.1a]), nboots=bs, match.out=matcht3f.nocal, data=cgf.t3)

#########################
## FULL SAMPLE -> MATCHED **WITH** CALIPERS = 1 SD
print("---treat3, matched, caliper=1SD, FULL---")
matcht3f.cal <- Match(Y=y.t3f, Tr=Tr.t3f, X=cgf.t3[cov.13], Weight=2, version="fast", caliper = TRUE)
summary(matcht3f.cal)
matched.t3f.cal <- rbind(cgf.t3[matcht3f.cal$index.treated,], cgf.t3[matcht3f.cal$index.control,])
write.table(matched.t3f.cal, "data/matching/11042016_maha_match_cal_t3.csv", sep=";",col.names=NA, row.names=TRUE)
balance.t3.cal <- MatchBalance(Tr.t3f ~ as.matrix(cgf.t3[cov.1a]), nboots=bs, match.out=matcht3f.cal)

## FULL SAMPLE -> MATCHED **WITH** CALIPERS = 0.5 SD
print("---treat3, matched, caliper=0.5SD, FULL---")
matcht3f.cal50 <- Match(Y=y.t3f, Tr=Tr.t3f, X=cgf.t3[cov.13], Weight=2, version="fast", caliper = 0.5)
summary(matcht3f.cal50)
matched.t3f.cal50 <- rbind(cgf.t3[matcht3f.cal50$index.treated,], cgf.t3[matcht3f.cal50$index.control,])
write.table(matched.t3f.cal50, "data/matching/11042016_maha_match_cal50_t3.csv", sep=";",col.names=NA, row.names=TRUE)
balance.t3.cal50 <- MatchBalance(Tr.t3f ~ as.matrix(cgf.t3[cov.1a]), nboots=bs, match.out=matcht3f.cal50)

## FULL SAMPLE -> MATCHED **WITH** CALIPERS = 0.25 SD
print("---treat3, matched, caliper=0.25SD, FULL---")
matcht3f.cal25 <- Match(Y=y.t3f, Tr=Tr.t3f, X=cgf.t3[cov.13], Weight=2, version="fast", caliper = 0.25)
summary(matcht3f.cal25)
matched.t3f.cal25 <- rbind(cgf.t3[matcht3f.cal25$index.treated,], cgf.t3[matcht3f.cal25$index.control,])
write.table(matched.t3f.cal25, "data/matching/11042016_maha_match_cal25_t3.csv", sep=";",col.names=NA, row.names=TRUE)
balance.t3.cal25 <- MatchBalance(Tr.t3f ~ as.matrix(cgf.t3[cov.1a]), nboots=bs, match.out=matcht3f.cal25)

## FULL SAMPLE -> MATCHED **WITH** CALIPERS = 1 SD, NO PRETREATMENT WATER USE
print("---treat3, matched, caliper=1SD, NPT, FULL---")
matcht3f.cal.npt <- Match(Y=y.t3f, Tr=Tr.t3f, X=cgf.t3[cov.12], Weight=2, version="fast", caliper = TRUE)
summary(matcht3f.cal.npt)
matched.t3f.cal.npt <- rbind(cgf.t3[matcht3f.cal.npt$index.treated,], cgf.t3[matcht3f.cal.npt$index.control,])
write.table(matched.t3f.cal.npt, "data/matching/11042016_maha_match_calnpt_t3.csv", sep=";",col.names=NA, row.names=TRUE)
balance.t3.cal.npt <- MatchBalance(Tr.t3f ~ as.matrix(cgf.t3[cov.1a]), nboots=bs, match.out=matcht3f.cal.npt)

#########################
## TRIMMED SAMPLE BALANCE TEST
print("---treat3, trimmed sample, FULL---")
cgf.t3 <- subset(cgf, treatment==3 | treatment==5 | treatment==6)
cgf.t3trim <- subset(cgf.t3, p3_trim==1)
#Outcome
y.t3trim <- cgf.t3trim$junsep07
#treatment
Tr.t3trim <- cgf.t3trim$treat3
balance.t3.trim <- MatchBalance(Tr.t3trim ~ as.matrix(cgf.t3trim[cov.1a]), nboots=1000)




### EXPORT t3 RESULTS

varname <- rep("junsep07", 40)
varname[6:10] <- rep("mayoct06", 5)
varname[11:15] <- rep("marapr07", 5)
varname[16:20] <- rep("fairmktvalue", 5)
varname[21:25] <- rep("ageofhome", 5)
varname[26:30] <- rep("acres", 5)
varname[31:35] <- rep("pct_edu", 5)
varname[36:40] <- rep("pct_pov", 5)
varname[41:45] <- rep("percapincome", 5)
varname[46:50] <- rep("pct_rent", 5)
varname[51:55] <- rep("pct_white", 5)


metric <- rep(c("Mean Difference", "Standardized Mean Difference", "Mean Raw eQQ Difference", 
                "Variance Ratio (Treat/Comp.)", "Kolmogrov-Smirnov Statistic"), 11)

outputT3nocal <- data.frame(cbind(varname, metric))
for(i in 1:11){
  outputT3nocal$FullSample[1+(5*(i-1))] <- balance.t3.nocal[[1]][[i]]$mean.Tr -balance.t3.nocal[[1]][[i]]$mean.Co
  outputT3nocal$FullSample[2+(5*(i-1))] <- balance.t3.nocal[[1]][[i]]$sdiff
  outputT3nocal$FullSample[3+(5*(i-1))] <- balance.t3.nocal[[1]][[i]]$qqsummary.raw$meandiff
  outputT3nocal$FullSample[4+(5*(i-1))] <- balance.t3.nocal[[1]][[i]]$var.ratio
  outputT3nocal$FullSample[5+(5*(i-1))] <- balance.t3.nocal[[1]][[i]]$ks$ks$statistic
  outputT3nocal$Matching[1+(5*(i-1))] <- balance.t3.nocal[[2]][[i]]$mean.Tr -balance.t3.nocal[[2]][[i]]$mean.Co
  outputT3nocal$Matching[2+(5*(i-1))] <- balance.t3.nocal[[2]][[i]]$sdiff
  outputT3nocal$Matching[3+(5*(i-1))] <- balance.t3.nocal[[2]][[i]]$qqsummary.raw$meandiff
  outputT3nocal$Matching[4+(5*(i-1))] <- balance.t3.nocal[[2]][[i]]$var.ratio
  outputT3nocal$Matching[5+(5*(i-1))] <- balance.t3.nocal[[2]][[i]]$ks$ks$statistic
}
write.csv(outputT3nocal, "results/balance/outputT3nocal.csv")

outputT3cal <- data.frame(cbind(varname, metric))
for(i in 1:11){
  outputT3cal$FullSample[1+(5*(i-1))] <- balance.t3.cal[[1]][[i]]$mean.Tr -balance.t3.cal[[1]][[i]]$mean.Co
  outputT3cal$FullSample[2+(5*(i-1))] <- balance.t3.cal[[1]][[i]]$sdiff
  outputT3cal$FullSample[3+(5*(i-1))] <- balance.t3.cal[[1]][[i]]$qqsummary.raw$meandiff
  outputT3cal$FullSample[4+(5*(i-1))] <- balance.t3.cal[[1]][[i]]$var.ratio
  outputT3cal$FullSample[5+(5*(i-1))] <- balance.t3.cal[[1]][[i]]$ks$ks$statistic
  outputT3cal$Matching[1+(5*(i-1))] <- balance.t3.cal[[2]][[i]]$mean.Tr -balance.t3.cal[[2]][[i]]$mean.Co
  outputT3cal$Matching[2+(5*(i-1))] <- balance.t3.cal[[2]][[i]]$sdiff
  outputT3cal$Matching[3+(5*(i-1))] <- balance.t3.cal[[2]][[i]]$qqsummary.raw$meandiff
  outputT3cal$Matching[4+(5*(i-1))] <- balance.t3.cal[[2]][[i]]$var.ratio
  outputT3cal$Matching[5+(5*(i-1))] <- balance.t3.cal[[2]][[i]]$ks$ks$statistic
}
write.csv(outputT3cal, "results/balance/outputT3cal.csv")

outputT3cal50 <- data.frame(cbind(varname, metric))
for(i in 1:11){
  outputT3cal50$FullSample[1+(5*(i-1))] <- balance.t3.cal50[[1]][[i]]$mean.Tr -balance.t3.cal50[[1]][[i]]$mean.Co
  outputT3cal50$FullSample[2+(5*(i-1))] <- balance.t3.cal50[[1]][[i]]$sdiff
  outputT3cal50$FullSample[3+(5*(i-1))] <- balance.t3.cal50[[1]][[i]]$qqsummary.raw$meandiff
  outputT3cal50$FullSample[4+(5*(i-1))] <- balance.t3.cal50[[1]][[i]]$var.ratio
  outputT3cal50$FullSample[5+(5*(i-1))] <- balance.t3.cal50[[1]][[i]]$ks$ks$statistic
  outputT3cal50$Matching[1+(5*(i-1))] <- balance.t3.cal50[[2]][[i]]$mean.Tr -balance.t3.cal50[[2]][[i]]$mean.Co
  outputT3cal50$Matching[2+(5*(i-1))] <- balance.t3.cal50[[2]][[i]]$sdiff
  outputT3cal50$Matching[3+(5*(i-1))] <- balance.t3.cal50[[2]][[i]]$qqsummary.raw$meandiff
  outputT3cal50$Matching[4+(5*(i-1))] <- balance.t3.cal50[[2]][[i]]$var.ratio
  outputT3cal50$Matching[5+(5*(i-1))] <- balance.t3.cal50[[2]][[i]]$ks$ks$statistic
}
write.csv(outputT3cal50, "results/balance/outputT3cal50.csv")

outputT3cal25 <- data.frame(cbind(varname, metric))
for(i in 1:11){
  outputT3cal25$FullSample[1+(5*(i-1))] <- balance.t3.cal25[[1]][[i]]$mean.Tr -balance.t3.cal25[[1]][[i]]$mean.Co
  outputT3cal25$FullSample[2+(5*(i-1))] <- balance.t3.cal25[[1]][[i]]$sdiff
  outputT3cal25$FullSample[3+(5*(i-1))] <- balance.t3.cal25[[1]][[i]]$qqsummary.raw$meandiff
  outputT3cal25$FullSample[4+(5*(i-1))] <- balance.t3.cal25[[1]][[i]]$var.ratio
  outputT3cal25$FullSample[5+(5*(i-1))] <- balance.t3.cal25[[1]][[i]]$ks$ks$statistic
  outputT3cal25$Matching[1+(5*(i-1))] <- balance.t3.cal25[[2]][[i]]$mean.Tr -balance.t3.cal25[[2]][[i]]$mean.Co
  outputT3cal25$Matching[2+(5*(i-1))] <- balance.t3.cal25[[2]][[i]]$sdiff
  outputT3cal25$Matching[3+(5*(i-1))] <- balance.t3.cal25[[2]][[i]]$qqsummary.raw$meandiff
  outputT3cal25$Matching[4+(5*(i-1))] <- balance.t3.cal25[[2]][[i]]$var.ratio
  outputT3cal25$Matching[5+(5*(i-1))] <- balance.t3.cal25[[2]][[i]]$ks$ks$statistic
}
write.csv(outputT3cal25, "results/balance/outputT3cal25.csv")

outputT3calNPT <- data.frame(cbind(varname, metric))
for(i in 1:11){
  outputT3calNPT$FullSample[1+(5*(i-1))] <- balance.t3.cal.npt[[1]][[i]]$mean.Tr -balance.t3.cal.npt[[1]][[i]]$mean.Co
  outputT3calNPT$FullSample[2+(5*(i-1))] <- balance.t3.cal.npt[[1]][[i]]$sdiff
  outputT3calNPT$FullSample[3+(5*(i-1))] <- balance.t3.cal.npt[[1]][[i]]$qqsummary.raw$meandiff
  outputT3calNPT$FullSample[4+(5*(i-1))] <- balance.t3.cal.npt[[1]][[i]]$var.ratio
  outputT3calNPT$FullSample[5+(5*(i-1))] <- balance.t3.cal.npt[[1]][[i]]$ks$ks$statistic
  outputT3calNPT$Matching[1+(5*(i-1))] <- balance.t3.cal.npt[[2]][[i]]$mean.Tr -balance.t3.cal.npt[[2]][[i]]$mean.Co
  outputT3calNPT$Matching[2+(5*(i-1))] <- balance.t3.cal.npt[[2]][[i]]$sdiff
  outputT3calNPT$Matching[3+(5*(i-1))] <- balance.t3.cal.npt[[2]][[i]]$qqsummary.raw$meandiff
  outputT3calNPT$Matching[4+(5*(i-1))] <- balance.t3.cal.npt[[2]][[i]]$var.ratio
  outputT3calNPT$Matching[5+(5*(i-1))] <- balance.t3.cal.npt[[2]][[i]]$ks$ks$statistic
}
write.csv(outputT3calNPT, "results/balance/outputT3calNPT.csv")

outputT3trim <- data.frame(cbind(varname, metric))
for(i in 1:11){
  outputT3trim$FullSample[1+(5*(i-1))] <- balance.t3.trim[[1]][[i]]$mean.Tr -balance.t3.trim[[1]][[i]]$mean.Co
  outputT3trim$FullSample[2+(5*(i-1))] <- balance.t3.trim[[1]][[i]]$sdiff
  outputT3trim$FullSample[3+(5*(i-1))] <- balance.t3.trim[[1]][[i]]$qqsummary.raw$meandiff
  outputT3trim$FullSample[4+(5*(i-1))] <- balance.t3.trim[[1]][[i]]$var.ratio
  outputT3trim$FullSample[5+(5*(i-1))] <- balance.t3.trim[[1]][[i]]$ks$ks$statistic
  outputT3trim$Matching[1+(5*(i-1))] <- balance.t3.trim[[2]][[i]]$mean.Tr -balance.t3.cal.npt[[2]][[i]]$mean.Co
  outputT3trim$Matching[2+(5*(i-1))] <- balance.t3.trim[[2]][[i]]$sdiff
  outputT3trim$Matching[3+(5*(i-1))] <- balance.t3.trim[[2]][[i]]$qqsummary.raw$meandiff
  outputT3trim$Matching[4+(5*(i-1))] <- balance.t3.trim[[2]][[i]]$var.ratio
  outputT3trim$Matching[5+(5*(i-1))] <- balance.t3.trim[[2]][[i]]$ks$ks$statistic
}
write.csv(outputT3trim, "results/balance/outputT3trim.csv")










##########################################################
#####Treatment1 vs Gwinnett Control Group (Full Sample)
##########################################################
cgf.t1 <- subset(cgf, treatment==1 | treatment==5 | treatment==6)

#Outcome
y.t1f <- cgf.t1$junsep07
#treatment
Tr.t1f <- cgf.t1$treat1

## MAHA MATCHING BELOW
#########################
## FULL SAMPLE -> MATCHED **WITHOUT** CALIPERS
print("---treat1, matched, no caliper, FULL---")
matcht1f.nocal <- Match(Y=y.t1f, Tr=Tr.t1f, X=cgf.t1[cov.13], Weight=2, version="fast")
summary(matcht1f.nocal)
matched.t1f.nocal <- rbind(cgf.t1[matcht1f.nocal$index.treated,], cgf.t1[matcht1f.nocal$index.control,])
write.table(matched.t1f.nocal, "data/matching/11042016_maha_match_nocal_t1.csv", sep=";",col.names=NA, row.names=TRUE)
balance.t1.nocal <- MatchBalance(Tr.t1f ~ as.matrix(cgf.t1[cov.1a]), nboots=bs, match.out=matcht1f.nocal)


#########################
## FULL SAMPLE -> MATCHED **WITH** CALIPERS = 1 SD
print("---treat3, matched, caliper=1SD, FULL---")
matcht1f.cal <- Match(Y=y.t1f, Tr=Tr.t1f, X=cgf.t1[cov.13], Weight=2, version="fast", caliper = TRUE)
summary(matcht1f.cal)
matched.t1f.cal <- rbind(cgf.t1[matcht1f.cal$index.treated,], cgf.t1[matcht1f.cal$index.control,])
write.table(matched.t1f.cal, "data/matching/11042016_maha_match_cal_t1.csv", sep=";",col.names=NA, row.names=TRUE)
balance.t1.cal <- MatchBalance(Tr.t1f ~ as.matrix(cgf.t1[cov.1a]), nboots=bs, match.out=matcht1f.cal)

## FULL SAMPLE -> MATCHED **WITH** CALIPERS = 0.5 SD
print("---treat3, matched, caliper=0.5SD, FULL---")
matcht1f.cal50 <- Match(Y=y.t1f, Tr=Tr.t1f, X=cgf.t1[cov.13], Weight=2, version="fast", caliper = 0.5)
summary(matcht1f.cal50)
matched.t1f.cal50 <- rbind(cgf.t1[matcht1f.cal50$index.treated,], cgf.t1[matcht1f.cal50$index.control,])
write.table(matched.t1f.cal50, "data/matching/11042016_maha_match_cal50_t1.csv", sep=";",col.names=NA, row.names=TRUE)
balance.t1.cal50 <- MatchBalance(Tr.t1f ~ as.matrix(cgf.t1[cov.1a]), nboots=bs, match.out=matcht1f.cal50)

## FULL SAMPLE -> MATCHED **WITH** CALIPERS = 0.25 SD
print("---treat3, matched, caliper=0.25SD, FULL---")
matcht1f.cal25 <- Match(Y=y.t1f, Tr=Tr.t1f, X=cgf.t1[cov.13], Weight=2, version="fast", caliper = 0.25)
summary(matcht1f.cal25)
matched.t1f.cal25 <- rbind(cgf.t1[matcht1f.cal25$index.treated,], cgf.t1[matcht1f.cal25$index.control,])
write.table(matched.t1f.cal25, "data/matching/11042016_maha_match_cal25_t1.csv", sep=";",col.names=NA, row.names=TRUE)
balance.t1.cal25 <- MatchBalance(Tr.t1f ~ as.matrix(cgf.t1[cov.1a]), nboots=bs, match.out=matcht1f.cal25)

## FULL SAMPLE -> MATCHED **WITH** CALIPERS = 1 SD, NO PRETREATMENT WATER USE
print("---treat3, matched, caliper=1SD, NPT, FULL---")
matcht1f.cal.npt <- Match(Y=y.t1f, Tr=Tr.t1f, X=cgf.t1[cov.12], Weight=2, version="fast", caliper = TRUE)
summary(matcht1f.cal.npt)
matched.t1f.cal.npt <- rbind(cgf.t1[matcht1f.cal.npt$index.treated,], cgf.t1[matcht1f.cal.npt$index.control,])
write.table(matched.t1f.cal.npt, "data/matching/11042016_maha_match_calnpt_t1.csv", sep=";",col.names=NA, row.names=TRUE)
balance.t1.cal.npt <- MatchBalance(Tr.t1f ~ as.matrix(cgf.t1[cov.1a]), nboots=bs, match.out=matcht1f.cal.npt)


#########################
## TRIMMED SAMPLE BALANCE TEST
print("---treat1, trimmed sample, FULL---")
cgf.t1 <- subset(cgf, treatment==1 | treatment==5 | treatment==6)
cgf.t1trim <- subset(cgf.t1, p1_trim==1)
#Outcome
y.t1trim <- cgf.t1trim$junsep07
#treatment
Tr.t1trim <- cgf.t1trim$treat1
balance.t1.trim <- MatchBalance(Tr.t1trim ~ as.matrix(cgf.t1trim[cov.13]), ks=TRUE, nboots=1000)




### EXPORT t1 RESULTS

varname <- rep("junsep07", 40)
varname[6:10] <- rep("mayoct06", 5)
varname[11:15] <- rep("marapr07", 5)
varname[16:20] <- rep("fairmktvalue", 5)
varname[21:25] <- rep("ageofhome", 5)
varname[26:30] <- rep("acres", 5)
varname[31:35] <- rep("pct_edu", 5)
varname[36:40] <- rep("pct_pov", 5)
varname[41:45] <- rep("percapincome", 5)
varname[46:50] <- rep("pct_rent", 5)
varname[51:55] <- rep("pct_white", 5)


metric <- rep(c("Mean Difference", "Standardized Mean Difference", "Mean Raw eQQ Difference", 
                "Variance Ratio (Treat/Comp.)", "Kolmogrov-Smirnov Statistic"), 11)

outputT1nocal <- data.frame(cbind(varname, metric))
for(i in 1:11){
  outputT1nocal$FullSample[1+(5*(i-1))] <- balance.t1.nocal[[1]][[i]]$mean.Tr -balance.t1.nocal[[1]][[i]]$mean.Co
  outputT1nocal$FullSample[2+(5*(i-1))] <- balance.t1.nocal[[1]][[i]]$sdiff
  outputT1nocal$FullSample[3+(5*(i-1))] <- balance.t1.nocal[[1]][[i]]$qqsummary.raw$meandiff
  outputT1nocal$FullSample[4+(5*(i-1))] <- balance.t1.nocal[[1]][[i]]$var.ratio
  outputT1nocal$FullSample[5+(5*(i-1))] <- balance.t1.nocal[[1]][[i]]$ks$ks$statistic
  outputT1nocal$Matching[1+(5*(i-1))] <- balance.t1.nocal[[2]][[i]]$mean.Tr -balance.t1.nocal[[2]][[i]]$mean.Co
  outputT1nocal$Matching[2+(5*(i-1))] <- balance.t1.nocal[[2]][[i]]$sdiff
  outputT1nocal$Matching[3+(5*(i-1))] <- balance.t1.nocal[[2]][[i]]$qqsummary.raw$meandiff
  outputT1nocal$Matching[4+(5*(i-1))] <- balance.t1.nocal[[2]][[i]]$var.ratio
  outputT1nocal$Matching[5+(5*(i-1))] <- balance.t1.nocal[[2]][[i]]$ks$ks$statistic
}
write.csv(outputT1nocal, "results/balance/outputT1nocal.csv")

outputT1cal <- data.frame(cbind(varname, metric))
for(i in 1:11){
  outputT1cal$FullSample[1+(5*(i-1))] <- balance.t1.cal[[1]][[i]]$mean.Tr -balance.t1.cal[[1]][[i]]$mean.Co
  outputT1cal$FullSample[2+(5*(i-1))] <- balance.t1.cal[[1]][[i]]$sdiff
  outputT1cal$FullSample[3+(5*(i-1))] <- balance.t1.cal[[1]][[i]]$qqsummary.raw$meandiff
  outputT1cal$FullSample[4+(5*(i-1))] <- balance.t1.cal[[1]][[i]]$var.ratio
  outputT1cal$FullSample[5+(5*(i-1))] <- balance.t1.cal[[1]][[i]]$ks$ks$statistic
  outputT1cal$Matching[1+(5*(i-1))] <- balance.t1.cal[[2]][[i]]$mean.Tr -balance.t1.cal[[2]][[i]]$mean.Co
  outputT1cal$Matching[2+(5*(i-1))] <- balance.t1.cal[[2]][[i]]$sdiff
  outputT1cal$Matching[3+(5*(i-1))] <- balance.t1.cal[[2]][[i]]$qqsummary.raw$meandiff
  outputT1cal$Matching[4+(5*(i-1))] <- balance.t1.cal[[2]][[i]]$var.ratio
  outputT1cal$Matching[5+(5*(i-1))] <- balance.t1.cal[[2]][[i]]$ks$ks$statistic
}
write.csv(outputT1cal, "results/balance/outputT1cal.csv")

outputT1cal50 <- data.frame(cbind(varname, metric))
for(i in 1:11){
  outputT1cal50$FullSample[1+(5*(i-1))] <- balance.t1.cal50[[1]][[i]]$mean.Tr -balance.t1.cal50[[1]][[i]]$mean.Co
  outputT1cal50$FullSample[2+(5*(i-1))] <- balance.t1.cal50[[1]][[i]]$sdiff
  outputT1cal50$FullSample[3+(5*(i-1))] <- balance.t1.cal50[[1]][[i]]$qqsummary.raw$meandiff
  outputT1cal50$FullSample[4+(5*(i-1))] <- balance.t1.cal50[[1]][[i]]$var.ratio
  outputT1cal50$FullSample[5+(5*(i-1))] <- balance.t1.cal50[[1]][[i]]$ks$ks$statistic
  outputT1cal50$Matching[1+(5*(i-1))] <- balance.t1.cal50[[2]][[i]]$mean.Tr -balance.t1.cal50[[2]][[i]]$mean.Co
  outputT1cal50$Matching[2+(5*(i-1))] <- balance.t1.cal50[[2]][[i]]$sdiff
  outputT1cal50$Matching[3+(5*(i-1))] <- balance.t1.cal50[[2]][[i]]$qqsummary.raw$meandiff
  outputT1cal50$Matching[4+(5*(i-1))] <- balance.t1.cal50[[2]][[i]]$var.ratio
  outputT1cal50$Matching[5+(5*(i-1))] <- balance.t1.cal50[[2]][[i]]$ks$ks$statistic
}
write.csv(outputT1cal50, "results/balance/outputT1cal50.csv")

outputT1cal25 <- data.frame(cbind(varname, metric))
for(i in 1:11){
  outputT1cal25$FullSample[1+(5*(i-1))] <- balance.t1.cal25[[1]][[i]]$mean.Tr -balance.t1.cal25[[1]][[i]]$mean.Co
  outputT1cal25$FullSample[2+(5*(i-1))] <- balance.t1.cal25[[1]][[i]]$sdiff
  outputT1cal25$FullSample[3+(5*(i-1))] <- balance.t1.cal25[[1]][[i]]$qqsummary.raw$meandiff
  outputT1cal25$FullSample[4+(5*(i-1))] <- balance.t1.cal25[[1]][[i]]$var.ratio
  outputT1cal25$FullSample[5+(5*(i-1))] <- balance.t1.cal25[[1]][[i]]$ks$ks$statistic
  outputT1cal25$Matching[1+(5*(i-1))] <- balance.t1.cal25[[2]][[i]]$mean.Tr -balance.t1.cal25[[2]][[i]]$mean.Co
  outputT1cal25$Matching[2+(5*(i-1))] <- balance.t1.cal25[[2]][[i]]$sdiff
  outputT1cal25$Matching[3+(5*(i-1))] <- balance.t1.cal25[[2]][[i]]$qqsummary.raw$meandiff
  outputT1cal25$Matching[4+(5*(i-1))] <- balance.t1.cal25[[2]][[i]]$var.ratio
  outputT1cal25$Matching[5+(5*(i-1))] <- balance.t1.cal25[[2]][[i]]$ks$ks$statistic
}
write.csv(outputT1cal25, "results/balance/outputT1cal25.csv")

outputT1calNPT <- data.frame(cbind(varname, metric))
for(i in 1:11){
  outputT1calNPT$FullSample[1+(5*(i-1))] <- balance.t1.cal.npt[[1]][[i]]$mean.Tr -balance.t1.cal.npt[[1]][[i]]$mean.Co
  outputT1calNPT$FullSample[2+(5*(i-1))] <- balance.t1.cal.npt[[1]][[i]]$sdiff
  outputT1calNPT$FullSample[3+(5*(i-1))] <- balance.t1.cal.npt[[1]][[i]]$qqsummary.raw$meandiff
  outputT1calNPT$FullSample[4+(5*(i-1))] <- balance.t1.cal.npt[[1]][[i]]$var.ratio
  outputT1calNPT$FullSample[5+(5*(i-1))] <- balance.t1.cal.npt[[1]][[i]]$ks$ks$statistic
  outputT1calNPT$Matching[1+(5*(i-1))] <- balance.t1.cal.npt[[2]][[i]]$mean.Tr -balance.t1.cal.npt[[2]][[i]]$mean.Co
  outputT1calNPT$Matching[2+(5*(i-1))] <- balance.t1.cal.npt[[2]][[i]]$sdiff
  outputT1calNPT$Matching[3+(5*(i-1))] <- balance.t1.cal.npt[[2]][[i]]$qqsummary.raw$meandiff
  outputT1calNPT$Matching[4+(5*(i-1))] <- balance.t1.cal.npt[[2]][[i]]$var.ratio
  outputT1calNPT$Matching[5+(5*(i-1))] <- balance.t1.cal.npt[[2]][[i]]$ks$ks$statistic
}
write.csv(outputT1calNPT, "results/balance/outputT1calNPT.csv")

outputT1trim <- data.frame(cbind(varname, metric))
for(i in 1:11){
  outputT1trim$FullSample[1+(5*(i-1))] <- balance.t1.trim[[1]][[i]]$mean.Tr -balance.t1.trim[[1]][[i]]$mean.Co
  outputT1trim$FullSample[2+(5*(i-1))] <- balance.t1.trim[[1]][[i]]$sdiff
  outputT1trim$FullSample[3+(5*(i-1))] <- balance.t1.trim[[1]][[i]]$qqsummary.raw$meandiff
  outputT1trim$FullSample[4+(5*(i-1))] <- balance.t1.trim[[1]][[i]]$var.ratio
  outputT1trim$FullSample[5+(5*(i-1))] <- balance.t1.trim[[1]][[i]]$ks$ks$statistic
  outputT1trim$Matching[1+(5*(i-1))] <- balance.t1.trim[[2]][[i]]$mean.Tr -balance.t1.cal.npt[[2]][[i]]$mean.Co
  outputT1trim$Matching[2+(5*(i-1))] <- balance.t1.trim[[2]][[i]]$sdiff
  outputT1trim$Matching[3+(5*(i-1))] <- balance.t1.trim[[2]][[i]]$qqsummary.raw$meandiff
  outputT1trim$Matching[4+(5*(i-1))] <- balance.t1.trim[[2]][[i]]$var.ratio
  outputT1trim$Matching[5+(5*(i-1))] <- balance.t1.trim[[2]][[i]]$ks$ks$statistic
}
write.csv(outputT1trim, "results/balance/outputT1trim.csv")






sink()
