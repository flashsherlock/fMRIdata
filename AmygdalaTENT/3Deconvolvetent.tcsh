#! /bin/csh
cd
if ( $# > 0 ) then
# set b=`echo \'\\\[${abc}22\\\]\'`
# 3dROIstats -mask S22.OdorValence.lateralAmyPU.t196+tlrc -nzmean S22.analysis.+tlrc`echo \\\[${abc}22\\\]`
# 3dROIstats -mask S22.OdorValence.lateralAmyPU.t196+tlrc -nzmean S22.analysis.+tlrc"[`seq -s , 1 3 20`22]"
# echo `echo "`seq -s , 1 3 20`"
# echo "hello1-`echo hello2-\`echo hello3-\\\`echo hello4\\\`\``"
# echo "hello1-`echo hello2-echo hello4\\\``"
# foreach subj (`echo $*`)
# foreach subj (`ls -d S*`)
foreach subj (S22)
#S22 S23 S24 S25 S26 S27 S28

cd *${subj}
#mkdir analysis
cd analysis

3dDeconvolve -input ${subj}_func_s+orig -num_stimts 14     \
 -jobs 2 \
 -polort 3 \
 -stim_file 1 func_s.mot'[1]' \
 -stim_file 2 func_s.mot'[2]' \
 -stim_file 3 func_s.mot'[3]' \
 -stim_file 4 func_s.mot'[4]' \
 -stim_file 5 func_s.mot'[5]' \
 -stim_file 6 func_s.mot'[6]' \
 -stim_base 1 \
 -stim_base 2 \
 -stim_base 3 \
 -stim_base 4 \
 -stim_base 5 \
 -stim_base 6 \
 -stim_times 7 ../../timingtxt/${subj}.FearPleaInv.txt 'TENT(0,20,11)' -stim_label 7 FearPleaInv \
 -stim_times 8 ../../timingtxt/${subj}.FearPleaVis.txt 'TENT(0,20,11)' -stim_label 8 FearPleaVis \
 -stim_times 9 ../../timingtxt/${subj}.FearUnpleaInv.txt 'TENT(0,20,11)' -stim_label 9 FearUnpleaInv \
 -stim_times 10 ../../timingtxt/${subj}.FearUnpleaVis.txt 'TENT(0,20,11)' -stim_label 10 FearUnpleaVis \
 -stim_times 11 ../../timingtxt/${subj}.HappPleaInv.txt 'TENT(0,20,11)' -stim_label 11 HappPleaInv \
 -stim_times 12 ../../timingtxt/${subj}.HappPleaVis.txt 'TENT(0,20,11)' -stim_label 12 HappPleaVis \
 -stim_times 13 ../../timingtxt/${subj}.HappUnpleaInv.txt 'TENT(0,20,11)' -stim_label 13 HappUnpleaInv \
 -stim_times 14 ../../timingtxt/${subj}.HappUnpleaVis.txt 'TENT(0,20,11)' -stim_label 14 HappUnpleaVis \
 # -iresp 7 ${subj}_FearPleaInv_TENT \
 # -iresp 8 ${subj}_FearPleaVis_TENT \
 # -iresp 9 ${subj}_FearUnPleaInv_TENT \
 # -iresp 10 ${subj}_FearUnPleaVis_TENT \
 # -iresp 11 ${subj}_HappyPleaInv_TENT \
 # -iresp 12 ${subj}_HappyPleaVis_TENT \
 # -iresp 13 ${subj}_HappyUnpleaInv_TENT \
 # -iresp 14 ${subj}_HappyUnpleaVis_TENT \
 -full_first -fout -tout         \
 -bucket ${subj}.analysis.tent

 @auto_tlrc -apar ${subj}.str_al+tlrc. -input ${subj}.analysis.tent+orig.

mkdir ../../ana4/tent_odorPU_lateral
mkdir ../../ana4/tent_odorPU_medial
mkdir ../../ana4/tent_odorPU_all
# OdorValence pleasant-unpleasant lateral amygdala
3dROIstats -mask ${subj}.OdorValence.lateralAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" > ../../ana4/tent_odorPU_lateral/${subj}.OdorValence.lateralAmyPU.t196_FPI.txt
3dROIstats -mask ${subj}.OdorValence.lateralAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  > ../../ana4/tent_odorPU_lateral/${subj}.OdorValence.lateralAmyPU.t196_FPV.txt
3dROIstats -mask ${subj}.OdorValence.lateralAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  > ../../ana4/tent_odorPU_lateral/${subj}.OdorValence.lateralAmyPU.t196_FUI.txt
3dROIstats -mask ${subj}.OdorValence.lateralAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  > ../../ana4/tent_odorPU_lateral/${subj}.OdorValence.lateralAmyPU.t196_FUV.txt
3dROIstats -mask ${subj}.OdorValence.lateralAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  > ../../ana4/tent_odorPU_lateral/${subj}.OdorValence.lateralAmyPU.t196_HPI.txt
3dROIstats -mask ${subj}.OdorValence.lateralAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  > ../../ana4/tent_odorPU_lateral/${subj}.OdorValence.lateralAmyPU.t196_HPV.txt
3dROIstats -mask ${subj}.OdorValence.lateralAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  > ../../ana4/tent_odorPU_lateral/${subj}.OdorValence.lateralAmyPU.t196_HUI.txt
3dROIstats -mask ${subj}.OdorValence.lateralAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  > ../../ana4/tent_odorPU_lateral/${subj}.OdorValence.lateralAmyPU.t196_HUV.txt

# OdorValence pleasant-unpleasant lateral amygdala
3dROIstats -mask ${subj}.OdorValence.medialAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" > ../../ana4/tent_odorPU_medial/${subj}.OdorValence.medialAmyPU.t196_FPI.txt
3dROIstats -mask ${subj}.OdorValence.medialAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  > ../../ana4/tent_odorPU_medial/${subj}.OdorValence.medialAmyPU.t196_FPV.txt
3dROIstats -mask ${subj}.OdorValence.medialAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  > ../../ana4/tent_odorPU_medial/${subj}.OdorValence.medialAmyPU.t196_FUI.txt
3dROIstats -mask ${subj}.OdorValence.medialAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  > ../../ana4/tent_odorPU_medial/${subj}.OdorValence.medialAmyPU.t196_FUV.txt
3dROIstats -mask ${subj}.OdorValence.medialAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  > ../../ana4/tent_odorPU_medial/${subj}.OdorValence.medialAmyPU.t196_HPI.txt
3dROIstats -mask ${subj}.OdorValence.medialAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  > ../../ana4/tent_odorPU_medial/${subj}.OdorValence.medialAmyPU.t196_HPV.txt
3dROIstats -mask ${subj}.OdorValence.medialAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  > ../../ana4/tent_odorPU_medial/${subj}.OdorValence.medialAmyPU.t196_HUI.txt
3dROIstats -mask ${subj}.OdorValence.medialAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  > ../../ana4/tent_odorPU_medial/${subj}.OdorValence.medialAmyPU.t196_HUV.txt

# OdorValence pleasant-unpleasant lateral amygdala
3dROIstats -mask ${subj}.OdorValence.AmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" > ../../ana4/tent_odorPU_all/${subj}.OdorValence.AmyPU.t196_FPI.txt
3dROIstats -mask ${subj}.OdorValence.AmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  > ../../ana4/tent_odorPU_all/${subj}.OdorValence.AmyPU.t196_FPV.txt
3dROIstats -mask ${subj}.OdorValence.AmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  > ../../ana4/tent_odorPU_all/${subj}.OdorValence.AmyPU.t196_FUI.txt
3dROIstats -mask ${subj}.OdorValence.AmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  > ../../ana4/tent_odorPU_all/${subj}.OdorValence.AmyPU.t196_FUV.txt
3dROIstats -mask ${subj}.OdorValence.AmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  > ../../ana4/tent_odorPU_all/${subj}.OdorValence.AmyPU.t196_HPI.txt
3dROIstats -mask ${subj}.OdorValence.AmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  > ../../ana4/tent_odorPU_all/${subj}.OdorValence.AmyPU.t196_HPV.txt
3dROIstats -mask ${subj}.OdorValence.AmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  > ../../ana4/tent_odorPU_all/${subj}.OdorValence.AmyPU.t196_HUI.txt
3dROIstats -mask ${subj}.OdorValence.AmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  > ../../ana4/tent_odorPU_all/${subj}.OdorValence.AmyPU.t196_HUV.txt
####################################################################################################################################################################################################################################


3dROIstats -mask ${subj}.FaceValence.lateralAmyHF.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.FaceValence.lateralAmyHF.t196.txt
3dROIstats -mask ${subj}.FaceValence.medialAmyHF.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.FaceValence.medialAmyHF.t196.txt
3dROIstats -mask ${subj}.FaceValence.AmyHF.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.FaceValence.AmyHF.t196.txt
##################

3dROIstats -mask ${subj}.OdorValence.lateralAmyUP.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.OdorValence.lateralAmyUP.t196.txt
3dROIstats -mask ${subj}.OdorValence.medialAmyUP.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.OdorValence.medialAmyUP.t196.txt
3dROIstats -mask ${subj}.OdorValence.AmyUP.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.OdorValence.AmyUP.t196.txt

3dROIstats -mask ${subj}.FaceValence.lateralAmyFH.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.FaceValence.lateralAmyFH.t196.txt
3dROIstats -mask ${subj}.FaceValence.medialAmyFH.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.FaceValence.medialAmyFH.t196.txt
3dROIstats -mask ${subj}.FaceValence.AmyFH.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.FaceValence.AmyFH.t196.txt











 3dROIstats -mask {$subj}.MaskforOdorValence.t1.64.TT+tlrc -nzmean {$subj}_HappyUnpleaVis_irf+tlrc'[0,1,2,3,4,5,6,7,8,9,10]' > {$subj}_HappyUnpleaVis_OdorValence_TimeCourse.txt
 3dROIstats -mask {$subj}.MaskforOdorValence.t1.64.TT+tlrc -nzmean {$subj}_HappyUnpleaInv_irf+tlrc'[0,1,2,3,4,5,6,7,8,9,10]' > {$subj}_HappyUnpleaInv_OdorValence_TimeCourse.txt
 3dROIstats -mask {$subj}.MaskforOdorValence.t1.64.TT+tlrc -nzmean {$subj}_HappyPleaVis_irf+tlrc'[0,1,2,3,4,5,6,7,8,9,10]' > {$subj}_HappyPleaVis_OdorValence_TimeCourse.txt
 3dROIstats -mask {$subj}.MaskforOdorValence.t1.64.TT+tlrc -nzmean {$subj}_HappyPleaInv_irf+tlrc'[0,1,2,3,4,5,6,7,8,9,10]' > {$subj}_HappyPleaInv_OdorValence_TimeCourse.txt
 3dROIstats -mask {$subj}.MaskforOdorValence.t1.64.TT+tlrc -nzmean {$subj}_FearUnpleaVis_irf+tlrc'[0,1,2,3,4,5,6,7,8,9,10]' > {$subj}_FearUnpleaVis_OdorValence_TimeCourse.txt
 3dROIstats -mask {$subj}.MaskforOdorValence.t1.64.TT+tlrc -nzmean {$subj}_FearUnpleaInv_irf+tlrc'[0,1,2,3,4,5,6,7,8,9,10]' > {$subj}_FearUnpleaInv_OdorValence_TimeCourse.txt
 3dROIstats -mask {$subj}.MaskforOdorValence.t1.64.TT+tlrc -nzmean {$subj}_FearPleaVis_irf+tlrc'[0,1,2,3,4,5,6,7,8,9,10]' > {$subj}_FearPleaVis_OdorValence_TimeCourse.txt
 3dROIstats -mask {$subj}.MaskforOdorValence.t1.64.TT+tlrc -nzmean {$subj}_FearPleaInv_irf+tlrc'[0,1,2,3,4,5,6,7,8,9,10]' > {$subj}_FearPleaInv_OdorValence_TimeCourse.txt

cd ..
cd ..

end

else
 echo "Usage: $0 <Subjname>"

endif
