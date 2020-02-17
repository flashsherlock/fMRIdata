#建立分析的函数
#读取数据，去掉Means列
rm(list = ls())
extractdata <- function(txtname){

data <- read.table(txtname,header = TRUE,
                   colClasses = c("character","character","NULL","character"),
                   col.names = c("Sub","TimePoints","Null","NZmean"))
# 去掉每个被试开头的标题的那一行
data$Sub[data$Sub=="File"] <- NA
data <- na.omit(data)

# data1 <- data[c(-3)]
sub <- strsplit(data$Sub,"\\.")
sub <- sapply(sub,"[",1)
data$Sub <- sub
#fixed = T拒绝使用正则表达式
tp <- strsplit(data$TimePoints,fixed = T,"[")
tp <- sapply(tp,"[",1)
data$TimePoints <- tp
data$NZmean <- as.numeric(data$NZmean)

require(data.table)
data1 <- melt(data,id=c("Sub","TimePoints"))
data1 <- dcast(data1,Sub~TimePoints)

return(data1)
}

# 设置工作目录循环
setwd("/Volumes/WD_D/allsub/ana4")
require(showtext)
# a <- 0
folder <- dir(pattern = "tent.*l")
for (workingpath in folder) {
  setwd(paste("/Volumes/WD_D/allsub/ana4",workingpath,sep="/"))
  getwd()
  # a <- a+1
  # 每个txt循环
  txtfile <- dir(pattern = "20subj_.*txt")
  for (name in txtfile) {
    # 名字中去掉最后的.txt
    result <- substring(name,1,nchar(name)-4)
    # 将得到的结果的数据框重命名
    assign(result,extractdata(name))
    results <- get(result)
    meanbeta <- apply(results[2:12],2,mean)
    #保存图片为eps
    setEPS()
    postscript(paste(result,"eps",sep="."))
    showtext_begin()
    plot(meanbeta,xaxt='n',xlab="TimePoint",ylab="Beta",type = 'b', lty = 3)
    axis(1,0:10)
    title(result)
    showtext_end()
    dev.off()
  }
}
rm(results)
# #保存图片为eps
# require(showtext)
# for (data in txtfile) {
#   result <- get(data)
#   meanbeta <- apply(result[2:12],2,mean)
#   setEPS()
#   postscript(paste(data,"eps",sep="."))
#   showtext_begin()
#   plot(meanbeta,xaxt='n',xlab="TimePoint",ylab="Beta",type = 'b', lty = 3)
#   axis(1,0:10)
#   title(data)
#   showtext_end()
#   dev.off()
# }
