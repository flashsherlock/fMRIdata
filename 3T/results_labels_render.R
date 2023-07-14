# default values"
path <- "/Volumes/WD_F/gufei/3T_cw/"
# subs no 12 15 30
subs <- c(sprintf('S%02d',c(3:29)))
# rois
roi <- c('Amy8_at165','corticalAmy_at165','CeMeAmy_at165','BaLaAmy_at165')
roiname <- c("Amy","Cortical","CeMe","BaLa")
suf <- c("14","14p")
# render roistats
for (s in suf) {
  suffix <- paste0("_tent_", s, ".txt")
  rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/3T/roistatas3t.Rmd",
                    output_dir = paste0(path,"results_labels_r"),
                    output_file = paste0("ROIstatas_align",s),
                    params = list(path = path, sub = subs, roi = roi, roiname = roiname, suffix = suffix))
}


roi <- c('Amy8_atfix165','corticalAmy_atfix165','CeMeAmy_atfix165','BaLaAmy_atfix165')
# render roistats
for (s in suf) {
  suffix <- paste0("_tent_", s, ".txt")
  rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/3T/roistatas3t.Rmd",
                    output_dir = paste0(path,"results_labels_r"),
                    output_file = paste0("ROIstatas_fix",s),
                    params = list(path = path, sub = subs, roi = roi, roiname = roiname, suffix = suffix))
}

roi <- c('Amy8_at11s165','corticalAmy_at11s165','CeMeAmy_at11s165','BaLaAmy_at11s165')
# render roistats
for (s in suf) {
  suffix <- paste0("_tent_", s, ".txt")
  rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/3T/roistatas3t.Rmd",
                    output_dir = paste0(path,"results_labels_r"),
                    output_file = paste0("ROIstatas_11s",s),
                    params = list(path = path, sub = subs, roi = roi, roiname = roiname, suffix = suffix))
}
