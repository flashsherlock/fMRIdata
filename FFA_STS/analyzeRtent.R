rm(list = ls())

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
load("FFAtent.RData")
load("STStent.RData")
list = ls(pattern = "20subj.*")

for (result in list) {
  # 通过get可以得到相应名称result的变量
  # result是一个字符串，results是数据框
  results <- get(result)
  # 先分割字符串
  tempstr <- strsplit(result,"[_\\.]")

  # 呈现刺激的条件
  stimuli <- sapply(tempstr,"[",5)
  # 位置
  position <- sapply(tempstr,"[",3)
  # 扩增
  position<- matrix(data = position,nrow = dim(results)[1])
  stimuli <- matrix(data = stimuli,nrow = dim(results)[1])
  # bind条件和位置和valance
  results <- cbind(results,position,stimuli)
  # 改变一下排列顺序，将10点放到最后，原来的是排在1的后面
  results <- results %>% select(c('Sub','0','1','2','3','4','5','6','7','8','9','10'),everything())
  # 改变列名称
  names(results) <- c('Sub','TR00','TR01','TR02','TR03','TR04','TR05','TR06','TR07','TR08','TR09','TR10',
                      'position','stimuli')
  # 将被试号转换为因子
  results$Sub <- factor(results$Sub)
  # 写回到原来的数据框中
  assign(result,results)
}

# 合并所有条件的数据框
all <- multimerge(list)

# 找出刺激可见
STS <- subset(all,position=="aSTS" & stimuli%in%c('FPV','FUV','HPV','HUV'))
FFA <- subset(all,position=="FFA" & stimuli%in%c('FPV','FUV','HPV','HUV'))
# 用于比对条件和更改名称
STSstim <- substr(STS$stimuli,1,2)
FFAstim <- substr(FFA$stimuli,1,2)
# 找出刺激不可见
ISTS <- subset(all,position=="aSTS" & stimuli%in%c('FPI','FUI','HPI','HUI'))
IFFA <- subset(all,position=="FFA" & stimuli%in%c('FPI','FUI','HPI','HUI'))

# 如果刺激的条件是对应的
if (all.equal(STSstim,substr(ISTS$stimuli,1,2))) {
  # print("OK")
  # 可见减去不可见
  STS[2:12] <- STS[2:12]-ISTS[2:12]
  # 更改刺激条件为相减
  STS$stimuli <- STSstim
}

# 如果刺激的条件是对应的
if (all.equal(FFAstim,substr(IFFA$stimuli,1,2))) {
  # print("OK")
  # 可见减去不可见
  FFA[2:12] <- FFA[2:12]-IFFA[2:12]
  # 更改刺激条件为相减
  FFA$stimuli <- FFAstim
}

# 合并相减的结果到总的数据框
all <- multimerge(c("all","STS","FFA"))

# 去掉中间变量
allobj <- ls()
rm(list=allobj[which (allobj != "all")])
rm(allobj)
save(all,file = "Alltent.RData")
