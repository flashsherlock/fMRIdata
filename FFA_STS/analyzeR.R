# 求标准误的函数
rm(list = ls())
se <- function(x,na.omit=FALSE){
  if (na.omit)
    x <- x[!is.na(x)]
  n <- length(x)
  se <- sd(x)/sqrt(n)
  return(se)
}
# 合并多个数据框
multimerge<-function(dat,...){
  if(length(dat)<2)return(as.data.frame(get(dat)))
  mergedat<-get(dat[1])
  dat<-dat[-1]
  for(i in dat){
    mergedat<-rbind(mergedat,get(i))
  }
  return(mergedat)
}

# 读取数据框列表
load("STS_FFA_block.RData")
list = ls(pattern = "20subj.*")

# 建立空的矩阵
meandata <- matrix(1:13,nrow=1)
sedata <- meandata

for (result in list) {
  # 通过get可以得到相应名称result的变量
  # result是一个字符串，results是数据框
  results <- get(result)
  # 先分割字符串
  tempstr <- strsplit(result,"[_\\.]")
  # 找出位置
  position <- sapply(tempstr,"[",3)


  # 计算Invisible和Visible条件的差值,bind
  results <- cbind(results,abs(results[c(2,4,6,8)]-results[c(3,5,7,9)]))
  # bind条件和位置和valance
  results <- cbind(results,position)
    # 改变列名称
  names(results) <- c('Sub','FPI','FPV','FUI','FUV','HPI','HPV','HUI','HUV','Count',
                      'FP','FU','HP','HU','position')
  # 将被试号转换为因子
  results$Sub <- factor(results$Sub)

  # 计算均值和标准误赋值到矩阵中
  assign(result,results)
  meandata <- rbind(meandata,apply(results[2:14],2,mean))
  sedata <- rbind(sedata,apply(results[2:14],2,se))
  #describe(results[2:10])
}

# 转换为数据框
meandata <- as.data.frame(meandata)
sedata <- as.data.frame(sedata)
meandata <- meandata[-1,]
sedata <- sedata[-1,]
# 更改列名称
names(sedata) <- names(meandata) <- c('FPI','FPV','FUI','FUV','HPI','HPV','HUI','HUV','Count','FP','FU','HP','HU')
# 加入每一行的条件
position <- strsplit(list,"[_\\.]")
position <- sapply(position,"[",3)
# 转置
# condition <- t(condition)
# 改变行名称
row.names(sedata) <- row.names(meandata) <- position

# bind
meandata <- cbind(meandata,position)
sedata <- cbind(sedata,position)

# 合并所有条件的数据框
all <- multimerge(list)
# 去掉中间变量
allobj <- ls()
rm(list=allobj[which (allobj != "all" &
                      allobj != "sedata"&
                      allobj != "meandata")])
rm(allobj)
save(list = ls(),file = "All.RData")

# 建立空的数据框
# meandata <- data.frame(FPI=0,FPV=0,FUI=0,FUV=0,HPI=0,HPV=0,HUI=0,HUV=0,Count=0)
# meandata <- meandata[-1,]
# sedata <- meandata
