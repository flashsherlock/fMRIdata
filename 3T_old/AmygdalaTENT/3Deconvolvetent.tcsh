#! /bin/csh
set datafolder=/Volumes/WD_D/allsub
cd ${datafolder}
if ( $# > 0 ) then
# set b=`echo \'\\\[${abc}22\\\]\'`
# 3dROIstats -mask S22.OdorValence.lateralAmyPU.t196+tlrc -nzmean S22.analysis.+tlrc`echo \\\[${abc}22\\\]`
# 3dROIstats -mask S22.OdorValence.lateralAmyPU.t196+tlrc -nzmean S22.analysis.+tlrc"[`seq -s , 1 3 20`22]"
# echo `echo "`seq -s , 1 3 20`"
# echo "hello1-`echo hello2-\`echo hello3-\\\`echo hello4\\\`\``"
# echo "hello1-`echo hello2-echo hello4\\\``"
# foreach subj (`echo $*`)
# foreach subj (`ls -d S*`)
# foreach subj (S03)
#S22 S23 S24 S25 S26 S27 S28
set subj = $1

cd ${subj}
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

cd ..
cd ..

# end

else
 echo "Usage: $0 <Subjname>"

endif
