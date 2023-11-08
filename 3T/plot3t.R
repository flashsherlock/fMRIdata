library(plotly)
library(stringr)
library(data.table)
library(psych)
library(ggpubr)
library(ggprism)
library(patchwork)
library(Rmisc)
theme_set(theme_prism(base_line_size = 0.5))
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
  summarise(data,
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
    geom_errorbar(data=df, position = position_dodge(0.6),
                  aes(ymin=y0,ymax=y100,color=test),linetype = 1,width = 0.3)+ # add line to whisker
    geom_boxplot(data=df,
                 aes(ymin = y0, lower = y25, middle = y50, upper = y75, ymax = y100,color=test),
                 outlier.shape = NA, fill="white", width=0.5, position = position_dodge(0.6),
                 stat = "identity") +
    scale_color_manual(values=c("#faa61e","#5067b0"))+
    # geom_point(aes(x=con, y=Score,fill=test), size = 0.5, color = "gray",show.legend = F)+
    geom_line(aes(x=con,y=Score,group = interaction(id,condition)), color = "#e8e8e8")+
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
  
  df <- summarySEwithin(Violin_data,measurevar = "Score",withinvars = c("condition","test"),idvar = "id")
  
  # lineplot
  pd <- position_dodge(0.15)
  ggplot(data=df, aes(x=condition,y=Score,color=test)) + 
    geom_point(size = 0.5, show.legend = F)+
    geom_line(aes(group=test),stat = "identity")+
    geom_errorbar(aes(ymin=Score-se, ymax=Score+se),width=.15)+
    scale_color_manual(values=c("#faa61e","#5067b0"))+
    scale_fill_manual(values = c("#faa61e","#5067b0")) +
    theme(axis.title.x=element_blank())
}

# default boxplot
boxplotd <- function(data, select, colors=rep("black",each=length(select))){
  # select data
  Violin_data <- subset(data, select = c("id", select))
  Violin_data <- reshape2::melt(Violin_data, c("id"),variable.name = "parameter", value.name = "Score")
  # summarise data 5% and 90% quantile
  df <- ddply(Violin_data, .(parameter), boxset)
  pd <- 0.6# boxplot
  # jitter
  set.seed(111)
  Violin_data <- transform(Violin_data, con = jitter(as.numeric(parameter), amount = 0.05))
  ggplot(data = Violin_data, aes(x = parameter)) +
    geom_errorbar(
      data = df, position = position_dodge(0.6), show.legend = F,
      aes(ymin = y0, ymax = y100, color = colors), linetype = 1, width = 0.15) + # add line to whisker
    geom_boxplot(
      data = df,
      aes(ymin = y0, lower = y25, middle = y50, upper = y75, ymax = y100, color = colors),
      outlier.shape = NA, fill = "white", width = 0.25, position = position_dodge(0.6),
      stat = "identity", show.legend = F) +
    # geom_text(aes(label = id, x = con+0.25, y = Score), size = 3.5)+
    geom_point(aes(x = con, y = Score, group = id), size = 0.5, color = "gray", show.legend = F) +
    scale_color_manual(values = colors)+
    geom_hline(yintercept = 0.5, size = 0.5, linetype = "dashed", color = "black")+
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
  # boxplot
  ggplot(data = Violin_data, aes(x = condition)) +
    geom_errorbar(
      data = df, position = position_dodge(0.6), color = '#50acdf',
      aes(ymin = y0, ymax = y100), linetype = 1, width = 0.15) + # add line to whisker
    geom_boxplot(
      data = df,
      aes(ymin = y0, lower = y25, middle = y50, upper = y75, ymax = y100),
      outlier.shape = NA, fill = "white", width = 0.25, position = position_dodge(0.6),
      stat = "identity", color = '#50acdf') +
    geom_point(aes(x = con, y = Score), size = 0.5, color = "gray", show.legend = F) +
    geom_hline(yintercept = hx, size = 0.5, linetype = "dashed", color = "black")+
    theme(axis.title.x = element_blank())
}
# box plot for comparision
boxcp <- function(data, con, select){
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
    geom_errorbar(data=df, position = position_dodge(0.6),
                  aes(ymin=y0,ymax=y100),linetype = 1,width = 0.15)+ # add line to whisker
    geom_boxplot(data=df,
                 aes(ymin = y0, lower = y25, middle = y50, upper = y75, ymax = y100),
                 outlier.shape = NA, fill="white", width=0.25, position = position_dodge(0.6),
                 stat = "identity") +
    # geom_point(aes(x=con, y=Score), size = 0.5, color = "gray",show.legend = F)+
    geom_line(aes(x=con,y=Score,group = interaction(id)), color = "#e8e8e8")+
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
# 2 Main -------------------------------------------------------------
# load data
data_dir <- "/Volumes/WD_F/gufei/3T_cw/stats/"
figure_dir <- "/Volumes/WD_F/gufei/3T_cw/results_labels_r/"
data_names <- c("Amy8_align","Pir_new","fusiformCA","FFA_CA",
                "FFV_CA", "insulaCA", "OFC6mm", "aSTS_OR","OFC_AAL")
data_names <- c("Amy8_at165","Pir_new_at165","fusiformCA_at165","FFA_CA_at165",
                "FFV_CA_at165", "insulaCA_at165", "OFC6mm_at165", "aSTS_OR_at165")
data_names <- c("Indiv40_0.001_odor_Pir",
                "Indiv40_0.001_odor_Amy",
                "Indiv4_0.001_odor_OFC",
                "Indiv40_0.001_face_vis_fusiform",
                "Indiv40_0.001_fointer_inv_Amy")
data_names <- c("Indiv40_0.001_odor_Pir",
                "Indiv4_0.001_odor_OFC",
                "Indiv40_0.001_face_vis_fusiform")
prefix <- 'indi8conppi_'
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
# add con-incon columns
betas <- mutate(betas,incon = rowMeans(betas[,c(2,3,8,9)]),con = rowMeans(betas[4:7]))
betas <- mutate(betas,vis = rowMeans(betas[,c(2,4,6,8)]),inv = rowMeans(betas[,c(3,5,7,9)]))
betas <- mutate(betas,coin = con-incon)
betas <- mutate(betas,vin = vis-inv)
# ttest
cat("*********",data_name,"ttest","*********")
bruceR::TTEST(betas, names)
# average names in betas
bruceR::TTEST(betas,c("con","incon","coin","vis","inv","vin"))
bruceR::TTEST(`names<-`(as.data.frame(rowMeans(betas[-1])),"x"),"x")

# ANOVA
cat("*********",data_name,"Invisible","*********")
bruceR::MANOVA(betas, dvs=c('FearPleaInv','FearUnpleaInv','HappPleaInv','HappUnpleaInv'), dvs.pattern="(Happ|Fear)(PleaInv|UnpleaInv)",
               within=c("face", "odor"))

cat("*********",data_name,"Visible","*********")
bruceR::MANOVA(betas, dvs=c('FearPleaVis','FearUnpleaVis','HappPleaVis','HappUnpleaVis'), dvs.pattern="(Happ|Fear)(PleaVis|UnpleaVis)",
               within=c("face", "odor"))

cat("*********",data_name,"ALL","*********")
bruceR::MANOVA(betas, dvs=c('FearPleaInv','FearUnpleaInv','HappPleaInv','HappUnpleaInv',
                            'FearPleaVis','FearUnpleaVis','HappPleaVis','HappUnpleaVis'),
               dvs.pattern="(Happ|Fear)(Plea|Unplea)(Inv|Vis)",
               within=c("face", "odor", "visibility"))
# # 3 lineplots -------------------------------------------------------------------
# invisible
line_hfinv <- lineplot(betas,c("Happ","Fear"),c('FearPleaInv','FearUnpleaInv','HappPleaInv','HappUnpleaInv'))+
  # coord_cartesian(ylim = c(-0.2,0))+
  # scale_y_continuous(expand = c(0,0),
  #                    breaks = seq(from=-0.2, to=0, by=0.1))+
  labs(y="Mean Beta",title = "Invisible")+
  scale_x_discrete(labels=c("Happy","Fearful"))
# visible
line_hfvis <- lineplot(betas,c("Happ","Fear"),c('FearPleaVis','FearUnpleaVis','HappPleaVis','HappUnpleaVis'))+
  # coord_cartesian(ylim = c(-0.2,0))+
  # scale_y_continuous(expand = c(0,0),
  #                    breaks = seq(from=-0.2, to=0, by=0.1))+
  labs(y="Mean Beta",title = "Visible")+
  scale_x_discrete(labels=c("Happy","Fearful"))
# save
line <- wrap_plots(line_hfinv,line_hfvis,ncol = 2,guides = 'collect')+plot_annotation(tag_levels = "A")
print(line)
ggsave(paste0(figure_dir,ifelse(str_detect(prefix,"ppi"),"ppiline_","line_"), data_name, ".pdf"), line, width = 8, height = 4,
       device = cairo_pdf)
# 3 boxplots -------------------------------------------------------------------
# invisible
box_hfinv <- boxplotv(betas,c("Happ","Fear"),c('FearPleaInv','FearUnpleaInv','HappPleaInv','HappUnpleaInv'))+
  # coord_cartesian(ylim = c(-0.7,0.5))+
  # scale_y_continuous(expand = c(0,0),
  #                    breaks = seq(from=-0.65, to=0.4, by=0.2))+
  labs(y="Mean Beta",title = "Invisible")+
  scale_x_discrete(labels=c("Happy","Fearful"))
# visible
box_hfvis <- boxplotv(betas,c("Happ","Fear"),c('FearPleaVis','FearUnpleaVis','HappPleaVis','HappUnpleaVis'))+
  # coord_cartesian(ylim = c(-0.7,0.5))+
  # scale_y_continuous(expand = c(0,0),
  #                    breaks = seq(from=-0.65, to=0.4, by=0.2))+
  labs(y="Mean Beta",title = "Visible")+
  scale_x_discrete(labels=c("Happy","Fearful"))
# save
box <- wrap_plots(box_hfinv,box_hfvis,ncol = 2,guides = 'collect')+plot_annotation(tag_levels = "A")
print(box)
ggsave(paste0(figure_dir,ifelse(str_detect(prefix,"ppi"),"ppibox_","box_"), data_name, ".pdf"), box, width = 8, height = 4,
       device = cairo_pdf)
# visible invisble compare
box_vin <- boxcp(betas,c("vis","inv"),c("vis","inv"))+
  labs(y="Mean Beta")+
  scale_x_discrete(labels=c("Visible","Invisible"))
ggsave(paste0(figure_dir,ifelse(str_detect(prefix,"ppi"),"ppiboxvin_","boxvin_"), data_name, ".pdf"), box_vin, width = 3, height = 2,
       device = cairo_pdf)
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
# ttest
bruceR::TTEST(betas,c("coin","coinvis","coininv"))

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
box_convin <- boxcp(betas,c("coininv","coinvis"),c("coininv","coinvis"))+
  labs(y="Mean Beta Difference")+
  coord_cartesian(ylim = c(-0.18,0.25))+
  scale_x_discrete(labels=c("Invisible","Visible"))
print(box_convin)
ggsave(paste0(figure_dir,"amy_convin.pdf"), box_convin, width = 4, height = 3,
       device = cairo_pdf)
# save
amy <- wrap_plots(line_hfinv,line_hfvis,coinbox,box_convin,ncol = 2)
print(amy)
ggsave(paste0(figure_dir,ifelse(str_detect(prefix,"ppi"),"ppiamy","amy"), ".pdf"), amy, width = 8, height = 6)

# 4 mvpa results -------------------------------------------------------------------
facecon <- c("vis","inv","all")
transcon <- c("inv_vis","vis_inv","test_inv","test_vis","train_inv","train_vis")
translabel <- c("Invisible Face\nVisible Face","Visible Face\nInvisible Face",
                "Odor\nInvisible Face","Odor\nVisible Face",
                "Invisible Face\nOdor","Visible Face\nOdor")
rois <- c("Amy8_align","OFC_AAL","FFV_CA005","Pir_new005")
rois <- c("FFV_CA_max2v", "FFV_CA_max3v", "FFV_CA_max4v", "FFV_CA_max5v", "FFV_CA_max6v")
# decoding results
dresults <- list()
for (roi in rois) {
  testface <- readacc("roi_face_shift6",facecon[1:2],roi)
  # testface$con <- paste0("face_",testface$con)
  testodor <- readacc("roi_odor_shift6",facecon[3],roi)
  # testodor$con <- paste0("odor_",testodor$con)
  # decast test
  test <- reshape2::dcast(rbind(testface,testodor), id ~ con, value.var = "acc")
  # save test to dresults
  dresults[[roi]][['normal']] <- test
  cat("*********",roi,"*********")
  bruceR::TTEST(test,facecon,test.value=0.5)
  
  acc <- boxplotd(test,facecon)+
    coord_cartesian(ylim = c(0.2,1))+
    scale_y_continuous(name = "Decoding Accuracy",expand = expansion(add = c(0,0)))+
    scale_x_discrete(labels=c('VisFace', 'InvFace', 'Odor'))
  print(acc)
  ggsave(paste0(figure_dir,"mvpa_",roi, ".pdf"), acc, width = 3, height = 3,
         device = cairo_pdf)
}
# trans decoding results
for (roi in rois[1:3]) {
  test <- readacc("roi_newtrans_shift6",transcon,roi)
  # decast test
  test <- reshape2::dcast(test, id ~ con, value.var = "acc")
  # save test to dresults
  dresults[[roi]][['trans']] <- test
  cat("*********",roi,"*********")
  bruceR::TTEST(test,transcon,test.value=0.5)
  
  acc <- boxplotd(test,transcon)+
    coord_cartesian(ylim = c(0.2,0.8))+
    scale_y_continuous(name = "Cross Decoding Accuracy",expand = expansion(add = c(0,0)))+
    scale_x_discrete(labels = c("InvFace\nVisFace","VisFace\nInvFace",
                                "Odor\nInvFace","Odor\nVisFace",
                                "InvFace\nOdor","VisFace\nOdor"))
  print(acc)
  ggsave(paste0(figure_dir,"mvpa_trans",roi, ".pdf"), acc, width = 4, height = 3,
         device = cairo_pdf)
}
# lesion cluster decoding results
prefix <- c('face_vis','face_inv','odor_all');
for (roi in rois[1:2]) {
  # lecons start with p
  lecon <- c(paste0(prefix,'_','l0'),paste0(prefix,'_','l00'))
  # sort lecon
  lecon <- lecon[c(1,4,2,5,3,6)]
  test <- readacc("roi_lesion_shift6",lecon,roi)
  # decast test
  test <- reshape2::dcast(test, id ~ con, value.var = "acc", fun.aggregate = mean)
  # save test to dresults
  dresults[[roi]][['cluster']] <- test
  cat("*********",roi,"*********")
  bruceR::TTEST(test,lecon,test.value=0.5)
  bruceR::TTEST(test,lecon,paired = T)
  
  acc <- boxplotd(test,lecon)+
    coord_cartesian(ylim = c(0.2,0.8))+
    scale_y_continuous(name = "Decoding Accuracy",expand = expansion(add = c(0,0)))+
    scale_x_discrete(labels = lecon)
  print(acc)
  ggsave(paste0(figure_dir,"mvpa_clusterlesion_",roi, ".pdf"), acc, width = 4, height = 3,
         device = cairo_pdf)
}
# lesion decoding results
prefix <- c('face_vis','face_inv','odor_all');
suffix <- c('p1','p2','l1','l2');
# combine each prefix with each suffix
lecons <- c()
for (p in prefix) {
  for (s in suffix) {
    lecons <- c(lecons,paste0(p,'_',s))
  }
}
for (roi in rois[1:2]) {
  for (p in prefix) {
    # lecons start with p
    lecon <- lecons[str_detect(lecons,p)]
    test <- readacc("roi_lesion10_shift6",lecon,roi)
    # decast test
    test <- reshape2::dcast(test, id ~ con, value.var = "acc", fun.aggregate = mean)
    # save test to dresults
    dresults[[roi]][['lesion10']] <- test
    # merge l0 results
    testl0 <- dresults[[roi]][['cluster']]
    test <- merge(test,testl0)
    lecon <- c(lecon,paste0(p,"_l0"))
    cat("*********",roi,"*********")
    bruceR::TTEST(test,lecon,test.value=0.5)
    bruceR::TTEST(test,lecon[c(5,3,5,4)],paired = T)
    
    acc <- boxplotd(test,lecon)+
      coord_cartesian(ylim = c(0.2,0.8))+
      scale_y_continuous(name = "Decoding Accuracy",expand = expansion(add = c(0,0)))+
      scale_x_discrete(labels = lecon)
    print(acc)
    # ggsave(paste0(figure_dir,"mvpa_lesion_",roi, ".pdf"), acc, width = 4, height = 3,
    #        device = cairo_pdf)
  }
}

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