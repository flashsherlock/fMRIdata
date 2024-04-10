#! /bin/csh
# 预处理脚本

if ( $# > 0 ) then
 # set subj = $1

# setenv AFNI_DICOM_RESCALE YES
# setenv AFNI_DICOM_WINDOW NO

foreach subj (`echo $*`)

cd ${subj}
# echo ${subj}
# mkdir analysis
# mv ${subj}.str+orig* analysis
cd analysis
# rm *str_al*
set last=`ls FMRI*.HEAD | awk 'END {print}' | cut -c1-9`
# set middle=`ls FMRI*.HEAD | awk 'NR==3 {print}' | cut -c1-9`
# # echo ${last}
#
#
# foreach scan (`ls FMRI*.HEAD | cut -c1-9`)
#
# # echo ${scan}
# touch func_s.mot
# #align to the middle img
# 3dvolreg -verbose -base ${middle}_o+orig'[97]' -dfile ${scan}_bs1.mot  -prefix ${scan}_r_bs1 ${scan}_o+orig
# cat ${scan}_bs1.mot >> func_s.mot
#
# 3dTsmooth -prefix ${scan}_f  ${scan}_r_bs1+orig
#
# 3dmerge -1blur_fwhm 2.5 -doall -prefix ${scan}_merge ${scan}_f+orig
#
# 3dAutomask -prefix ${scan}_mask ${scan}_merge+orig
#
# 3dTstat -prefix ${scan}_mean_r ${scan}_merge+orig
#
# 3dcalc -a ${scan}_merge+orig -b ${scan}_mean_r+orig -expr "(a/b * 100)" -prefix ${scan}_s
#
# # rm ${scan}_r_bs1+orig*
# # rm ${scan}_f+orig*
# # rm ${scan}_merge+orig*
# # rm ${scan}_mean_r+orig*
# end
#
# #merge 5 runs
# 3dTcat -prefix func_${subj} `ls FMRI.*_s+orig.HEAD | cut -c1-16`
#
# 3dcalc -a func_${subj}+orig -b ${last}_mask+orig -expr 'a*b' -prefix ${subj}_func_s
#
# #remove some useless data
# rm FMRI.*_f+orig*
# rm FMRI.*_merge+orig*
# rm FMRI.*_mean_r+orig*
# rm FMRI.*_s+orig*

# # align epi to anat -partial_axial
# align_epi_anat.py -AddEdge -big_move -volreg_method '3dvolreg' -Allineate_opts '-warp shift_rotate' -anat ${subj}.str+orig -epi ${subj}_WB_EPI+orig. -epi_base 0
# align_epi_anat.py -AddEdge -big_move -volreg_method '3dvolreg' -Allineate_opts '-warp shift_rotate' -anat ${subj}.str+orig -epi ${last}_r_bs1+orig. -epi_base 0
# # align to MNI152_T1_2009c+tlrc
# @auto_tlrc -no_ss -maxite 500 -base ~/abin/MNI152_T1_2009c+tlrc. -input ${subj}.str_al+orig.
# @AddEdge ${last}_r_bs1+orig. ${subj}.str_al+orig.
@AddEdge -auto_record
# mv *_o+orig* ../
# mv *str+ori* ../
cd ..
cd ..
end

else
 echo "Usage: $0 <Subjname>"
endif
