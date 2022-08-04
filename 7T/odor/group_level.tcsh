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
# mris_convert mni_recon/surf/lh.pial mni_recon/lh.pial.stl
# right hemisphere
# mris_convert mni_recon/surf/rh.pial mni_recon/rh.pial.stl

# make dir to save masks
if (! -e mask) then
    mkdir mask
endif

# change segmentation masks to experiment space
# can also use -surf_anat_followers option in @SUMA_AlignToExperiment 
foreach mask (${masks})
    set input = `echo ${mask} | sed 's/mri/SUMA/' | sed 's/.mgz/.nii/'`
    set output = `echo ${input} | cut -d '/' -f 3 | sed 's/.nii/+tlrc/'`
    # resample to the EPI grid
    3dresample                                                             \
        -master MNI152_T1_2009c+tlrc                                       \
        -prefix mask/${output}                                             \
        -input  ${input}
    set lr=`echo ${output} | cut -c1`
    3dcalc -a "mask/${output}<7001..7015>" -expr 'step(a-7000)' -prefix mask/${lr}Amy.freesurfer+tlrc   
    3dcalc -a "mask/${output}" -expr 'ispositive(a-7000)*(a-7000)' -prefix mask/${lr}Amy.seg.freesurfer+tlrc   
end

# all of the amygdala
3dcalc -a mask/lAmy.freesurfer+tlrc -b mask/rAmy.freesurfer+tlrc -expr 'a+b' -prefix mask/Amy9_align.freesurfer+tlrc
# different regions of amygdala
3dcalc -a mask/lAmy.seg.freesurfer+tlrc -b mask/rAmy.seg.freesurfer+tlrc -expr 'a+b' -prefix mask/sAmy.freesurfer+tlrc

# # Print number of voxels for each ROI
3dROIstats -nzvoxels -mask mask/sAmy.freesurfer+tlrc mask/sAmy.freesurfer+tlrc >! mask/voxels.txt

# create cortical amygdala mask
3dcalc -a mask/sAmy.freesurfer+tlrc -expr 'amongst(a,7,9)' -prefix mask/corticalAmy_align.freesurfer+tlrc
# create centralmedial amygdala mask
3dcalc -a mask/sAmy.freesurfer+tlrc -expr 'amongst(a,5,6)' -prefix mask/CeMeAmy_align.freesurfer+tlrc
# create lateralbasal amygdala mask
3dcalc -a mask/sAmy.freesurfer+tlrc -expr 'amongst(a,1,3,8,15)' -prefix mask/BaLaAmy_align.freesurfer+tlrc
# creat amygdala mask without AAA
3dcalc -a mask/sAmy.freesurfer+tlrc -expr 'amongst(a,1,3,5,6,7,8,9,15)' -prefix mask/Amy8_align.freesurfer+tlrc

# create mask for each region
foreach region (1 3 5 6 7 8 9 10 15)
    3dcalc -a mask/sAmy.freesurfer+tlrc -expr "equals(a,${region})" -prefix mask/Amy_align${region}seg.freesurfer+tlrc
end

# mask for piriform
# resample Piriform mask
3dcopy COPY_MNI152_T1_2009c+tlrc mask/Piriform.seg+tlrc
# creat piriform mask and remove voxels in Amy
3dcalc -a mask/Piriform.seg+tlrc -b mask/sAmy.freesurfer+tlrc -expr 'amongst(a,21,22,29)*iszero(b)' -prefix mask/Pir_new.draw+orig
# creat old piriform mask
3dcalc -a mask/Piriform.seg+tlrc -b mask/sAmy.freesurfer+tlrc -expr 'amongst(a,21,22)*iszero(b)' -prefix mask/Pir_old.draw+orig
# create APC_new
3dcalc -a mask/Piriform.seg+tlrc -b mask/sAmy.freesurfer+tlrc -expr 'amongst(a,21,29)*iszero(b)' -prefix mask/APC_new.draw+orig
# create APC_old
3dcalc -a mask/Piriform.seg+tlrc -b mask/sAmy.freesurfer+tlrc -expr 'amongst(a,21)*iszero(b)' -prefix mask/APC_old.draw+orig
# creat PPC
3dcalc -a mask/Piriform.seg+tlrc -b mask/sAmy.freesurfer+tlrc -expr 'amongst(a,22)*iszero(b)' -prefix mask/PPC.draw+orig

# combine Piriform and Amygdala
3dcalc -a mask/Amy8_align.freesurfer+tlrc -b mask/Pir_new.draw+tlrc \
-prefix mask/allROI \
-expr "or(a,b)"