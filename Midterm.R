setwd("D:/Lucy Liu/NUS/Master-term 1/courses/5209 econometrics/Midterm")
#dat = read.csv("A0166273B.csv",sep="",header=F)
dat = read.csv("A0165971U.csv",sep="",header=F)

#1
library(tseries)
dailysales=dat[,2]
dailysales=ts(dailysales)
plot(dailysales)
#2
acf(dailysales)
adf.test(dailysales)
kpss.test(dailysales)
#3
library(forecast)
auto.arima(dailysales,max.P=0,max.Q=0,ic="aic")
fit1 = arima(dailysales,order=c(1,1,0))
plot(residuals(fit1))
acf(residuals(fit1))
Box.test(residuals(fit1), lag = 10, type="Ljung")

resid2 = residuals(fit1)^2
acf(resid2)
Box.test(resid2, lag = 10, type="Ljung")

#4         
par(mfrow=c(1,1))
qqnorm(dailysales,datax=T,main="Normal QQ Plot")
qqline(dailysales,datax=T)

library(fGarch)
difSales=diff(dailysales)
auto.arima(difSales,max.P=0,max.Q=0,ic="aic")
fit2=arima(difSales,order=c(1,0,0))
par(mfrow=c(1,2))
acf(residuals(fit2))
pacf(residuals(fit2))
par(mfrow=c(1,2))
acf(residuals(fit2)^2)
pacf(residuals(fit2)^2)

garchFit1 = garchFit(formula= ~arma(1,0) + garch(1,2),difSales)
summary(garchFit1)

garchFit2 = garchFit(formula= ~arma(1,1) + garch(1,0),difSales)
summary(garchFit2)

garchFit3 = garchFit(formula= ~arma(1,1) + garch(1,1),difSales)
summary(garchFit3)

#5
res1 = residuals(garchFit1)
res_std1 = res1 / garchFit1@sigma.t
par(mfrow=c(2,3))
plot(res1)
acf(res1)
acf(res1^2)
plot(res_std1)
acf(res_std1)
acf(res_std1^2)
###########################
res2 = residuals(garchFit2)
res_std2 = res2 / garchFit2@sigma.t
par(mfrow=c(2,3))
plot(res2)
acf(res2)
acf(res2^2)
plot(res_std2)
acf(res_std2)
acf(res_std2^2)
#########################
res3 = residuals(garchFit3)
res_std3 = res3 / garchFit3@sigma.t
par(mfrow=c(2,3))
plot(res3)
acf(res3)
acf(res3^2)
plot(res_std3)
acf(res_std3)
acf(res_std3^2)  #第三个最好
#########################
##########以上为第一题
########################
#6
profits=dat[,3]
profits=ts(profits)
par(mfrow=c(1,1))
plot(profits)

acf(profits)
adf.test(profits)
kpss.test(profits)
#7
library(forecast)
auto.arima(profits,max.P=0,max.Q=0,ic="aic")
fitP1 = arima(profits,order=c(1,0,1))
summary((fitP1))
plot(residuals(fitP1))
acf(residuals(fitP1))
Box.test(residuals(fitP1), lag = 10, type="Ljung")

resid1P2 = residuals(fitP1)^2
acf(resid1P2)
Box.test(resid1P2, lag = 10, type="Ljung")
#8
library(fGarch)
garchFitP1 = garchFit(formula= ~arma(1,1) + garch(2,0),profits)
summary(garchFitP1)

garchFitP2 = garchFit(formula= ~arma(1,1) + garch(1,2),profits)
summary(garchFitP2)

garchFitP3 = garchFit(formula= ~arma(1,1) + garch(1,0),profits)
summary(garchFitP3)

resP1 = residuals(garchFitP1)
res_stdP1 = resP1 / garchFitP1@sigma.t
par(mfrow=c(2,3))
plot(resP1)
acf(resP1)
acf(resP1^2)
plot(res_stdP1)
acf(res_stdP1)
acf(res_stdP1^2)
###################################
resP2 = residuals(garchFitP2)
res_stdP2 = resP2 / garchFitP2@sigma.t
par(mfrow=c(2,3))
plot(resP2)
acf(resP2)
acf(resP2^2)
plot(res_stdP2)
acf(res_stdP2)
acf(res_stdP2^2)
#######################################
resP3 = residuals(garchFitP3)
res_stdP3 = resP3 / garchFitP3@sigma.t
par(mfrow=c(2,3))
plot(resP3)
acf(resP3)
acf(resP3^2)
plot(res_stdP3)
acf(res_stdP3)
acf(res_stdP3^2)  #第二个最好

#9代码同上
#10
forecasts = predict(garchFitP2,1)
forecasts2 = predict(garchFitP2,2)
pred=forecasts$meanForecast
itv=c(pred-1.96*forecasts$standardDeviation,pred+1.96*forecasts$standardDeviation)
pred2=as.matrix(forecasts2$meanForecast)
itv2_1=c(pred2[1]-1.96*forecasts2$standardDeviation[1],pred2[1]+1.96*forecasts2$standardDeviation[1])
itv2_2=c(pred2[2]-1.96*forecasts2$standardDeviation[2],pred2[2]+1.96*forecasts2$standardDeviation[2])


