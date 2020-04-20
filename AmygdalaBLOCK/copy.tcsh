#! /bin/csh
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
