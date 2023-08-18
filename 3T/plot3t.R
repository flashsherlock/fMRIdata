library(plotly)
library(stringr)
library(data.table)
library(psych)
library(ggpubr)
library(ggprism)
library(patchwork)
library(Rmisc)
library(dplyr)
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
  df <- Violin_data %>% group_by(condition, test) %>% boxset
  
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
    coord_cartesian(ylim = c(1.3,1.8))+
    scale_fill_manual(values = c("#faa61e","#5067b0")) +
    theme(axis.title.x=element_blank())
}
# 2 Main -------------------------------------------------------------
# load data
data_dir <- "/Volumes/WD_F/gufei/3T_cw/stats/"
figure_dir <- "/Volumes/WD_F/gufei/3T_cw/results_labels_r/"
data_name <- 'Indiv40'
txtname <- paste0(data_dir,'indi8con_',data_name,'.txt')
betas <- extractdata(txtname)
names <- c('FearPleaVis','FearPleaInv','FearUnpleaVis','FearUnpleaInv',
           'HappPleaVis','HappPleaInv','HappUnpleaVis','HappUnpleaInv')
# convert betas$condition to factors
betas$condition <- factor(betas$condition, levels = c(1:8), labels = names, ordered = F)
# reshape data to wide format
betas <- reshape2::dcast(betas, id ~ condition, value.var = "NZmean")
# ANOVA
bruceR::MANOVA(betas, dvs=c('FearPleaInv','FearUnpleaInv','HappPleaInv','HappUnpleaInv'), dvs.pattern="(Happ|Fear)(PleaInv|UnpleaInv)",
               within=c("face", "odor"))%>%
  bruceR::EMMEANS("odor", by="face")
bruceR::MANOVA(betas, dvs=c('FearPleaVis','FearUnpleaVis','HappPleaVis','HappUnpleaVis'), dvs.pattern="(Happ|Fear)(PleaVis|UnpleaVis)",
               within=c("face", "odor"))%>%
  bruceR::EMMEANS("odor", by="face")
# 3 lineplots -------------------------------------------------------------------
# invisible
line_hfinv <- lineplot(betas,c("Happ","Fear"),c('FearPleaInv','FearUnpleaInv','HappPleaInv','HappUnpleaInv'))+
  coord_cartesian(ylim = c(-0.2,0))+
  scale_y_continuous(expand = c(0,0),
                     breaks = seq(from=-0.2, to=0, by=0.1))+
  labs(y="Mean Beta",title = "Invisible")+
  scale_x_discrete(labels=c("Happy","Fearful"))
# visible
line_hfvis <- lineplot(betas,c("Happ","Fear"),c('FearPleaVis','FearUnpleaVis','HappPleaVis','HappUnpleaVis'))+
  coord_cartesian(ylim = c(-0.2,0))+
  scale_y_continuous(expand = c(0,0),
                     breaks = seq(from=-0.2, to=0, by=0.1))+
  labs(y="Mean Beta",title = "Visible")+
  scale_x_discrete(labels=c("Happy","Fearful"))
# save
line <- wrap_plots(line_hfinv,line_hfvis,ncol = 2,guides = 'collect')+plot_annotation(tag_levels = "A")
print(line)
ggsave(paste0(figure_dir,"line_", data_name, ".pdf"), line, width = 8, height = 4,
       device = cairo_pdf)
# 3 boxplots -------------------------------------------------------------------
# invisible
box_hfinv <- boxplotv(betas,c("Happ","Fear"),c('FearPleaInv','FearUnpleaInv','HappPleaInv','HappUnpleaInv'))+
  coord_cartesian(ylim = c(-0.7,0.5))+
  scale_y_continuous(expand = c(0,0),
                     breaks = seq(from=-0.65, to=0.4, by=0.2))+
  labs(y="Mean Beta",title = "Invisible")+
  scale_x_discrete(labels=c("Happy","Fearful"))
# visible
box_hfvis <- boxplotv(betas,c("Happ","Fear"),c('FearPleaVis','FearUnpleaVis','HappPleaVis','HappUnpleaVis'))+
  coord_cartesian(ylim = c(-0.7,0.5))+
  scale_y_continuous(expand = c(0,0),
                     breaks = seq(from=-0.65, to=0.4, by=0.2))+
  labs(y="Mean Beta",title = "Visible")+
  scale_x_discrete(labels=c("Happy","Fearful"))
# save
box <- wrap_plots(box_hfinv,box_hfvis,ncol = 2,guides = 'collect')+plot_annotation(tag_levels = "A")
print(box)
ggsave(paste0(figure_dir,"box_", data_name, ".pdf"), box, width = 8, height = 4,
       device = cairo_pdf)
