#! /bin/csh

set datafolder=/Volumes/WD_E/gufei/7T_odor/group
cd "${datafolder}"
# generate template and brain mask
3dTcat -prefix MNI152_2009.nii ~/abin/MNI152_2009_template_SSW.nii.gz'[1]'
3dTcat -prefix bmask.nii ~/abin/MNI152_2009_template_SSW.nii.gz'[3]'
# use freesurfer to reconstruct surfaces
# -sd pass working dir, the default is defined by env var 
# high resolution reconstruction
recon-all                                                                   \
    -i MNI152_2009.nii                                                  \
    -s mni_recon -sd ./                                                     \
    -all                                                                    \
    -parallel -threads 12

# create files for suma
# -fs_setup might me useful on macOS according to the help page
@SUMA_Make_Spec_FS -fs_setup -NIFTI -fspath mni_recon -sid MNI152_2009c

# Amygdala segmentation
# use multipal threads
setenv ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS 8
# the second input is subject_dir, error will occur when using ./
segmentHA_T1.sh mni_recon ${datafolder}
# save amygdala mask
set masks = `ls mni_recon/mri/?h.hippoAmygLabels-T1.v21.HBT.mgz`
# echo ${masks}
foreach mask (${masks})
    # echo ${mask}
    # change name
    set name = `echo ${mask} | cut -d '/' -f 3 | sed 's/.mgz/.nii/'`
    # echo ${name}
    mri_convert -ot nii ${mask} mni_recon/SUMA/${name}
end

# generate surface model
# left hemisphere
mris_convert mni_recon/surf/lh.pial mni_recon/lh.pial.stl
# right hemisphere
mris_convert mni_recon/surf/rh.pial mni_recon/rh.pial.stl
