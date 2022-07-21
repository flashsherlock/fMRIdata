# default values
path <- "/Volumes/WD_E/gufei/7T_odor/"
mp<- c("roi_VIodor_l1_labelrpt_67")
analysis <- c("pabiode")
# subs 
subs <- c(sprintf('S%02d',c(4:11,13,14,16:18)))
# rois
roi <- c('Amy8_at165','corticalAmy_at165','CeMeAmy_at165','BaLaAmy_at165','Pir_new_at165','Pir_old_at165','APC_new_at165','APC_old_at165','PPC_at165')
roi <- c('Amy8_at196','corticalAmy_at196','CeMeAmy_at196','BaLaAmy_at196','Pir_new_at196','Pir_old_at196','APC_new_at196','APC_old_at196','PPC_at196')
roi <- c('Amy8_align','corticalAmy','CeMeAmy','BaLaAmy','Pir_new','Pir_old','APC_new','APC_old','PPC')
roiname <- c("Amy","Cortical","CeMe","BaLa","Pir_new","Pir_old","APC_new","APC_old","PPC")
roi <- c('Amy8_align','corticalAmy','CeMeAmy','BaLaAmy')
roiname <- c("Amy","Cortical","CeMe","BaLa")

# render ratings
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/5odor/ratings.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0("Raings_13sub"))

# odor_va results
# render mean mvpa results
title <- "Mean67rpt_odor_4-18"
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/5odor/results_labels_mean.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0("Mean_67rpt_418"),
                  params = list(sub = subs, set_title = title, analysis = analysis, 
                                roi = roi, roiname = roiname, mvpa_pattern = mp))

# render roistats
suffix <- "_tent_12.txt"
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/5odor/roistatas.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0("ROIstatas_13sub_12"),
                  params = list(sub = subs, roi = roi, suffix = suffix))


# render mvpa results for each subject
for (i_sub in subs) {
  analysis <- c("pabiode")
  title <-  paste("Amygdala_decoding", i_sub, mp,sep = "_")
  rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/5odor/results_labels.Rmd",
                    output_dir = paste0(path,"results_labels_r"),
                    output_file = paste0(i_sub,'_biova'),
                    params = list(sub = i_sub, set_title = title, analysis = analysis, 
                                  roi = roi, roiname = roiname, mvpa_pattern = mp))
}
