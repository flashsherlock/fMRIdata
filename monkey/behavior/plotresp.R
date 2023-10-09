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
library(R.matlab)
library(psych)
library(ggradar)
# ggthemr('fresh',layout = "clean",spacing = 0.5)
theme_set(theme_prism(base_line_size = 0.5))
showtext_auto(enable = F)
font_add("Helvetica","Helvetica.ttc")
theme_update(text=element_text(family="Helvetica",face = "plain"))
# boxplot
ci90 <- function(x){
  # similar to 5% and 90%
  return(qnorm(0.95)*sd(x, na.rm = T))
}

boxset <- function(data){
  summarise(data,
            y0 = quantile(Score, 0.05, na.rm = T), 
            #y0 = mean(Score, na.rm = T)-ci90(Score),
            y25 = quantile(Score, 0.25, na.rm = T), 
            # y50 = median(Score, na.rm = T),
            y50 = mean(Score, na.rm = T),
            y75 = quantile(Score, 0.75, na.rm = T), 
            #y100 = mean(Score, na.rm = T)+ci90(Score))
            y100 = quantile(Score, 0.95, na.rm = T))
}

boxplot <- function(data, select, colors){
  # select data
  Violin_data <- subset(data, select = c("odor", select))
  Violin_data <- reshape2::melt(Violin_data, c("odor"),variable.name = "parameter", value.name = "Score")

  # summarise data 5% and 90% quantile
  df <- Violin_data %>%
    group_by(odor,parameter) %>%
    boxset()
  # jitter
  set.seed(111)
  nodor <- length(unique(Violin_data$odor))
  pd <- 0.6
  Violin_data <- transform(Violin_data, con = jitter(as.numeric(parameter)+(pd/nodor)*(as.numeric(odor)-median(1:nodor)), amount = 0.01))
  # boxplot
  ggplot(data = Violin_data, aes(x = parameter)) +
    geom_hline(yintercept = 0, linetype="dashed", color = "black")+
    geom_errorbar(
      data = df, position = position_dodge(pd),
      aes(ymin = y0, ymax = y100, color = odor), linetype = 1, width = 0.2) + # add line to whisker
    geom_boxplot(
      data = df,
      aes(ymin = y0, lower = y25, middle = y50, upper = y75, ymax = y100, color = odor),
      outlier.shape = NA, fill = "white",width = 0.3, position = position_dodge(pd),
      stat = "identity") +
    # geom_point(aes(x = con, y = Score, group = odor), size = 0.5, color = "gray", show.legend = F) +
    scale_color_manual(values = colors)+
    scale_y_continuous(name = "Normalized value", expand = expansion(add = c(0, 0))) +
    theme(axis.title.x = element_blank())
}
# default boxplot
boxplotd <- function(data, select, colors){
  # select data
  Violin_data <- subset(data, select = c("odor", select))
  Violin_data <- reshape2::melt(Violin_data, c("odor"),variable.name = "parameter", value.name = "Score")
  pd <- 0.6# boxplot
  ggplot(data = Violin_data, aes(x = parameter)) +
    geom_boxplot(aes(y=Score, color = odor),
                 outlier.shape = NA, fill = "white",width = 0.3, position = position_dodge(pd))+
    # geom_point(aes(x = con, y = Score, group = odor), size = 0.5, color = "gray", show.legend = F) +
    scale_color_manual(values = colors)+
    scale_y_continuous(name = "Normalized value", expand = expansion(add = c(0, 0))) +
    theme(axis.title.x = element_blank())
}
# lineplot
errorline <- function(data,select,colors){
  ggplot(subset(datachosen, odor%in%select), aes(x=time)) + 
    labs(x='Time (s)',y='Normalized respiration',color='Odor') +
    geom_hline(yintercept = 0, linetype="dashed", color = "black")+
    scale_y_continuous(expand = c(0,0))+
    scale_fill_manual(values = colors)+
    scale_color_manual(values = colors)+
    scale_x_continuous(expand = c(0,0))+
    geom_line(aes(y=mean,color=odor,group=odor)) +
    geom_ribbon(aes(ymin = mean - 1.96*se,color=odor,group=odor,
                    ymax = mean + 1.96*se,fill = odor), alpha = 0.1,linetype=0)+
    guides(fill = "none",color = guide_legend(
      order = 1,# set legend order
      override.aes = list(fill = colors)))
}
odors <- c('Indole', 'Iso_l', 'Iso_h', 'Peach', 'Banana', 'Unpleasant', 'Pleasant')
colors <- c('#777DDD', '#69b4d9', '#149ade', '#41AB5D', '#ECB556', '#ea5751','#90c31e');
# 2 Main -------------------------------------------------------------
# read mat file
data_dir <- '/Volumes/WD_D/gufei/monkey_data/respiratory/adinstrument/'
names <- c('pm2','pm1')
for (pm in names) {
  # load data
  dataparm <- readMat(file.path(data_dir,paste0(pm,'.mat')))
  dataparm <- as.data.frame(dataparm$outpm)
  names(dataparm) <- c('odor','volume','duration','peak','speed')
  # ttest
  bruceR::TTEST(subset(dataparm,odor%in%c(6:7)), x="odor",y=names(dataparm)[-1])
  bruceR::MANOVA(subset(dataparm,odor%in%c(1:5)),dv="volume",between = "odor")%>%
  bruceR::EMMEANS("odor")
  bruceR::MANOVA(subset(dataparm,odor%in%c(1:5)),dv="duration",between = "odor")%>%
  bruceR::EMMEANS("odor")
  # bruceR::MANOVA(subset(dataparm,odor%in%c(1:5)),dv="peak",between = "odor")%>%
  # bruceR::EMMEANS("odor")
  # bruceR::MANOVA(subset(dataparm,odor%in%c(1:5)),dv="speed",between = "odor")%>%
  # bruceR::EMMEANS("odor")
  # convert odors to factors
  dataparm$odor <- factor(dataparm$odor,levels = c(1:7),labels = odors)
  # describe dataparm by odor
  data_ana <- describeBy(dataparm[,-1], list(dataparm$odor), mat = TRUE)
  select <- c('volume','duration')
  # plot
  odor5 <- boxplot(subset(dataparm,odor%in%odors[1:5]),select,colors[1:5])+coord_cartesian(ylim = c(-0.6,1))
  odor2 <- boxplot(subset(dataparm,odor%in%odors[6:7]),select,colors[6:7])+coord_cartesian(ylim = c(-0.6,1))
  # save
  box <- wrap_plots(odor5,odor2,ncol = 2,guides = 'collect')
  print(box)
  ggsave(paste0(data_dir,pm,"_mean.pdf"), box, width = 8, height = 3,
         device = cairo_pdf)
  
  # respiration
  resp <- readMat(file.path(data_dir,paste0('resp',substr(pm,3,3),'.mat')))
  resp <- as.data.frame(resp$outresp)
  # select time
  resp <- resp[1:1501,]
  # names(resp) <- c(paste0("mean_",odors),paste0("se_",odors),"ap","tp")
  names(resp) <- c(paste0("",odors),paste0("",odors),"ap","tp")
  # add a column ap1 if ap<0.05 ap1=1 else ap1 is na
  resp$ap1 <- ifelse(resp$ap<0.05,1,NA)
  resp$tp1 <- ifelse(resp$tp<0.05,1,NA)
  # add a column from 0 to nrows/1000
  resp$time <- seq(0,(nrow(resp)-1)/1000,1/1000)
  # reshape resp[1:7] to long format
  datachosen <- merge(reshape2::melt(subset(resp,select=c(1:7,ncol(resp))), 
                                        c("time"),variable.name = "odor", value.name = "mean"),
                      reshape2::melt(subset(resp,select=c(8:14,ncol(resp))), 
                                     c("time"),variable.name = "odor", value.name = "se"))
  # plot
  resp5 <- errorline(datachosen,odors[1:5],colors[1:5])+
    geom_line(data = resp[c("time","ap1")],aes(y=ap1*0.5))+
    coord_cartesian(ylim = c(-0.35,0.55))
  resp2 <- errorline(datachosen,odors[6:7],colors[6:7])+
    geom_line(data = resp[c("time","tp1")],aes(y=tp1*0.5))+
    coord_cartesian(ylim = c(-0.35,0.55))
  # save
  resp_line <- wrap_plots(resp5,resp2,ncol = 2,guides = 'collect')
  print(resp_line)
  ggsave(paste0(data_dir,paste0('resp',substr(pm,3,3)),".pdf"), resp_line, width = 9, height = 3,
         device = cairo_pdf)

}
# 3 human rating -------------------------------------------------------
# load data
hva <- readMat(file.path(data_dir,paste0('human_va','.mat')))
hva <- as.data.frame(hva$valence)
names(hva) <- odors[1:5]
# add subject id
hva$id <- 1:nrow(hva)
# average to pleasant and unpleasant
hpu <- as.data.frame(hva$id)
names(hpu) <- "id"
hpu$Unpleasant <- rowMeans(subset(hva,select = odors[1:3]))
hpu$Pleasant <- rowMeans(subset(hva,select = odors[4:5]))
# pleasant and unpleasant
bruceR::TTEST(hpu, y=c("Pleasant","Unpleasant"),paired = T)
# reshape data
hva <- reshape2::melt(hva,'id', variable.name = "odor", value.name = "valence")
hpu <- reshape2::melt(hpu,'id', variable.name = "odor", value.name = "valence")
# anova
bruceR::MANOVA(hva,subID='id',dv="valence",within = "odor")%>%
  bruceR::EMMEANS("odor")
# plot
human5 <- boxplot(hva,'valence',colors[1:5])+
  scale_y_continuous(name = "Valence", 
                     expand = expansion(add = c(0, 0)),breaks=c(1,25,50,75,100))+
  scale_x_discrete(labels = NULL)+
  coord_cartesian(ylim = c(1,100))
# plea unplea
human2 <- boxplot(hpu,'valence',colors[6:7])+
  scale_y_continuous(name = "Valence", 
                     expand = expansion(add = c(0, 0)),breaks=c(1,25,50,75,100))+
  scale_x_discrete(labels = NULL)+
  coord_cartesian(ylim = c(1,100))
# save
human <- wrap_plots(human5,human2,ncol = 2,guides = 'collect')
print(human)
ggsave(paste0(data_dir,'human_va',"_mean.pdf"), human, width = 6, height = 3,
       device = cairo_pdf)
# 4 new human rating and descriptions-------------------------------------------------------
# load data
radarplot <- function(data, rgrid, ...){
  ggradar(...,data,
          gridline.mid.colour = "grey",
          group.line.width = 1,
          group.point.size = 3,
          grid.min = rgrid[1],
          grid.mid = rgrid[2],
          grid.max = rgrid[3],
          values.radar = rgrid)
}
data_dir2 <- '/Volumes/WD_D/gufei/monkey_data/description/'
des <- readMat(file.path(data_dir2,paste0('mresults','.mat')))
# ratings
ratingdims <- c('valence','intensity','familarity','edibility','arousal')
mvi <- cbind(factor(odors[1:5],levels = odors[1:5]),as.data.frame(des$mvi))
colnames(mvi) <- c('odors',ratingdims)
rgrid <- c(20, 60, 100)
fig_mvi <- radarplot(mvi,rgrid,
                     group.colours = colors,
                     centre.y = 10)
print(fig_mvi)
# descriptions
dimensions <- c('fear','hostility','sadness','joviality','self-assurance',
                'attentiveness','shyness','fatigue','serenity','surprise')
mdes <- cbind(factor(odors[1:5],levels = odors[1:5]),as.data.frame(des$desdim))
colnames(mdes) <- c('odors',dimensions)
rgrid <- c(10, 40, 70)
fig_des <- radarplot(mdes,rgrid,
                     group.colours = colors,
                     centre.y = 1)
print(fig_des)
ggsave(paste0(data_dir2,'des',"_mean.pdf"),
       wrap_plots(fig_mvi,fig_des,ncol = 2,guides = 'collect'),
       width = 12, height = 4, device = cairo_pdf)