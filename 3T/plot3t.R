library(plotly)
library(stringr)
library(data.table)
library(psych)
library(ggpubr)
library(ggprism)
library(patchwork)
library(Rmisc)
library(R.matlab)
library(Hmisc)
library(dataPreparation)
# set to 0.5 will results in 32/30
theme_set(theme_prism(base_line_size = 15/64, base_rect_size = 15/64))
showtext::showtext_auto(enable = F)
sysfonts::font_add("Helvetica","Helvetica.ttc")
theme_update(text=element_text(family="Helvetica",face = "plain"))

# 1 functions -------------------------------------------------------------
extractdata <- function(txtname){
  # use comment.char = "" to avoid problems caused by "#"
  data <- read.table(txtname,header = TRUE,fill=TRUE,comment.char = "",
                     colClasses = c("character","character","NULL","character"),
                     col.names = c("id","condition","Null","NZmean"))
  # sub
  sub <- strsplit(data$id,"\\/")
  sub <- sapply(sub,"[",1)
  data$id <- sub
  # conditions: extract first character from data$condition
  data$condition <- as.numeric(substr(data$condition,1,1))+1
  # converter to numeric
  data$NZmean <- as.numeric(data$NZmean)
  return(data)
}

# boxplot
ci90 <- function(x){
  # return(qnorm(0.95)*sd(x)/sqrt(length(x)))
  # similar to 5% and 90%
  return(qnorm(0.95)*sd(x))
}

boxset <- function(data){
  data <- na.omit(data)
  summarise(data,
            m = mean(Score),
            y0 = quantile(Score, 0.05), 
            #y0 = mean(Score)-ci90(Score),
            y25 = quantile(Score, 0.25), 
            y50 = median(Score), 
            # y50 = mean(Score), 
            y75 = quantile(Score, 0.75), 
            #y100 = mean(Score)+ci90(Score))
            y100 = quantile(Score, 0.95))
}

# boxplot with horizontal line
boxplotv <- function(data, con, select){
  # select data
  Violin_data <- subset(data,select = c("id",select))
  Violin_data <- reshape2::melt(Violin_data, c("id"),variable.name = "Task", value.name = "Score")
  test="Plea"
  tests <- c("Pleasant","Unpleasant")
  
  Violin_data <- mutate(Violin_data,
                        test=ifelse(str_detect(Task,test),tests[1],tests[2]),
                        condition=ifelse(str_detect(Task,con[1]),con[1],con[2]))
  Violin_data$test <- factor(Violin_data$test, levels = tests,ordered = TRUE)
  Violin_data$condition <- factor(Violin_data$condition, levels = con, labels = str_to_title(con), ordered = F)
  
  # summarise data 5% and 90% quantile
  df <- ddply(Violin_data, .(condition, test), boxset)
  # df <- Violin_data %>% group_by(condition, test) %>% boxset
  
  # jitter
  set.seed(111)
  Violin_data <- transform(Violin_data, con = ifelse(test == tests[1], 
                                                     jitter(as.numeric(condition) - 0.15, 0.3),
                                                     jitter(as.numeric(condition) + 0.15, 0.3) ))
  # boxplot
  ggplot(data=Violin_data, aes(x=condition)) + 
    # geom_boxplot(aes(y=Score,color=test),
    #              outlier.shape = NA, fill="white", width=0.5, position = position_dodge(0.6))+
    geom_errorbar(data=df, position = position_dodge(0.6), size=15/64,
                  aes(ymin=y0,ymax=y100,color=test),linetype = 1,width = 0.3)+ # add line to whisker
    geom_boxplot(data=df, size=15/64,
                 aes(ymin = y0, lower = y25, middle = y50, upper = y75, ymax = y100,color=test),
                 outlier.shape = NA, fill="white", width=0.5, position = position_dodge(0.6),
                 stat = "identity") +
    scale_color_manual(values=c("#faa61e","#5067b0"))+
    # geom_point(aes(x=con, y=Score,fill=test), size = 0.5, color = "gray",show.legend = F)+
    geom_line(aes(x=con,y=Score,group = interaction(id,condition)), size=15/64, color = "#e8e8e8")+
    theme(axis.title.x=element_blank())
}

lineplot <- function(data, con, select){
  # select data
  Violin_data <- subset(data,select = c("id",select))
  Violin_data <- reshape2::melt(Violin_data, c("id"),variable.name = "Task", value.name = "Score")
  test="Plea"
  tests <- c("Pleasant","Unpleasant")

  Violin_data <- mutate(Violin_data,
                        test=ifelse(str_detect(Task,test),tests[1],tests[2]),
                        condition=ifelse(str_detect(Task,con[1]),con[1],con[2]))
  Violin_data$test <- factor(Violin_data$test, levels = tests,ordered = TRUE)
  Violin_data$condition <- factor(Violin_data$condition, levels = con, labels = str_to_title(con), ordered = F)
  
  df <- summarySEwithin(Violin_data,measurevar = "Score",withinvars = c("condition","test"),idvar = "id",na.rm = T)
  
  # lineplot
  pd <- position_dodge(0.15)
  ggplot(data=df, aes(x=condition,y=Score,color=test)) + 
    geom_point(size = 0.5, show.legend = F)+
    geom_line(aes(group=test), size=15/64,stat = "identity")+
    geom_errorbar(aes(ymin=Score-se, ymax=Score+se), size=15/64, width=.15)+
    scale_color_manual(values=c("#faa61e","#5067b0"))+
    scale_fill_manual(values = c("#faa61e","#5067b0")) +
    theme(axis.title.x=element_blank())
}

# default boxplot
boxplotd <- function(data, select, colors=rep("black",each=length(select))){
  # select data
  Violin_data <- subset(data, select = c("id", select))
  Violin_data <- reshape2::melt(Violin_data, c("id"),variable.name = "parameter", value.name = "Score")
  # convert parameter into factor
  # Violin_data$parameter <- factor(Violin_data$parameter,levels = select)
  # summarise data 5% and 90% quantile
  df <- ddply(Violin_data, .(parameter), boxset)
  pd <- 0.6# boxplot
  # jitter
  set.seed(111)
  Violin_data <- transform(Violin_data, con = jitter(as.numeric(parameter), amount = 0.05))
  # replace NA values with 99
  Violin_data <- replace(Violin_data,is.na(Violin_data),99)
  ggplot(data = Violin_data, aes(x = parameter)) +
    geom_errorbar(
      data = df, position = position_dodge(0.6), show.legend = F, size=15/64,
      aes(ymin = y0, ymax = y100, color = parameter), linetype = 1, width = 0.15) + # add line to whisker
    geom_boxplot(
      data = df,
      aes(ymin = y0, lower = y25, middle = y50, upper = y75, ymax = y100, color = parameter), size=15/64,
      outlier.shape = NA, fill = "white", width = 0.25, position = position_dodge(0.6),
      stat = "identity", show.legend = F) +
    # geom_text(aes(label = id, x = con+0.25, y = Score), size = 3.5)+
    geom_point(aes(x = con, y = Score, group = id), size = 0.5, color = "gray", show.legend = F) +
    scale_color_manual(values = colors)+
    geom_hline(yintercept = 0.5, size=15/64, linetype = "dashed", color = "black")+
    theme(axis.title.x = element_blank())
}
# default boxplot with txt
boxplotdt <- function(data, select, colors=rep("black",each=length(select))){
  # select data
  Violin_data <- subset(data, select = c("id", select))
  Violin_data <- reshape2::melt(Violin_data, c("id"),variable.name = "parameter", value.name = "Score")
  # convert parameter into factor
  # Violin_data$parameter <- factor(Violin_data$parameter,levels = select)
  # summarise data 5% and 90% quantile
  df <- ddply(Violin_data, .(parameter), boxset)
  pd <- 0.6# boxplot
  # jitter
  set.seed(111)
  Violin_data <- transform(Violin_data, con = jitter(as.numeric(parameter), amount = 0.05))
  # replace NA values with 99
  Violin_data <- replace(Violin_data,is.na(Violin_data),99)
  ggplot(data = Violin_data, aes(x = parameter)) +
    geom_errorbar(
      data = df, position = position_dodge(0.6), show.legend = F, size=15/64,
      aes(ymin = y0, ymax = y100, color = parameter), linetype = 1, width = 0.15) + # add line to whisker
    geom_boxplot(
      data = df,
      aes(ymin = y0, lower = y25, middle = y50, upper = y75, ymax = y100, color = parameter), size=15/64,
      outlier.shape = NA, fill = "white", width = 0.25, position = position_dodge(0.6),
      stat = "identity", show.legend = F) +
    geom_text(aes(label = id, x = con+0.5, y = Score), size = 3.5,position=position_jitter(width=0.2,height=0.01))+
    geom_point(aes(x = con, y = Score, group = id), size = 0.5, color = "gray", show.legend = F) +
    scale_color_manual(values = colors)+
    geom_hline(yintercept = 0.5, size=15/64, linetype = "dashed", color = "black")+
    theme(axis.title.x = element_blank())
}

boxplot <- function(data, con, select, hx=0){
  # select data
  Violin_data <- subset(data, select = c("id", select))
  Violin_data <- mutate(Violin_data, condition = con)
  # rename select to Score
  Violin_data <- dplyr::rename(Violin_data, Score = all_of(select))
  Violin_data$condition <- factor(Violin_data$condition, levels = con, labels = str_to_title(con), ordered = F)
  
  # summarise data 5% and 90% quantile
  df <- ddply(Violin_data, .(condition), boxset)
  
  # jitter
  set.seed(111)
  Violin_data <- transform(Violin_data, con = jitter(as.numeric(condition), amount = 0.05))
  # replace NA values with 99
  Violin_data <- replace(Violin_data,is.na(Violin_data),99)
  # boxplot
  ggplot(data = Violin_data, aes(x = condition)) +
    geom_errorbar(
      data = df, position = position_dodge(0.6), color = '#50acdf', size=15/64,
      aes(ymin = y0, ymax = y100), linetype = 1, width = 0.15) + # add line to whisker
    geom_boxplot(
      data = df,
      aes(ymin = y0, lower = y25, middle = y50, upper = y75, ymax = y100), size=15/64,
      outlier.shape = NA, fill = "white", width = 0.25, position = position_dodge(0.6),
      stat = "identity", color = '#50acdf') +
    geom_point(aes(x = con, y = Score), size = 0.5, color = "gray", show.legend = F) +
    geom_hline(yintercept = hx, size=15/64, linetype = "dashed", color = "black")+
    theme(axis.title.x = element_blank())
}
# box plot for comparision
boxcp <- function(data, con, select, colors=rep("black",each=length(select))){
  # select data
  Violin_data <- subset(data,select = c("id",select))
  Violin_data <- reshape2::melt(Violin_data, c("id"),variable.name = "Task", value.name = "Score")
  Violin_data <- mutate(Violin_data,
                        condition=ifelse(str_detect(Task,con[1]),con[1],con[2]))
  Violin_data$condition <- factor(Violin_data$condition, levels = con, labels = str_to_title(con), ordered = F)
  
  # summarise data 5% and 90% quantile
  df <- ddply(Violin_data, .(condition), boxset)
  # jitter
  set.seed(111)
  Violin_data <- transform(Violin_data, con = jitter(as.numeric(condition), 0.3))
  # boxplot
  ggplot(data=Violin_data, aes(x=condition)) + 
    # geom_boxplot(aes(y=Score,color=test),
    #              outlier.shape = NA, fill="white", width=0.5, position = position_dodge(0.6))+
    geom_errorbar(data=df, position = position_dodge(0.6), show.legend = F, size=15/64,
                  aes(ymin=y0,ymax=y100,color = condition),linetype = 1,width = 0.15)+ # add line to whisker
    geom_boxplot(data=df, show.legend = F,
                 aes(ymin = y0, lower = y25, middle = y50, upper = y75, ymax = y100, color = condition),
                 outlier.shape = NA, fill="white", width=0.25, position = position_dodge(0.6),
                 stat = "identity", size=15/64) +
    scale_color_manual(values = colors)+
    # geom_point(aes(x=con, y=Score), size = 0.5, color = "gray",show.legend = F)+
    geom_line(aes(x=con,y=Score,group = interaction(id)), color = "#e8e8e8", size = 0.15*0.15/0.32)+
    theme(axis.title.x=element_blank())
}
# function for loading mvpa acc
readacc <- function(mvpa_pattern,con,roi_order) {
  path <- "/Volumes/WD_F/gufei/3t_cw/"
  ana <- c("de")
  data <- data.frame(id=0,roi=0,con=0,acc=0)
  data <- data[-1,]
  subs <- c(sprintf('S%02d',c(3:29)))
  for (sub in subs) {
    workingdir <- paste0(path,sub,'/',sub,'.',ana,'.results/mvpa')
    mvpa <- dir(path=workingdir,pattern = mvpa_pattern)
    for (m in mvpa){
      # roi
      for (r in roi_order){
        for (c in con){
          # read mat file
          mat <- readMat(file.path(workingdir,m,paste(c,r,sep='_'),'res_confusion_matrix.mat'))
          # find acc
          acc <- mat$results[[9]][[1]][[1]][[1]]
          # average diagonal of acc
          acc <- mean(diag(acc))/100
          data[nrow(data)+1,] <- c(sub,r,c,acc)
        }
      }
    }
  }
  data[,4] <- as.numeric(data[,4])
  data <- mutate(data, roi=factor(roi,levels = roi_order))
  return(data)
}
# function to remove outliers
FindOutliers <- function(data,nsigma=2) {
  mean_data <- mean(data, na.rm = TRUE)
  sd_data <- sd(data, na.rm = TRUE)
  upper = nsigma*sd_data + mean_data
  lower = mean_data - nsigma*sd_data
  replace(data, data > upper | data < lower, NA)
}
# 2 Main -------------------------------------------------------------
# load data
data_dir <- "/Volumes/WD_F/gufei/3T_cw/stats/"
figure_dir <- "/Volumes/WD_F/gufei/3T_cw/results_labels_r/"
dresults <- list()
alldata <- list()
data_names <- c("Amy8_align","Pir_new","fusiformCA","FFA_CA",
                "FFV_CA", "insulaCA", "OFC6mm", "aSTS_OR","OFC_AAL")
data_names <- c("Amy8_at165","Pir_new_at165","fusiformCA_at165","FFA_CA_at165",
                "FFV_CA_at165", "insulaCA_at165", "OFC6mm_at165", "aSTS_OR_at165")
data_names <- c("p2acc_OFC_AAL_inter3",
                "sm_OFC_AAL_inter3")
data_names <- c("p2acc_OFC_AAL_inter3",
                "sm_OFC_AAL_inter3",
                "p2acc_Amy_inter3",
                "sm_Amy_inter3")
prefix <- 'indi8con_'
# for each data_name
for (data_name in data_names) {
txtname <- paste0(data_dir,prefix,data_name,'.txt')
betas <- extractdata(txtname)
names <- c('FearPleaVis','FearPleaInv','FearUnpleaVis','FearUnpleaInv',
           'HappPleaVis','HappPleaInv','HappUnpleaVis','HappUnpleaInv')
# convert betas$condition to factors
betas$condition <- factor(betas$condition, levels = c(1:8), labels = names, ordered = F)
# reshape data to wide format
betas <- reshape2::dcast(betas, id ~ condition, value.var = "NZmean")
if (str_detect(prefix,"ppi")) {
# add vis-inv columns
betas <- mutate(betas,vis = rowMeans(betas[,c(2,4,6,8)]),inv = rowMeans(betas[,c(3,5,7,9)]))
betas <- mutate(betas,vin = vis-inv)
# ttest
cat("*********",data_name,"ttest","*********")
betas <- dplyr::mutate_if(betas,is.numeric, FindOutliers)
bruceR::TTEST(betas, names)
# average names in betas
bruceR::TTEST(betas,c("vis","inv","vin"))
bruceR::TTEST(betas,c("vis","inv"),paired = T)
} else {
  # add con-incon columns
  betas <- mutate(betas,incon = rowMeans(betas[,c(2,3,8,9)]),con = rowMeans(betas[4:7]))
  betas <- mutate(betas,coin = con-incon)
  betas <- mutate(betas,inconvis = rowMeans(betas[,c(2,8)]),convis = rowMeans(betas[,c(4,6)]))
  betas <- mutate(betas,coinvis = -(convis-inconvis))
  betas <- mutate(betas,inconinv = rowMeans(betas[,c(3,9)]),coninv = rowMeans(betas[,c(5,7)]))
  betas <- mutate(betas,coininv = -(coninv-inconinv))
  cat("*********",data_name,"congrency ttest","*********")
  betas <- dplyr::mutate_if(betas,is.numeric, FindOutliers)
  bruceR::TTEST(betas,c("coinvis","coininv"))
  bruceR::TTEST(betas,c("coinvis","coininv"),paired = T)
}
# # average names in betas
# bruceR::TTEST(betas,c("con","incon","coin","vis","inv","vin"))
# bruceR::TTEST(`names<-`(as.data.frame(rowMeans(betas[-1])),"x"),"x")

# # ANOVA
# cat("*********",data_name,"Invisible","*********")
# bruceR::MANOVA(betas, dvs=c('FearPleaInv','FearUnpleaInv','HappPleaInv','HappUnpleaInv'), dvs.pattern="(Happ|Fear)(PleaInv|UnpleaInv)",
#                within=c("face", "odor"))
# 
# cat("*********",data_name,"Visible","*********")
# bruceR::MANOVA(betas, dvs=c('FearPleaVis','FearUnpleaVis','HappPleaVis','HappUnpleaVis'), dvs.pattern="(Happ|Fear)(PleaVis|UnpleaVis)",
#                within=c("face", "odor"))
# 
# cat("*********",data_name,"ALL","*********")
# bruceR::MANOVA(betas, dvs=c('FearPleaInv','FearUnpleaInv','HappPleaInv','HappUnpleaInv',
#                             'FearPleaVis','FearUnpleaVis','HappPleaVis','HappUnpleaVis'),
#                dvs.pattern="(Happ|Fear)(Plea|Unplea)(Inv|Vis)",
#                within=c("face", "odor", "visibility"))
# # # 3 lineplots -------------------------------------------------------------------
# # invisible
# line_hfinv <- lineplot(betas,c("Happ","Fear"),c('FearPleaInv','FearUnpleaInv','HappPleaInv','HappUnpleaInv'))+
#   # coord_cartesian(ylim = c(-0.2,0))+
#   # scale_y_continuous(expand = c(0,0),
#   #                    breaks = seq(from=-0.2, to=0, by=0.1))+
#   labs(y="Mean Beta",title = "Invisible")+
#   scale_x_discrete(labels=c("Happy","Fearful"))
# # visible
# line_hfvis <- lineplot(betas,c("Happ","Fear"),c('FearPleaVis','FearUnpleaVis','HappPleaVis','HappUnpleaVis'))+
#   # coord_cartesian(ylim = c(-0.2,0))+
#   # scale_y_continuous(expand = c(0,0),
#   #                    breaks = seq(from=-0.2, to=0, by=0.1))+
#   labs(y="Mean Beta",title = "Visible")+
#   scale_x_discrete(labels=c("Happy","Fearful"))
# # save
# line <- wrap_plots(line_hfinv,line_hfvis,ncol = 2,guides = 'collect')+plot_annotation(tag_levels = "A")
# print(line)
# ggsave(paste0(figure_dir,ifelse(str_detect(prefix,"ppi"),"ppiline_","line_"), data_name, ".pdf"), line, width = 8, height = 4,
#        device = cairo_pdf)
# # 3 boxplots -------------------------------------------------------------------
# # invisible
# box_hfinv <- boxplotv(betas,c("Happ","Fear"),c('FearPleaInv','FearUnpleaInv','HappPleaInv','HappUnpleaInv'))+
#   # coord_cartesian(ylim = c(-0.7,0.5))+
#   # scale_y_continuous(expand = c(0,0),
#   #                    breaks = seq(from=-0.65, to=0.4, by=0.2))+
#   labs(y="Mean Beta",title = "Invisible")+
#   scale_x_discrete(labels=c("Happy","Fearful"))
# # visible
# box_hfvis <- boxplotv(betas,c("Happ","Fear"),c('FearPleaVis','FearUnpleaVis','HappPleaVis','HappUnpleaVis'))+
#   # coord_cartesian(ylim = c(-0.7,0.5))+
#   # scale_y_continuous(expand = c(0,0),
#   #                    breaks = seq(from=-0.65, to=0.4, by=0.2))+
#   labs(y="Mean Beta",title = "Visible")+
#   scale_x_discrete(labels=c("Happy","Fearful"))
# # save
# box <- wrap_plots(box_hfinv,box_hfvis,ncol = 2,guides = 'collect')+plot_annotation(tag_levels = "A")
# print(box)
# ggsave(paste0(figure_dir,ifelse(str_detect(prefix,"ppi"),"ppibox_","box_"), data_name, ".pdf"), box, width = 8, height = 4,
#        device = cairo_pdf)
# visible invisble compare
# laby <- ifelse(str_detect(prefix,"ppi"),paste0("Connectivity with ",strsplit(data_names,"_")[[1]][1]),"Mean Beta")
# box_vin <- boxcp(betas,c("vis","inv"),c("vis","inv"))+
#   labs(y=laby)+
#   # coord_cartesian(ylim = c(-0.2,0.4))+
#   geom_hline(yintercept = 0, size = 15/64, linetype = "dashed", color = "black")+
#   scale_x_discrete(labels=c("Visible","Invisible"))
# ggsave(paste0(figure_dir,ifelse(str_detect(prefix,"ppi"),"ppiboxvin_","boxvin_"), data_name, ".pdf"), box_vin, width = 3, height = 3,
#        device = cairo_pdf)
}

# 4 boxplot for con-incon -------------------------------------------------------------------
# load data
data_dir <- "/Volumes/WD_F/gufei/3T_cw/stats/"
figure_dir <- "/Volumes/WD_F/gufei/3T_cw/results_labels_r/"
data_name <- c("Indiv40_0.001_fointer_inv_Amy")
prefix <- 'indi8con_'
txtname <- paste0(data_dir,prefix,data_name,'.txt')
betas <- extractdata(txtname)
names <- c('FearPleaVis','FearPleaInv','FearUnpleaVis','FearUnpleaInv',
           'HappPleaVis','HappPleaInv','HappUnpleaVis','HappUnpleaInv')
# convert betas$condition to factors
betas$condition <- factor(betas$condition, levels = c(1:8), labels = names, ordered = F)
# reshape data to wide format
betas <- reshape2::dcast(betas, id ~ condition, value.var = "NZmean")
# add con-incon columns
betas <- mutate(betas,incon = rowMeans(betas[,c(2,3,8,9)]),con = rowMeans(betas[4:7]))
betas <- mutate(betas,coin = -(con-incon))
betas <- mutate(betas,inconvis = rowMeans(betas[,c(2,8)]),convis = rowMeans(betas[,c(4,6)]))
betas <- mutate(betas,coinvis = -(convis-inconvis))
betas <- mutate(betas,inconinv = rowMeans(betas[,c(3,9)]),coninv = rowMeans(betas[,c(5,7)]))
betas <- mutate(betas,coininv = -(coninv-inconinv))
alldata[["betainter"]] <- betas
# ttest
# bruceR::TTEST(betas,c("coin","coinvis","coininv"))
# bruceR::TTEST(betas,c("coinvis","coininv"),paired = T)
# betas <- remove_sd_outlier(betas,c("coinvis","coininv"),n_sigmas = 2)
betas <- dplyr::mutate_if(betas,is.numeric, FindOutliers)
bruceR::TTEST(betas,c("coinvis","coininv"))
bruceR::TTEST(betas,c("coinvis","coininv"),paired = T)
# invisible
line_hfinv <- lineplot(betas,c("Happ","Fear"),c('FearPleaInv','FearUnpleaInv','HappPleaInv','HappUnpleaInv'))+
  labs(y="Mean Beta",title = "Invisible")+
  coord_cartesian(ylim = c(-0.18,0))+
  scale_x_discrete(labels=c("Happy","Fearful"))
# visible
line_hfvis <- lineplot(betas,c("Happ","Fear"),c('FearPleaVis','FearUnpleaVis','HappPleaVis','HappUnpleaVis'))+
  labs(y="Mean Beta",title = "Visible")+
  coord_cartesian(ylim = c(-0.18,0))+
  scale_x_discrete(labels=c("Happy","Fearful"))
# con-incon for amy interaction invisible
coinbox <- boxplot(betas,"Amy_invis_inter","coininv",0)+
  coord_cartesian(ylim = c(-0.18,0.25))+
  scale_y_continuous(name = "Mean Beta Difference",expand = expansion(add = c(0,0)),breaks = c(seq(from=-0.2, to=0.2, by=0.1)))
# boxcp for visible and invisible
box_convin <- boxcp(betas,c("coinvis","coininv"),c("coininv","coinvis"),c("#f8766d","#00ba38"))+
  labs(y="Beta Difference\n(congruent & incongruent)")+
  geom_hline(yintercept = 0, size = 15/64, linetype = "dashed", color = "black")+
  coord_cartesian(ylim = c(-0.2,0.3))+
  scale_x_discrete(labels=c("Visible","Invisible"))
print(box_convin)
ggsave(paste0(figure_dir,"amy_convin.pdf"), box_convin, width = 3, height = 3,
       device = cairo_pdf)
# save
amy <- wrap_plots(line_hfinv,line_hfvis,coinbox,box_convin,ncol = 2)
print(amy)
ggsave(paste0(figure_dir,ifelse(str_detect(prefix,"ppi"),"ppiamy","amy"), ".pdf"), amy, width = 8, height = 6)

# ppi with OFC
data_name <- "OFC_AAL"
prefix <- 'indi8conppi_'
# for each data_name
txtname <- paste0(data_dir,prefix,data_name,'.txt')
betas <- extractdata(txtname)
names <- c('FearPleaVis','FearPleaInv','FearUnpleaVis','FearUnpleaInv',
           'HappPleaVis','HappPleaInv','HappUnpleaVis','HappUnpleaInv')
# convert betas$condition to factors
betas$condition <- factor(betas$condition, levels = c(1:8), labels = names, ordered = F)
# reshape data to wide format
betas <- reshape2::dcast(betas, id ~ condition, value.var = "NZmean")
# add con-incon columns
betas <- mutate(betas,incon = rowMeans(betas[,c(2,3,8,9)]),con = rowMeans(betas[4:7]))
betas <- mutate(betas,vis = rowMeans(betas[,c(2,4,6,8)]),inv = rowMeans(betas[,c(3,5,7,9)]))
betas <- mutate(betas,coin = con-incon)
betas <- mutate(betas,vin = vis-inv)
alldata[["betappi"]] <- betas
# ttest
cat("*********",data_name,"ttest","*********")
betas <- dplyr::mutate_if(betas,is.numeric, FindOutliers)
bruceR::TTEST(betas, names)
# average names in betas
bruceR::TTEST(betas,c("vis","inv","vin"))
bruceR::TTEST(betas,c("vis","inv"),paired = T)
# visible invisble compare
laby <- ifelse(str_detect(prefix,"ppi"),paste0("Connectivity with ",strsplit(data_names,"_")[[1]][1]),"Mean Beta")
box_vin <- boxcp(betas,c("vis","inv"),c("vis","inv"),c("#f8766d","#00ba38"))+
  labs(y=laby)+
  # coord_cartesian(ylim = c(-0.2,0.4))+
  geom_hline(yintercept = 0, size = 15/64, linetype = "dashed", color = "black")+
  scale_x_discrete(labels=c("Visible","Invisible"))
ggsave(paste0(figure_dir,ifelse(str_detect(prefix,"ppi"),"ppiboxvin_","boxvin_"), data_name, ".pdf"), box_vin, width = 3, height = 3,
       device = cairo_pdf)
# save
amyinter <- wrap_plots(box_convin,box_vin,ncol = 2)
print(amyinter)
ggsave(paste0(figure_dir,"Amy_inter", ".pdf"), amyinter, width = 7, height = 3)

# 5 rating results -------------------------------------------------------------------
# load data
rating <- Hmisc::spss.get(paste0(data_dir,"../Rose_Fish_rating.sav"))
info <- Hmisc::spss.get(paste0(data_dir,"../info.sav"))
info$id <- str_remove(info$id," ")
info <- subset(info,!id%in%c("S01","S02"))
describe(info$age)
table(info$gender)
# Intensity
bruceR::TTEST(rating,c("Intensity.Rose","Intensity.Fish"),paired = T)
ratein <- boxcp(rating,c("Rose","Fish"),c("Intensity.Rose", "Intensity.Fish"),c("#faa61e","#5067b0"))+
  coord_cartesian(ylim = c(1,7))+
  scale_y_continuous(name = "Odor intensity",breaks = c(1,seq(from=2, to=7, by=1)))
# Valence
bruceR::TTEST(rating,c("Valence.Rose","Valence.Fish"),paired = T)
rateva <- boxcp(rating,c("Rose","Fish"),c("Valence.Rose", "Valence.Fish"),c("#faa61e","#5067b0"))+
  coord_cartesian(ylim = c(1,7))+
  scale_y_continuous(name = "Odor pleasantness",breaks = c(1,seq(from=2, to=7, by=1)))
ratemri <-  wrap_plots(ratein,rateva,ncol = 2)
print(ratemri)
ggsave(paste0(figure_dir,"ratings.pdf"),ratemri, width = 4, height = 3,
       device = cairo_pdf)
alldata[["rating"]] <- merge(info,rating,all=T)

# 6 mvpa results -------------------------------------------------------------------
facecon <- c("vis","inv","all")
# transcon <- c("inv_vis","vis_inv","test_inv","test_vis","train_inv","train_vis")
# translabel <- c("Invisible Face\nVisible Face","Visible Face\nInvisible Face",
#                 "Odor\nInvisible Face","Odor\nVisible Face",
#                 "Invisible Face\nOdor","Visible Face\nOdor")
transcon <- c("vis_inv","inv_vis","train_vis","test_vis","train_inv","test_inv")
trans3con <- c("avg_visinv", "avg_visodo", "avg_invodo")
transconnew <- c("train_visinv","test_visinv","train_visodo","test_visodo","train_invodo","test_invodo")
translabel <- c("VisFace\nInvFace","InvFace\nVisFace",
                "VisFace\nOdor","Odor\nVisFace",
                "InvFace\nOdor","Odor\nInvFace")
translabelnew <- c("Visible\nInvisible","Visible\nOlfactory","Invisible\nOlfactory")
rois <- c("Amy8_align","OFC_AAL","FFV_CA_max3v","Pir_new005")
rois <- c("FFV_CA_max2v", "FFV_CA_max3v", "FFV_CA_max4v", "FFV_CA_max5v", "FFV_CA_max6v")
rois <- c("FFV_CA_max2v")
ffvs <- c("FFV_CA01", "FFV_CA05", "FFV_CA005", "FFV_CA001", "FFV_CA_max3v", "FFV_CA_max4v", "FFV_CA_max5v", "FFV_CA_max6v")

# decoding results
for (roi in rois[1:3]) {
  testface <- readacc("roi_face_shift6",facecon[1:2],roi)
  # testface$con <- paste0("face_",testface$con)
  testodor <- readacc("roi_odor_shift6",facecon[3],roi)
  # testodor$con <- paste0("odor_",testodor$con)
  # decast test
  test <- reshape2::dcast(rbind(testface,testodor), id ~ con, value.var = "acc")
  # save test to dresults
  dresults[[roi]][['normal']] <- test
  # remove sub S15
  # test <- test[-which(test$id%in%c("S15")),]
  # remove 2sd
  # test <- remove_sd_outlier(test,n_sigmas = 2)
  test <- dplyr::mutate_if(test,is.numeric, FindOutliers)
  cat("*********",roi,"*********")
  bruceR::TTEST(test,facecon,test.value=0.5)
  # bruceR::TTEST(dresults[[roi]][['normal']],c("vis","inv"),paired = T)
  if (roi=="OFC_AAL")
    yrange <- c(0.4,0.9)
  else
    yrange <- c(0.3,0.8)
  acc[[roi]] <- boxplotd(test,facecon,c("#f8766d","#00ba38","#619cff"))+
    coord_cartesian(ylim = yrange)+
    scale_y_continuous(name = "Decoding Accuracy",expand = expansion(add = c(0,0)),breaks = c(seq(from=yrange[1], to=yrange[2], by=0.1)))+
    scale_x_discrete(labels=c("Visible","Invisible","Olfactory"))
  print(acc[[roi]])
  ggsave(paste0(figure_dir,"mvpa_",roi, ".pdf"), acc[[roi]], width = 4, height = 3,
         device = cairo_pdf)
}
acc_all <- wrap_plots(acc[[rois[2]]],acc[[rois[1]]],acc[[rois[3]]],ncol =1)
ggsave(paste0(figure_dir,"mvpa_3con.pdf"), acc_all, width = 4, height = 8,
       device = cairo_pdf)

# combine decoding results
test <- dresults[[rois[1]]][['normal']]
names(test)[-1] <- paste0(names(test[-1]),"_",str_sub(rois[1],1,3))
for (roi in rois[2:3]) {
  test0 <- dresults[[roi]][['normal']]
  names(test0)[-1] <- paste0(names(test0[-1]),"_",str_sub(roi,1,3))
  test <- merge(test,test0)
}
alldata[["mvparoi"]] <- test
# remove outliers
test <- dplyr::mutate_if(test,is.numeric, FindOutliers)
bruceR::TTEST(test,names(test)[-1],test.value=0.5)
# melt test and split into two variables
test <- reshape2::melt(test, id.vars = "id")
test <- tidyr::separate(test, variable, c("condition","lesion"), sep = "_")
# convert con and lesion into factor
test$condition <- factor(test$condition, levels = c("vis","inv","all"), labels = c("Visible","Invisible","Olfactory"))
test$lesion <- factor(test$lesion, levels = c("OFC","Amy","FFV"), labels = c("OFC","Amygdala","Fusiform"))
# summarise data 5% and 90% quantile
names(test) <- str_replace(names(test),"value","Score")
df <- ddply(test, .(condition,lesion), boxset)
# jitter
set.seed(111)
n <- length(unique(test$condition))
dg <- 0.8
test <- transform(test, con = jitter(as.numeric(lesion)+(as.numeric(condition)-n/2-0.5)*(dg/n), 0.3))
# replace NA values with 99
test <- replace(test,is.na(test),99)
accs <- ggplot(data=df, aes(x=lesion,color=condition)) + 
  geom_errorbar(position = position_dodge(dg), size = 15/64,
                aes(ymin=y0,ymax=y100),width = 0.3)+ # add line to whisker
  geom_boxplot(stat = "identity", size = 15/64,
               aes(ymin = y0, lower = y25, middle = y50, upper = y75, ymax = y100),
               outlier.shape = NA, fill="white", width=0.5, position = position_dodge(dg)) +
  scale_color_manual(values=c("#f8766d","#00ba38","#619cff"))+
  geom_point(data=test,aes(x=con, y=Score, group = interaction(id,condition)), size = 0.5, color = "gray",show.legend = F)+
  coord_cartesian(ylim = c(0.3,0.91))+
  geom_hline(yintercept = 0.5, size = 15/64, linetype = "dashed", color = "black")+
  scale_y_continuous(expand = expansion(add = c(0,0)),name = "Decoding Accuracy",breaks = seq(from=0.2, to=1, by=0.1))+
  theme(axis.title.x=element_blank())
print(accs)
ggsave(paste0(figure_dir,"mvpa_all.pdf"), accs, width = 6, height = 3,
       device = cairo_pdf)

# trans decoding results
acct <- list()
acctv <- list()
for (roi in rois[1:2]) {
  test <- readacc("roi_newtrans_shift6",transcon,roi)
  # decast test
  test <- reshape2::dcast(test, id ~ con, value.var = "acc")
  # average into three conditions
  test <- mutate(test,avg_visinv = (vis_inv+inv_vis)/2,
                 avg_visodo = (test_vis+train_vis)/2,
                 avg_invodo = (test_inv+train_inv)/2)
  # save test to dresults
  dresults[[roi]][['trans']] <- test
  alldata[[paste0("mvpatrans_",str_sub(roi,1,3))]] <- test
  cat("*********",roi,"*********")
  # remove outliers
  test <- dplyr::mutate_if(test,is.numeric, FindOutliers)
  bruceR::TTEST(test,transcon,test.value=0.5)
  # avgeraged 3 conditions
  bruceR::TTEST(test,trans3con,test.value=0.5)
  # bruceR::TTEST(test,trans3con[c(2,3)],paired = T)
  acctv[[roi]] <- boxplotd(test,trans3con)+
    coord_cartesian(ylim = c(0.3,0.71))+
    scale_y_continuous(name = "Cross Decoding Accuracy",expand = expansion(add = c(0,0)))+
    scale_x_discrete(labels = translabelnew)
  print(acctv[[roi]])
  ggsave(paste0(figure_dir, "mvpa_avgtrans", roi, ".pdf"), acctv[[roi]],
    width = 4, height = 3, device = cairo_pdf)
  # acct[[roi]] <- boxplotd(test,transcon)+
  #   coord_cartesian(ylim = c(0.3,0.71))+
  #   scale_y_continuous(name = "Cross Decoding Accuracy",expand = expansion(add = c(0,0)))+
  #   scale_x_discrete(labels = translabel)
  # print(acct[[roi]])
  
  # group into three conditions
  # melt test and split into two variables
  test <- reshape2::melt(subset(test,select = c("id",transcon)), id.vars = "id")
  test$variable <- factor(test$variable, levels = transcon, labels = transconnew)
  test <- tidyr::separate(test, variable, c("condition","lesion"), sep = "_")
  # convert con and lesion into factor
  test$condition <- factor(test$condition, levels = c("train", "test"), labels = c("train", "test"))
  test$lesion <- factor(test$lesion, levels = c("visinv", "visodo", "invodo"), labels = c("visinv", "visodo", "invodo"))
  # summarise data 5% and 90% quantile
  names(test) <- str_replace(names(test),"value","Score")
  df <- ddply(test, .(condition,lesion), boxset)
  # jitter
  set.seed(111)
  n <- length(unique(test$condition))
  dg <- 0.8
  test <- transform(test, con = jitter(as.numeric(lesion)+(as.numeric(condition)-n/2-0.5)*(dg/n), 0.3))
  # replace NA values with 99
  test <- replace(test,is.na(test),99)
  acct[[roi]] <- ggplot(data=df, aes(x=lesion,color=condition)) + 
    geom_errorbar(position = position_dodge(dg), size = 15/64,
                  aes(ymin=y0,ymax=y100),width = 0.3)+ # add line to whisker
    geom_boxplot(stat = "identity", size = 15/64,
                 aes(ymin = y0, lower = y25, middle = y50, upper = y75, ymax = y100),
                 outlier.shape = NA, fill="white", width=0.5, position = position_dodge(dg)) +
    scale_color_manual(values=c("#000000","#666666"),labels = c("a-b","b-a"))+
    geom_point(data=test,aes(x=con, y=Score, group = interaction(id,condition)), size = 0.5, color = "gray",show.legend = F)+
    coord_cartesian(ylim = c(0.3,0.71))+
    geom_hline(yintercept = 0.5, size = 15/64, linetype = "dashed", color = "black")+
    scale_y_continuous(expand = expansion(add = c(0,0)),name = "Cross Decoding Accuracy",breaks = seq(from=0.2, to=1, by=0.1))+
    scale_x_discrete(labels = translabelnew)+
    theme(axis.title.x=element_blank())
  ggsave(paste0(figure_dir,"mvpa_trans",roi, ".pdf"), acct[[roi]], width = 4, height = 3,
         device = cairo_pdf)
}
ggsave(paste0(figure_dir,"mvpa_transall.pdf"), wrap_plots(acct[[2]],acct[[1]],ncol = 1,guides = 'collect'),
       width = 5, height = 6, device = cairo_pdf)
# average into three conditions
ggsave(paste0(figure_dir,"mvpa_avgtransall.pdf"), wrap_plots(acctv[[2]],acctv[[1]],ncol = 1,guides = 'collect'),
       width = 4, height = 6, device = cairo_pdf)
ggsave(paste0(figure_dir,"mvpa_trans.pdf"), wrap_plots(acctv[[2]],acct[[2]],acctv[[1]],acct[[1]],ncol = 2,guides = 'collect'),
       width = 9, height = 6, device = cairo_pdf)

# results for intersection
level <- c('p2acc','sm');
region <- c('Amy','OFC_AAL');
cons <- c('inter3','visinv','invodo','visodo');
# combine each prefix with each suffix
interroi <- c()
for (l in level) {
  for (r in region) {
    for (c in cons) {
      interroi <- c(interroi,paste(l,r,c,sep = "_"))
    }
  }
}
# decoding results
for (roi in interroi) {
  testface <- readacc("roi_face_shift6",facecon[1:2],roi)
  testodor <- readacc("roi_odor_shift6",facecon[3],roi)
  # decast test
  test <- reshape2::dcast(rbind(testface,testodor), id ~ con, value.var = "acc")
  test <- dplyr::mutate_if(test,is.numeric, FindOutliers)
  cat("*********",roi,"*********")
  bruceR::TTEST(test,facecon,test.value=0.5)
}
# trans decoding results
for (roi in interroi) {
  test <- readacc("roi_newtrans_shift6",transcon,roi)
  # decast test
  test <- reshape2::dcast(test, id ~ con, value.var = "acc")
  # average into three conditions
  test <- mutate(test,avg_visinv = (vis_inv+inv_vis)/2,
                 avg_visodo = (test_vis+train_vis)/2,
                 avg_invodo = (test_inv+train_inv)/2)
  cat("*********",roi,"*********")
  # remove outliers
  test <- dplyr::mutate_if(test,is.numeric, FindOutliers)
  bruceR::TTEST(test,transcon,test.value=0.5)
  # avgeraged 3 conditions
  bruceR::TTEST(test,trans3con,test.value=0.5)
}

# lesion permutation
prefix <- c('face_vis','face_inv','odor_all');
suffix <- c('p1');
# combine each prefix with each suffix
lecons <- c()
for (p in prefix) {
  for (s in suffix) {
    lecons <- c(lecons,paste0(p,'_',s))
  }
}
accl <- list()
for (roi in rois[1:2]) {
  test <- readacc("roi_roimeanperm_shift6",lecons,roi)
  # decast test
  test <- reshape2::dcast(test, id ~ con, value.var = "acc", fun.aggregate = mean)
  # merge lesion connective individual top clusters
  testl2 <- readacc("roi_roilesiontraininteracc_shift6",str_replace(lecons,"p1","l2"),roi)
  # decast test
  testl2 <- reshape2::dcast(testl2, id ~ con, value.var = "acc", fun.aggregate = mean)
  # merge connective individual top clusters
  testp2 <- readacc("roi_roilesiontraininteracc_shift6",str_replace(lecons,"p1","p2"),roi)
  # decast test
  testp2 <- reshape2::dcast(testp2, id ~ con, value.var = "acc", fun.aggregate = mean)
  testl0 <- dresults[[roi]][['normal']]
  names(testl0)[-1] <- paste0(names(testl0)[-1],"_l0")
  test <- merge(merge(merge(test,testl2),testp2),testl0)
  names(test) <- str_replace(names(test),"(face_)?(odor_)?","")
  # save test to dresults
  dresults[[roi]][['roimeanperm']] <- test
  alldata[[paste0("mvpalesion_",str_sub(roi,1,3))]] <- test
  # split p with "_"
  cat("*********",roi,"*********")
  # print(mean(test[,2]))
  # remove outliers
  test <- dplyr::mutate_if(test,is.numeric, FindOutliers)
  bruceR::TTEST(test,names(test)[-1],test.value=0.5)
  cp <- c("inv_p1","inv_l2","vis_p1","vis_l2","all_p1","all_l2",
          "inv_l0","inv_l2","vis_l0","vis_l2","all_l0","all_l2",
          "inv_l0","inv_p2","vis_l0","vis_p2","all_l0","all_p2")
  # paired t-test
  bruceR::TTEST(test,cp,paired = T)
  # melt test and split into two variables
  test <- reshape2::melt(test, id.vars = "id")
  test <- tidyr::separate(test, variable, c("condition","lesion"), sep = "_")
  # convert con and lesion into factor
  test$condition <- factor(test$condition, levels = c("vis","inv","all"), labels = c("Visible","Invisible","Olfactory"))
  test$lesion <- factor(test$lesion, levels = c("l0","p2","l2","p1"), labels = c("Intact","Clusters","Lesion","Random"))
  test <- subset(test,lesion%in%c("Clusters","Lesion","Random"))
  # summarise data 5% and 90% quantile
  names(test) <- str_replace(names(test),"value","Score")
  df <- ddply(test, .(condition,lesion), boxset)
  # jitter
  set.seed(111)
  n <- length(unique(test$lesion))
  dg <- 0.8
  if (n==4){
    test <- transform(test, con = jitter(as.numeric(condition)+(as.numeric(lesion)-n/2-0.5)*(dg/n), 0.3))
  } else{
    test <- transform(test, con = jitter(as.numeric(condition)+(as.numeric(lesion)-n/2-1.5)*(dg/n), 0.3))
  }
  # replace NA values with 99
  test <- replace(test,is.na(test),99)
  accl[[roi]] <- ggplot(data=df, aes(x=condition,color=condition,linetype = lesion)) + 
    geom_errorbar(position = position_dodge(dg), size = 15/64,
                  aes(ymin=y0,ymax=y100),width = 0.3)+ # add line to whisker
    geom_boxplot(stat = "identity", size = 15/64,
                 aes(ymin = y0, lower = y25, middle = y50, upper = y75, ymax = y100),
                 outlier.shape = NA, fill="white", width=0.5, position = position_dodge(dg)) +
    scale_color_manual(values=c("#f8766d","#00ba38","#619cff"))+
    scale_linetype_manual(values = c(1,6,3,5))+
    geom_point(data=test,aes(x=con, y=Score, group = interaction(id,condition)), size = 0.5, color = "gray",show.legend = F)+
    # geom_line(data=test, aes(x=con, y=Score, group = interaction(id,condition)), color = "#e8e8e8",linetype = 1)+
    coord_cartesian(ylim = c(0.3,0.95))+
    guides(color="none")+
    geom_hline(yintercept = 0.5, size = 15/64, linetype = "dashed", color = "black")+
    scale_y_continuous(expand = expansion(add = c(0,0)),name = "Decoding Accuracy",breaks = seq(from=0.2, to=1, by=0.1))+
    theme(axis.title.x=element_blank())
  print(accl[[roi]])
  ggsave(paste0(figure_dir,"mvpa_lesion_",roi, ".pdf"), accl[[roi]], width = 5, height = 3,
         device = cairo_pdf)
}
accs <- wrap_plots(accl[[2]],accl[[1]],ncol = 1, guides = 'collect')
ggsave(paste0(figure_dir,"mvpa_lesionall.pdf"), accs, width = 7, height = 6,
       device = cairo_pdf)
# save alldata into Rdata
saveRDS(alldata, paste0(data_dir,'../alldata.Rdata'))
alldata <- readRDS(paste0(data_dir,'../alldata.Rdata'))
# lapply(alldata, function(x) write.table(data.frame(x), paste0(data_dir,'../data.csv'), append= T, sep=',' ))

# # lesion cluster decoding results
# prefix <- c('face_vis','face_inv','odor_all');
# for (roi in rois[1:2]) {
#   # lecons start with p
#   lecon <- c(paste0(prefix,'_','l0'),paste0(prefix,'_','l00'))
#   # sort lecon
#   lecon <- lecon[c(1,4,2,5,3,6)]
#   test <- readacc("roi_lesion_shift6",lecon,roi)
#   # decast test
#   test <- reshape2::dcast(test, id ~ con, value.var = "acc", fun.aggregate = mean)
#   # save test to dresults
#   dresults[[roi]][['cluster']] <- test
#   cat("*********",roi,"*********")
#   bruceR::TTEST(test,lecon,test.value=0.5)
#   bruceR::TTEST(test,lecon,paired = T)
#   
#   acc <- boxplotd(test,lecon)+
#     coord_cartesian(ylim = c(0.2,0.8))+
#     scale_y_continuous(name = "Decoding Accuracy",expand = expansion(add = c(0,0)))+
#     scale_x_discrete(labels = lecon)
#   print(acc)
#   ggsave(paste0(figure_dir,"mvpa_clusterlesion_",roi, ".pdf"), acc, width = 4, height = 3,
#          device = cairo_pdf)
# }

# # 4 stats number of voxels -------------------------------------------------------------------
# expected threshold
# trials <- 27
# x <- seq(0,trials)
# bi_viz <- data.frame(x,dbinom(x, trials, 0.5), pbinom(x, trials, 0.5))
# names(bi_viz) <- c("number","dbinom","pbinom")
# # bi_viz <- mutate(bi_viz,number = number/trials)
# cri <- as.numeric(bi_viz[min(which(bi_viz$pbinom>0.95)),1])
# rois <- c("Amy","Pir", "fusiformCA", "FFA_CA", "insulaCA", "OFC6mm", "aSTS_OR", "FFV_CA")
# # blank vc: column name is rois
# vc <- data.frame(matrix(ncol = 9, nrow = 0))
# # voxel number
# for (r in rois) {
#   cfile <- paste("count",r,"0.001.txt",sep = "_")
#   # read txt
#   count_data <- read.table(paste0(data_dir,cfile), header = T)
#   # count number of sub in count_data above 0 for each column
#   vc <- rbind(vc, colSums(count_data[,-1]>0))
# }
# # rownames of vc is rois
# rownames(vc) <- rois
# # column names of vc is the same as count_data
# colnames(vc) <- colnames(count_data[,-1])
# # mutate to 1 if vc > cri
# vcbi <- mutate(vc, across(everything(), ~ifelse(.>cri,1,0)))