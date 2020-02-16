#! /bin/csh
set datafolder=/Volumes/WD_D/allsub
cd ${datafolder}

if ( $# > 0 ) then

# foreach subj (`echo $*`)

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
 -stim_times 7 ../../timingtxt/${subj}.FearPleaInv.txt 'BLOCK(10,1)' -stim_label 7 FearPleaInv \
 -stim_times 8 ../../timingtxt/${subj}.FearPleaVis.txt 'BLOCK(10,1)' -stim_label 8 FearPleaVis \
 -stim_times 9 ../../timingtxt/${subj}.FearUnpleaInv.txt 'BLOCK(10,1)' -stim_label 9 FearUnpleaInv \
 -stim_times 10 ../../timingtxt/${subj}.FearUnpleaVis.txt 'BLOCK(10,1)' -stim_label 10 FearUnpleaVis \
 -stim_times 11 ../../timingtxt/${subj}.HappPleaInv.txt 'BLOCK(10,1)' -stim_label 11 HappPleaInv \
 -stim_times 12 ../../timingtxt/${subj}.HappPleaVis.txt 'BLOCK(10,1)' -stim_label 12 HappPleaVis \
 -stim_times 13 ../../timingtxt/${subj}.HappUnpleaInv.txt 'BLOCK(10,1)' -stim_label 13 HappUnpleaInv \
 -stim_times 14 ../../timingtxt/${subj}.HappUnpleaVis.txt 'BLOCK(10,1)' -stim_label 14 HappUnpleaVis \
 -num_glt 3	                                 \
        -glt_label 1 Visible_Invisible -gltsym 'SYM: FearUnpleaVis +HappUnpleaVis +FearPleaVis +HappPleaVis -FearUnpleaInv -HappUnpleaInv -FearPleaInv -HappPleaInv'   \
        -glt_label 2 InvFaceValenceF_H -gltsym 'SYM: FearUnpleaInv +FearPleaInv -HappUnpleaInv -HappPleaInv'   \
		    -glt_label 3 InvOlfacValenceU_P -gltsym 'SYM: FearUnpleaInv +HappUnpleaInv -FearPleaInv -HappPleaInv'   \
 -full_first -fout -tout         \
 -fitts fittsSF.${subj}.         \
 -bucket ${subj}.analysisSF.     \

 @auto_tlrc -apar ${subj}.str_al+tlrc. -input ${subj}.analysisSF.+orig.

cd ..
cd ..

end

else
 echo "Usage: $0 <Subjname>"

endif
