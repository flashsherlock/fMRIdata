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
# 2 Main -------------------------------------------------------------
# read mat file
data_dir <- '/Volumes/WD_D/gufei/monkey_data/respiratory/adinstrument/'
odors <- c('Indole', 'Iso_l', 'Iso_h', 'Peach', 'Banana', 'Unpleasant', 'Pleasant')
colors <- c('#777DDD', '#69b4d9', '#149ade', '#41AB5D', '#ECB556', '#ea5751','#0891c9');
names <- c('pm2','pm1')
for (pm in names) {
  # load data
  data <- readMat(file.path(data_dir,paste0(pm,'.mat')))
  data <- as.data.frame(data$outpm)
  names(data) <- c('odor','volume','duration','peak','speed')
  # ttest
  bruceR::TTEST(subset(data,odor%in%c(6:7)), x="odor",y=names(data)[-1])
  # bruceR::MANOVA(subset(data,odor%in%c(1:5)),dv="volume",between = "odor")
  # bruceR::MANOVA(subset(data,odor%in%c(1:5)),dv="duration",between = "odor")
  # bruceR::MANOVA(subset(data,odor%in%c(1:5)),dv="peak",between = "odor")
  # bruceR::MANOVA(subset(data,odor%in%c(1:5)),dv="speed",between = "odor")
  # convert odors to factors
  data$odor <- factor(data$odor,levels = c(1:7),labels = odors)
  # describe data by odor
  data_ana <- describeBy(data[,-1], list(data$odor), mat = TRUE)
  select <- c('volume','duration')
  # plot
  odor5 <- boxplot(subset(data,odor%in%odors[1:5]),select,colors[1:5])+coord_cartesian(ylim = c(-0.6,1))
  odor2 <- boxplot(subset(data,odor%in%odors[6:7]),select,colors[6:7])+coord_cartesian(ylim = c(-0.6,1))
  # save
  box <- wrap_plots(odor5,odor2,ncol = 2)
  print(box)
  ggsave(paste0(data_dir,pm,"_mean.pdf"), box, width = 10, height = 4,
         device = cairo_pdf)
}
# 3 human rating -------------------------------------------------------
# load data
hva <- readMat(file.path(data_dir,paste0('human_va','.mat')))
hva <- as.data.frame(hva$valence)
names(hva) <- odors[1:5]
# add subject id
hva$id <- 1:nrow(hva)
# reshape data
hva <- reshape2::melt(hva,'id', variable.name = "odor", value.name = "valence")
# plot
human <- boxplot(hva,'valence',colors[1:5])+
  scale_y_continuous(name = "Valence", 
                     expand = expansion(add = c(0, 0)),breaks=c(1,25,50,75,100))+
  scale_x_discrete(labels = NULL)+
  coord_cartesian(ylim = c(1,100))
# save
human <- wrap_plots(human,odor5,odor2,ncol = 3,guides = 'collect')
print(human)
ggsave(paste0(data_dir,'human_va',"_mean.pdf"), human, width = 12, height = 4,
       device = cairo_pdf)
 