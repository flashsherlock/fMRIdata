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

# 新建文件夹
if (! -e Invisible) then
mkdir Invisible
endif

# 进入文件夹
cd Invisible

3dDeconvolve -input ../${subj}_func_s+orig -num_stimts 14     \
 -jobs 4 \
 -polort 3 \
 -stim_file 1 ../func_s.mot'[1]' \
 -stim_file 2 ../func_s.mot'[2]' \
 -stim_file 3 ../func_s.mot'[3]' \
 -stim_file 4 ../func_s.mot'[4]' \
 -stim_file 5 ../func_s.mot'[5]' \
 -stim_file 6 ../func_s.mot'[6]' \
 -stim_base 1 \
 -stim_base 2 \
 -stim_base 3 \
 -stim_base 4 \
 -stim_base 5 \
 -stim_base 6 \
 -stim_times 7 ../../../timingtxt/${subj}.FearPleaInv.txt 'BLOCK(10,1)' -stim_label 7 FearPleaInv \
 -stim_times 8 ../../../timingtxt/${subj}.FearPleaVis.txt 'BLOCK(10,1)' -stim_label 8 FearPleaVis \
 -stim_times 9 ../../../timingtxt/${subj}.FearUnpleaInv.txt 'BLOCK(10,1)' -stim_label 9 FearUnpleaInv \
 -stim_times 10 ../../../timingtxt/${subj}.FearUnpleaVis.txt 'BLOCK(10,1)' -stim_label 10 FearUnpleaVis \
 -stim_times 11 ../../../timingtxt/${subj}.HappPleaInv.txt 'BLOCK(10,1)' -stim_label 11 HappPleaInv \
 -stim_times 12 ../../../timingtxt/${subj}.HappPleaVis.txt 'BLOCK(10,1)' -stim_label 12 HappPleaVis \
 -stim_times 13 ../../../timingtxt/${subj}.HappUnpleaInv.txt 'BLOCK(10,1)' -stim_label 13 HappUnpleaInv \
 -stim_times 14 ../../../timingtxt/${subj}.HappUnpleaVis.txt 'BLOCK(10,1)' -stim_label 14 HappUnpleaVis \
 -num_glt 6	                                 \
		    -glt_label 1 InvOlfacValenceU_P -gltsym 'SYM: FearUnpleaInv +HappUnpleaInv -FearPleaInv -HappPleaInv'   \
        -glt_label 2 InvFaceValenceF_H -gltsym 'SYM: FearPleaInv +FearUnpleaInv -HappPleaInv -HappUnpleaInv'   \
        -glt_label 3 InvFaceF0 -gltsym 'SYM: 0.5*FearPleaInv +0.5*FearUnpleaInv'   \
        -glt_label 4 InvFaceH0 -gltsym 'SYM: 0.5*HappPleaInv +0.5*HappUnpleaInv'   \
        -glt_label 5 InvOdorP0 -gltsym 'SYM: 0.5*FearPleaInv +0.5*HappPleaInv'   \
        -glt_label 6 InvOdorU0 -gltsym 'SYM: 0.5*FearUnpleaInv +0.5*HappUnpleaInv'   \
 -full_first -fout -tout         \
 -fitts fitts.${subj}.         \
 -bucket ${subj}.analysisInv.     \

 @auto_tlrc -apar ../${subj}.str_al+tlrc. -input ${subj}.analysisInv.+orig.


cd ..
cd ..

end


else
 echo "Usage: $0 <Subjname>"

endif
