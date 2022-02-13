# install vscode-r extension

# install packages
# install.packages("languageserver")
# install.packages("httpgd")
# devtools::install_github("ManuelHentschel/vscDebugger")

# test plot
# h <- c(1, 2, 3, 4, 5, 6)
# M <- c("A", "B", "C", "D", "E", "F")
# barplot(h,
#         names.arg = M, xlab = "X", ylab = "Y",
#         col = "#00cec9", main = "Chart", border = "#fdcb6e"
# )

library(ggpubr)
library(Hmisc)

# plot functions
# scatter
diagplot <- function(data,x,y){
  p_size <- 3
  p_jitter <- 0.2*p_size
  bound <- max(data[x],data[y])+5
  ggplot(data,aes_(as.name(x),as.name(y)))+
    geom_hline(yintercept = 0, linetype="dotted", color = "black")+
    geom_vline(xintercept = 0, linetype="dotted", color = "black")+
    geom_abline(intercept = 0, slope = 1, color = "#826a50")+
    geom_point(aes(color = gender), size = p_size, alpha = 0.7,
               position=position_jitter(h=p_jitter,w=p_jitter,seed = 1))+
    coord_cartesian(xlim = c(-bound,bound),ylim = c(-bound,bound))+
    scale_y_continuous(breaks = scales::breaks_width(10))+
    scale_x_continuous(breaks = scales::breaks_width(10))
}
# correlation
correplot <- function(data,x,y){
  ggplot(data, aes_(as.name(x),as.name(y)))+
    geom_point(color = "#233b42", size = 3, alpha = 0.5,
               position=position_jitter(h=0.02,w=0.02, seed = 5))+
    geom_smooth(method = "lm", formula = 'y ~ x')+
    scale_y_continuous(breaks = scales::breaks_width(0.1))+
    scale_x_continuous(breaks = scales::breaks_width(10))
}

# data_dir <- "C:/Users/GuFei/zhuom/yanqihu/result100.sav"
data_dir <- "/Volumes/WD_D/gufei/writing/"
data_exp1 <- spss.get(paste0(data_dir,"result100.sav"))
# select data according to hit rate
data_exp1 <- subset(data_exp1, data_exp1$hitrate>=0.8)
# gender coding
data_exp1$gender <- factor(data_exp1$gender,labels = c("Male","Female"))
data_exp1$gender <- factor(data_exp1$gender,levels = c("Female","Male"))
# happy fear
data_exp1 <- mutate(data_exp1, prevadif=prehappy.va-prefear.va, aftervadif=afterhappy.va-afterfear.va)
data_exp1 <- mutate(data_exp1, preindif=prehappy.in-prefear.in, afterindif=afterhappy.in-afterfear.in)
# plus minus
data_exp1 <- mutate(data_exp1, prevadif_pm=preplus.va-preminus.va, aftervadif_pm=afterplus.va-afterminus.va)
data_exp1 <- mutate(data_exp1, preindif_pm=preplus.in-preminus.in, afterindif_pm=afterplus.in-afterminus.in)
# absolute va.dif after pairing
data_exp1 <- mutate(data_exp1,absvadif=abs(va.dif))
data_exp1 <- mutate(data_exp1,abslearndif=abs(learn.dif))
cor(data_exp1$va.dif,data_exp1$after.acc)
cor(data_exp1$absvadif,data_exp1$after.acc)
cor(data_exp1$learn.dif,data_exp1$after.acc)
cor(data_exp1$abslearndif,data_exp1$after.acc)

# summary
str(data_exp1)
summary(data_exp1)

diagplot(data_exp1,"prevadif","aftervadif")
diagplot(data_exp1,"preindif","afterindif")
diagplot(data_exp1,"prevadif_pm","aftervadif_pm")
diagplot(data_exp1,"preindif_pm","afterindif_pm")

correplot(data_exp1,"va.dif","after.acc")
correplot(data_exp1,"absvadif","after.acc")
correplot(data_exp1,"learn.dif","after.acc")
correplot(data_exp1,"abslearndif","after.acc")

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

