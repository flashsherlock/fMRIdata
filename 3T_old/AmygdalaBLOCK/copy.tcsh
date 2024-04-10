#! /bin/csh
# copy whole brain epi image
set datafolder=/Volumes/WD_D/allsub
cd "${datafolder}"

foreach subj (3 4 5 6 7 8 11 14 15 16 19 21)

if (${subj} < 10) then
  set sub=S0${subj}
else
  set sub=S${subj}
endif

cp /Volumes/WD_D/Exp_odor_face/program\&data/ROI_analysis/S${subj}/S${subj}_WB_EPI+orig.BRIK ${sub}/${sub}_WB_EPI+orig.BRIK
cp /Volumes/WD_D/Exp_odor_face/program\&data/ROI_analysis/S${subj}/S${subj}_WB_EPI+orig.HEAD ${sub}/${sub}_WB_EPI+orig.HEAD

end

# copy structural and epi images
#foreach subj (S003 S004 S005 S006 S007 S008 S011 S014 S015 S016 S019 S021)
foreach subj (`ls -d *S2*`)
cd ${subj}
cd analysis
echo ${subj}|cut -c16-17
set folder=S0`echo ${subj}|cut -c16-17`
set f=S0${folder}
echo ${f}
echo ${folder}
# $filename={`ls *.1D`}
# foreach filename (`ls FMRI*_o*`)
# echo ${filename}
# end
ls FMR*_o*
ls *str+*
# mkdir /Volumes/WD_D/allsub/S0${folder}
# cp -R FMR*_o* /Volumes/WD_D/allsub/S0${folder}/
# cp -R *str+* /Volumes/WD_D/allsub/S0${folder}/


cd ..
cd ..

end
