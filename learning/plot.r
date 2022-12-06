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
library(ggsci)
library(ggpubr)
library(Hmisc)
library(ggunchained)
library(ggthemr)
library(ggprism)
library(stringr)
library(Rmisc)
library(dplyr)
library(tidyr)
library(boot)
library(car)
library(showtext)
library(egg)
library(patchwork)
# ggthemr('fresh',layout = "clean",spacing = 0.5)
theme_set(theme_prism(base_line_size = 0.5))
showtext_auto(enable = F)
font_add("Helvetica","Helvetica.ttc")
theme_update(text=element_text(family="Helvetica",face = "plain"))
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
  
  p_size <- 2
  p_jitter <- 0*p_size
  bound <- max(data[x],data[y])+1
  ggplot(data,aes_(as.name(x),as.name(y)))+
    geom_hline(yintercept = 0, linetype="dashed", color = "black")+
    geom_vline(xintercept = 0, linetype="dashed", color = "black")+
    geom_abline(intercept = 0, slope = 1, color = "black",size = 0.5)+
    geom_point(aes(color = "data"), size = p_size, alpha = 0.5, shape=16,stroke = 0,
               position=position_jitter(h=p_jitter,w=p_jitter,seed = 1))+
    coord_cartesian(xlim = c(-bound,bound),ylim = c(-bound,bound))+
    scale_y_continuous(breaks = scales::breaks_width(10))+
    scale_x_continuous(breaks = scales::breaks_width(10))+
    # theme_prism(base_line_size = 0.5,border = T)+
    # theme(text = element_text(family = "Helvetica"))+
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
    coord_cartesian(ylim = c(1,100))+
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
    tests <- c("Pre-test","Post-test")
  } else if (test=="happy"){
    tests <- c("Happy_odor","Fearful_odor")
  } else if (test=="plus"){
    tests <- c("Plus","Minus")
  } else if (test=="Citral"){
    tests <- c("Citral","Indole")
  } else {
    tests <- c("H","F")
  }
  
  Violin_data <- mutate(Violin_data,
                        test=ifelse(str_detect(Task,test),tests[1],tests[2]),
                        condition=ifelse(str_detect(Task,con[1]),con[1],con[2]))
  Violin_data$test <- factor(Violin_data$test, levels = tests,ordered = TRUE)
  Violin_data$condition <- factor(Violin_data$condition, levels = con, labels = str_to_title(con), ordered = F)
  
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
    scale_y_continuous(expand = expansion(add = c(0,0)),breaks = c(1,seq(from=20, to=100, by=20)))+
    theme(axis.title.x=element_blank())
}

barplot <- function(data, con, select, test="pre"){
  # select data
  Violin_data <- subset(data,select = c("id",select))
  Violin_data <- reshape2::melt(Violin_data, c("id"),variable.name = "Task", value.name = "Score")
  if (test=="pre"){
    tests <- c("Pre-test","Post-test")
  } else if (test=="happy"){
    tests <- c("Happy_odor","Fearful_odor")
  } else if (test=="plus"){
    tests <- c("Plus","Minus")
  } else if (test=="Citral"){
    tests <- c("Citral","Indole")
  } else {
    tests <- c("H","F")
  }
  
  Violin_data <- mutate(Violin_data,
                        test=ifelse(str_detect(Task,test),tests[1],tests[2]),
                        condition=ifelse(str_detect(Task,con[1]),con[1],con[2]))
  Violin_data$test <- factor(Violin_data$test, levels = tests,ordered = TRUE)
  Violin_data$condition <- factor(Violin_data$condition, levels = con, labels = str_to_title(con), ordered = F)
  
  df <- summarySEwithin(Violin_data,measurevar = "Score",withinvars = c("condition","test"),idvar = "id")
  
  # boxplot
  pd <- position_dodge(0.8)
  ggplot(data=df, aes(x=condition,y=Score,fill=test)) + 
    geom_bar(aes(color=test),stat = "identity",
                 width=0.5, position = pd)+
    geom_errorbar(aes(ymin=Score-se, ymax=Score+se),
                  position=pd, width=.2,color = "black")+
    scale_color_manual(values=c("#a1d08d","#f8c898"))+
    coord_cartesian(ylim = c(1.3,1.8))+
    scale_fill_manual(values = c("#a1d08d","#f8c898")) + 
    scale_y_continuous(expand = c(0,0),
                       breaks = seq(from=1.3, to=1.8, by=0.1))+
    theme(axis.title.x=element_blank())
}

# boxplot with horizontal line
boxplotv <- function(data, con, select, test="pre"){
  # select data
  Violin_data <- subset(data,select = c("id",select))
  Violin_data <- reshape2::melt(Violin_data, c("id"),variable.name = "Task", value.name = "Score")
  if (test=="pre"){
    tests <- c("Pre-test","Post-test")
  } else if (test=="happy"){
    tests <- c("Happy_odor","Fearful_odor")
  } else if (test=="plus"){
    tests <- c("Plus","Minus")
  } else if (test=="Citral"){
    tests <- c("Citral","Indole")
  } else {
    tests <- c("H","F")
  }

  Violin_data <- mutate(Violin_data,
                        test=ifelse(str_detect(Task,test),tests[1],tests[2]),
                        condition=ifelse(str_detect(Task,con[1]),con[1],con[2]))
  Violin_data$test <- factor(Violin_data$test, levels = tests,ordered = TRUE)
  Violin_data$condition <- factor(Violin_data$condition, levels = con, labels = str_to_title(con), ordered = F)
  
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
  Violin_data <- transform(Violin_data, con = ifelse(test == tests[1], 
                                                 jitter(as.numeric(condition) - 0.15, 0.3),
                                                 jitter(as.numeric(condition) + 0.15, 0.3) ))
  # boxplot
  ggplot(data=Violin_data, aes(x=condition)) + 
    # geom_boxplot(aes(y=Score,color=test),
    #              outlier.shape = NA, fill="white", width=0.5, position = position_dodge(0.6))+
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
    scale_y_continuous(expand = expansion(add = c(0,0)),breaks = c(1,seq(from=20, to=100, by=20)))+
    theme(axis.title.x=element_blank())
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
    geom_point(aes(group =id, fill=test), size = 0.5, shape=16, color = "gray",show.legend = F,
               position = pd)+
    geom_line(aes(group = id), color = "#e8e8e8", position = pd)+
    facet_grid(~condition) +
    coord_cartesian(ylim = c(1,100))+
    scale_fill_manual(values = c("#233b42","#65adc2")) + 
    scale_y_continuous(breaks = c(1,seq(from=20, to=100, by=20)))
}

# binomial distribution
binomial_plot <- function(trials,positive){
  set.seed(1)
  psize <- 3
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
    scale_y_continuous(expand = c(0,0),breaks=seq(0,1500,500))+
    coord_cartesian(ylim = c(0,1600),clip = 'off') +
    labs(x="Number of subjects",y="Count")+
    geom_point(x=tru,y=psize*10,size=psize,color="red")
}


# binomial distribution
binomial_prob <- function(trials,positive){
  psize <- 3
  
  x <- seq(0,trials)
  bi_viz <- data.frame(x,dbinom(x, trials, 0.5), pbinom(x, trials, 0.5))
  names(bi_viz) <- c("number","dbinom","pbinom")
  bi_viz <- bi_viz[6:24,]
  
  cri <- as.numeric(bi_viz[min(which(bi_viz$pbinom>0.95)),1])
  tru <- as.numeric(bi_viz[bi_viz$number==positive,1])
  # plot binomial distribution
  ggplot(bi_viz,aes(number,dbinom)) +
    geom_col(fill="#4d9dd4")+
    # plot p=0.95
    geom_vline(xintercept = cri,size=0.5,linetype = "dashed", color = "black")+
    scale_y_continuous(expand = c(0,0),breaks=seq(0,0.15,0.05))+
    coord_cartesian(xlim = c(5,23), ylim = c(0,0.16),clip = 'off') +
    labs(x="Number of subjects",y="Probability")+
    geom_point(x=tru,y=psize*0.001,size=psize,color="red")
}

# separate two groups
pair_sep_plot <- function(data,var,c=0){
  after_box_data <- subset(data,select = c("id","gender","pair",var))
  after_box_data <- reshape2::melt(after_box_data, c("id","gender","pair"),variable.name = "Odor", value.name = "Score")
  after_box_data <- mutate(after_box_data, Odor=ifelse(str_detect(Odor,"plus"),"(+)-pinene","(−)-pinene"))
  after_box_data <- mutate(after_box_data, Condition=ifelse((Odor=="(+)-pinene" & pair=="+")|(Odor=="(−)-pinene" & pair=="-"),"Happy","Fearful"))

  after_box_data$Odor <- factor(after_box_data$Odor, levels = c("(+)-pinene","(−)-pinene"),ordered = F)
  after_box_data$pair <- factor(after_box_data$pair, levels = c("+","-"),labels = c("(+)-Happy","(−)-Happy"),ordered = F)
  after_box_data$Condition <- factor(after_box_data$Condition, levels = c("Happy","Fearful"),ordered = F)
  
  # summarise data 5% and 90% quantile
  df <- after_box_data %>% group_by(pair,Odor) %>% 
    summarise(y0 = quantile(Score, 0.05), 
              #y0 = mean(Score)-ci90(Score),
              y25 = quantile(Score, 0.25), 
              y50 = median(Score), 
              y75 = quantile(Score, 0.75), 
              #y100 = mean(Score)+ci90(Score))
              y100 = quantile(Score, 0.95))
  df <- mutate(df, Condition=ifelse((Odor=="(+)-pinene" & pair=="(+)-Happy")|(Odor=="(−)-pinene" & pair=="(−)-Happy"),"Happy","Fearful"))
  df$Condition <- factor(df$Condition, levels = c("Happy","Fearful"),ordered = F)
  
  # jitter
  set.seed(111)
  after_box_data <- transform(after_box_data, con = ifelse(Odor == "(+)-pinene", 
                                                     jitter(as.numeric(pair) - 0.15, 0.3),
                                                     jitter(as.numeric(pair) + 0.15, 0.3) ))
  
  if (c==0){
    ggplot(data=after_box_data, aes(x=pair)) + 
      geom_errorbar(data=df, position = position_dodge(0.6),
                    aes(ymin=y0,ymax=y100,color=Odor),linetype = 1,width = 0.3)+ # add line to whisker
      geom_boxplot(data=df,
                   stat = "identity",
                   aes(ymin = y0, lower = y25, middle = y50, upper = y75, ymax = y100,color=Odor),
                   outlier.shape = NA, fill="white", width=0.5, position = position_dodge(0.6)) +
      scale_color_manual(values=c("grey50","black"))+
      geom_point(aes(x=con, y=Score, group = Odor), size = 0.5, color = "gray",show.legend = F)+
      geom_line(aes(x=con, y=Score, group = interaction(id,pair)), color = "#e8e8e8")+
      coord_cartesian(ylim = c(0,100))+
      # scale_color_npg() +
      scale_y_continuous(expand = expansion(add = c(0,0)),name = "Valence",breaks = c(1,seq(from=20, to=100, by=20)))+
      theme(axis.title.x=element_blank())
  } else {
    ggplot(data=after_box_data, aes(x=pair)) + 
      geom_errorbar(data=df, position = position_dodge(0.6),
                    aes(ymin=y0,ymax=y100,color=Odor),linetype = 1,width = 0.3)+ # add line to whisker
      geom_boxplot(data=df,
                   stat = "identity",
                   aes(ymin = y0, lower = y25, middle = y50, upper = y75, ymax = y100,color=Odor,fill=Condition),
                   outlier.shape = NA, width=0.5, position = position_dodge(0.6)) +
      scale_color_manual(values=c("grey50","black"))+
      geom_point(aes(x=con, y=Score, group = Odor), size = 0.5, color = "gray",show.legend = F)+
      geom_line(aes(x=con, y=Score, group = interaction(id,pair)), color = "#e8e8e8")+
      coord_cartesian(ylim = c(0,100))+
      scale_fill_manual(values = c("#a1d08d","#f8c898")) +
      guides(color = guide_legend(
        order = 1,override.aes = list(fill = NA)))+
      # scale_color_npg() +
      scale_y_continuous(expand = expansion(add = c(0,0)),name = "Valence",breaks = c(1,seq(from=20, to=100, by=20)))+
      theme(axis.title.x=element_blank())
  }
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

# paired t test with cohen's d
bruceR::TTEST(data_exp1, y=c("pre.acc", "after.acc"), paired=TRUE)
# ANOVA
bruceR::MANOVA(data_exp1, dvs=c("prehappy.va","prefear.va", "afterhappy.va", "afterfear.va"), dvs.pattern="(pre|after)(happy|fear).va",
               within=c("learn", "emotion"))%>%
  bruceR::EMMEANS("learn", by="emotion")

bruceR::MANOVA(data_exp1, dvs=c("afterplus.va","afterminus.va"), dvs.pattern="after(plus|minus).va",
               within="pm",between = "pair")%>%
  bruceR::EMMEANS("pm", by="pair")
# 3.1 diag plots -----------------------------------------------------------------

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
p_size <- 2
p_jitter <- 0*p_size
diag1 <- diagplot(data_exp1,"prevadif","aftervadif")+
  geom_point(data = data,aes(prevadif_pm,aftervadif_pm, color = "pm"), size = p_size, alpha = 0.5, shape=16,stroke = 0,
             position=position_jitter(h=p_jitter,w=p_jitter,seed = 1))+
  scale_color_manual(labels = c("Happy/Fearful","Plus/Minus"),values = c(data = "#0073c2", pm = "gray50"))+
  labs(x="Valence difference in pre-test", y="Valence difference in post-test")
ggsave(paste0(data_dir,"diag_va_combine.pdf"),diag1, width = 5, height = 3.5)

# 3.2 correlation plot ----------------------------------------------------

# correplot(data_exp1,"zaftervadif","after.acc","zprevadif","pre.acc")

ggplot(data_exp1, aes(aftervadif,after.acc))+
  geom_point(color = "#0073c2", size = 3, alpha = 0.5,shape=16,stroke=0,
             position=position_jitter(h=0.02,w=0.02, seed = 5))+
  geom_smooth(color = "#0073c2", method = "lm", formula = 'y ~ x')+
  coord_cartesian(ylim = c(0,1))+
  scale_y_continuous(expand=c(0,0),breaks = seq(0.2,1,0.2))+
  scale_x_continuous(breaks = scales::breaks_width(10))+
  labs(x="Valence difference in post-test",y="Discrimination accuracy in post-test")

# use ggscatter
corr1 <- ggscatter(data_exp1, x = "aftervadif", y = "after.acc",alpha = 0.8,size = 3,stroke=0,
          conf.int = TRUE, color = "#4c95c8", shape=16, add = "reg.line",fullrange = F,
          position=position_jitter(h=0.02,w=0.02, seed = 5)) +
  stat_cor(aes(label = paste(..r.label.., ..p.label.., sep = "~`,`~")),
           label.x = -20,show.legend=F)+
  theme_prism(base_line_size = 0.5)+
  theme(text = element_text(family = "Helvetica",face = "plain"))+
  coord_cartesian(ylim = c(0,1))+
  scale_y_continuous(expand=c(0,0),breaks = seq(0.2,1,0.2))+
  scale_x_continuous(breaks = scales::breaks_width(10))+
  labs(x="Valence difference",y="Discrimination accuracy")

ggsave(paste0(data_dir,"correlation.pdf"),corr1, width = 4, height = 4)


# 3.3 distribution --------------------------------------------------------
# count subjects
nochange <- sum(data_exp1$learn.dif==0)
positive <- sum(data_exp1$learn.dif>0)
trials <- nrow(data_exp1)-nochange
dis1 <- binomial_plot(trials,positive)
dis1 <- binomial_prob(trials,positive)
ggsave(paste0(data_dir,"distribution.pdf"),dis1, width = 4, height = 3)

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

va_hf <- boxplotv(data_exp1,c("happy","fearful"),c("prehappy.va","prefear.va","afterhappy.va","afterfear.va"))+
  ylab("Valence")
ggsave(paste0(data_dir,"box_va_hf.pdf"), va_hf, width = 5, height = 4)

boxplotv(data_exp1,c("happy","fearful"),c("prehappy.in","prefear.in","afterhappy.in","afterfear.in"))+
  ylab("Intensity")
ggsave(paste0(data_dir,"box_in_hf.pdf"), width = 5, height = 4)

va_pm <- boxplotv(data_exp1,c("plus","minus"),c("preplus.va","preminus.va","afterplus.va","afterminus.va"))+
  ylab("Valence")+
  scale_x_discrete(labels = paste(c("(+)","(−)"),"\u03B1","pinene",sep = "-"))
ggsave(paste0(data_dir,"box_va_pm.pdf"), va_pm, width = 5, height = 4)

boxplotv(data_exp1,c("plus","minus"),c("preplus.in","preminus.in","afterplus.in","afterminus.in"))+
  ylab("Intensity")
ggsave(paste0(data_dir,"box_in_pm.pdf"), width = 5, height = 4)

# 3.5 pre post_test -----------------------------------------------------------
# select valence in pre and post-test

# va_before <- pair_sep_plot(data_exp1,c("preplus.va","preminus.va"))
# ggsave(paste0(data_dir,"box_va_before.pdf"),va_before, width = 5, height = 4)

va_before <- pair_sep_plot(data_exp1,c("preplus.va","preminus.va"))+
  scale_color_manual(values=c("grey50","black"),labels = paste(c("(+)","(−)"),"\u03B1","pinene",sep = "-"))
ggsave(paste0(data_dir,"box_va_before.pdf"),va_before, width = 5, height = 4, device = cairo_pdf)

# va_after <- pair_sep_plot(data_exp1,c("afterplus.va","afterminus.va"))
# ggsave(paste0(data_dir,"box_va_after.pdf"),va_after, width = 5, height = 4)

va_after <- pair_sep_plot(data_exp1,c("afterplus.va","afterminus.va"))+
  scale_color_manual(values=c("grey50","black"),labels = paste(c("(+)","(−)"),"\u03B1","pinene",sep = "-"))
ggsave(paste0(data_dir,"box_va_after.pdf"),va_after, width = 5, height = 4, device = cairo_pdf)


# 3.6 arrange plots -------------------------------------------------------
# box plots
# exp1_box <- ggarrange(va_before,va_after,va_hf,va_pm,ncol=4)
exp1_box <- wrap_plots(va_hf,va_pm,va_after,va_before,ncol=4)+plot_annotation(tag_levels = "A")

ggsave(paste0(data_dir,"box_exp1.pdf"),
       exp1_box,
       width = 20, height = 3.5,
       device = cairo_pdf)

exp1_other <- wrap_plots(dis1,diag1,corr1,ncol=3)+plot_annotation(tag_levels = "A")
ggsave(paste0(data_dir,"others_exp1.pdf"),
       exp1_other,
       width = 15, height = 4)
# 4 EXP2 analysis --------------------------------------------------------------
# Load Data
data_dir <- "/Volumes/WD_D/gufei/writing/"
data_exp2 <- spss.get(paste0(data_dir,"result_exp2.sav"))
# select data
data_exp2 <- subset(data_exp2, id!=35)

# paired t test with cohen's d
bruceR::TTEST(data_exp2, y=c("con", "incon"), paired=TRUE)
# 4.1 boxplots -------------------------------------------------------------------
# H and F represent visual condition
# boxplot(data_exp2,c("happy","fear"),c("happyF","fearF","happyH","fearH"),test="H")+
box_hf <- boxplotv(data_exp2,c("H","F"),c("happyF","fearF","happyH","fearH"),test="happy")+
  coord_cartesian(ylim = c(0,3.5))+
  scale_y_continuous(expand = c(0,0),breaks = c(seq(from=0, to=3, by=0.5)))+
  labs(y="Response time (s)")+
  scale_x_discrete(labels=c("Happy","Fearful"))
# ggsave(paste0(data_dir,"box_RT_hf.pdf"), width = 5, height = 4)

# plus and minus
box_pm <- boxplotv(data_exp2,c("H","F"),c("plusF","minusF","plusH","minusH"),test="plus")+
  coord_cartesian(ylim = c(0,3.5))+
  scale_y_continuous(expand = c(0,0),breaks = c(seq(from=0, to=3, by=0.5)))+
  labs(y="Response time (s)")+
  scale_x_discrete(labels=c("Happy","Fearful"))
# ggsave(paste0(data_dir,"box_RT_pm.pdf"), width = 5, height = 4)
box <- wrap_plots(box_hf,box_pm,ncol = 2)+plot_annotation(tag_levels = "A")
print(box)
ggsave(paste0(data_dir,"box_2_RT.pdf"), box, width = 10, height = 4,
       device = cairo_pdf)

# diagplot for bootstrapped mean RT
# combine with pm
set.seed(1)
#perform bootstrapping with 1000 replications
reps <- boot(data_exp2[c("happyF","happyH","fearF","fearH")], statistic=boot_mean, R=1000)
data <- data.frame(reps$t)
names(data) <- names(reps$data)
# point size
p_size <- 2
p_jitter <- 0*p_size
bound1 <- round(min(data),1)-0.1
bound2 <- round(max(data),1)+0.1
diag_exp2_faces <- ggplot(data)+
  geom_point(aes(fearF,happyF, color = "f"), size = p_size, alpha = 0.5, shape=16,stroke = 0,
             position=position_jitter(h=p_jitter,w=p_jitter,seed = 1))+
  geom_point(aes(fearH,happyH, color = "h"), size = p_size, alpha = 0.5, shape=16,stroke = 0,
             position=position_jitter(h=p_jitter,w=p_jitter,seed = 1))+
  geom_abline(intercept = 0, slope = 1, color = "black",size = 0.5)+
  coord_cartesian(xlim = c(bound1,bound2),ylim = c(bound1,bound2))+
  scale_color_manual(labels = c("Fearful","Happy"),values = c(f = "#f8c898", h = "#a1d08d"))+
  labs(x="odor paired with fearful faces", y="odor paired with happy faces")
ggsave(paste0(data_dir,"diag_va_faces.pdf"),diag_exp2_faces, width = 5, height = 3.5)
# separate by odors
diag_exp2_odors <- ggplot(data)+
  geom_point(aes(fearF,fearH, color = "f"), size = p_size, alpha = 0.5, shape=16,stroke = 0,
             position=position_jitter(h=p_jitter,w=p_jitter,seed = 1))+
  geom_point(aes(happyF,happyH, color = "h"), size = p_size, alpha = 0.5, shape=16,stroke = 0,
             position=position_jitter(h=p_jitter,w=p_jitter,seed = 1))+
  geom_abline(intercept = 0, slope = 1, color = "black",size = 0.5)+
  coord_cartesian(xlim = c(bound1,bound2),ylim = c(bound1,bound2))+
  scale_color_manual(labels = c("Fearful","Happy"),values = c(f = "#f8c898", h = "#a1d08d"))+
  labs(x="fearful faces", y="happy faces")
ggsave(paste0(data_dir,"diag_va_odors.pdf"),diag_exp2_odors, width = 5, height = 3.5)

# difference between fearful and happy faces
data <- mutate(data,feardiff = fearH-fearF,happydiff = happyH-happyF)
diag_exp2_odors <- ggplot(data)+
  geom_point(aes(feardiff,happydiff), size = p_size, alpha = 0.5, shape=16,stroke = 0,
             position=position_jitter(h=p_jitter,w=p_jitter,seed = 1))+
  geom_abline(intercept = 0, slope = 1, color = "black",size = 0.5)+
  coord_cartesian(xlim = c(0.1,0.3),ylim = c(0.1,0.3))+
  scale_color_manual(values = c(data = "#0073c2"))+
  labs(x="odor paired with fearful faces", y="odor paired with happy faces")


# 4.2 bar plot ----------------------------------------------------------------
bar_hf <- barplot(data_exp2,c("H","F"),c("happyF","fearF","happyH","fearH"),test="happy")+
  labs(y="Response time (s)")+
  theme(legend.title=element_text(size = 12))+
  scale_x_discrete(labels=c("Happy","Fearful"))+
  scale_fill_manual(name = "Odor paired with",
                    values = c("#a1d08d","#f8c898"),labels = c("Happy faces","Fearful faces"))+
  scale_color_manual(name = "Odor paired with",
                     values = c("#a1d08d","#f8c898"),labels = c("Happy faces","Fearful faces"))
ggsave(paste0(data_dir,"bar_RT_hf.pdf"),bar_hf, width = 5, height = 4)
# plus and minus
bar_pm <- barplot(data_exp2,c("H","F"),c("plusF","minusF","plusH","minusH"),test="plus")+
  labs(y="Response time (s)")+
  scale_x_discrete(labels=c("Happy","Fearful"))+
  scale_fill_manual(values = c("#c9caca","#727171"),labels = paste(c("(+)","(−)"),"\u03B1","pinene",sep = "-"))+
  scale_color_manual(values = c("#c9caca","#727171"),labels = paste(c("(+)","(−)"),"\u03B1","pinene",sep = "-"))
ggsave(paste0(data_dir,"bar_RT_pm.pdf"),bar_hf, width = 5, height = 4,
       device = cairo_pdf)
# combine to one plot
# bar <- ggarrange(bar_hf,bar_pm, ncol = 2)
bar <- wrap_plots(bar_hf,bar_pm,ncol = 2)+plot_annotation(tag_levels = "A")
print(bar)
ggsave(paste0(data_dir,"bar_2_RT.pdf"), bar, width = 10, height = 3,
       device = cairo_pdf)

# count subjects
nochange <- sum(data_exp2$learn.dif==0)
positive <- sum(data_exp2$learn.dif>0)
trials <- nrow(data_exp2)-nochange
binomial_plot(trials,positive)
# ggsave(paste0(data_dir,"distribution_exp2.pdf"), width = 4, height = 3)

# correlation between learn.dif and incon_con
data_exp2 <- mutate(data_exp2,RT2incon.con = RT2.incon - RT2.con)
data_exp2 <- mutate(data_exp2,RT1incon.con = RT1.incon - RT1.con)
rposition <- min(data_exp2$learn.dif)
ggscatter(data_exp2, x = "learn.dif", y = "RT2incon.con",alpha = 0.8,
          conf.int = TRUE, palette=c("grey50","black"),add = "reg.line",fullrange = F,
          position=position_jitter(h=0.02,w=0.02, seed = 5)) +
  stat_cor(aes(label = paste(..r.label.., ..p.label.., sep = "~`,`~")),
           label.x = rposition,show.legend=F)+
  theme_prism(base_line_size = 0.5)
# Ftest for equality of variance
# var.test(incon.con ~ learnva, data = data_exp2)
# levene's test for equality of variance
leveneTest(RT2incon.con ~ as.factor(learnva), data = data_exp2, center=mean)
t.test(RT2incon.con ~ learnva, data = data_exp2, var.equal = T)

# 5 EXP visual -----------------------------------------------------
# Load Data
data_dir <- "/Volumes/WD_D/gufei/writing/"
data_expv2 <- spss.get(paste0(data_dir,"result_expv2.sav"))
data_expv3 <- spss.get(paste0(data_dir,"result_expv3.sav"))
# 4.1 boxplots -------------------------------------------------------------------
box_hf <- boxplotv(data_exp2,c("H","F"),c("happyF","fearF","happyH","fearH"),test="happy")+
  coord_cartesian(ylim = c(0,3.5))+
  scale_y_continuous(expand = c(0,0),breaks = c(seq(from=0, to=3, by=0.5)))+
  labs(y="Response time (s)")+
  scale_x_discrete(labels=c("Happy","Fearful"))

# 4.2 barplots -------------------------------------------------------------------
exp_con <- c("Happy","Fearful")
bar2 <- barplot(data_expv2,exp_con,c("Indole.Happy","Indole.Fearful","Citral.Happy","Citral.Fearful"),"Citral")+
  coord_cartesian(ylim = c(1,1.5))+
  scale_y_continuous(name = "Response time (s)",expand = c(0,0),breaks = c(seq(from=1, to=1.5, by=0.1)))+
  scale_x_discrete(labels=exp_con)
ggsave(paste0(data_dir,"box_expv2.pdf"),bar2, width = 5, height = 4)

bar3 <- barplot(data_expv3,exp_con,c("Indole.Happy","Indole.Fearful","Citral.Happy","Citral.Fearful"),"Citral")+
  coord_cartesian(ylim = c(1,1.5))+
  scale_y_continuous(name = "Response time (s)",expand = c(0,0),breaks = c(seq(from=1, to=1.5, by=0.1)))+
  scale_x_discrete(labels=exp_con)
ggsave(paste0(data_dir,"box_expv3.pdf"),bar3, width = 5, height = 4)
# arrange
barv <- wrap_plots(bar2,bar3,ncol = 2)+plot_annotation(tag_levels = "A")
print(barv)
ggsave(paste0(data_dir,"bar_v23_RT.pdf"), barv, width = 10, height = 3)

# all bar plots
bar_all <- wrap_plots(bar2,bar3,bar_hf,bar_pm,ncol = 2)+plot_annotation(tag_levels = "A")
ggsave(paste0(data_dir,"bar_RT.pdf"), bar_all, width = 10, height = 6,
       device = cairo_pdf)
