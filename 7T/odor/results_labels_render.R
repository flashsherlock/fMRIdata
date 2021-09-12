# default values
path <- "/Volumes/WD_E/gufei/7T_odor/"
mp<- c("roi_VIvaAM1odor_l1_label_6")
analysis <- c("pabiode")
# subs 
subs <- c("S01_yyt",sprintf('S%02d',c(1:3)))
# rois
roi <- c('Amy8_align','corticalAmy','CeMeAmy','BaLaAmy','Pir_new','Pir_old','APC_new','APC_old','PPC')
roiname <- c("Amy","Cortical","CeMe","BaLa","Pir_new","Pir_old","APC_new","APC_old","PPC")

# render ratings
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/ratings.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0("Raings"))

# odor_va results
# render mean mvpa results
title <- "Mean_odor_vaAM14odor"
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/results_labels_mean.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0("Mean_vaAM14odor"),
                  params = list(sub = subs, set_title = title, analysis = analysis, 
                                roi = roi, roiname = roiname, mvpa_pattern = mp))

# render roistats
suffix <- "_tentva.txt"
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/roistatas.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0("ROIstatas_va"),
                  params = list(sub = subs, roi = roi, suffix = suffix))

# render diffmap
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/diffmap.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0("diffmap"),
                  params = list(sub = subs, roi = roi))

# S01 compare run
i_sub <- "S01"
analysis <- c("pabiode","pabio5r","pabio12run","pabio11run")
mp <- "roi_VIvaodor_l1_label_6"
title <-  paste("Amygdala_decoding", i_sub, mp,"motion",sep = "_")
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/results_labels.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0(i_sub,'_runs'),
                  params = list(sub = i_sub, set_title = title, analysis = analysis,
                                roi = roi, roiname = roiname, mvpa_pattern = mp))

# render mvpa results for each subject
for (i_sub in subs) {
  # # bioact, with activation mask
  # analysis <- c("pabiode")
  # roi <- c('Amy9_at165','corticalAmy_at165',paste0('Amy_at165',c(1,3,7:10,15),'seg'))
  # rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/results_labels.Rmd",
  #                   output_dir = paste0(path,"results_labels_r"),
  #                   output_file = paste0(i_sub,'_bioact'),
  #                   params = list(sub = i_sub, set_title = title, analysis = analysis, roi = roi))
  # params = list(path = path, analysis = analysis, mvpa_pattern = mp, roi = roi)

  # bio analysis, add odor_va regressor, combine to three large ROIs, add piriform roi
  analysis <- c("pabiode")
  title <-  paste("Amygdala_decoding", i_sub, mp,sep = "_")
  rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/results_labels.Rmd",
                    output_dir = paste0(path,"results_labels_r"),
                    output_file = paste0(i_sub,'_biova'),
                    params = list(sub = i_sub, set_title = title, analysis = analysis, 
                                  roi = roi, roiname = roiname, mvpa_pattern = mp))
}

mp<- c("roi_VIodor_l1_label_6")
# odor_va results
# render mean mvpa results
title <- "Mean_odor"
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/results_labels_mean.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0("Mean"),
                  params = list(sub = subs, set_title = title, analysis = analysis, 
                                roi = roi, roiname = roiname, mvpa_pattern = mp))

# render roistats
suffix <- "_tent.txt"
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/roistatas.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0("ROIstatas"),
                  params = list(sub = subs, roi = roi, suffix = suffix))

# render mvpa results for each subject
for (i_sub in subs) {
  # bio analysis,combine to three large ROIs, add piriform roi
  analysis <- c("pabiode")
  title <-  paste("Amygdala_decoding", i_sub, mp,sep = "_")
  rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/results_labels.Rmd",
                    output_dir = paste0(path,"results_labels_r"),
                    output_file = paste0(i_sub,'_bio'),
                    params = list(sub = i_sub, set_title = title, analysis = analysis, 
                                  roi = roi, roiname = roiname, mvpa_pattern = mp))
}

# S01 compare motion
# i_sub <- "S01"
# analysis <- c("pabiode","pabiocen","pabio5r")
# roi <- c('Amy9_align','corticalAmy_align','CeMeAmy_align','BaLaAmy_align', paste0('Amy_align',c(1,3,5:10,15),'seg'))
# roiname <- c("Amy","Cortical","CeMe","BaLa","La","Ba","Ce","Me","Co","AB","CAT","AAA","PL")
# mp <- "roi_VIvaodor_l1_label_6"
# title <-  paste("Amygdala_decoding", i_sub, mp,"motion",sep = "_")
# rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/results_labels.Rmd",
#                   output_dir = paste0(path,"results_labels_r"),
#                   output_file = paste0(i_sub,'_motion'),
#                   params = list(sub = i_sub, set_title = title, analysis = analysis,
#                                 roi = roi, roiname = roiname, mvpa_pattern = mp))
# 
