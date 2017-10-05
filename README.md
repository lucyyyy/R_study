# R_study

## 非系统tips（from 153min）
### 基础知识
1. 使用tab自动补全，使用两次返回所有可能的补全命令列表
2. 清除变量： 单个用rm(), 清除内存中所有变量 `rm(list=ls(all=TRUE))`
3. 更改小数点后位数： options(digits= )  默认为7
4. 调用系统内程序： system() 或 shell.exec()
```
# go to the cran
system (paste(’”C:/Program Files/Internet Explorer/iexplore.exe”’,’cran.r-project.org’),wait = FALSE)
# invoke the notepad
system(”notepad”)
shell.exec( ”C:/WINDOWS/clock”)
```
5. 工作目录： getwd()  setwd()
6. 保存： save.image()  save(...,file=)
7. 如何得到加载package的列表： search()函数返回当前加载的包的情况，然后使用 `.packages(all.available=TRUE)`获得本地安装的包列表
8. 数据类型： character, numeric integer logical complex list factor
9. data frame 数据框： 可以理解成一个松散的数据集，可以由不同类型的列组成的类矩阵（matrix-like）
10. lm中公式的符号含义： y~model  model中的变量由+连接  由:表示变量间的交互作用  由/* 表示a+b+a:b (a+b+c)^2 表示主因素a,b,c和各个因素的交互作用。-表示去掉之意， (a+b+c)^2-a:b表示a+b+c+b:c+a:c
### 输入输出
11. 读入数据： 可以用 foreign等包读入其他软件的数据； 不建议直接读取excel数据，读的话用RODBC包的odbcConnectExcel()函数或者xlsReadWrite包的read.xls函数； 最建议用 read.csv()函数读取csv
12. 转换数据类型： f是因子，转成数字  `as.numeric(as.character(f))` 或 `as.numeric(levels(f))[as.integer(f)]` 这个点一定要小心，因为对于顺序型factor 数据，如果强制转化为数值型，会返回的是factor的顺序信息，而非你看到的character 信息。
13. 使用双反斜杠\\或单斜杠/表示文件路径
### 数据处理
14. 删除缺失值： NA是一个逻辑值（就是和TRUE FALSE一类），所以要用 is.na()来判断缺失值。删除缺失值使用`x[!is.na(x)]`
15. 向一个向量添加元素： append (x, values, after = length(x)) 
```
x<-1:5
foo<-c(x[1],0,x[2:5])
append(x,0,after=1) #same effect: 1 0 2 3 4 5 
```
16. 移除某行/列数据：
```
x<-data.frame(matrix(1:30,nrow=5,byrow=T))
dim(x)
print(x)
new.x1<-x[-c(1,4),]
new.x2<-x[,-c[2,3]]
new.x1;new.x2
```
17. 去掉数据框中相同的行：unique函数
```
x<-c(9:20,1:5,3:7,0:8)
unique(x) #不改变x
```
18. 对矩阵按行/列作计算： apply函数
```
vec=1:20
mat=matrix(vec,ncol=4)
vec
cumsum(vec)
mat
apply(mat,2,cumsum)
apply(mat,1,cumsum)
```
19. 判断数据框的列是否是数字？ sapply函数，有循环之意 `sapply(dataframe,is.numeric)`
20. 根据共有的列将两个数据框合并： `merge(x,y,by.x=,by.y=,all=)`
### 数学运算
21. 如何得到一个列向量？ t()函数 
```
x<-1:10
t(x)  #把向量转成矩阵
t(t(x))  #把矩阵转置
```
行向量、列向量会有比较模糊的地方： `x%*%x`计算的是xTx，可以用crossprod()函数更清晰地表示 `XT.y<-crossprod(X,y)`
22. 生成对角矩阵：对一个向量使用diag()函数可以得到对角线元素为向量的对角矩阵；对整数Z使用此函数得到Z维的单位矩阵
23. 求立方根： ^不但是运算符号，还可以看做是函数 `"^"(x,1/3)`
24. 求导： D()  
```
f1<-expression(sin(x)*x)
f2<-expression(x^2*y+y^2)
D(f,"x")
```
25. 如何模拟高斯（正态）分布数据？ rnorm(n,mean,sd) 
### 字符操作
26. R对大小写是敏感的
27. R 运行结果输出到文件中时，文件名中可以用变量代替：
```
for (var in letters[1:6]){
x<-var
write.table(x,paste("Foo_",var,".txt",sep=""))
}
```
### 日期时间
28. 日期可以做算术运算吗？   可以。一般使用as.Date() as.POSIXct()函数将读取的日期（字符串）转换为Date类型数据， Date类型数据可以进行算术运算
```
d1<-c("06/29/07");d2<-c("07/02/07")
D1<-as.Date(d1,"%m/%d/%y")
D2<-as.Date(d2,"%m/%d/%y")
D1+2;D1-D2
difftime(D1,D2,units="days")
```
### 绘图相关
29. 在同一画面画出多张图：三种解决方案
- 修改绘图参数，如par(mfrow=c(2,2))或 par(mfcol=c(2,2))
- 更为强大功能的layout函数，可以设置图形绘制顺序和图形大小
- split.screen()函数
30. 绘图功能十分强大，设置边缘大小，在已有图形上加水平线，做双坐标，标题换行，设置颜色等等，用的时候尽情查……
### 统计模型
31. 直接计算峰度和偏度的函数：  FBasics包中的 skewness()和kurtosis()
32. 线性回归： `lm.swiss<-lm(Fertility ~ . ,data=swiss)` lm()的结果是一个包含回归信息的列表，包含coefficients, residuals,fitted.valus等
summary()和anova()分别返回回归模型的概要信息和方差分析表  如果去掉常数项，就加0
33. 如何得到一个正态总体均值\miu 的区间估计？  t.test()函数
```
x<-rnorm(100)
t.test(x)
```
34. 回归模型参数的置信区间  confint函数
35. D-W检验  car包中的durbin.waston函数，lmtest包中的dwtest函数
36. 时间序列相关模型  arima(x,order=c(0,0,0),seasonal=list(order=c(0,0,0))
37. 强大：聚类分析，主成分分析，因子分析，logistic回归……
### 其他
38. 如何加速R的运行速度？ 针对不同的目标会有不同的解决方案，这里介绍一种：parallel包
```
library(parallel)
doit<-function(x)(x)^2+2*x
system.time(res<-laaply(1:5000000,doit))
rm(res)
gc()
cl<-makeCluster(getOption("cl.cores",3))
system.time(res<-parLapply(cl,1:5000000,doit))
stopCluster(cl)
```
39. 计算函数运行使用时间： proc.time()可以获得R进程存在的时间，system.time()通过调用两次proc.time()来计算函数运行的时间。一般来说，秒级以上的可以使用system.time()函数，但更短的则需要使用两次Sys.time()来精确显示程序所花的时间了
40. 如何释放R运行后占用的内存？  gc()

## R-导论中文版笔记
### 第一章 绪论
- 键盘的上下键可以使光标在命令的历史记录中前翻或后退
### 第二章 简单的算术操作和向量运算
- R中最简单的机构是一串有序数值构成的数值向量（vector）,单个的数值也被看作长度为1的向量
- 索引向量中，要善于运用名字索引，在数据框操作中优势很明显
- 除了向量之外，其他类型的对象：矩阵（数组），因子，列表，数据框，函数
### 第三章 对象及它们的模式和属性
### 第四章 有序因子和无序因子
### 第五章 数组和矩阵
- 向量只有在定义了dim属性后才能作为数组在R中使用； `dim(z)<-c(3,5,100)`使得该向量成一个3x5x100的数组
- 索引数组*【这个好棒啊，必须要马一下……可以用来做python那个任务】*
```
> x <- array(1:20, dim=c(4,5)) # 产生一个4 × 5 的数组。
> x
[,1] [,2] [,3] [,4] [,5]
[1,] 1 5 9 13 17
[2,] 2 6 10 14 18
[3,] 3 7 11 15 19
[4,] 4 8 12 16 20
> i <- array(c(1:3,3:1), dim=c(3,2))
> i # i 是一个3 × 2 的索引矩阵。
[,1] [,2]
[1,] 1 3
[2,] 2 2
[3,] 3 1
> x[i] # 提取这些元素。
[1] 9 6 3
> x[i] <- 0 # 用0替换这些元素。
> x
[,1] [,2] [,3] [,4] [,5]
[1,] 1 5 0 13 17
[2,] 2 0 10 14 18
[3,] 0 7 11 15 19
[4,] 4 8 12 16 20
>
```
- 用cbind()和rbind()构建分块矩阵： c横向r纵向合并
### 第六章 列表和数据框
- 列表是一个以对象的有序集合构成的对象，其中的分量可以是不同模式或类型，访问是`Lst[[1]]访问第一个分量，如果第一个是个数组，Lst[[4]][1]就是数组第一个元素`,同样也是命名使之更方便
### 第七章 从文件中读取数据
- 强烈建议整个数据框用函数 read.table()读入
- 用edit调用数据框和矩阵时，R会产生一个电子表形式的编辑环境 `xnew<-edit(xold)`
### 第八章 概率分布
### 第九章 成组，循环和条件控制
- 控制语句
```
if (expr1) expr2 else expr3  #也支持短路操作符
for (name in expr_1) expr_2  #R中最好不用这种显式循环，效率极低，可以用apply,lapply等函数代替
repeat expr
while (condition) expr #关键字 break 和 next适用
```
### 第十章 编写函数
- 允许用户创建自己的函数 `name<-function(arg_1,arg_2,...) expression`
### 第十一章 R中的统计模型
### 第十二章 图形工具
### 第十三章 包
- 用library()载入某个特别的包
- 命名空间 base::t

### 附录1 一个演示会话
已经把书上例子写成一个Rscript了，路径：‪D:\PRGS\R\examIntro.R 
这里也贴一份:)
```
help.start()

x<-rnorm(50)
y<-rnorm(x)    #产生两个伪正态随机数向量x 和y。
plot(x,y)     #画二维散点图。一个图形窗口会自动出现。
ls()          #查看当前工作空间里面的R 对象。
rm(x,y)       #去掉不再需要的对象。(清空)。

x<-1:20             #等价于x = (1; 2; : : : ; 20)。
w<-1+sqrt(x)/2      #标准差的`权重'向量。
dummy<-data.frame(x=x,y=x+rnorm(x)*w)
dummy                  #创建一个由x 和y构成的双列数据框，查看它们。
fm<-lm(y~x,data=dummy)
summary(fm)             #拟合y 对x 的简单线性回归，查看分析结果。
fm1<-lm(y~x,data=dummy,weight=1/w^2)
summary(fm1)            #现在我们已经知道标准差，做一个加权回归。

attach(dummy)        #让数据框中的列项可以像一般的变量那样使用。
lrf<-lowess(x,y)     #做一个非参局部回归。
plot(x,y)            #标准散点图。
lines(x,lrf$y)       #增加局部回归曲线。
abline(0,1,lty=3)    #真正的回归曲线：(截距0，斜率1)。
abline(coef(fm))     #无权重回归曲线。
abline(coef(fm1),col="red")    #加权回归曲线。
detach()                  #将数据框从搜索路径中去除。

plot(fitted(fm),resid(fm),
     xlab="Fitted values",
     ylab = "Residuals",
     main="Residuals vs Fitted")    #一个检验异方差性（heteroscedasticity）的标准回归诊断图。

qqnorm(resid(fm),main="Residuals Rankit Plot") #用正态分值图检验数据的偏度（skewness），峰度（kurtosis）和异常值（outlier）。（这里没有多大的用途，只是演示一下而已。）
rm(fm,fm1,lrf,x,dummy)     #再次清空。

###################################################
##第二部分将研究Michaelson 和Morley 测量光速的经典实验。这个数据集可以从
##对象morley 中得到，但是我们从中读出数据以演示函数read.table 的作用。
####################################################

filepath<-system.file("data","morley.tab",package="database")
filepath    #得到文件路径。
file.show(filepath)   #可选。查看文件内容。
mm<-read.table(filepath)
mm       #以数据框的形式读取Michaelson 和Morley 的数据，并且查看。数据由五次实验(Expt
         # 列)，每次运行20 次(Run 列)的观测得到。数据框中的sl 是光速的记录。这些数据以
         # 适当形式编码。
mm$Expt<-factor(mm$Expt)
mm$Run<-factor(mm$Run)   #将Expt 和Run 改为因子。

attach(mm)       #让数据在位置3 (默认) 可见（即可以直接访问）。

plot(Expt,Speed,main="Speed of Light Data",xlab="Experiment No.")    #用简单的盒状图比较五次实验。
fm<-aov(Speed~Run+Expt,data=mm)
summary(fm)        #分析随机区组，`runs' 和`experiments' 作为因子。
fm0<-update(fm,.~.-Run)
anova(fm0,fm)      #拟合忽略`runs' 的子模型，并且对模型更改前后进行方差分析。
detach()
rm(fm,fm0)         #在进行下面工作前，清空数据。

######################################################
###我们现在查看更有趣的图形显示特性：等高线和影像显示。
######################################################

x<-seq(-pi,pi,len=50)
y<-x               #x 是一个在¡¼ · x · ¼ 内等间距的50个元素的向量，y 类似。
f<-outer(x,y,function(x,y) cos(y)/(1+x^2))   #f 是一个方阵，行列分别被x 和y 索引，对应的值是函数cos(y)=(1 + x2) 的结果。
oldpar<-par(no.readonly = TRUE)
par(pty="s")       #保存图形参数，设定图形区域为\正方形"。
contour(x,y,f)
contour(x,y,f,nlevels=15,add=TRUE)     #绘制f 的等高线；增加一些曲线显示细节。
fa<-(f-t(f))/2                        #fa 是f 的\非对称部分"(t() 是转置函数)。
contour(x,y,fa,nlevels=15)           #画等高线
par(oldpar)                         #恢复原始的图形参数。

image(x,y,f)
image(x,y,fa)                #绘制一些高密度的影像显示，(如果你想要，你可以保存它的硬拷贝)
objects();rm(x,y,f,fa)       #在继续下一步前，清空数据。

###################################################
###R 可以做复数运算。
###################################################
th<-seq(-pi,pi,len=100)
z<-exp(1i*th)           # 1i 表示复数i。
par(pty="s")
plot(z,type="l")        #图形参数是复数时，表示虚部对实部画图。这可能是一个圆。
w<-rnorm(100)+rnorm(100)*1i  #假定我们想在这个圆里面随机抽样。一种方法将让复数的虚部和实部值是标准正态随机数.
w<-ifelse(Mod(w)>1,1/w,w)    #将圆外的点映射成它们的倒数。

plot(w,xlim=c(-1,1),ylim=c(-1,1),pch="+",xlab="x",ylab="y")
lines(z)                     #所有的点都在圆中，但分布不是均匀的。
w<-sqrt(runif(100))*exp(2*pi*runif(100)*1i)
plot(w,xlim=c(-1,1),ylim=c(-1,1),pch="+",xlab="x",ylab="y")
lines(z)                     #第二种方法采用均匀分布。现在圆盘中的点看上去均匀多了。
rm(th,w,z)                  #再次清空。

q()    #离开R 程序。你可能被提示是否保存R 工作空间
```

# FE5209
## 1 Misc
1. 自定义函数 `arc <- function(x) 2*asin(sqrt(x))`
2. 帮助 `help(t.test)` 或者`?rnorm`
3. 设置路径 `setwd("c:/.../")`
4. 访问数据框变量： `myData$Learning`
   用attach之后就可以直接访问 `attach(myData); Learning`
5. 合并多图
```
par(mfrow=c(1,2))
hist(Learning[Condition=="High"&Group=="A"])
hist(Learning[Condition=="Low"&Group=="A"])
```
6. 检查正态分布：shapiro test `shapiro.test(Learning[Condition=="High"&Group=="A"])`
7. 变量筛选： step `step(myModel, direction="backward")`
8. 看数据统计学特征： `boxplot(Learning~Group*Condition,col=c("#ffdddd","#ddddff"))`
### Rlab_1.R
```
setwd("D:\\PRGS\\R")      #设置工作路径

dat = read.csv("Stock_FX_bond.csv",header=TRUE)   #确保文件在工作路径下
names(dat)        #print the names of the variables in the data set
attach(dat)       
par(mfrow=c(1,2)) 
plot(GM_AC) 
plot(F_AC)
n = dim(dat)[1]    #find number of rows in dat
GMReturn = GM_AC[2:n]/GM_AC[1:(n-1)] - 1
FReturn = F_AC[2:n]/F_AC[1:(n-1)] - 1 
par(mfrow=c(1,1)) 
plot(GMReturn,FReturn)

GMLogReturn = diff(log(GM_AC)) 
cor(GMLogReturn,GMReturn) 
```
## 2 Regression
### Rlab2_1.R
```
#This section uses the data set USMacroG in R's AER package
install.packages("AER")
library(AER)
data("USMacroG")   
MacroDiff= apply(USMacroG,2,diff)  #向量化运算， 2表示column
consumption = MacroDiff[,2]  
dpi= MacroDiff[,5]
cpi= MacroDiff[,6]
government= MacroDiff[,4]
unemp= MacroDiff[,9]

pairs(cbind(consumption,dpi,cpi,government,unemp))  #cbind列与列合并，pairs：create a scatterplot matrix，互相为横纵坐标

fitLm1 = lm(consumption~dpi+cpi+government+unemp) 
summary(fitLm1)
confint(fitLm1)   #Computes confidence intervals for one or more parameters in a fitted model.
anova(fitLm1)

library(MASS)     #variables selection: use stepAIC() in the MASS package
fitLm2 = stepAIC(fitLm1)
summary(fitLm2)
AIC(fitLm1)
AIC(fitLm2)
AIC(fitLm1)-AIC(fitLm2)

install.packages("car")  #The function vif in the car package will compute variance inflation factors
library(car)
vif(fitLm1)    #vif test the correlation of one factor with others 1:no collinearity 4 need check 10 serious collinearity
vif(fitLm2)


par(mfrow=c(2,2))
sp = 0.8   #值越大，smooth程度越大
crPlot(fitLm1,dpi,span=sp,col="black")  #crplot means (component plus residual plot) or (partial residual plot)用来看是否线性关系
crPlot(fitLm1,cpi,span=sp,col="black")
crPlot(fitLm1,government,span=sp,col="black")
crPlot(fitLm1,unemp,span=sp,col="black")#A substantial deviation of the lowess curve from the least-squares line is an indication that                                            #the effect of the predictor is nonlinear
```
### Rlab2_2.R
## 3 CAPM
### Rlab3.R
```
setwd("D:\\PRGS\\R")
dat = read.csv("Rlab3_Stock_FX_Bond_2004_to_2006.csv",header=T)
prices = dat[,c(5,7,9,11,13,15,17,24)]
n = dim(prices)[1]  #一维dimension of price

dat2 = as.matrix(cbind(dat[(2:n),3]/365, 100*(prices[2:n,]/prices[1:(n-1),] - 1))) #convert the risk-free rate to a daily rate, compute net returns
names(dat2)[1] = "treasury"
risk_free = dat2[,1]
ExRet = dat2[,2:9] - risk_free
market = ExRet[,8]
stockExRet = ExRet[,1:7]

fit_reg = lm(stockExRet~market)
summary(fit_reg)
res = residuals(fit_reg)  #compute the residuals
pairs(res)
options(digits=3)
betas=fit_reg$coeff[2,]  #提取beta出来

betas*mean(market) 
apply(stockExRet,2,mean)   #把stockExret 按列 求mean
#以上两行在比较 用model estimate的excess return和用sample mean算出来的有什么区别

res = residuals(fit_reg)
options(digits=3)
cor(res)

4*betas
```
## 5 NTS
### Rlab5.R
```
install.packages("Ecdat")
data(Tbrate,package="Ecdat")
install.packages("tseries")
library(tseries)
# r = the 91-day treasury bill rate
# y = the log of real GDP
# pi = the inflation rate
plot(Tbrate)      #初步看是否mean-reverting 来判断stationarity
acf(Tbrate)
adf.test(Tbrate[,1])   #augmented Dickey-Fuller test: p-value <0.05(0.1)才可以reject null
adf.test(Tbrate[,2])
adf.test(Tbrate[,3])

diff_rate = diff(Tbrate)
adf.test(diff_rate[,1])
adf.test(diff_rate[,2])
adf.test(diff_rate[,3])
pairs(diff_rate) # scatterplot matrix  查看cross-sectional association
plot(diff_rate) # time series plots  (The plot function would create a scatterplot matrix if the 
##data were in a data.frame rather than having “class" time series (ts). Check the class of diff_rate with attr(diff_rate,"class").
acf(diff_rate)

par(mfrow=c(1,1))
boxplot(diff_rate[,1] ~ cycle(diff_rate))  #cycle函数extract quarterly period 

install.packages("forecast")
library(forecast)
auto.arima(Tbrate[,1],max.P=0,max.Q=0,ic="aic")  #P.Q是season模型的ar.ma阶数
auto.arima(Tbrate[,1],max.P=0,max.Q=0,ic="bic")

fit1 = arima(Tbrate[,1],order=c(?,?,?))  #?里面填刚才跑的结果
acf(residuals(fit1))
Box.test(residuals(fit1), lag = 10, type="Ljung")  #检查是否有autocorrelation,p<0.1有

resid2 = residuals(fit1)^2
acf(resid2)
Box.test(resid2, lag = 10, type="Ljung") #以上检查residual 平方是否有autocorrelation

###以下讲如何用R forecast

data(Tbrate,package="Ecdat")
# r = the 91-day Treasury bill rate
# y = the log of real GDP
# pi = the inflation rate
# fit the nonseasonal ARIMA model found by auto.arima
attach(as.list(Tbrate))
auto.arima(pi,max.P=0,max.Q=0,ic="bic")
fit = arima(pi,order=c(?,?,?))
forecasts = predict(fit,36)  #往前36期
plot(pi,xlim=c(1980,2006),ylim=c(-7,12))
lines(seq(from=1997,by=.25,length=36), forecasts$pred,col="red")
lines(seq(from=1997,by=.25,length=36), forecasts$pred + 1.96*forecasts$se,col="blue")
lines(seq(from=1997,by=.25,length=36), forecasts$pred - 1.96*forecasts$se,col="blue")
#注意预测到后来不再波动，是因为auto.arima假设zero-mean for difference, 后面就趋于0 【不确定哦】
```
## 6 GARCH
### Rlab6.R
```
install.packages("Ecdat")
install.packages("tseries")
install.packages("fGarch")
data(Tbrate,package="Ecdat")
library(tseries)
library(fGarch)
# r = the 91-day treasury bill rate
# y = the log of real GDP
# pi = the inflation rate
Tbill = Tbrate[,1]
Del.Tbill = diff(Tbill)
del.log.tbill = diff(log(Tbill))
Del.Tbill2 =Del.Tbill^2

adf.test(Tbill)  #null是non-stationary 
kpss.test(Tbill)  #null是stationary 

par(mfrow=c(2,2))
acf(Del.Tbill)
pacf(Del.Tbill)
acf(Del.Tbill2)
pacf(Del.Tbill2)

garch.model.Tbill = garchFit(formula= ~arma(1,0) + garch(1,0),Del.Tbill)
summary(garch.model.Tbill)
garch.model.Tbill@fit$matcoef

res = residuals(garch.model.Tbill)
res_std = res / garch.model.Tbill@sigma.t
par(mfrow=c(2,3))
plot(res)
acf(res)
acf(res^2)
plot(res_std)
acf(res_std)
acf(res_std^2)

garch.model.log.Tbill = garchFit(formula= ~arma(1,0) + garch(1,0),del.log.tbill)
summary(garch.model.log.Tbill)
garch.model.log.Tbill@fit$matcoef

res = residuals(garch.model.log.Tbill)
res_std = res / garch.model.log.Tbill@sigma.t
par(mfrow=c(2,3))
plot(res)
acf(res)
acf(res^2)
plot(res_std)
acf(res_std)
acf(res_std^2)

#The advantage of using a log transformation prior to taking differences is that the log 
#transformation removes a type of heteroscedasticity that GARCH models cannot model adequately,
#specifically that in the original Tbill series the conditional variance of the difference is
#proportional to the rate.
```
### Rlab6_2.R
```
install.packages("Ecdat") 
install.packages("fGarch") 
library(Ecdat)
library(fGarch)
data(SP500,package="Ecdat")
returnBlMon = SP500$r500[1805]
x = SP500$r500[(1804-2*253+1):1804]
plot(c(x,returnBlMon))
results = garchFit(~arma(1,0)+garch(1,1),data=x,cond.dist="std")
dfhat = as.numeric(results@fit$par[6])
forecast = predict(results,n.ahead=1)  #n.ahead specifies how many days ahead to forecast

probBlackMonday = pstd(returnBlMon,mean=forecast$meanForecast,sd=forecast$standardDeviation,nu=dfhat)
round(probBlackMonday,7) 

std_res =results@residuals/results@sigma.t 
par(mfrow=c(1,3))
plot(std_res) 
acf(std_res) 
acf(std_res^2)

summary(results)

fitAR1 = arima(x,order=c(1,0,0))
fitAR1 
par(mfrow=c(1,3))
residAR1 = residuals(fitAR1)
plot(residAR1) 
acf(residAR1) 
acf(residAR1^2)
```
