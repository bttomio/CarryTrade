# Drived From Below:
################################################################################
# Project: The Real Exchange Rate, Real Interest Rates, and the Risk Premium   #
# Program: for Table 2 -- Fama Regressions                                     #
# Dataset: dat73_1                                                             #
# Date: 02.14.2011                                                             #
# Author: Mian Zhu  <mian.zhu@gmail.com> 
# Updated: Kyle B. Lackinger
# Date: 07.27.2020
################################################################################

rm(list=ls())     # clear workspace

library(sandwich) # import package
library(vars)
library(plyr)

#######
#Need to read in the updated dataset and append the new data after row 440
GBP=read.csv("GBP.csv",header= TRUE)
TTD=read.csv("TTD.csv",header= TRUE)
SEK=read.csv("SEK.csv",header= TRUE)
ZAR=read.csv("ZAR.csv",header= TRUE)
SLL=read.csv("SLL.csv",header= TRUE)
NZD=read.csv("NZD.csv",header= TRUE)
CAD=read.csv("CAD.csv",header= TRUE)
FRF=read.csv("FRF.csv",header= TRUE)
BEF=read.csv("BEF.csv",header= TRUE)
HKD=read.csv("HKD.csv",header= TRUE)
ESP=read.csv("ESP.csv",header= TRUE)
HUF=read.csv("HUF.csv",header= TRUE)
MXN=read.csv("MXN.csv",header= TRUE)
GYD=read.csv("GYD.csv",header= TRUE)
SZL=read.csv("SZL.csv",header= TRUE)
BBD=read.csv("BBD.csv",header= TRUE)
KES=read.csv("KES.csv",header= TRUE)
LBP=read.csv("LBP.csv",header= TRUE)
MWK=read.csv("MWK.csv",header= TRUE)
JPY=read.csv("JPY.csv",header= TRUE)
NPR=read.csv("NPR.csv",header= TRUE)
ILS=read.csv("ILS.csv",header= TRUE)
NAD=read.csv("NAD.csv",header= TRUE)
LKR=read.csv("LKR.csv",header= TRUE)
CVE=read.csv("CVE.csv",header= TRUE)

mylist<-c("GBP","TTD","SEK","ZAR","SLL","NZD","CAD","FRF","BEF","HKD","ESP","HUF","MXN","GYD","SZL","BBD","KES","LBP","MWK","JPY","NPR","ILS","NAD","LKR","CVE") 
fama.result<-matrix(0,25,6)
for (cno in 1:25){
      init_date<-c(1998,1)
      start_date <- init_date + c(10,6)
      end_date<-c(2017,3) 
      country<-mylist[cno]
      Cdat<-data.frame(window(ts(get(country),start=init_date,freq=12),start=start_date, end=end_date))
      attach(Cdat)
      s<-log(get(paste("S",country,sep=".")))
      istar<-get(paste("i",country,sep="."))
      i<-100*(-(1+i.USD/100)^(1/12)+(1+istar/100)^(1/12))
      ni<-i[-length(i)]
      ex <- diff(100*s)+ni
      reg.fama<-lm(ex~ni)  # Fama regression
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

#write.csv(fama.result,"Table1.postZ.csv")
