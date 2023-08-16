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

# 1 functions -------------------------------------------------------------
extractdata <- function(txtname){
  # use comment.char = "" to avoid problems caused by "#"
  data <- read.table(txtname,header = TRUE,fill=TRUE,comment.char = "",
                     colClasses = c("character","character","NULL","character"),
                     col.names = c("sub","condition","Null","NZmean"))
  # sub
  sub <- strsplit(data$sub,"\\/")
  sub <- sapply(sub,"[",1)
  data$sub <- sub
  # conditions: extract first character from data$condition
  data$condition <- as.numeric(substr(data$condition,1,1))+1
  # converter to numeric
  data$NZmean <- as.numeric(data$NZmean)
  return(data)
}
# 2 Main -------------------------------------------------------------
# load data
data_dir <- "/Volumes/WD_F/gufei/3T_cw/stats/"
figure_dir <- "/Volumes/WD_F/gufei/3T_cw/results_labels_r/"
txtname <- paste0(data_dir,'indi8con_','Amy8_align','.txt')
betas <- extractdata(txtname)
