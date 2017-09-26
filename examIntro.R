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

