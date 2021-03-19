# default values
path <- "/Volumes/WD_E/gufei/7T_odor/"
analysis <- c("pade","paphde","pabiode")
mvpa_pattern <- c("roi_VIodor_l1_label_6")
roi <- c('Amy9_align','corticalAmy_align',paste0('Amy_align',c(1,3,5:10,15),'seg'))
roi <- c('Amy9_align',paste0('Amy_align',c(1,3,8:9),'seg'))
# roi <- c('Amy9_at165','corticalAmy_at165',paste0('Amy_at165',c(1,3,7:10,15),'seg'))
# subs 
sub <- c("S01_yyt",sprintf('S%02d',c(1:3)))
for (i_sub in sub) {
  title <-  paste("Amygdala_decoding", i_sub, mvpa_pattern,sep = "_")
  rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/results_labels.Rmd",
                    output_dir = paste0(path,"results_labels_r"),
                    output_file = paste0(i_sub,'_large'),
                    params = list(sub = i_sub, set_title = title, analysis = analysis, roi = roi))
  # params = list(path = path, analysis = analysis, mvpa_pattern = mvpa_pattern, roi = roi)
}