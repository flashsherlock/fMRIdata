# default values
path <- "/Volumes/WD_F/gufei/blind/"
analysis <- c("pade")
# subs
subs <- c(sprintf('S%02d',c(2:4,6:13)))
# rois
# roi <- c('Amy8_at165','corticalAmy_at165','CeMeAmy_at165','BaLaAmy_at165','Pir_new_at165','Pir_old_at165','APC_new_at165','APC_old_at165','PPC_at165')
# roiname <- c("Amy","Cortical","CeMe","BaLa","Pir_new","Pir_old","APC_new","APC_old","PPC")
roi <- c('Amy8_at165','Pir_new_at165','Pir_old_at165','APC_new_at165','APC_old_at165','PPC_at165','EarlyV_at165','V1_at165','V2_at165','V3_at165')
# roi <- c('Amy8_align','Pir_new','Pir_old','APC_new','APC_old','PPC','EarlyV','V1','V2','V3')
roiname <- c("Amy","Pir_new","Pir_old","APC_new","APC_old","PPC","EarlyV","V1","V2","V3")

# render roistats
suffix <- "_tent_12.txt"
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/blind/roistatas.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0("ROIstatas_13sub_12"),
                  params = list(path = path, sub = subs, roi = roi, suffix = suffix))

# render mean mvpa results
title <- "Mean_shift6_at165"
mp <- "roi_odor_shift6"
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/blind/results_labels_mean.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0("Mean_shift6_13sub_at165"),
                  params = list(path = path, sub = subs, set_title = title, analysis = analysis, 
                                roi = roi, roiname = roiname, mvpa_pattern = mp))
