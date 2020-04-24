rm(list = ls())

# 求标准误的函数
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
load("PPI.RData")
list = ls(pattern = "20subj.*")

# 建立空的矩阵
meandata <- matrix(1:5,nrow=1)
sedata <- meandata

for (result in list) {
  # 通过get可以得到相应名称result的变量
  # result是一个字符串，results是数据框
  results <- get(result)
  # 先分割字符串,转义需要两个斜线\\
  tempstro <- strsplit(result,"[_\\.]")
  tempstr <- sapply(tempstro,'[',2)
  # position表示是aSTS还是FFA
  position <- sapply(tempstro,"[",3)
  
  # 找出位置和条件
  # condition 表示是哪两种条件相减
  condition<- substr(tempstr,nchar(tempstr)-1,nchar(tempstr))
  # roi表示是哪个位置的杏仁核
  roi <- substr(tempstr,1,nchar(tempstr)-2)
  # 扩增为对应的行数
  position<- matrix(data = position,nrow = dim(results)[1])
  condition<- matrix(data = condition,nrow = dim(results)[1])
  roi <- matrix(data = roi,nrow = dim(results)[1])
  
  # bind条件和位置和roi
  results <- cbind(results,position,condition,roi)
  # 改变列名称
  names(results) <- c('Sub','Inv','Vis','Inv_t','Vis_t','Count',
                      'position','condition','roi')
  # 将被试号转换为因子
  results$Sub <- factor(results$Sub)
  
  # 计算均值和标准误赋值到矩阵中
  assign(result,results)
  meandata <- rbind(meandata,apply(results[2:6],2,mean))
  sedata <- rbind(sedata,apply(results[2:6],2,se))
  #describe(results[2:10])
}

# 转换为数据框
meandata <- as.data.frame(meandata)
sedata <- as.data.frame(sedata)
meandata <- meandata[-1,]
sedata <- sedata[-1,]
# 更改列名称
names(sedata) <- names(meandata) <- c('Inv','Vis','Inv_t','Vis_t','Count')
# 加入每一行的条件
# 先分割字符串,转义需要两个斜线\\
tempstro <- strsplit(list,"[_\\.]")
tempstr <- sapply(tempstro,'[',2)
# position表示是aSTS还是FFA
position <- sapply(tempstro,"[",3)

# 把条件名称再放到后面
# 先分割字符串
condition<- substr(tempstr,nchar(tempstr)-1,nchar(tempstr))
roi <- substr(tempstr,1,nchar(tempstr)-2)

# bind
meandata <- cbind(meandata,position,condition,roi)
sedata <- cbind(sedata,position,condition,roi)

# 合并所有条件的数据框
all <- multimerge(list)

save(all,sedata,meandata,file = "All.RData")

