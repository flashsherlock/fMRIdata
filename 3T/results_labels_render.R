# default values"
path <- "/Volumes/WD_F/gufei/3T_cw/"
# subs no 12 15 30
subs <- c(sprintf('S%02d',c(3:29)))
# rois
# roibase <- c('Amy8_at165','Pir_new_at165',"Fusiform_at165","FFA_at165","FusiformCA_at165","FFA_CA_at165")
# roiname <- c("Amy","Piriform","Fusiform","FFA","FusiformCA","FFA_CA")
roibase <- c('Amy8_at165','Pir_new_at165',"FusiformCA_at165","FFA_CA_at165")
roiname <- c("Amy","Piriform","FusiformCA","FFA_CA")
roibase <- c('OFC6mm_at165','insulaCA_at165',"aSTS_OR_at165","FFV_CA_at165")
roiname <- c("OFC","insula","aSTS","FFV")
suf <- c("14","14p")
rois <- c("at165")
# render roistats
for (roi_i in rois){
  # replace roi with rois
  roi <- gsub("at165",roi_i,roibase)
  for (s in suf) {
    suffix <- paste0("_tent_", s, ".txt")
    rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/3T/roistatas3t.Rmd",
                      output_dir = paste0(path,"results_labels_r"),
                      output_file = paste("ROIstatas_add",roi_i,s,sep = "_"),
                      params = list(path = path, sub = subs, roi = roi, roiname = roiname, suffix = suffix))
  }
}
roi <- c("Indiv40_0.001_odor_Pir",
         "Indiv40_0.001_odor_Amy",
         "Indiv4_0.001_odor_OFC",
         "Indiv40_0.001_face_vis_fusiform",
         "Indiv40_0.001_fointer_inv_Amy")
roiname <- c("Pir_odor","OFC_odor","Amy_odor","Fus_facevis","Amy_interinv")
s <- "14"
suffix <- paste0("_tent_", s, ".txt")
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/3T/roistatas3t.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste("ROIstatas","indiv40",s,sep = "_"),
                  params = list(path = path, sub = subs, roi = roi, roiname = roiname, suffix = suffix))
# mvpa results
mvpa_pattern <- "roi_face_shift6"
roi <- c('all_Amy8_align','all_Amy8_at165','vis_Amy8_align','vis_Amy8_at165','inv_Amy8_align','inv_Amy8_at165',
         'all_Pir_new','all_Pir_new_at165','vis_Pir_new','vis_Pir_new_at165','inv_Pir_new','inv_Pir_new_at165',
         'all_fusiformCA','all_fusiformCA_at165','vis_fusiformCA','vis_fusiformCA_at165','inv_fusiformCA','inv_fusiformCA_at165')
roi <- c('all_Amy8_align','vis_Amy8_align','inv_Amy8_align')
roi <- c('all_Pir_new','vis_Pir_new','inv_Pir_new',
         'all_OFC6mm','vis_OFC6mm','inv_OFC6mm',
         'all_FFV_CA','vis_FFV_CA','inv_FFV_CA')
roi <- c('all_aSTS','vis_aSTS','inv_aSTS',
         'all_OFC_AAL','vis_OFC_AAL','inv_OFC_AAL')
roi <- c('all_APC_old','vis_APC_old','inv_APC_old',
         'all_APC_new','vis_APC_new','inv_APC_new',
         'all_PPC','vis_PPC','inv_PPC')
roi <- c('all_FFV_CA05','vis_FFV_CA05','inv_FFV_CA05',
         'all_FFV_CA01','vis_FFV_CA01','inv_FFV_CA01',
         'all_FFV_CA005','vis_FFV_CA005','inv_FFV_CA005',
         'all_FFV_CA001','vis_FFV_CA001','inv_FFV_CA001')
roi <- c('all_Pir_new05','vis_Pir_new05','inv_Pir_new05',
         'all_Pir_new01','vis_Pir_new01','inv_Pir_new01',
         'all_Pir_new005','vis_Pir_new005','inv_Pir_new005',
         'all_Pir_new001','vis_Pir_new001','inv_Pir_new001')
roi <- c('all_aSTS_OR05','vis_aSTS_OR05','inv_aSTS_OR05',
         'all_aSTS_OR01','vis_aSTS_OR01','inv_aSTS_OR01',
         'all_aSTS_OR005','vis_aSTS_OR005','inv_aSTS_OR005',
         'all_aSTS_OR001','vis_aSTS_OR001','inv_aSTS_OR001')
roi <- c(  "all_pSTS_OR", "vis_pSTS_OR", "inv_pSTS_OR",
           "all_aSTS", "vis_aSTS", "inv_aSTS")
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/3T/results_labels_mean.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste("mvpa_faces_Pir_news"),
                  params = list(path = path, sub = subs, roi = roi, roiname = roi, mvpa_pattern = mvpa_pattern))
mvpa_pattern <- "roi_odor_shift6"
roi <- c('all_pSTS_OR','all_aSTS')
roi <- c('all_aSTS_OR05','all_aSTS_OR01','all_aSTS_OR005','all_aSTS_OR001')
roi <- c('all_Pir_new05','all_Pir_new01','all_Pir_new005','all_Pir_new001')
roi <- c('all_FFV_CA05','all_FFV_CA01','all_FFV_CA005','all_FFV_CA001')
roi <- c('all_APC_old','all_APC_new','all_PPC')
roi <- c('all_Amy8_align','all_Amy8_at165','all_Pir_new','all_Pir_new_at165','all_fusiformCA','all_fusiformCA_at165')
roi <- c('all_Amy8_align')
roi <- c('all_Pir_new','all_OFC6mm','all_FFV_CA')
roi <- c('all_aSTS','all_OFC_AAL')
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/3T/results_labels_mean.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste("mvpa_odors_Pir_news"),
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
