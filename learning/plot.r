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
library(ggunchained)
library(ggthemr)
library(ggprism)
# ggthemr('fresh',layout = "clean",spacing = 0.5)
theme_set(theme_prism(base_line_size = 0.5))
# theme_set(theme(axis.ticks.length.x = unit(-0.1,"cm")))
# theme_set(theme_pubr())
# theme_set(theme_classic())
# plot functions

#  function for bootstrap
boot_mean <- function(data, indices) {
  d <- data[indices,] #allows boot to select sample
  return(sapply(d,mean)) #return R-squared of model
}
# scatter
diagplot <- function(data,x,y){
  # bootstrap
  set.seed(1)
  #perform bootstrapping with 1000 replications
  reps <- boot(data[c(x,y)], statistic=boot_mean, R=1000)
  data <- data.frame(reps$t)
  names(data) <- names(reps$data)
  
  p_size <- 1
  p_jitter <- 0*p_size
  bound <- max(data[x],data[y])+1
  ggplot(data,aes_(as.name(x),as.name(y)))+
    geom_hline(yintercept = 0, linetype="dashed", color = "black")+
    geom_vline(xintercept = 0, linetype="dashed", color = "black")+
    geom_abline(intercept = 0, slope = 1, color = "black",size = 0.5)+
    geom_point(color = "#13acf7", size = p_size, alpha = 0.7, shape=19,
               position=position_jitter(h=p_jitter,w=p_jitter,seed = 1))+
    coord_cartesian(xlim = c(-bound,bound),ylim = c(-bound,bound))+
    scale_y_continuous(breaks = scales::breaks_width(10))+
    scale_x_continuous(breaks = scales::breaks_width(10))+
    theme_prism(base_line_size = 0.5,border = T)
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

# violinplot
vioplot <- function(data,condition, select){
  # select data
  Violin_data <- subset(data,select = c("id","gender",select))
  Violin_data <- reshape2::melt(Violin_data, c("id","gender"),variable.name = "Task", value.name = "Score")
  Violin_data <- mutate(Violin_data,
                        test=ifelse(str_detect(Task,"pre"),"pre_test","post_test"),
                        condition=ifelse(str_detect(Task,condition[1]),condition[1],condition[2]))
  
  Violin_data$test <- factor(Violin_data$test, levels = c("pre_test","post_test"),ordered = TRUE)
  # violinplot
  ggplot(data=Violin_data, aes(x=condition, y=Score, fill=test)) + 
    geom_split_violin(trim=FALSE,color="black",na.rm = TRUE, scale = "area") +
    geom_point(aes(group = test), size = 0.5, color = "gray",show.legend = F,
               position = position_jitterdodge(
                 jitter.width = 0.5,
                 jitter.height = 0,
                 dodge.width = 0.6,
                 seed = 1))+
    coord_cartesian(ylim = c(0,100))+
    scale_fill_manual(values = c("#233b42","#65adc2")) + 
    scale_y_continuous(breaks = c(1,seq(from=20, to=100, by=20)))
}

# boxplot
boxplot <- function(data, con, select){
  # select data
  Violin_data <- subset(data,select = c("id","gender",select))
  Violin_data <- reshape2::melt(Violin_data, c("id","gender"),variable.name = "Task", value.name = "Score")
  Violin_data <- mutate(Violin_data,
                        test=ifelse(str_detect(Task,"pre"),"pre_test","post_test"),
                        condition=ifelse(str_detect(Task,con[1]),con[1],con[2]))
  
  Violin_data$test <- factor(Violin_data$test, levels = c("pre_test","post_test"),ordered = TRUE)
  Violin_data$condition <- factor(Violin_data$condition, levels = c("fearful","happy"),ordered = F)
  # violinplot
  ggplot(data=Violin_data, aes(x=condition, y=Score)) + 
    geom_boxplot(aes(color=test),
                 outlier.shape = NA, fill=NA, width=0.5, position = position_dodge(0.6)) +
    scale_color_manual(values=c("grey50","black"))+
    geom_point(aes(group = test, fill=test), size = 0.5, color = "gray",show.legend = F,
               position = position_jitterdodge(
                 jitter.width = 0.3,
                 jitter.height = 0,
                 dodge.width = 0.6,
                 seed = 1))+
    geom_line(aes(group = interaction(id,condition)), position = position_dodge(0.6))+
    coord_cartesian(ylim = c(0,100))+
    scale_fill_manual(values = c("#233b42","#65adc2")) + 
    scale_y_continuous(breaks = c(1,seq(from=20, to=100, by=20)))
}

# boxplot with line
boxplot_line <- function(data, con, select){
  # select data
  Violin_data <- subset(data,select = c("id","gender",select))
  Violin_data <- reshape2::melt(Violin_data, c("id","gender"),variable.name = "Task", value.name = "Score")
  Violin_data <- mutate(Violin_data,
                        test=ifelse(str_detect(Task,"pre"),"pre_test","post_test"),
                        condition=ifelse(str_detect(Task,con[1]),con[1],con[2]))
  
  Violin_data$test <- factor(Violin_data$test, levels = c("pre_test","post_test"),ordered = TRUE)
  Violin_data$condition <- factor(Violin_data$condition, levels = c("fearful","happy"),ordered = F)
  # violinplot
  pd <- position_dodge(0.1)
  ggplot(data=Violin_data, aes(x=test, y=Score)) + 
    geom_boxplot(aes(color=test),
                 outlier.shape = NA, fill=NA, width=0.5, position = position_dodge(0.6)) +
    scale_color_manual(values=c("grey50","black"))+
    geom_point(aes(group =id, fill=test), size = 0.5, shape=21, color = "gray",show.legend = F,
               position = pd)+
    geom_line(aes(group = id), color = "#e8e8e8", position = pd)+
    facet_grid(~condition) +
    coord_cartesian(ylim = c(0,100))+
    scale_fill_manual(values = c("#233b42","#65adc2")) + 
    scale_y_continuous(breaks = c(1,seq(from=10, to=100, by=10)))
}

# Load Data
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
ggsave(paste0(data_dir,"diag_va_hf.pdf"), width = 6, height = 5)

diagplot(data_exp1,"preindif","afterindif")
ggsave(paste0(data_dir,"diag_in_hf.pdf"), width = 6, height = 5)

diagplot(data_exp1,"prevadif_pm","aftervadif_pm")
ggsave(paste0(data_dir,"diag_va_pm.pdf"), width = 6, height = 5)

diagplot(data_exp1,"preindif_pm","afterindif_pm")
ggsave(paste0(data_dir,"diag_in_pm.pdf"), width = 6, height = 5)

correplot(data_exp1,"va.dif","after.acc")
ggsave(paste0(data_dir,"correlation.pdf"), width = 6, height = 4)

correplot(data_exp1,"absvadif","after.acc")
correplot(data_exp1,"learn.dif","after.acc")
correplot(data_exp1,"abslearndif","after.acc")

# vioplot(data_exp1,c("happy","fearful"),c("prehappy.va","prefear.va","afterhappy.va","afterfear.va"))
# ggsave(paste0(data_dir,"violin_va_hf.eps"), width = 4, height = 3)
# ggsave(paste0(data_dir,"violin_va_hf.pdf"), width = 4, height = 3)
# 
# vioplot(data_exp1,c("happy","fearful"),c("prehappy.in","prefear.in","afterhappy.in","afterfear.in"))
# ggsave(paste0(data_dir,"violin_in_hf.eps"), width = 4, height = 3)
# ggsave(paste0(data_dir,"violin_in_hf.pdf"), width = 4, height = 3)
# 
# vioplot(data_exp1,c("plus","minus"),c("preplus.va","preminus.va","afterplus.va","afterminus.va"))
# ggsave(paste0(data_dir,"violin_va_pm.eps"), width = 4, height = 3)
# ggsave(paste0(data_dir,"violin_va_pm.pdf"), width = 4, height = 3)
# 
# vioplot(data_exp1,c("plus","minus"),c("preplus.in","preminus.in","afterplus.in","afterminus.in"))
# ggsave(paste0(data_dir,"violin_in_pm.eps"), width = 4, height = 3)
# ggsave(paste0(data_dir,"violin_in_pm.pdf"), width = 4, height = 3)

boxplot(data_exp1,c("happy","fearful"),c("prehappy.va","prefear.va","afterhappy.va","afterfear.va"))
boxplot_line(data_exp1,c("happy","fearful"),c("prehappy.va","prefear.va","afterhappy.va","afterfear.va"))
ggsave(paste0(data_dir,"box_va_hf.pdf"), width = 4, height = 3)

boxplot(data_exp1,c("happy","fearful"),c("prehappy.in","prefear.in","afterhappy.in","afterfear.in"))
ggsave(paste0(data_dir,"box_in_hf.pdf"), width = 4, height = 3)

boxplot(data_exp1,c("plus","minus"),c("preplus.va","preminus.va","afterplus.va","afterminus.va"))
ggsave(paste0(data_dir,"box_va_pm.pdf"), width = 4, height = 3)

boxplot(data_exp1,c("plus","minus"),c("preplus.in","preminus.in","afterplus.in","afterminus.in"))
ggsave(paste0(data_dir,"box_in_pm.pdf"), width = 4, height = 3)

# select valence in post-test
after_box_data <- subset(data_exp1,select = c("id","gender","pair","afterplus.va","afterminus.va"))
after_box_data <- reshape2::melt(after_box_data, c("id","gender","pair"),variable.name = "Odor", value.name = "Score")
after_box_data <- mutate(after_box_data, Odor=ifelse(str_detect(Odor,"plus"),"(+)-pinene","(-)-pinene"))
after_box_data <- mutate(after_box_data, Condition=ifelse((Odor=="(+)-pinene" & pair=="+")|(Odor=="(-)-pinene" & pair=="-"),"happy","fearful"))

after_box_data$Odor <- factor(after_box_data$Odor, levels = c("(+)-pinene","(-)-pinene"),ordered = F)
after_box_data$pair <- factor(after_box_data$pair, levels = c("+","-"),labels = c("(+)-happy","(-)-happy"),ordered = F)
after_box_data$Condtion <- factor(after_box_data$Condtion, levels = c("happy","fearful"),ordered = F)

ggplot(data=after_box_data, aes(x=pair, y=Score)) + 
  geom_boxplot(aes(color=Odor),
               outlier.shape = NA, fill=NA, width=0.5, position = position_dodge(0.6)) +
  scale_color_manual(values=c("grey50","black"))+
  geom_point(aes(group = Odor, fill=Odor), size = 0.5, color = "gray",show.legend = F,
             position = position_jitterdodge(
               jitter.width = 0.2,
               jitter.height = 0,
               dodge.width = 0.6,
               seed = 1))+
  coord_cartesian(ylim = c(0,100))+
  scale_fill_manual(values = c("#233b42","#65adc2")) + 
  scale_y_continuous(breaks = c(1,seq(from=10, to=100, by=10)))
ggsave(paste0(data_dir,"box_va_after.pdf"), width = 4, height = 3)

ggplot(data=after_box_data, aes(x=pair, y=Score,fill=Condition)) + 
  geom_boxplot(aes(color=Odor),
               outlier.shape = NA, width=0.5, position = position_dodge(0.6)) +
  scale_color_manual(values=c("grey50","black"))+
  geom_point(aes(group = Odor), size = 0.5, color = "gray",show.legend = F,
             position = position_jitterdodge(
               jitter.width = 0.2,
               jitter.height = 0,
               dodge.width = 0.6,
               seed = 1))+
  coord_cartesian(ylim = c(0,100))+
  guides(color = guide_legend(
    order = 1,override.aes = list(fill = NA)))+
  scale_fill_manual(values = c("red","blue")) + 
  scale_y_continuous(breaks = c(1,seq(from=10, to=100, by=10)))
ggsave(paste0(data_dir,"boxcolor_va_after.pdf"), width = 4, height = 3)
