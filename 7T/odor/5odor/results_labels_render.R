# default values
# path <- "/Volumes/WD_E/gufei/7T_odor/"
path <- "/Volumes/WD_F/gufei/7T_odor/"
# mp<- c("roi_VIvaodor_l1_label_6")
mp <- c("roi_ARodor_l1_select50base_-6-36")
analysis <- c("pabiode")
# subs no 12 15 30
subs <- c(sprintf('S%02d',c(4:11,13,14,16:29,31:34)))
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
                  output_file = paste0("Raings_28sub"))

# odor_va results
# render mean mvpa results
title <- "Mean6_6ARbase_select50_-6_-3_6"
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/5odor/results_labels_mean.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0("Mean_6ARbase_2TR50vox_434"),
                  params = list(path = path, sub = subs, set_title = title, analysis = analysis, 
                                roi = roi, roiname = roiname, mvpa_pattern = mp))

# render roistats
suffix <- "_tent_12.txt"
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/5odor/roistatas.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0("ROIstatas_28sub_12"),
                  params = list(path = path, sub = subs, roi = roi, suffix = suffix))

# render voxel search
threshold <- 2.051831 # DOF = 27 ccalc -expr "cdf2stat(0.975,3,27,0,0)"
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/5odor/voxels_search.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0("searchlight_group_rmbase"),
                  params = list(path = path, sub = "search_rmbase", thr = threshold, percent = 1))
# render voxel group
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/5odor/voxels_group.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0("group"),
                  params = list(path = path, sub = "results", thr = threshold))
threshold <- 2.160369 # DOF = 13
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/5odor/voxels_group.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0("WARP_group_half1"),
                  params = list(path = path, sub = "WARP_results_half1", thr = threshold))
rmarkdown::render("/Users/mac/Documents/GitHub/fMRIdata/7T/odor/5odor/voxels_group.Rmd",
                  output_dir = paste0(path,"results_labels_r"),
                  output_file = paste0("WARP_group_half2"),
                  params = list(path = path, sub = "WARP_results_half2", thr = threshold))


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
