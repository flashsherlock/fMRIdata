library(plotly)
library(stringr)
library(data.table)
library(psych)
library(ggpubr)
library(ggprism)
library(patchwork)
theme_set(theme_prism(base_line_size = 15/64, base_rect_size = 15/64))
showtext::showtext_auto(enable = F)
sysfonts::font_add("Helvetica","Helvetica.ttc")
theme_update(text=element_text(family="Helvetica",face = "plain"))
# box plot for Amy and Pir
concolor <-  c("#33A02C", "#1F78B4", "#A6CEE3", "#B2DF8A", "#E31A1C","#FDBF6F", "#FF7F00")
# 1 functions -------------------------------------------------------------
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
# separate two groups
pair_sep_plot <- function(data,vara,varb){
  after_box_data <- reshape2::melt(data, c("sub"),variable.name = "parameter", value.name = "Score")
  after_box_data <- mutate(after_box_data, Odor=ifelse(str_detect(parameter,vara[1]),vara[1],vara[2]))
  after_box_data <- mutate(after_box_data, pair=ifelse(str_detect(parameter,varb[1]),varb[1],varb[2]))
  
  after_box_data$Odor <- factor(after_box_data$Odor, levels = vara)
  after_box_data$pair <- factor(after_box_data$pair, levels = varb)
  
  # summarise data 5% and 90% quantile
  df <- ddply(after_box_data, .(pair,Odor), boxset)
  
  # jitter
  set.seed(111)
  after_box_data <- transform(after_box_data, con = ifelse(Odor == vara[1], 
                                                           jitter(as.numeric(pair) - 0.15, 0.3),
                                                           jitter(as.numeric(pair) + 0.15, 0.3) ))
  ggplot(data=after_box_data, aes(x=pair)) + 
    geom_errorbar(data=df, position = position_dodge(0.6), size=15/64,
                  aes(ymin=y0,ymax=y100,color=Odor),linetype = 1,width = 0.3)+ # add line to whisker
    geom_boxplot(data=df,
                 stat = "identity", size=15/64,
                 aes(ymin = y0, lower = y25, middle = y50, upper = y75, ymax = y100,color=Odor),
                 outlier.shape = NA, fill = "white",width=0.5, position = position_dodge(0.6)) +
    scale_color_manual(values=c("#F03B20","#2C7FB8"))+
    geom_line(aes(x=con, y=Score, group = interaction(sub,pair)), color = "gray", size=15/64)+
    guides(color = guide_legend(
      order = 1,override.aes = list(fill = NA)))+
    labs(y = "fisherz r")+
    theme(axis.title.x=element_blank())
}
boxplot <- function(data, roiselect, dataselect,colors){
  # select data
  Violin_data <- subset(data, roi%in%roiselect,select = c("sub","roi",dataselect))
  Violin_data$roi <- factor(Violin_data$roi,levels = roiselect,labels = roiselect)
  Violin_data <- reshape2::melt(Violin_data, c("sub","roi"),variable.name = "parameter", value.name = "Score")
  # summarise data 5% and 90% quantile
  df <- ddply(Violin_data, .(roi), boxset)
  # jitter
  set.seed(111)
  pd <- 0.6
  Violin_data <- transform(Violin_data, con = jitter(as.numeric(roi), amount = 0.01))
  # boxplot
  ggplot(data = Violin_data, aes(x = roi))+
    geom_errorbar(
      data = df, position = position_dodge(pd), size=15/64,
      aes(ymin = y0, ymax = y100, color = roi), linetype = 1, width = 0.2) + # add line to whisker
    geom_boxplot(
      data = df, size=15/64,
      aes(ymin = y0, lower = y25, middle = y50, upper = y75, ymax = y100, color = roi),
      outlier.shape = NA, fill = "white",width = 0.3, position = position_dodge(pd),
      stat = "identity") +
    geom_line(aes(x = con, y = Score, group = sub),color = "gray", show.legend = F, size=15/64) +
    scale_color_manual(values = colors)+
    scale_y_continuous(name = "Accuracy", expand = expansion(add = c(0, 0)))+
    theme(axis.title.x=element_blank())
}
boxplot4 <- function(data, select, colors){
  # select data
  Violin_data <- subset(data, roi%in%select)
  Violin_data$roi <- factor(Violin_data$roi,levels = select,labels = select)
  Violin_data <- reshape2::melt(Violin_data, c("sub","roi"),variable.name = "parameter", value.name = "Score")
  # summarise data 5% and 90% quantile
  df <- ddply(Violin_data, .(roi), boxset)
  # jitter
  set.seed(111)
  nodor <- length(unique(Violin_data$roi))
  pd <- 0.6
  Violin_data <- transform(Violin_data, con = jitter(as.numeric(roi), amount = 0.01))
  # boxplot
  ggplot(data = Violin_data, aes(x = roi))+
    geom_errorbar(
      data = df, position = position_dodge(pd), size=15/64,
      aes(ymin = y0, ymax = y100, color = roi), linetype = 1, width = 0.2) + # add line to whisker
    geom_boxplot(
      data = df, size=15/64,
      aes(ymin = y0, lower = y25, middle = y50, upper = y75, ymax = y100, color = roi),
      outlier.shape = NA, fill = "white",width = 0.3, position = position_dodge(pd),
      stat = "identity") +
    # geom_point(aes(x = con, y = strnorm, group = roi),color = "gray", show.legend = F) +
    scale_color_manual(values = colors)+
    labs(y = "Structure-Quality index")+
    theme(axis.title.x=element_blank(),legend.position = "none")
}
calmean <- function(results,idx = "strnorm"){
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
  
  avg <- data.frame(matrix(ncol = 3, nrow = 0))
  for (roi_i in names(roilist)) {
    act <- results[roi %in% roilist[[roi_i]],.SD,.SDcols = c("sub",idx)]
    #   # add roi name
    act <- cbind(act,rep(roi_i,times=nrow(act)))
    avg <- rbind(avg,act)
  }
  # change column names
  names(avg) <- c("sub",idx,"roi")
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
txtname <- "allvalue_tlrc.txt"
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
newlables <- c("Deep","Deep","Super","Super","Super","Deep","Super","Deep","APC","PPC","APC")
results[,roi:=factor(roi,levels = sort(unique(results$roi)),labels=roilabels)]
# reverse xy
results$x <- -results$x
results$y <- -results$y
# save results to Rdata
save(results,file = paste0(figure_dir, str_remove(txtname,".txt"),".RData"))
# load beta and search data
t1 <- min(round(qt(1-(0.05/2),27),6),100)
# beta
load(paste0(data_dir,"results.RData"))
betaresults <- results
betaresults[,betaany:=ifelse(abs(`t_lim-car`)>t1 | abs(`t_lim-cit`)>t1,1,0)]
betaresults[,betaall:=ifelse(abs(`t_lim-car`)>t1 & abs(`t_lim-cit`)>t1,1,0)]
betaresults[,valbet:=(abs(`m_lim-tra`)+abs(`m_lim-ind`-`m_lim-cit`)+abs(`m_lim-ind`)+abs(`m_lim-tra`-`m_lim-cit`))/4]
# betaresults[,valbet:=(abs(`m_lim-ind`-`m_lim-cit`))]
betaresults[,strnbet:=(abs(`m_lim-cit`)-abs(`m_lim-car`))/(abs(`m_lim-cit`)+abs(`m_lim-car`))]
# search
load(paste0(data_dir,"search_rmbase.RData"))
searchresults <- results
searchresults[,mvpaany:=ifelse(`t_lim-car`>t1 | `t_lim-cit`>t1,1,0)]
searchresults[,mvpaall:=ifelse(`t_lim-car`>t1 & `t_lim-cit`>t1,1,0)]
searchresults[,valacc:=(`m_lim-tra`+`m_lim-ind`+`m_tra-cit`+`m_cit-ind`)/4]
searchresults[,strnacc:=(`m_lim-cit`-`m_lim-car`)/(`m_lim-cit`+`m_lim-car`)]
selectv <- merge(betaresults[,c("x","y","z","betaany","betaall")],
                  searchresults[,c("x","y","z","mvpaany","mvpaall")])
groupv <- merge(betaresults[,c("sub","x","y","z","roi","betaany","betaall","valbet","strnbet")],
                searchresults[,c("x","y","z","mvpaany","mvpaall","valacc","strnacc")])
# load data
load(paste0(figure_dir, str_remove(txtname,".txt"),".RData"))
if (txtname=="allvalue_tlrc.txt"){
  results <- merge(results,selectv)
}
# 2.2 calculate new values ----------------------------------------------
# acc below 0 is 0
results[,`a_lim-tra`:=ifelse(`a_lim-tra`<=0, 0, `a_lim-tra`)]
results[,`a_lim-car`:=ifelse(`a_lim-car`<=0, 0, `a_lim-car`)]
results[,`a_lim-cit`:=ifelse(`a_lim-cit`<=0, 0, `a_lim-cit`)]
results[,`a_lim-ind`:=ifelse(`a_lim-ind`<=0, 0, `a_lim-ind`)]
results[,`a_tra-car`:=ifelse(`a_tra-car`<=0, 0, `a_tra-car`)]
results[,`a_tra-cit`:=ifelse(`a_tra-cit`<=0, 0, `a_tra-cit`)]
results[,`a_tra-ind`:=ifelse(`a_tra-ind`<=0, 0, `a_tra-ind`)]
results[,`a_cit-ind`:=ifelse(`a_cit-ind`<=0, 0, `a_cit-ind`)]
# compute strnorm
results[,strnbet:=(abs(`m_cit-lim`)-abs(`m_car-lim`))/(abs(`m_cit-lim`)+abs(`m_car-lim`))]
results[,strnacc:=(`a_lim-cit`-`a_lim-car`)/(`a_lim-cit`+`a_lim-car`)]
# valence index
results[,valacc:=(`a_lim-tra`+`a_lim-ind`+`a_tra-cit`+`a_cit-ind`)/2]
results[,valbet:=(abs(`m_lim-tra`)+abs(`m_ind-lim`-`m_cit-lim`)+abs(`m_ind-lim`)+abs(`m_lim-tra`+`m_cit-lim`))/2]
# recode rois
results[.(roi = roilabels, to = newlables),on = "roi", roinew := i.to]
# calculate if abs(t_cit-lim) and abs(t_car-lim) > tvalue
tvalue <- 1.65
results[,str:=ifelse(abs(`t_cit-lim`)>tvalue,1,0)]
results[,qua:=ifelse(abs(`t_car-lim`)>tvalue,1,0)]
# average stnbet when sign165==1 for each sub
# avg_results <- results[roinew != "APn" & sig165==1, .(sig = sum(sig165),valacc = mean(valacc),valbet = mean(valbet)), by = list(sub,roinew)]
avg_results <- results[roinew != "APn" & betaany==1, 
                       .(strnbet=mean(strnbet),
                         strnacc=mean(strnacc,na.rm=T),
                         valacc = mean(valacc),
                         valbet = mean(valbet),
                         mstrbet = abs(mean(abs(`m_cit-lim`))),
                         mquabet = abs(mean(abs(`m_car-lim`))),
                         mstracc = abs(mean(abs(`a_lim-cit`))),
                         mquaacc = abs(mean(abs(`a_lim-car`))),
                         int = abs(mean(abs(m_int))), 
                         val = abs(mean(abs(m_val)))), 
                       by = list(sub,roinew)]
# check data
# test <- results[, .(`m_car-lim` = mean(`m_car-lim`)), 
#                        by = list(x,y,z)]
# betaresults[x==-46&y==7&z==-22,`m_lim-car`]
avg_results <- results[roinew != "APn" & mvpaall==1, 
                       .(strnbet=mean(strnbet),
                         strnacc=mean(strnacc,na.rm=T),
                         valacc = mean(valacc),
                         valbet = mean(valbet),
                         mstrbet = abs(mean(abs(`m_cit-lim`))),
                         mquabet = abs(mean(abs(`m_car-lim`))),
                         mstracc = abs(mean(abs(`a_lim-cit`))),
                         mquaacc = abs(mean(abs(`a_lim-car`))),
                         int = abs(mean(abs(m_int))), 
                         val = abs(mean(abs(m_val)))), 
                       by = list(sub,roinew)]

# compute strnorm
avg_results[,mstrnbet:=(mstrbet-mquabet)/(mstrbet+mquabet)]
avg_results[,mstrnacc:=(mstracc-mquaacc)/(mstracc+mquaacc)]
# 2.3 load rsaval data -------------
rsadata <- extractdata(figure_dir,'./','rsaval_30_at165.txt')
rsa_names <- c("Amy","Cortical","CeMe","BaLa",'Pirn','Piro','APCn','APC','PPC','Super','Deep')
names(rsadata) <- c("sub",paste(rep(c("str","val"),length(rsa_names)),rep(rsa_names,each=2),sep = "_"))
rsadata$sub <- subs
rsadata <- as.data.table(rsadata)
# plot rsa results
rsa <- pair_sep_plot(rsadata[,c(1,14,15,18,19)], c("str", "val"), c("APC", "PPC"))
ggsave(paste0(figure_dir,"rsaval_pir.pdf"),rsa, width = 5, height = 4, device = cairo_pdf)
rsa <- pair_sep_plot(rsadata[,c(1,20:23)], c("str", "val"), c("Super", "Deep"))
ggsave(paste0(figure_dir,"rsaval_amy.pdf"),rsa, width = 5, height = 4, device = cairo_pdf)
# anova
bruceR::MANOVA(rsadata[,c(14,15,18,19)], dvs=names(rsadata[,c(14,15,18,19)]),dvs.pattern="(str|val)_(APCn|PPC)",
               within=c("odor", "roi"))
bruceR::MANOVA(rsadata[,c(20:23)], dvs=names(rsadata[,c(20:23)]),dvs.pattern="(str|val)_(Super|Deep)",
               within=c("odor", "roi"))
bruceR::TTEST(rsadata,c(names(rsadata[,c(14,15,18,19)]),names(rsadata[,c(20:23)])),paired = T)
# 2.3 load rsa data -------------
rsadata <- extractdata(figure_dir,'./','rsaint_30_at165.txt')
rsa_names <- c("Amy","Cortical","CeMe","BaLa",'Pirn','Piro','APCn','APC','PPC','Super','Deep')
names(rsadata) <- c("sub",paste(rep(c("str","int"),length(rsa_names)),rep(rsa_names,each=2),sep = "_"))
rsadata$sub <- subs
rsadata <- as.data.table(rsadata)
# plot rsa results
rsa <- pair_sep_plot(rsadata[,c(1,14,15,18,19)], c("str", "int"), c("APC", "PPC"))
ggsave(paste0(figure_dir,"rsaint_pir.pdf"),rsa, width = 5, height = 4, device = cairo_pdf)
rsa <- pair_sep_plot(rsadata[,c(1,20:23)], c("str", "int"), c("Super", "Deep"))
ggsave(paste0(figure_dir,"rsaint_amy.pdf"),rsa, width = 5, height = 4, device = cairo_pdf)
# anova
bruceR::MANOVA(rsadata[,c(14,15,18,19)], dvs=names(rsadata[,c(14,15,18,19)]),dvs.pattern="(str|int)_(APCn|PPC)",
               within=c("odor", "roi"))
bruceR::MANOVA(rsadata[,c(20:23)], dvs=names(rsadata[,c(20:23)]),dvs.pattern="(str|int)_(Super|Deep)",
               within=c("odor", "roi"))
bruceR::TTEST(rsadata,c(names(rsadata[,c(14,15,18,19)]),names(rsadata[,c(20:23)])),paired = T)
# 2.3 load rsa data -------------
rsadata <- extractdata(figure_dir,'./','rsa_30_at165.txt')
rsa_names <- c("Amy","Cortical","CeMe","BaLa",'Pirn','Piro','APCn','APC','PPC','Super','Deep')
names(rsadata) <- c("sub",paste(rep(c("str","qua"),length(rsa_names)),rep(rsa_names,each=2),sep = "_"))
rsadata$sub <- subs
rsadata <- as.data.table(rsadata)
# plot rsa results
rsa <- pair_sep_plot(rsadata[,c(1,14,15,18,19)], c("str", "qua"), c("APC", "PPC"))
ggsave(paste0(figure_dir,"rsa_pir.pdf"),rsa, width = 5, height = 4, device = cairo_pdf)
rsa <- pair_sep_plot(rsadata[,c(1,20:23)], c("str", "qua"), c("Super", "Deep"))
ggsave(paste0(figure_dir,"rsa_amy.pdf"),rsa, width = 5, height = 4, device = cairo_pdf)
# anova
bruceR::MANOVA(rsadata[,c(14,15,18,19)], dvs=names(rsadata[,c(14,15,18,19)]),dvs.pattern="(str|qua)_(APCn|PPC)",
               within=c("odor", "roi"))
bruceR::MANOVA(rsadata[,c(20:23)], dvs=names(rsadata[,c(20:23)]),dvs.pattern="(str|qua)_(Super|Deep)",
               within=c("odor", "roi"))
bruceR::TTEST(rsadata,c(names(rsadata[,c(14,15,18,19)]),names(rsadata[,c(20:23)])),paired = T)
# 2.4 decast and export avgresults -------------
dataspss<- merge(dcast.data.table(avg_results,sub ~ roinew, 
                          value.var = names(avg_results)[c(-1,-2)]),
         rsadata[,c(1,14:23)])
# save to spss
bruceR::export(dataspss, file = paste0(figure_dir,"allvalue.sav"))
# 2.5 ttest
bruceR::TTEST(dataspss,c("mstrnbet_APC","mstrnbet_PPC","mstrnbet_Super","mstrnbet_Deep",
                         "mstrnacc_APC","mstrnacc_PPC","mstrnacc_Super","mstrnacc_Deep",
                         "mstrbet_APC","mstrbet_PPC","mstrbet_Super","mstrbet_Deep",
                         "mquabet_APC","mquabet_PPC","mquabet_Super","mquabet_Deep",
                         "mstracc_APC","mstracc_PPC","mstracc_Super","mstracc_Deep",
                         "mquaacc_APC","mquaacc_PPC","mquaacc_Super","mquaacc_Deep"),paired = T)
bruceR::TTEST(dataspss,c("strnbet_APC","strnbet_PPC","strnbet_Super","strnbet_Deep",
                            "strnacc_APC","strnacc_PPC","strnacc_Super","strnacc_Deep",
                            "valbet_APC","valbet_PPC","valbet_Super","valbet_Deep",
                            "valacc_APC","valacc_PPC","valacc_Super","valacc_Deep",
                            "val_APC","val_PPC","val_Super","val_Deep",
                            "int_APC","int_PPC","int_Super","int_Deep"),paired = T)
# 3 group level results ----------------------------------------------
tract <- as.data.table(read.table(paste0(data_dir,"tract.txt")))
names(tract) <- c("x","y","z","roi","prob","betaval","betaint")
# reverse xy
tract$x <- -tract$x
tract$y <- -tract$y
tract <- merge(groupv,tract[,-4])
tract[.(roi = roilabels, to = newlables),on = "roi", roinew := i.to]
tract[,betaval:=abs(betaval)]
tract[,betaint:=abs(betaint)]
results_select <- tract[betaany==1,]
# results_prob <- tract[roinew %in% c("Super","Deep") & y>=-2,]
results_prob <- tract[mvpaany==1&roinew %in% c("Super","Deep")&y>=-2&prob>0.04,]
results_prob <- results_prob[,pro := ifelse(prob>0.2,"h","l")]
bruceR::TTEST(results_prob,y="strnbet",x="pro")
# plot data
strbox <- boxplot4(calmean(results_select,"strnbet"),
                   c("Superficial","Deep","APC","PPC"),concolor[c(3,4,6,7)])+
          coord_cartesian(ylim = c(-1,1)) +
          geom_hline(yintercept = 0, linetype="dashed", color = "black", size=15/64)
ggsave(paste0(figure_dir,paste0('strnbet.pdf')),
       strbox, width = 4, height = 3, device = cairo_pdf)
#
valbox <- boxplot4(calmean(results_select,"valbet"),
                   c("Superficial","Deep","APC","PPC"),concolor[c(3,4,6,7)])+
          coord_cartesian(ylim = c(0,0.3),)+
          labs(y="valence index")
ggsave(paste0(figure_dir,paste0('valbet.pdf')),
       valbox, width = 4, height = 3, device = cairo_pdf)
#
valaccbox <- boxplot4(calmean(results_select,"valacc"),
                   c("Superficial","Deep","APC","PPC"),concolor[c(3,4,6,7)])+
          coord_cartesian(ylim = c(0,4),)+
          labs(y="valence index")
ggsave(paste0(figure_dir,paste0('valacc.pdf')),
       valaccbox, width = 4, height = 3, device = cairo_pdf)
#
betavalbox <- boxplot4(calmean(results_select,"betaval"),
                   c("Superficial","Deep","APC","PPC"),concolor[c(3,4,6,7)])+
          coord_cartesian(ylim = c(0,0.3),)+
          labs(y="valence beta")
ggsave(paste0(figure_dir,paste0('betaval.pdf')),
       betavalbox, width = 4, height = 3, device = cairo_pdf)
#
straccbox <- boxplot4(calmean(results_select,"strnacc"),
                   c("Superficial","Deep","APC","PPC"),concolor[c(3,4,6,7)])+
          coord_cartesian(ylim = c(-1,1),) +
          geom_hline(yintercept = 0, linetype="dashed", color = "black", size=15/64)+
          labs(y="Structure-Quality MVPA")
ggsave(paste0(figure_dir,paste0('strnacc.pdf')),
       straccbox, width = 4, height = 3, device = cairo_pdf)
# ttest
bruceR::TTEST(results_select[roinew%in%c("Super","Deep"),],x="roinew",
              y=c("strnbet","strnacc","valbet","valacc","betaint","betaval"))
bruceR::TTEST(results_select[roinew%in%c("APC","PPC"),],x="roinew",
              y=c("strnbet","strnacc","valbet","valacc","betaint","betaval"))
# select by mvpa
results_select <- tract[mvpaany==1,]
# plot data
strbox <- boxplot4(calmean(results_select,"strnbet"),
                   c("Superficial","Deep","APC","PPC"),concolor[c(3,4,6,7)])+
  coord_cartesian(ylim = c(-1,1)) +
  geom_hline(yintercept = 0, linetype="dashed", color = "black", size=15/64)
ggsave(paste0(figure_dir,paste0('acc_strnbet.pdf')),
       strbox, width = 4, height = 3, device = cairo_pdf)
valbox <- boxplot4(calmean(results_select,"valbet"),
                   c("Superficial","Deep","APC","PPC"),concolor[c(3,4,6,7)])+
  coord_cartesian(ylim = c(0,0.3),)+
  labs(y="valence index")
ggsave(paste0(figure_dir,paste0('acc_valbet.pdf')),
       valbox, width = 4, height = 3, device = cairo_pdf)
betavalbox <- boxplot4(calmean(results_select,"betaval"),
                       c("Superficial","Deep","APC","PPC"),concolor[c(3,4,6,7)])+
  coord_cartesian(ylim = c(0,0.3),)+
  labs(y="valence beta")
ggsave(paste0(figure_dir,paste0('acc_betaval.pdf')),
       betavalbox, width = 4, height = 3, device = cairo_pdf)
valaccbox <- boxplot4(calmean(results_select,"valacc"),
                      c("Superficial","Deep","APC","PPC"),concolor[c(3,4,6,7)])+
             coord_cartesian(ylim = c(0,4),)+
             labs(y="valence index")
ggsave(paste0(figure_dir,paste0('acc_valacc.pdf')),
       valaccbox, width = 4, height = 3, device = cairo_pdf)
straccbox <- boxplot4(calmean(results_select,"strnacc"),
                      c("Superficial","Deep","APC","PPC"),concolor[c(3,4,6,7)])+
  coord_cartesian(ylim = c(-1,1),) +
  geom_hline(yintercept = 0, linetype="dashed", color = "black", size=15/64)+
  labs(y="Structure-Quality MVPA")
ggsave(paste0(figure_dir,paste0('acc_strnacc.pdf')),
       straccbox, width = 4, height = 3, device = cairo_pdf)
# ttest
bruceR::TTEST(results_select[roinew%in%c("Super","Deep"),],x="roinew",
              y=c("strnbet","strnacc","valbet","valacc","betaint","betaval"))
bruceR::TTEST(results_select[roinew%in%c("APC","PPC"),],x="roinew",
              y=c("strnbet","strnacc","valbet","valacc","betaint","betaval"))
# 4 tent and mvpa results ----------------------------------------------
# tent results
load(paste0(figure_dir, "tent.RData"))
select <- c(1:4,5,7,9)
figure_roi <- ggplot(subset(roi_tent,roi%in%unique(roi_tent$roi)[select]), aes(x=time, y=mean,group=roi,color=roi)) + 
  labs(x='Time(s)',y='Percent of signal change (%)')+
  scale_y_continuous(expand = c(0,0))+
  coord_cartesian(ylim=c(min(roi_tent$mean)-0.1,max(roi_tent$mean+0.1)),
                  clip = 'off') + 
  scale_color_manual(values=concolor)+
  scale_fill_manual(values=concolor)+ 
  scale_x_discrete(expand = c(0,0))+
  geom_line(position = position_dodge(0.1), size=15/64) +
  geom_hline(yintercept=0, linetype="dotted", size=15/64)+
  # geom_errorbar(aes(ymin=mean-se, ymax=mean+se), width=.1,position = pd) +
  geom_ribbon(aes(ymin = mean - se, ymax = mean + se, fill = roi),
              alpha = 0.2,linetype=0)+
  geom_point(position = position_dodge(0.1),size=0.5)
ggsave(paste0(figure_dir,paste0('time_course.pdf')), figure_roi, width = 6, height = 4,
       device = cairo_pdf)

# mvpa results
load(paste0(figure_dir, "mvpa_roi.RData"))
# 5-new piriform
roi_select <- as.character(unique(acc4odor$roi)[c(1,5)])
accbox <- boxplot(acc4odor,roi_select,"acc",concolor[c(1,5)])+
  coord_cartesian(ylim = c(10,40))+
  scale_x_discrete(labels=c("Amygdala","Piriform")) +
  geom_hline(yintercept = 20, linetype="dashed", color = "black", size=15/64)+
  theme(legend.position = "none")
ggsave(paste0(figure_dir,paste0('acc.pdf')), accbox, width = 3, height = 2.5,
       device = cairo_pdf)
# ttest
bruceR::TTEST(reshape2::dcast(acc4odor,sub~roi,value.var = "acc"),
              roi_select,paired = T)
# 5 rating results ----------------------------------------------
# read mat file
data <- readMat(paste0(figure_dir,'../rating5odor.mat'))
avgdata <- as.data.frame(data$rate.avg)
# add subject number
snum <- nrow(avgdata)
row.names(avgdata) <- sprintf("S%02d",c(1:snum))
avgdata <- cbind(avgdata,row.names(avgdata))
names(avgdata) <- c(paste("valence",odors,"olfactometer",sep = "_"),
                    paste("intensity",odors,"olfactometer",sep = "_"),
                    paste("similarity",pairs,"olfactometer",sep = "_"),
                    "sub")
# remove zeros to select 28 subs
avgdata <- avgdata[rowSums(avgdata==0)==0,]
avgdata <- as.data.table(avgdata)
avgdataw <- avgdata
# melt to long format
avgdata <- separate(melt(id.vars="sub",avgdata),variable,c("dimension","odor","presentation"),sep = "_")
# anova
bruceR::MANOVA(avgdata[dimension=="intensity",],subID = "sub",dv="value",within = "odor")
bruceR::MANOVA(avgdata[dimension=="intensity"&odor!="ind",],subID = "sub",dv="value",within = "odor")
avgdataw[,valence_limcar:=abs(valence_lim_olfactometer-valence_car_olfactometer)]
avgdataw[,valence_limcit:=abs(valence_lim_olfactometer-valence_cit_olfactometer)]
bruceR::TTEST(avgdataw,y=c("valence_lim_olfactometer","valence_cit_olfactometer"),paired = T)
bruceR::TTEST(avgdataw,y=c("valence_lim_olfactometer","valence_car_olfactometer"),paired = T)
bruceR::TTEST(avgdataw,y=c("valence_limcar","valence_limcit"),paired = T)
#  plot
gf_color <- c("#F16913","#41AB5D","#4292C6","#ECB556","#777DDD")
for (dim in unique(avgdata$dimension)) {
  current <- subset(avgdata,dimension==dim)
  analyze_current <- describeBy(current$value,list(current$presentation,current$odor),mat = TRUE)
  datachosen <- subset(analyze_current,select = c(group1,group2,mean,se))
  names(datachosen) <- c("presentation","odor","mean","se")
  # 箱线图
  if (dim == "similarity") {
    current <- mutate(current,odor = factor(odor,pairs))
  }else{
    current <- mutate(current,odor = factor(odor,odors))
  }
  figure <- ggplot(current,aes(x=odor,y=value,label=sub,
                               group=interaction(odor,presentation))) + 
    labs(title = str_to_title(dim) ,x='Odor',y=dim)+
    scale_y_continuous(expand = c(0,0))+
    coord_cartesian(ylim=c(1,7)) + 
    geom_boxplot() +
    scale_fill_manual(values = gf_color)+
    geom_point(col=2,pch=16,cex=1)+
    theme_prism(base_line_size = 0.5)
  print(figure)
}