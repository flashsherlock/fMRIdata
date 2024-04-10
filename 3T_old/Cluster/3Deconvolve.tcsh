#! /bin/csh
# 为了能够获得某个条件大于0的t值结果重新进行deconvolve
set datafolder=/Volumes/WD_D/allsub
# set datafolder=/Volumes/WD_D/Exp_odor_face/fMRI\ data_supplemental/
cd "${datafolder}"

if ( $# > 0 ) then

foreach subj (`echo $*`)

cd *${subj}
#mkdir analysis
cd analysis

# 去掉之前的结果
rm fitts.${subj}.+orig*
rm ${subj}.analysis.+*

3dDeconvolve -input ${subj}_func_s+orig -num_stimts 14     \
 -jobs 4 \
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
 -stim_times 7 ../../timingtxt/${subj}.FearPleaInv.txt 'BLOCK(10,1)' -stim_label 7 FearPleaInv \
 -stim_times 8 ../../timingtxt/${subj}.FearPleaVis.txt 'BLOCK(10,1)' -stim_label 8 FearPleaVis \
 -stim_times 9 ../../timingtxt/${subj}.FearUnpleaInv.txt 'BLOCK(10,1)' -stim_label 9 FearUnpleaInv \
 -stim_times 10 ../../timingtxt/${subj}.FearUnpleaVis.txt 'BLOCK(10,1)' -stim_label 10 FearUnpleaVis \
 -stim_times 11 ../../timingtxt/${subj}.HappPleaInv.txt 'BLOCK(10,1)' -stim_label 11 HappPleaInv \
 -stim_times 12 ../../timingtxt/${subj}.HappPleaVis.txt 'BLOCK(10,1)' -stim_label 12 HappPleaVis \
 -stim_times 13 ../../timingtxt/${subj}.HappUnpleaInv.txt 'BLOCK(10,1)' -stim_label 13 HappUnpleaInv \
 -stim_times 14 ../../timingtxt/${subj}.HappUnpleaVis.txt 'BLOCK(10,1)' -stim_label 14 HappUnpleaVis \
 -num_glt 8	                                 \
        -glt_label 1 OlfacValenceU_P -gltsym 'SYM: FearUnpleaVis +HappUnpleaVis +FearUnpleaInv +HappUnpleaInv -FearPleaVis -HappPleaVis -FearPleaInv -HappPleaInv'   \
        -glt_label 2 FaceValenceF_H -gltsym 'SYM: FearPleaVis +FearUnpleaVis +FearPleaInv +FearUnpleaInv -HappPleaVis -HappUnpleaVis  -HappPleaInv -HappUnpleaInv'   \
		    -glt_label 3 VisOlfacValenceU_P -gltsym 'SYM: FearUnpleaVis +HappUnpleaVis -FearPleaVis -HappPleaVis'   \
        -glt_label 4 VisFaceValenceF_H -gltsym 'SYM: FearPleaVis +FearUnpleaVis -HappPleaVis -HappUnpleaVis'   \
        -glt_label 5 VisFaceF0 -gltsym 'SYM: 0.5*FearPleaVis +0.5*FearUnpleaVis'   \
        -glt_label 6 VisFaceH0 -gltsym 'SYM: 0.5*HappPleaVis +0.5*HappUnpleaVis'   \
        -glt_label 7 VisOdorP0 -gltsym 'SYM: 0.5*FearPleaVis +0.5*HappPleaVis'   \
        -glt_label 8 VisOdorU0 -gltsym 'SYM: 0.5*FearUnpleaVis +0.5*HappUnpleaVis'   \
 -full_first -fout -tout         \
 -fitts fitts.${subj}.         \
 -bucket ${subj}.analysis.     \

 @auto_tlrc -apar ${subj}.str_al+tlrc. -input ${subj}.analysis.+orig.


cd ..
cd ..

end


else
 echo "Usage: $0 <Subjname>"

endif
