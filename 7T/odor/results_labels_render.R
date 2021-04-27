# default values
path <- "/Volumes/WD_E/gufei/7T_odor/"
mvpa_pattern <- c("roi_VIodor_l1_label_6")
# subs 
sub <- c("S01_yyt",sprintf('S%02d',c(1:3)))
# render mvpa results for each subject
for (i_sub in sub) {
  # title <-  paste("Amygdala_decoding", i_sub, mvpa_pattern,sep = "_")
  # # all ROIs and all analysis
  # analysis <- c("pade","paphde","pabiode")
  # roi <- c('Amy9_align',paste0('Amy_align',c(1,3,5:10,15),'seg'))
  # rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/results_labels.Rmd",
  #                   output_dir = paste0(path,"results_labels_r"),
  #                   output_file = paste0(i_sub),
  #                   params = list(sub = i_sub, set_title = title, analysis = analysis, roi = roi))
  # # large ROIs only, as well as cortical+CAT=corticalAmy
  # roi <- c('Amy9_align','corticalAmy_align',paste0('Amy_align',c(1,3,8:9),'seg'))
  # rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/results_labels.Rmd",
  #                   output_dir = paste0(path,"results_labels_r"),
  #                   output_file = paste0(i_sub,'_large'),
  #                   params = list(sub = i_sub, set_title = title, analysis = analysis, roi = roi))
  # # bio analysis
  # analysis <- c("pabiode")
  # roi <- c('Amy9_align',paste0('Amy_align',c(1,3,5:10,15),'seg'))
  # rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/results_labels.Rmd",
  #                   output_dir = paste0(path,"results_labels_r"),
  #                   output_file = paste0(i_sub,'_bio'),
  #                   params = list(sub = i_sub, set_title = title, analysis = analysis, roi = roi))
  # # bioact, with activation mask
  # analysis <- c("pabiode")
  # roi <- c('Amy9_at165','corticalAmy_at165',paste0('Amy_at165',c(1,3,7:10,15),'seg'))
  # rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/results_labels.Rmd",
  #                   output_dir = paste0(path,"results_labels_r"),
  #                   output_file = paste0(i_sub,'_bioact'),
  #                   params = list(sub = i_sub, set_title = title, analysis = analysis, roi = roi))
  # params = list(path = path, analysis = analysis, mvpa_pattern = mvpa_pattern, roi = roi)

  # bio analysis, add odor_va regressor, combine to three large ROIs
  analysis <- c("pabiode")
  roi <- c('Amy9_align','corticalAmy_align','CeMeAmy_align','BaLaAmy_align', paste0('Amy_align',c(1,3,5:10,15),'seg'))
  roiname <- c("Amy","Cortical","CeMe","BaLa","La","Ba","Ce","Me","Co","AB","CAT","AAA","PL")
  mp <- "roi_VIvaodor_l1_label_6"
  title <-  paste("Amygdala_decoding", i_sub, mp,sep = "_")
  rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/results_labels.Rmd",
                    output_dir = paste0(path,"results_labels_r"),
                    output_file = paste0(i_sub,'_biova'),
                    params = list(sub = i_sub, set_title = title, analysis = analysis, 
                                  roi = roi, roiname = roiname, mvpa_pattern = mp))
}

# render mean mvpa results
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/results_labels_mean.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0("Mean"),
                  params = list(sub = sub, analysis = analysis, roi = roi))

# render ratings
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/ratings.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0("Raings"))

# render roistats
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/roistatas.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0("ROIstatas"),
                  params = list(sub = sub))

# odor_va results
# render mean mvpa results
analysis <- c("pabiode")
title <- "Mean_odor_va"
roi <- c('Amy9_align','corticalAmy_align','CeMeAmy_align','BaLaAmy_align', paste0('Amy_align',c(1,3,5:10,15),'seg'))
roiname <- c("Amy","Cortical","CeMe","BaLa","La","Ba","Ce","Me","Co","AB","CAT","AAA","PL")
mp <- "roi_VIvaodor_l1_label_6"
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/results_labels_mean.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0("Mean_va"),
                  params = list(sub = sub, set_title = title, analysis = analysis, 
                                roi = roi, roiname = roiname, mvpa_pattern = mp))

# render roistats
suffix <- "_tentva.txt"
roi <- c('Amy9_align','corticalAmy_align','CeMeAmy_align','BaLaAmy_align', paste0('Amy_align',c(1,3,5:10,15),'seg'))
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/roistatas.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0("ROIstatas_va"),
                  params = list(sub = sub, roi = roi, suffix = suffix))