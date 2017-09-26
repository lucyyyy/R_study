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
 



