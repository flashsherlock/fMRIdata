#建立分析的函数
#读取数据，去掉Means列
rm(list = ls())
extractdata <- function(txtname){

data <- read.table(txtname,header = TRUE,
                   colClasses = c("character","character","NULL","character","character"),
                   col.names = c("Sub","Conditions","Null","NZmean","Count"))
# 去掉每个被试开头的标题的那一行
data$Sub[data$Sub=="File"] <- NA
data <- na.omit(data)

# data1 <- data[c(-3)]
# 把sub编号找出来
sub <- strsplit(data$Sub,"\\.")
sub <- sapply(sub,"[",1)
data$Sub <- sub
# 不加fixed = T使用正则表达式 [][]匹配的是]和[
# tp <- strsplit(data$Conditions,"[][]")
tp <- strsplit(data$Conditions,fixed = T,"[")
# 用[返回第二个值
tp <- sapply(tp,"[",1)
data$Conditions <- tp
data$NZmean <- as.numeric(data$NZmean)
# 把count单独放出来
Count <- data$Count[seq(1,4*20,4)]
data <- data[c(-4)]

data1 <- reshape2::melt(data,id=c("Sub","Conditions"))
data1 <- reshape2::dcast(data1,Sub~Conditions)
data1 <- cbind(data1,as.numeric(Count))
return(data1)
}

# 设置工作目录循环
setwd("/Volumes/WD_D/allsub/ana4")
require(showtext)
# a <- 0
folder <- dir(pattern = "PPI")
for (workingpath in folder) {
  setwd(paste("/Volumes/WD_D/allsub/ana4",workingpath,sep="/"))
  # 每个txt循环
  txtfile <- dir(pattern = "20subj_.*txt")
  for (name in txtfile) {
    # 名字中去掉最后的.txt
    result <- substring(name,1,nchar(name)-4)
    # 将得到的结果的数据框重命名
    assign(result,extractdata(name))
    results <- get(result)

  }
}
# save data
setwd("~/Documents/GitHub/fMRIdata/PPI")
save(list = ls(pattern = "20subj.*"), file = "PPI.RData")