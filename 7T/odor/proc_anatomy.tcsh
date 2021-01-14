#! /bin/csh
# use @SSwarper to process anatomy
set sub=S01_yyt
set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"

@SSwarper -input   S01_yyt.uniden15.nii             \
                   -subid ${sub}                    \
                   -odir  ${sub}_anat_warped        \
                   -base  MNI152_2009_template_SSW.nii.gz
