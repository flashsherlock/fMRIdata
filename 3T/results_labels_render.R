# default values"
path <- "/Volumes/WD_F/gufei/3T_cw/"
# subs no 12 15 30
subs <- c(sprintf('S%02d',c(3:29)))
# rois
roibase <- c('Amy8_at165','corticalAmy_at165','CeMeAmy_at165','BaLaAmy_at165')
roiname <- c("Amy","Cortical","CeMe","BaLa")
suf <- c("14","14p")
rois <- c("at165","atfix165","atfixdu165")
# roibase <- c('Amy8_at165','Pir_new_at165',"Fusiform_at165","FFA_at165","FusiformCA_at165","FFA_CA_at165")
# roiname <- c("Amy","Piriform","Fusiform","FFA","FusiformCA","FFA_CA")
roibase <- c('Amy8_at165','Pir_new_at165',"FusiformCA_at165","FFA_CA_at165")
roiname <- c("Amy","Piriform","FusiformCA","FFA_CA")
rois <- c("at165")
# render roistats
for (roi_i in rois){
  # replace roi with rois
  roi <- gsub("at165",roi_i,roibase)
  for (s in suf) {
    suffix <- paste0("_tent_", s, ".txt")
    rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/3T/roistatas3t.Rmd",
                      output_dir = paste0(path,"results_labels_r"),
                      output_file = paste("ROIstatas",roi_i,s,sep = "_"),
                      params = list(path = path, sub = subs, roi = roi, roiname = roiname, suffix = suffix))
  }
}
roi <- c("Indiv40_0.001_odor_Pir",
         "Indiv40_0.001_odor_Amy",
         "Indiv40_0.001_face_vis_fusiform",
         "Indiv40_0.001_fointer_inv_Amy")
roiname <- c("Pir_odor","Amy_odor","Fus_facevis","Amy_interinv")
s <- "14"
suffix <- paste0("_tent_", s, ".txt")
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/3T/roistatas3t.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste("ROIstatas","indiv40",s,sep = "_"),
                  params = list(path = path, sub = subs, roi = roi, roiname = roiname, suffix = suffix))
# mvpa results
mvpa_pattern <- "roi_face_shift6"
roi <- c('all_Amy8_align','all_Amy8_at165','vis_Amy8_align','vis_Amy8_at165','inv_Amy8_align','inv_Amy8_at165')
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/3T/results_labels_mean.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste("mvpa_faces"),
                  params = list(path = path, sub = subs, roi = roi, roiname = roi, mvpa_pattern = mvpa_pattern))
mvpa_pattern <- "roi_odor_shift6"
roi <- c('all_Amy8_align','all_Amy8_at165')
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/3T/results_labels_mean.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste("mvpa_odors"),
                  params = list(path = path, sub = subs, roi = roi, roiname = roi, mvpa_pattern = mvpa_pattern))
# transition
for (con in c('odor','face')) {
mvpa_pattern <- paste0('roi_',con,'trans_shift6')
roi <- c('vis_Amy8_align','vis_Amy8_at165','inv_Amy8_align','inv_Amy8_at165',
         'con_Amy8_align','con_Amy8_at165','inc_Amy8_align','inc_Amy8_at165')
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/3T/results_labels_mean.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0("mvpa_trans",con),
                  params = list(path = path, sub = subs, roi = roi, roiname = roi, mvpa_pattern = mvpa_pattern))
}
