#!/bin/tcsh
# set sub=S01_yyt
# use input as sub
if ( $# > 0 ) then
set sub = $1
set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}
# set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"

switch ($2)
    case bio:
        set analysis=pabiode
        breaksw
    case phy:
        set analysis=paphde
        breaksw
    case no:
        set analysis=pade
        breaksw
    default:
        echo The second input must be bio, phy or no.
        echo ${analysis}
endsw

echo ${sub} ${analysis}

# run the regression analysis
set subj = ${sub}.${analysis}
cd ${subj}.results

# # auto tlrc to MNI space
# # normalize Anatomical img to mni space
# @auto_tlrc -no_ss -init_xform AUTO_CENTER -maxite 500 -base ~/abin/MNI152_T1_2009c+tlrc. -input anat_final.${sub}.${analysis}+orig
# # align to nomalized Anatomical img
# @auto_tlrc -apar anat_final.${sub}.${analysis}+tlrc -input stats.${subj}+orig

# generate t threshold masks
# all of the amygdala
# 3dcalc  -a stats.${subj}+orig'[2]' \
#         -b stats.${subj}+orig'[5]' \
#         -c stats.${subj}+orig'[8]' \
#         -d stats.${subj}+orig'[11]' \
#         -e ./Amy.freesurfer+orig \
#         -expr 'or(step(a-1.65),step(b-1.65),step(c-1.65),step(d-1.65))*e' \
#         -prefix Amy_t165.freesurfer
# 3dcopy Amy_t165.freesurfer+orig ../mask/Amy9_at165.freesurfer+orig
# # different regions of amygdala
# 3dcalc  -a stats.${subj}+orig'[2]' \
#         -b stats.${subj}+orig'[5]' \
#         -c stats.${subj}+orig'[8]' \
#         -d stats.${subj}+orig'[11]' \
#         -e ./Amy.seg.freesurfer+orig \
#         -expr 'or(step(a-1.65),step(b-1.65),step(c-1.65),step(d-1.65))*e' \
#         -prefix Amy.seg_t165.freesurfer
# # Print number of voxels for each ROI
# 3dROIstats -nzvoxels -mask Amy.seg_t165.freesurfer+orig.HEAD Amy.seg_t165.freesurfer+orig.HEAD >! ../mask/voxels_act.txt

# # create cortical amygdala mask
# 3dcalc -a Amy.seg_t165.freesurfer+orig -expr 'amongst(a,7,9)' -prefix ../mask/corticalAmy_at165.freesurfer+orig

# # create mask for each region
# foreach region (1 3 5 6 7 8 9 10 15)
#     3dcalc -a Amy.seg_t165.freesurfer+orig -expr "equals(a,${region})" -prefix ../mask/Amy_at165${region}seg.freesurfer+orig
# end

# extract tent and beta values
set filedec = odorVI_noblur
set maskdec = align # at165 or align
set data_tent=tent.${subj}.${filedec}+orig
set data_beta=stats.${subj}+orig

# make dir
if (! -e ../../stats) then
    mkdir ../../stats
endif
if (! -e ../../stats/${sub}) then
    mkdir ../../stats/${sub}
endif

# # extract tent data (without blur)
3dROIstats -mask ../mask/Amy9_${maskdec}.freesurfer+orig \
-nzmean ${data_tent}"[`seq -s , 1 43`44]" >! ../../stats/${sub}/Amy9_${maskdec}_tent.txt

# extract betas from blurred statas
3dROIstats -mask ../mask/Amy9_${maskdec}.freesurfer+orig \
-nzmean ${data_beta}"[`seq -s , 1 3 9`10]" >! ../../stats/${sub}/Amy9_${maskdec}_beta.txt

foreach region (1 3 5 6 7 8 9 10 15)
    3dROIstats -mask ../mask/Amy_${maskdec}${region}seg.freesurfer+orig \
    -nzmean ${data_tent}"[`seq -s , 1 43`44]" >! ../../stats/${sub}/Amy_${maskdec}_seg${region}_tent.txt
    3dROIstats -mask ../mask/Amy_${maskdec}${region}seg.freesurfer+orig \
    -nzmean ${data_beta}"[`seq -s , 1 3 9`10]" >! ../../stats/${sub}/Amy_${maskdec}_seg${region}_beta.txt
end

else
 echo "Usage: $0 <Subjname> <analysis>"

endif
