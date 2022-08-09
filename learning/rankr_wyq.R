library(Hmisc)
library(Rmisc)
library(dplyr)
library(tidyr)
library(effectsize)
# Load Data
# data_dir <- "C:/Users/GuFei/zhuom/yanqihu/result100.sav"
data_dir <- "/Volumes/WD_D/gufei/writing/"
# paired sample
data <- spss.get(paste0(data_dir,"wyq.sav"))
wilcox.test(data$adP, data$adU, paired = TRUE,
            digits.rank = 7)
rank_biserial(data$adP, data$adU, paired = TRUE)
wilcox.test(data$adP.N, data$adU.N, paired = TRUE,
            digits.rank = 7)
rank_biserial(data$adP.N, data$adU.N, paired = TRUE)
wilcox.test(data$adpNostril, data$UnadpNostril, paired = TRUE,
            digits.rank = 7)
wilcox.test(round(data$adpNostril,7), round(data$UnadpNostril,7), paired = TRUE)
rank_biserial(data$adpNostril, data$UnadpNostril, paired = TRUE)
wilcox.test(data$adaptP.contra, data$adaptU.contra, paired = TRUE,
            digits.rank = 7)
rank_biserial(data$adaptP.contra, data$adaptU.contra, paired = TRUE)
# two sample
data2 <- spss.get(paste0(data_dir,"wyq2.sav"))
data2 <- rename(data2,group=VAR00002)
wilcox.test(data2$P ~ data2$group,
            digits.rank = 7)
rank_biserial(data2$P ~ data2$group)
wilcox.test(data2$U ~ data2$group,
            digits.rank = 7)
rank_biserial(data2$U ~ data2$group)
