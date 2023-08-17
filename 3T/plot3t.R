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

lineplot <- function(data, con, select){
  # select data
  Violin_data <- subset(data,select = c("id",select))
  Violin_data <- reshape2::melt(Violin_data, c("id"),variable.name = "Task", value.name = "Score")
  test="Plea"
  tests <- c("Happy_odor","Fearful_odor")

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
    scale_color_manual(values=c("#a1d08d","#f8c898"))+
    coord_cartesian(ylim = c(1.3,1.8))+
    scale_fill_manual(values = c("#a1d08d","#f8c898")) +
    theme(axis.title.x=element_blank())
}
# 2 Main -------------------------------------------------------------
# load data
data_dir <- "/Volumes/WD_F/gufei/3T_cw/stats/"
figure_dir <- "/Volumes/WD_F/gufei/3T_cw/results_labels_r/"
txtname <- paste0(data_dir,'indi8con_','Indiv40','.txt')
betas <- extractdata(txtname)
names <- c('FearPleaVis','FearPleaInv','FearUnpleaVis','FearUnpleaInv',
           'HappPleaVis','HappPleaInv','HappUnpleaVis','HappUnpleaInv')
# convert betas$condition to factors
betas$condition <- factor(betas$condition, levels = c(1:8), labels = names, ordered = F)
# reshape data to wide format
betas <- reshape2::dcast(betas, id ~ condition, value.var = "NZmean")

# 3 lineplots -------------------------------------------------------------------
line_hfinv <- lineplot(betas,c("Happ","Fear"),c('FearPleaInv','FearUnpleaInv','HappPleaInv','HappUnpleaInv'))+
  coord_cartesian(ylim = c(-0.2,0.1))+
  scale_y_continuous(expand = c(0,0),
                     breaks = seq(from=-0.2, to=0.1, by=0.1))+
  labs(y="Mean Beta",title = "Invisible")+
  scale_x_discrete(labels=c("Happy","Fearful"))
# visible
line_hfvis <- lineplot(betas,c("Happ","Fear"),c('FearPleaVis','FearUnpleaVis','HappPleaVis','HappUnpleaVis'))+
  coord_cartesian(ylim = c(-0.2,0.1))+
  scale_y_continuous(expand = c(0,0),
                     breaks = seq(from=-0.2, to=0.1, by=0.1))+
  labs(y="Mean Beta",title = "Visible")+
  scale_x_discrete(labels=c("Happy","Fearful"))
