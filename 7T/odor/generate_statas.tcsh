#!/bin/tcsh
# set sub=S01_yyt
# use input as sub
if ( $# > 0 ) then
set sub = $1
set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}
# set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"
set analysis=pabiode

# switch ($2)
#     case bio:
#         set analysis=pabiode
#         breaksw
#     case phy:
#         set analysis=paphde
#         breaksw
#     case no:
#         set analysis=pade
#         breaksw
#     default:
#         echo The second input must be bio, phy or no.
#         echo ${analysis}
# endsw

echo ${sub} ${analysis}

# run the regression analysis
set subj = ${sub}.${analysis}
set subjva = ${subj}.odorVIva
cd ${subj}.results

# # auto tlrc to MNI space
# # normalize Anatomical img to mni space
# @auto_tlrc -no_ss -init_xform AUTO_CENTER -maxite 500 -base ~/abin/MNI152_T1_2009c+tlrc. -input anat_final.${sub}.${analysis}+orig
# # align to nomalized Anatomical img
# @auto_tlrc -apar anat_final.${sub}.${analysis}+tlrc -input stats.${subj}+orig
rm *t165.freesurfer*
rm ../mask/*at165*
# generate t threshold masks
# all of the amygdala
3dcalc  -a stats.${subjva}+orig'[2]' \
        -b stats.${subjva}+orig'[5]' \
        -c stats.${subjva}+orig'[8]' \
        -d stats.${subjva}+orig'[11]' \
        -e ./Amy.freesurfer+orig \
        -expr 'or(astep(a,1.65),astep(b,1.65),astep(c,1.65),astep(d,1.65))*e' \
        -prefix Amy_t165.freesurfer
3dcopy Amy_t165.freesurfer+orig ../mask/Amy9_at165.freesurfer+orig
# different regions of amygdala
3dcalc  -a stats.${subjva}+orig'[2]' \
        -b stats.${subjva}+orig'[5]' \
        -c stats.${subjva}+orig'[8]' \
        -d stats.${subjva}+orig'[11]' \
        -e ./Amy.seg.freesurfer+orig \
        -expr 'or(astep(a,1.65),astep(b,1.65),astep(c,1.65),astep(d,1.65))*e' \
        -prefix Amy.seg_t165.freesurfer
# Print number of voxels for each ROI
3dROIstats -nzvoxels -mask Amy.seg_t165.freesurfer+orig.HEAD Amy.seg_t165.freesurfer+orig.HEAD >! ../mask/voxels_act.txt

# create cortical amygdala mask
3dcalc -a Amy.seg_t165.freesurfer+orig -expr 'amongst(a,7,9)' -prefix ../mask/corticalAmy_at165.freesurfer+orig
# create centralmedial amygdala mask
3dcalc -a Amy.seg_t165.freesurfer+orig -expr 'amongst(a,5,6)' -prefix ../mask/CeMeAmy_at165.freesurfer+orig
# create lateralbasal amygdala mask
3dcalc -a Amy.seg_t165.freesurfer+orig -expr 'amongst(a,1,3,8,15)' -prefix ../mask/BaLaAmy_at165.freesurfer+orig
# create amygdala mask without AAA
3dcalc -a Amy.seg_t165.freesurfer+orig -expr 'amongst(a,1,3,5,6,7,8,9,15)' -prefix ../mask/Amy8_at165.freesurfer+orig

# create mask for each region
foreach region (1 3 5 6 7 8 9 10 15)
    3dcalc -a Amy.seg_t165.freesurfer+orig -expr "equals(a,${region})" -prefix ../mask/Amy_at165${region}seg.freesurfer+orig
end

# print activated voxels for odor_va
# different regions of amygdala
3dcalc  -a stats.${subjva}+orig'[20]' \
        -e ./Amy.seg.freesurfer+orig \
        -expr 'astep(a,1.65)*e' \
        -prefix Amy.seg_t165odorva.freesurfer
# Print number of odor_va activated voxels for each ROI
3dROIstats -nzvoxels -mask Amy.seg_t165odorva.freesurfer+orig.HEAD Amy.seg_t165odorva.freesurfer+orig.HEAD >! ../mask/voxels_va.txt

# extract tent and beta values
set filedec = odorVIva_noblur
set maskdec = align # at165 or align
set data_tent=tent.${subj}.${filedec}+orig
set data_beta=stats.${subj}+orig
set data_beta_va=stats.${subj}.odorVIva+orig

# # make dir
# if (! -e ../../stats) then
#     mkdir ../../stats
# endif
# if (! -e ../../stats/${sub}) then
#     mkdir ../../stats/${sub}
# endif

# foreach region (Amy9 corticalAmy CeMeAmy BaLaAmy)
#     # extract tent data (without blur)
#     3dROIstats -mask ../mask/${region}_${maskdec}.freesurfer+orig \
#     -nzmean ${data_tent}"[`seq -s , 1 43`44]" >! ../../stats/${sub}/${region}_${maskdec}_tentva.txt

#     # extract betas from blurred statas
#     # 3dROIstats -mask ../mask/${region}_${maskdec}.freesurfer+orig \
#     # -nzmean ${data_beta}"[`seq -s , 1 3 9`10]" >! ../../stats/${sub}/${region}_${maskdec}_beta.txt
# end

# foreach region (1 3 5 6 7 8 9 10 15)
#     3dROIstats -mask ../mask/Amy_${maskdec}${region}seg.freesurfer+orig \
#     -nzmean ${data_tent}"[`seq -s , 1 43`44]" >! ../../stats/${sub}/Amy_${maskdec}${region}seg_tentva.txt

#     # 3dROIstats -mask ../mask/Amy_${maskdec}${region}seg.freesurfer+orig \
#     # -nzmean ${data_beta}"[`seq -s , 1 3 9`10]" >! ../../stats/${sub}/Amy_${maskdec}${region}seg_beta.txt
# end

# # extract beta values from each voxel
# 3dmaskdump -mask ../mask/sAmy.freesurfer+orig   \
#     -mrange 1 15                                \
#     -o ../../stats/${sub}/sAmy_betadiff.txt     \
#     ../mask/sAmy.freesurfer+orig                \
#     ${data_beta}"[`seq -s , 19 3 33`34,`seq -s , 20 3 34`35]"
#     # -o option can not replace exsisting files
#     # >! ../../stats/${sub}/sAmy_betadiff.txt
rm ../../stats/${sub}/sAmy_betadiff_va.txt
# extract beta values from odor_va the number of data should +3
3dmaskdump -mask ../mask/sAmy.freesurfer+orig   \
    -mrange 1 15                                \
    -o ../../stats/${sub}/sAmy_betadiff_va.txt     \
    ../mask/sAmy.freesurfer+orig                \
    ${data_beta_va}"[`seq -s , 22 3 36`37,`seq -s , 23 3 37`38]"

else
 echo "Usage: $0 <Subjname> <analysis>"

endif
