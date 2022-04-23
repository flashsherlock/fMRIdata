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


# 1 functions -------------------------------------------------------------
# use control+shift+R to add labels

library(ggpubr)
library(Hmisc)
library(ggunchained)
library(ggthemr)
library(ggprism)
library(stringr)
library(dplyr)
library(tidyr)
library(boot)
library(car)
# ggthemr('fresh',layout = "clean",spacing = 0.5)
theme_set(theme_prism(base_line_size = 0.5))
# theme_set(theme(axis.ticks.length.x = unit(-0.1,"cm")))
# theme_set(theme_pubr())
# theme_set(theme_classic())
# plot functions

#  function for bootstrap
boot_mean <- function(data, indices) {
  d <- data[indices,] #allows boot to select sample
  return(sapply(d,mean)) #return mean value for each column
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
    geom_point(aes(color = "data"), size = p_size, alpha = 0.7, shape=19,stroke = 0,
               position=position_jitter(h=p_jitter,w=p_jitter,seed = 1))+
    coord_cartesian(xlim = c(-bound,bound),ylim = c(-bound,bound))+
    scale_y_continuous(breaks = scales::breaks_width(10))+
    scale_x_continuous(breaks = scales::breaks_width(10))+
    theme_prism(base_line_size = 0.5,border = T)+
    scale_color_manual(values = c(data = "#0073c2"))
}

# calculate zscore
zscore <- function(x){
  return((x-mean(x))/sd(x))
}
# pot correlation
correplot <- function(data,x1,y1,x2,y2){
  
  Corr_data <- subset(data,select = c("id","gender",x1,y1,x2,y2))
  # reshape data (gather and spread can also do that)
  Corr_data <- reshape2::melt(Corr_data, c("id","gender"),variable.name = "Task", value.name = "Score")
  Corr_data <- mutate(Corr_data,
                        test=ifelse(str_detect(Task,"pre"),"pre_test","post_test"),
                        condition=ifelse(str_detect(Task,"vadif"),"vadif",'acc'))
  rposition <- min(Corr_data$Score)
  Corr_data <- reshape2::dcast(Corr_data,id+gender+test~condition,value.var = "Score")
  Corr_data$test <- factor(Corr_data$test, levels = c("pre_test","post_test"),ordered = TRUE)
  
  ggscatter(Corr_data, x = "vadif", y = "acc", color="test",alpha = 0.8,
            conf.int = TRUE, palette=c("grey50","black"),add = "reg.line",fullrange = F,
            position=position_jitter(h=0.02,w=0.02, seed = 5)) +
    stat_cor(aes(color = test,label = paste(..r.label.., ..p.label.., sep = "~`,`~")),
             label.x = rposition,show.legend=F)+
    theme_prism(base_line_size = 0.5)
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
ci90 <- function(x){
  return(qnorm(0.95)*sd(x)/sqrt(length(x)))
  # similar to 5% and 90%
  # return(qnorm(0.95)*sd(x))
}
boxplot <- function(data, con, select, test="pre"){
  # select data
  Violin_data <- subset(data,select = c("id",select))
  Violin_data <- reshape2::melt(Violin_data, c("id"),variable.name = "Task", value.name = "Score")
  if (test=="pre"){
    tests <- c("pre_test","post_test")
  } else if (test=="happy"){
    tests <- c("happy_odor","fearful_odor")
  } else if (test=="plus"){
    tests <- c("plus","minus")
  } else {
    tests <- c("H","F")
  }
  
  Violin_data <- mutate(Violin_data,
                        test=ifelse(str_detect(Task,test),tests[1],tests[2]),
                        condition=ifelse(str_detect(Task,con[1]),con[1],con[2]))
  Violin_data$test <- factor(Violin_data$test, levels = tests,ordered = TRUE)
  Violin_data$condition <- factor(Violin_data$condition, levels = con, ordered = F)
  
  # summarise data 5% and 90% quantile
  df <- Violin_data %>% group_by(condition, test) %>% 
    summarise(y0 = quantile(Score, 0.05), 
              #y0 = mean(Score)-ci90(Score),
              y25 = quantile(Score, 0.25), 
              y50 = median(Score), 
              y75 = quantile(Score, 0.75), 
              #y100 = mean(Score)+ci90(Score))
              y100 = quantile(Score, 0.95))
  
  # boxplot
  ggplot(data=Violin_data, aes(x=condition)) + 
    # geom_boxplot(aes(y=Score,color=test),
    #              outlier.shape = NA, fill=NA, width=0.5, position = position_dodge(0.6))+
    geom_boxplot(data=df,
                 aes(ymin = y0, lower = y25, middle = y50, upper = y75, ymax = y100,color=test),
                 outlier.shape = NA, fill=NA, width=0.5, position = position_dodge(0.6),
                 stat = "identity") +
    scale_color_manual(values=c("grey50","black"))+
    geom_point(aes(group = test, fill=test, y=Score), size = 0.5, color = "gray",show.legend = F,
               position = position_jitterdodge(
                 jitter.width = 0.3,
                 jitter.height = 0,
                 dodge.width = 0.6,
                 seed = 1))+
    coord_cartesian(ylim = c(0,100))+
    scale_fill_manual(values = c("#233b42","#65adc2")) + 
    scale_y_continuous(breaks = c(1,seq(from=20, to=100, by=20)))
}

# boxplot with horizontal line
boxplotv <- function(data, con, select, test="pre"){
  # select data
  Violin_data <- subset(data,select = c("id",select))
  Violin_data <- reshape2::melt(Violin_data, c("id"),variable.name = "Task", value.name = "Score")
  if (test=="pre"){
    tests <- c("pre_test","post_test")
    } else if (test=="happy"){
    tests <- c("happy_odor","fearful_odor")
    } else if (test=="plus"){
    tests <- c("plus","minus")
    } else {
    tests <- c("H","F")
  }

  Violin_data <- mutate(Violin_data,
                        test=ifelse(str_detect(Task,test),tests[1],tests[2]),
                        condition=ifelse(str_detect(Task,con[1]),con[1],con[2]))
  Violin_data$test <- factor(Violin_data$test, levels = tests,ordered = TRUE)
  Violin_data$condition <- factor(Violin_data$condition, levels = con, ordered = F)
  
  # summarise data 5% and 90% quantile
  df <- Violin_data %>% group_by(condition, test) %>% 
    summarise(y0 = quantile(Score, 0.05), 
              #y0 = mean(Score)-ci90(Score),
              y25 = quantile(Score, 0.25), 
              y50 = median(Score), 
              y75 = quantile(Score, 0.75), 
              #y100 = mean(Score)+ci90(Score))
              y100 = quantile(Score, 0.95))
  
  # jitter
  set.seed(111)
  Violin_data <- transform(Violin_data, con = ifelse(test == "pre_test", 
                                                 jitter(as.numeric(condition) - 0.15, 0.3),
                                                 jitter(as.numeric(condition) + 0.15, 0.3) ))
  # boxplot
  ggplot(data=Violin_data, aes(x=condition)) + 
    # geom_boxplot(aes(y=Score,color=test),
    #              outlier.shape = NA, fill=NA, width=0.5, position = position_dodge(0.6))+
    geom_errorbar(data=df, position = position_dodge(0.6),
                  aes(ymin=y0,ymax=y100,color=test),linetype = 1,width = 0.3)+ # add line to whisker
    geom_boxplot(data=df,
                 aes(ymin = y0, lower = y25, middle = y50, upper = y75, ymax = y100,color=test),
                 outlier.shape = NA, fill="white", width=0.5, position = position_dodge(0.6),
                 stat = "identity") +
    scale_color_manual(values=c("grey50","black"))+
    geom_point(aes(x=con, y=Score,fill=test), size = 0.5, color = "gray",show.legend = F)+
    geom_line(aes(x=con,y=Score,group = interaction(id,condition)), color = "#e8e8e8")+
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
  Violin_data$condition <- factor(Violin_data$condition, levels = con, ordered = F)
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
    scale_y_continuous(breaks = c(1,seq(from=20, to=100, by=20)))
}

# binomial distribution
binomial_plot <- function(trials,positive){
  set.seed(1)
  # generate binomial distribution
  bi <- rbinom(10000, trials, 0.5)
  # convert to data frame
  bi_viz <- tibble(number = factor(bi)) %>%
    count(number, name = "count") %>%
    mutate(dbinom = count / sum(count), pbinom = cumsum(dbinom))
  cri <- as.numeric(bi_viz[min(which(bi_viz$pbinom>0.95)),1])
  tru <- as.numeric(bi_viz[bi_viz$number==positive,1])
  # plot binomial distribution
  ggplot(bi_viz,aes(number,count)) +
    geom_col(fill="#4d9dd4")+
    # plot p=0.95
    geom_vline(xintercept = cri,size=0.5,linetype = "dashed", color = "black")+
    # xtick every 10
    scale_x_discrete(breaks=seq(5,25,5))+
    scale_y_continuous(expand = c(0.01,0))+
    labs(x="Number of subjects",y="Count")+
    geom_point(x=tru,y=1,color="red")
}
# 2 EXP1 analysis --------------------------------------------------------------

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
# zscore for correlation
data_exp1 <- mutate(data_exp1, zprevadif=zscore(prevadif), zaftervadif=zscore(aftervadif))
data_exp1 <- mutate(data_exp1, preindif=prehappy.in-prefear.in, afterindif=afterhappy.in-afterfear.in)
# plus minus
data_exp1 <- mutate(data_exp1, prevadif_pm=preplus.va-preminus.va, aftervadif_pm=afterplus.va-afterminus.va)
data_exp1 <- mutate(data_exp1, preindif_pm=preplus.in-preminus.in, afterindif_pm=afterplus.in-afterminus.in)
# absolute va.dif after pairing
data_exp1 <- mutate(data_exp1,absvadif=abs(va.dif))
data_exp1 <- mutate(data_exp1,abslearndif=abs(learn.dif))
cor(data_exp1$va.dif,data_exp1$after.acc)
cor(data_exp1$prevadif,data_exp1$pre.acc)
cor(data_exp1$absvadif,data_exp1$after.acc)
cor(data_exp1$learn.dif,data_exp1$after.acc)
cor(data_exp1$abslearndif,data_exp1$after.acc)

# summary
str(data_exp1)
summary(data_exp1)


# 3 plots -----------------------------------------------------------------

diagplot(data_exp1,"prevadif","aftervadif")+
  guides(color="none")
ggsave(paste0(data_dir,"diag_va_hf.pdf"), width = 3.5, height = 3)

diagplot(data_exp1,"preindif","afterindif")+
  guides(color="none")
ggsave(paste0(data_dir,"diag_in_hf.pdf"), width = 3.5, height = 3)

diagplot(data_exp1,"prevadif_pm","aftervadif_pm")+
  guides(color="none")
ggsave(paste0(data_dir,"diag_va_pm.pdf"), width = 3.5, height = 3)

diagplot(data_exp1,"preindif_pm","afterindif_pm")+
  guides(color="none")
ggsave(paste0(data_dir,"diag_in_pm.pdf"), width = 3.5, height = 3)

# combine with pm
set.seed(1)
#perform bootstrapping with 1000 replications
reps <- boot(data_exp1[c("prevadif_pm","aftervadif_pm")], statistic=boot_mean, R=1000)
data <- data.frame(reps$t)
names(data) <- names(reps$data)
p_size <- 1
p_jitter <- 0*p_size
diagplot(data_exp1,"prevadif","aftervadif")+
  geom_point(data = data,aes(prevadif_pm,aftervadif_pm, color = "pm"), size = p_size, alpha = 0.7, shape=19,stroke = 0,
             position=position_jitter(h=p_jitter,w=p_jitter,seed = 1))+
  scale_color_manual(values = c(data = "#0073c2", pm = "gray50"))+
  labs(x="valence difference in pre-test", y="valence difference in post-test")
ggsave(paste0(data_dir,"diag_va_combine.pdf"), width = 4.5, height = 3.5)

# 3.2 correlation plot ----------------------------------------------------

# correplot(data_exp1,"zaftervadif","after.acc","zprevadif","pre.acc")

ggplot(data_exp1, aes(aftervadif,after.acc))+
  geom_point(color = "#0073c2", size = 4, alpha = 0.5,shape=19,stroke=0,
             position=position_jitter(h=0.02,w=0.02, seed = 5))+
  geom_smooth(color = "#0073c2", method = "lm", formula = 'y ~ x')+
  scale_y_continuous(breaks = scales::breaks_width(0.2))+
  scale_x_continuous(breaks = scales::breaks_width(10))

ggsave(paste0(data_dir,"correlation.pdf"), width = 6, height = 3)


# 3.3 distribution --------------------------------------------------------
# count subjects
nochange <- sum(data_exp1$learn.dif==0)
positive <- sum(data_exp1$learn.dif>0)
trials <- nrow(data_exp1)-nochange
binomial_plot(trials,positive)
ggsave(paste0(data_dir,"distribution.pdf"), width = 4, height = 3)

# correplot(data_exp1,"absvadif","after.acc")
# correplot(data_exp1,"learn.dif","after.acc")
# correplot(data_exp1,"abslearndif","after.acc")

# 3.4 violin and box plot -------------------------------------------------

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
# boxplot_line(data_exp1,c("happy","fearful"),c("prehappy.va","prefear.va","afterhappy.va","afterfear.va"))
ggsave(paste0(data_dir,"box_va_hf.pdf"), width = 4, height = 3)

boxplot(data_exp1,c("happy","fearful"),c("prehappy.in","prefear.in","afterhappy.in","afterfear.in"))
ggsave(paste0(data_dir,"box_in_hf.pdf"), width = 4, height = 3)

boxplot(data_exp1,c("plus","minus"),c("preplus.va","preminus.va","afterplus.va","afterminus.va"))
ggsave(paste0(data_dir,"box_va_pm.pdf"), width = 4, height = 3)

boxplot(data_exp1,c("plus","minus"),c("preplus.in","preminus.in","afterplus.in","afterminus.in"))
ggsave(paste0(data_dir,"box_in_pm.pdf"), width = 4, height = 3)


# 3.5 post_test -----------------------------------------------------------
# select valence in post-test
after_box_data <- subset(data_exp1,select = c("id","gender","pair","afterplus.va","afterminus.va"))
after_box_data <- reshape2::melt(after_box_data, c("id","gender","pair"),variable.name = "Odor", value.name = "Score")
after_box_data <- mutate(after_box_data, Odor=ifelse(str_detect(Odor,"plus"),"(+)-pinene","(-)-pinene"))
after_box_data <- mutate(after_box_data, Condition=ifelse((Odor=="(+)-pinene" & pair=="+")|(Odor=="(-)-pinene" & pair=="-"),"happy","fearful"))

after_box_data$Odor <- factor(after_box_data$Odor, levels = c("(+)-pinene","(-)-pinene"),ordered = F)
after_box_data$pair <- factor(after_box_data$pair, levels = c("+","-"),labels = c("(+)-happy","(-)-happy"),ordered = F)
after_box_data$Condition <- factor(after_box_data$Condition, levels = c("happy","fearful"),ordered = F)

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
  scale_y_continuous(breaks = c(1,seq(from=10, to=100, by=20)))
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
  scale_y_continuous(breaks = c(1,seq(from=10, to=100, by=20)))
ggsave(paste0(data_dir,"boxcolor_va_after.pdf"), width = 4, height = 3)

# 4 EXP2 analysis --------------------------------------------------------------
# Load Data
data_dir <- "/Volumes/WD_D/gufei/writing/"
data_exp2 <- spss.get(paste0(data_dir,"result_exp2.sav"))
# select data
data_exp2 <- subset(data_exp2, id!=35)
# boxplot
# H and F represent visual condition
# boxplot(data_exp2,c("happy","fear"),c("happyF","fearF","happyH","fearH"),test="H")+
boxplot(data_exp2,c("H","F"),c("happyF","fearF","happyH","fearH"),test="happy")+
  coord_cartesian(ylim = c(0,3.5))+
  scale_y_continuous(expand = c(0,0),breaks = c(seq(from=0, to=3, by=0.5)))+
  labs(y="RT")
ggsave(paste0(data_dir,"box_RT_all.pdf"), width = 4, height = 3)
# plus and minus
boxplot(data_exp2,c("H","F"),c("plusF","minusF","plusH","minusH"),test="plus")+
  coord_cartesian(ylim = c(0,3.5))+
  scale_y_continuous(expand = c(0,0),breaks = c(seq(from=0, to=3, by=0.5)))+
  labs(y="RT")
ggsave(paste0(data_dir,"box_RT_pm.pdf"), width = 4, height = 3)

# count subjects
nochange <- sum(data_exp2$learn.dif==0)
positive <- sum(data_exp2$learn.dif>0)
trials <- nrow(data_exp2)-nochange
binomial_plot(trials,positive)
ggsave(paste0(data_dir,"distribution_exp2.pdf"), width = 4, height = 3)

# correlation between learn.dif and incon_con
data_exp2 <- mutate(data_exp2,RT2incon.con = RT2.incon - RT2.con)
data_exp2 <- mutate(data_exp2,RT1incon.con = RT1.incon - RT1.con)
rposition <- min(data_exp2$learn.dif)
ggscatter(data_exp2, x = "learn.dif", y = "RT2incon.con",alpha = 0.8,
          conf.int = TRUE, palette=c("grey50","black"),add = "reg.line",fullrange = F,
          position=position_jitter(h=0.02,w=0.02, seed = 5)) +
  stat_cor(aes(color = test,label = paste(..r.label.., ..p.label.., sep = "~`,`~")),
           label.x = rposition,show.legend=F)+
  theme_prism(base_line_size = 0.5)
# Ftest for equality of variance
# var.test(incon.con ~ learnva, data = data_exp2)
# levene's test for equality of variance
leveneTest(RT2incon.con ~ as.factor(learnva), data = data_exp2, center=mean)
t.test(RT2incon.con ~ learnva, data = data_exp2, var.equal = T)

