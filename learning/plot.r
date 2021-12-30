# install vscode-r extension

# install packages
# install.packages("languageserver")
# install.packages("httpgd")
# devtools::install_github("ManuelHentschel/vscDebugger")

library(Hmisc)

# data_dir <- "C:/Users/GuFei/zhuom/yanqihu/result100.sav"
data_dir <- "/Volumes/WD_D/gufei/writing/"
data_exp1 <- spss.get(paste0(data_dir,"result100.sav"))
# select data according to hit rate
data_exp1 <- subset(data_exp1, data_exp1$hitrate>=0.8)
data_exp1$gender <- factor(data_exp1$gender,labels = c("M","F"))
str(data_exp1)
summary(data_exp1)

# valence rating
valence <- subset(data_exp1,select = c("id","gender","prehappy.va","prefear.va","afterhappy.va","afterfear.va"))
valence <- reshape::melt(valence, id.vars="id",variable.name = "Task", value.name = "Score")
Violin_data$Task <- factor(Violin_data$Task, levels = c("A", "B"), ordered = TRUE)
Violin_data$Test <- factor(Violin_data$Test,levels = c("1","2"),ordered = TRUE)
violin <- ggplot(data=Violin_data, aes(x=Task, y=Score,fill=Test)) + 
  geom_split_violin(trim=FALSE,color="black",na.rm = TRUE, scale = "area") +
  geom_jitter(aes(group = Task,color =Test), size = 0.1, position = position_dodge2(width = 0.5, preserve = "single")) +
  scale_fill_manual(values = c("red","blue")) + 
  geom_boxplot(data = controldata_z, aes(x=Task, y=Score,fill = NULL), width = 0.05,outlier.shape = NA) +
  theme(panel.background = element_blank(),axis.ticks.length.y = unit(-0.1,"cm"),axis.line = element_line(colour = "black"),legend.text=element_text(), legend.title = element_text(), axis.text.y=element_text(margin = unit(c(0.3, 0.3, 0.3, 0.3), "cm")), axis.text.x = element_text())
  
print(violin)

ggsave(paste0(data_dir,"Retest_violin.eps"), width = 5, height = 3)

# test plot
h <- c(1, 2, 3, 4, 5, 6)
M <- c("A", "B", "C", "D", "E", "F")
barplot(h,
        names.arg = M, xlab = "X", ylab = "Y",
        col = "#00cec9", main = "Chart", border = "#fdcb6e"
)