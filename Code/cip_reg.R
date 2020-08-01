# Code derived from below.  Updated to perform CIP deviation regressions.
################################################################################
# Project: The Real Exchange Rate, Real Interest Rates, and the Risk Premium   #
# Program: for Table 2 -- Fama Regressions                                     #
# Dataset: dat73_1                                                             #
# Date: 02.14.2011                                                             #
# Author: Mian Zhu  <mian.zhu@gmail.com> 
# Updated: Kyle B. Lackinger
# Date: 07.28.2020
################################################################################

rm(list=ls())     # clear workspace

library(sandwich) # import package
library(vars)
library(plyr)

#######
#Need to read in the updated dataset and append the new data after row 440
GBP=read.csv("GBP_F.csv",header= TRUE)
NLG=read.csv("NLG_F.csv",header= TRUE)
SEK=read.csv("SEK_F.csv",header= TRUE)
ZAR=read.csv("ZAR_F.csv",header= TRUE)
NOK=read.csv("NOK_F.csv",header= TRUE)
NZD=read.csv("NZD_F.csv",header= TRUE)
CAD=read.csv("CAD_F.csv",header= TRUE)
FRF=read.csv("FRF_F.csv",header= TRUE)
BEF=read.csv("BEF_F.csv",header= TRUE)
HKD=read.csv("HKD_F.csv",header= TRUE)
ESP=read.csv("ESP_F.csv",header= TRUE)
CHF=read.csv("CHF_F.csv",header= TRUE)
ITL=read.csv("ITL_F.csv",header= TRUE)
DKK=read.csv("DKK_F.csv",header= TRUE)
DEU=read.csv("DEU_F.csv",header= TRUE)
AUD=read.csv("AUD_F.csv",header= TRUE)
JPY=read.csv("JPY_F.csv",header= TRUE)


mylist<-c("GBP","NLG","SEK","ZAR","NOK","NZD","CAD","FRF","BEF","HKD","ESP","CHF","ITL","DKK","DEU","AUD","JPY") 
fama.result<-matrix(0,17,6)
for (cno in 1:17){
      init_date<-c(2000,2)
      #start_date <- init_date+c(8,5)
      start_date <- init_date
      end_date<-c(2017,3)
      #end_date<-c(2008,6)
      country<-mylist[cno]
      Cdat<-data.frame(window(ts(get(country),start=init_date,freq=12),start=start_date, end=end_date))
      attach(Cdat)
      s<-log(get(paste("S",country,sep=".")))
      f<-log(get(paste("F",country,sep=".")))
      istar<-get(paste("i",country,sep="."))
      i<-100*(-(1+i.USD/100)^(1/12)+(1+istar/100)^(1/12))
      ni<-i[-length(i)]
      cip <- (100*(1/3)*(f-s))+i
      reg.fama<-lm(cip~i)  # Fama regression
      detach(Cdat)
      reg.fama.nw<-matrix(coeftest(reg.fama,df=Inf,vcov=kernHAC(reg.fama,prewhite=F,bw=6,kernel="Bartlett")),2,4) # Calculate Newey-West standard errors
      coef0<-reg.fama.nw[1,1]
      std0<-reg.fama.nw[1,2]
      cf0<-c(-1.645*std0+coef0,1.645*std0+coef0)
      coef1<-reg.fama.nw[2,1]
      std1<-reg.fama.nw[2,2]
      cf1<-c(-1.645*std1+coef1,1.645*std1+coef1)
      fama.result[cno,]<-c(coef0,cf0,coef1,cf1)
}

# Output

write.csv(fama.result,"Table1.cip.full.csv")
