library(plotly)
library(stringr)
library(data.table)
library(psych)
library(ggpubr)
library(ggprism)
library(patchwork)
showtext::showtext_auto(enable = F)
sysfonts::font_add("Helvetica","Helvetica.ttc")
theme_update(text=element_text(family="Helvetica",face = "plain"))
# box plot for Amy and Pir
concolor <-  c("#33A02C", "#1F78B4", "#A6CEE3", "#B2DF8A", "#E31A1C","#FDBF6F", "#FF7F00")
# 1 functions -------------------------------------------------------------
boxset <- function(data){
  summarise(data,
            y0 = quantile(strnorm, 0.05, na.rm = T), 
            #y0 = mean(strnorm, na.rm = T)-ci90(strnorm),
            y25 = quantile(strnorm, 0.25, na.rm = T), 
            # y50 = median(strnorm, na.rm = T),
            y50 = mean(strnorm, na.rm = T),
            y75 = quantile(strnorm, 0.75, na.rm = T), 
            #y100 = mean(strnorm, na.rm = T)+ci90(strnorm))
            y100 = quantile(strnorm, 0.95, na.rm = T))
}
boxplot <- function(data, select, colors){
  # select data
  Violin_data <- subset(data, roi%in%select)
  Violin_data$roi <- factor(Violin_data$roi,levels = select,labels = select)
  # summarise data 5% and 90% quantile
  df <- Violin_data %>%
    group_by(roi) %>%
    boxset()
  # jitter
  set.seed(111)
  nodor <- length(unique(Violin_data$roi))
  pd <- 0.6
  Violin_data <- transform(Violin_data, con = jitter(as.numeric(roi), amount = 0.01))
  # boxplot
  ggplot(data = Violin_data, aes(x = roi)) +
    geom_hline(yintercept = 0, linetype="dashed", color = "black")+
    geom_errorbar(
      data = df, position = position_dodge(pd),
      aes(ymin = y0, ymax = y100, color = roi), linetype = 1, width = 0.2) + # add line to whisker
    geom_boxplot(
      data = df,
      aes(ymin = y0, lower = y25, middle = y50, upper = y75, ymax = y100, color = roi),
      outlier.shape = NA, fill = "white",width = 0.3, position = position_dodge(pd),
      stat = "identity") +
    # geom_point(aes(x = con, y = strnorm, group = roi),color = "gray", show.legend = F) +
    scale_color_manual(values = colors)+
    scale_y_continuous(name = "Structure-Quality index")
}
calmean <- function(results){
  A <- c("La","Ba","Ce","Me","Co","BM","CoT","Para")
  B <- c("La","Ba","BM","Para")
  Ce <- c("Ce","Me")
  Co <- c("Co","CoT")
  Su <- c("Ce","Me","Co","CoT")
  Pn <- c("APc","PPc","APn")
  Po <- c("APc","PPc")
  An <- c("APc","APn")
  Ao <- "APc"
  PPC <- "PPc"
  roilist <- list(Deep=B,Superficial=Su,APC=An,PPC=PPC,Amy=A,CeMe=Ce,Cortical=Co,Pir_old=Po,APC_old=Ao)
  
  idx <- "strnorm"
  avg <- data.frame(matrix(ncol = 3, nrow = 0))
  for (roi_i in names(roilist)) {
    act <- results[roi %in% roilist[[roi_i]],.SD,.SDcols = c("sub",idx)]
    #   # add roi name
    act <- cbind(act,rep(roi_i,times=nrow(act)))
    avg <- rbind(avg,act)
  }
  # change column names
  names(avg) <- c("sub","strnorm","roi")
  return(avg)
}
# function to load txt file
extractdata <- function(path,sub,txtname){
  data <- read.table(file.path(path,sub,txtname))
  # add subject name to the first column
  data <- cbind(rep(sub,times=nrow(data)),data)
  return(data)
}
# 2 Main -------------------------------------------------------------
# 2.1 load data -------------
data_dir <- "/Volumes/WD_D/gufei/shiny/apps/7T/"
stats_dir <- "/Volumes/WD_F/gufei/7T_odor/stats/"
figure_dir <- "/Volumes/WD_F/gufei/7T_odor/figures/"
txtname <- "allvalue_orig.txt"
# load txt files
subs <- c(sprintf('S%02d',c(4:11,13,14,16:29,31:34)))
odors <- c("lim", "tra", "car", "cit", "ind")
betas <- c("car-lim","cit-lim","lim-tra","ind-lim","val","int")
pairs <- apply(combn(odors, 2), 2, function(x) paste(x[1], x[2], sep = "-"))
cnames <- c("sub","x","y","z","roi",paste("m",betas,sep = "_"),paste("t",betas,sep = "_"),
                    paste("a",pairs,sep = "_"),"sig165","sig196")
results <- data.frame(matrix(ncol = length(cnames), nrow = 0))
# extract results
for (sub in subs) {
  results <- rbind(results,extractdata(stats_dir,sub,txtname))
}
names(results) <- cnames
results <- as.data.table(results)
# add labels to roi
roilabels <- c("La","Ba","Ce","Me","Co","BM","CoT","Para","APc","PPc","APn")
results[,roi:=factor(roi,levels = sort(unique(results$roi)),labels=roilabels)]
# reverse xy
results$x <- -results$x
results$y <- -results$y
# save results to Rdata
save(results,file = paste0(figure_dir, str_remove(txtname,".txt"),".RData"))
# 2.2 calculate new values ----------------------------------------------
# load data
load(paste0(figure_dir, str_remove(txtname,".txt"),".RData"))
# compute strnorm
results[,strnbet:=(abs(`m_cit-lim`)-abs(`m_car-lim`))/(abs(`m_cit-lim`)+abs(`m_car-lim`))]
# acc below 0 is 0
results[,`a_lim-tra`:=ifelse(`a_lim-tra`<=0,50,`a_lim-tra`+50)]
results[,`a_lim-car`:=ifelse(`a_lim-car`<=0,50,`a_lim-car`+50)]
results[,`a_lim-cit`:=ifelse(`a_lim-cit`<=0,50,`a_lim-cit`+50)]
results[,`a_lim-ind`:=ifelse(`a_lim-ind`<=0,50,`a_lim-ind`+50)]
results[,`a_tra-car`:=ifelse(`a_tra-car`<=0,50,`a_tra-car`+50)]
results[,`a_tra-cit`:=ifelse(`a_tra-cit`<=0,50,`a_tra-cit`+50)]
results[,`a_tra-ind`:=ifelse(`a_tra-ind`<=0,50,`a_tra-ind`+50)]
results[,`a_cit-ind`:=ifelse(`a_cit-ind`<=0,50,`a_cit-ind`+50)]
results[,strnacc:=(`a_lim-cit`-`a_lim-car`)/(`a_lim-cit`+`a_lim-car`)]
# valence index
results[,valacc:=(`a_lim-tra`+`a_lim-ind`+`a_tra-cit`+`a_cit-ind`)/2]
results[,valbet:=(abs(`m_lim-tra`)+abs(`m_ind-lim`-`m_cit-lim`)+abs(`m_ind-lim`)+abs(`m_lim-tra`+`m_cit-lim`))/2]
# recode rois
newlables <- c("Deep","Deep","Super","Super","Super","Deep","Super","Deep","APC","PPC","APn")
results[.(roi = roilabels, to = newlables),on = "roi", roinew := i.to]
# calculate if abs(t_cit-lim) and abs(t_car-lim) > tvalue
tvalue <- 1.65
results[,str:=ifelse(abs(`t_cit-lim`)>tvalue,1,0)]
results[,qua:=ifelse(abs(`t_car-lim`)>tvalue,1,0)]
# average stnbet when sign165==1 for each sub
# avg_results <- results[roinew != "APn" & sig165==1, .(sig = sum(sig165),valacc = mean(valacc),valbet = mean(valbet)), by = list(sub,roinew)]
avg_results <- results[roinew != "APn" & (str==1 | qua==1), 
                       .(strnbet=mean(strnbet),
                         strnacc=mean(strnacc),
                         valacc = mean(valacc),
                         valbet = mean(valbet)), 
                       by = list(sub,roinew)]
avg_results165 <- results[roinew != "APn" & (str==1 | qua==1) & sig165==1, 
                       .(strnbet=mean(strnbet),
                         strnacc=mean(strnacc),
                         valacc = mean(valacc),
                         valbet = mean(valbet)), 
                       by = list(sub,roinew)]

# 3 group level results ----------------------------------------------
prefix <- "results"
prefix <- "search_rmbase"
load(paste0(data_dir,prefix,".RData"))
# compute strnorm
if (ncol(results)<20){
  results[,strnorm:=(abs(`m_lim-cit`)-abs(`m_lim-car`))/(abs(`m_lim-cit`)+abs(`m_lim-car`))]
} else{
  results[,strnorm:=(`m_lim-cit`-`m_lim-car`)/(`m_lim-cit`+`m_lim-car`)]
}
t1 <- min(round(qt(1-(0.05/2),input$df),6),100)
results_select <- results[abs(`t_lim-car`)>t1 | abs(`t_lim-cit`)>t1,]
results_select <- calmean(results_select)
strbox <- boxplot(results_select,c("Superficial","Deep","APC","PPC"),concolor[c(3,4,6,7)])+
  coord_cartesian(ylim = c(-1,1))
# save according to input name
ggsave(paste0(figure_dir,paste0('strnorm', ifelse(str_detect(prefix,"search"),"_search",""), '.pdf')),
       strbox, width = 4, height = 3, device = cairo_pdf)
# ttest
bruceR::TTEST(results_select[roi%in%c("Superficial","Deep"),],x="roi",y=c("strnorm"))
bruceR::TTEST(results_select[roi%in%c("APC","PPC"),],x="roi",y=c("strnorm"))

# tent
load(paste0(figure_dir, "tent.RData"))
load(paste0(figure_dir, "mvpa_roi.RData"))