#! /bin/csh
if ( $# > 0 ) then

foreach subj (`echo $*`)

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
 -stim_times 7 ../../timingtxt/${subj}.FearPleaInv.txt 'BLOCK(10,1)' -stim_label 7 FearPleaInv \
 -stim_times 8 ../../timingtxt/${subj}.FearPleaVis.txt 'BLOCK(10,1)' -stim_label 8 FearPleaVis \
 -stim_times 9 ../../timingtxt/${subj}.FearUnpleaInv.txt 'BLOCK(10,1)' -stim_label 9 FearUnpleaInv \
 -stim_times 10 ../../timingtxt/${subj}.FearUnpleaVis.txt 'BLOCK(10,1)' -stim_label 10 FearUnpleaVis \
 -stim_times 11 ../../timingtxt/${subj}.HappPleaInv.txt 'BLOCK(10,1)' -stim_label 11 HappPleaInv \
 -stim_times 12 ../../timingtxt/${subj}.HappPleaVis.txt 'BLOCK(10,1)' -stim_label 12 HappPleaVis \
 -stim_times 13 ../../timingtxt/${subj}.HappUnpleaInv.txt 'BLOCK(10,1)' -stim_label 13 HappUnpleaInv \
 -stim_times 14 ../../timingtxt/${subj}.HappUnpleaVis.txt 'BLOCK(10,1)' -stim_label 14 HappUnpleaVis \
 -num_glt 4	                                 \
        -glt_label 1 OlfacValenceU_P -gltsym 'SYM: FearUnpleaVis +HappUnpleaVis +FearUnpleaInv +HappUnpleaInv -FearPleaVis -HappPleaVis -FearPleaInv -HappPleaInv'   \
        -glt_label 2 FaceValenceF_H -gltsym 'SYM: FearPleaVis +FearUnpleaVis +FearPleaInv +FearUnpleaInv -HappPleaVis -HappUnpleaVis  -HappPleaInv -HappUnpleaInv'   \
		-glt_label 3 VisOlfacValenceU_P -gltsym 'SYM: FearUnpleaVis +HappUnpleaVis -FearPleaVis -HappPleaVis'   \
        -glt_label 4 VisFaceValenceF_H -gltsym 'SYM: FearPleaVis +FearUnpleaVis -HappPleaVis -HappUnpleaVis'   \
 -full_first -fout -tout         \
 -fitts fitts.${subj}.         \
 -bucket ${subj}.analysis.     \

 @auto_tlrc -apar ${subj}.str_al+tlrc. -input ${subj}.analysis.+orig.


 # merge some of the conditions (no difference)
 # -stim_times 7 ../../timingtxt_two/${subj}.Happy.txt 'BLOCK(10,1)' -stim_label 7 Happy \
 # -stim_times 8 ../../timingtxt_two/${subj}.Fear.txt 'BLOCK(10,1)' -stim_label 8 Fear \
 # -stim_times 9 ../../timingtxt_two/${subj}.Plea.txt 'BLOCK(10,1)' -stim_label 9 Plea \
 # -stim_times 10 ../../timingtxt_two/${subj}.Unplea.txt 'BLOCK(10,1)' -stim_label 10 Unplea \
 # -num_glt 2	                                 \
 #          -glt_label 1 FaceValenceF_H -gltsym 'SYM: Fear -Happy'   \
 #          -glt_label 2 OlfacValenceU_P -gltsym 'SYM: Unplea -Plea'   \
 # -full_first -fout -tout         \
 # -fitts fitts.${subj}.twoblock         \
 # -bucket ${subj}.analysis.twoblock     \
 #
 # @auto_tlrc -apar ${subj}.str_al+tlrc. -input ${subj}.analysis.twoblock+orig.

 # 3dcalc -a ${subj}.analysis.gf+tlrc'[26]' -b ../../ROIamy_TT+tlrc -expr '(step(a-1.64))*b' -prefix ${subj}.OdorValenceU_P.t1.64.TT.gf
 # 3dcalc -a ${subj}.analysis.gf+tlrc'[29]' -b ../../ROIamy_TT+tlrc -expr '(step(a-1.64))*b' -prefix ${subj}.FaceValenceF_H.t1.64.TT.gf
 # 3dcalc -a ${subj}.analysis.gf+tlrc'[26]' -b ../../ROIamy_TT+tlrc -expr '(step(-a-1.64))*b' -prefix ${subj}.OdorValenceP_U.t1.64.TT.gf
 # 3dcalc -a ${subj}.analysis.gf+tlrc'[29]' -b ../../ROIamy_TT+tlrc -expr '(step(-a-1.64))*b' -prefix ${subj}.FaceValenceH_F.t1.64.TT.gf
 # 3dROIstats -mask ${subj}.OdorValenceU_P.t1.64.TT.gf+tlrc -nzmean -nzvoxels ${subj}.analysis.gf+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.OdorValenceU_P.t1.64.TT_signal.gf.txt
 # 3dROIstats -mask ${subj}.FaceValenceF_H.t1.64.TT.gf+tlrc -nzmean -nzvoxels ${subj}.analysis.gf+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.FaceValenceF_H.t1.64.TT_signal.gf.txt
 # 3dROIstats -mask ${subj}.OdorValenceP_U.t1.64.TT.gf+tlrc -nzmean -nzvoxels ${subj}.analysis.gf+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.OdorValenceP_U.t1.64.TT_signal.gf.txt
 # 3dROIstats -mask ${subj}.FaceValenceH_F.t1.64.TT.gf+tlrc -nzmean -nzvoxels ${subj}.analysis.gf+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.FaceValenceH_F.t1.64.TT_signal.gf.txt

cd ..
cd ..

end

# cd ana4

# cat *.OdorValenceU_P.t1.64.TT_signal.gf.txt > 8subj_OdorValenceU_P.t1.64.TT_signal.gf.txt
# cat *.FaceValenceF_H.t1.64.TT_signal.gf.txt > 8subj_FaceValenceF_H.t1.64.TT_signal.gf.txt
# cat *.OdorValenceP_U.t1.64.TT_signal.gf.txt > 8subj_OdorValenceP_U.t1.64.TT_signal.gf.txt
# cat *.FaceValenceH_F.t1.64.TT_signal.gf.txt > 8subj_FaceValenceH_F.t1.64.TT_signal.gf.txt
else
 echo "Usage: $0 <Subjname>"

endif
