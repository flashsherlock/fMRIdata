#! /bin/csh
set datafolder=/Volumes/WD_D/allsub
cd ${datafolder}
# if ( $# > 0 ) then
# t=1.96  生成对可见反应显著的FFA和STS并看激活
# foreach subj (`echo $*`)
# foreach subj (S29)

# mkdir ana4/STS_FFA05
foreach subj (`ls -d S*`)
#S22 S23 S24 S25 S26 S27 S28
# set subj = $1

cd ${subj}
#mkdir analysis
cd analysis
 # 26U_P 29F_H 32VisU_P 35VisF_H Tstatis
 # 3dcalc -a ${subj}.analysisSF.+tlrc'[26]' -b ../../BN_atlas/FFA_right+tlrc -expr 'step(a-1.96)*b' -prefix ${subj}.Visible.FFA.t196
 # 3dcalc -a ${subj}.analysisSF.+tlrc'[26]' -b ../../BN_atlas/pSTS_right+tlrc -expr 'step(a-1.96)*b' -prefix ${subj}.Visible.pSTS.t196
 # rm ${subj}.Visible.STS.t196*
 3dcalc -a ${subj}.analysisSF.+tlrc'[26]' -b ../../BN_atlas/aSTS_right+tlrc -expr 'step(a-1.96)*b' -prefix ${subj}.Visible.aSTS.t196

 # 3dROIstats -mask ${subj}.Visible.FFA.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/STS_FFA05/${subj}.Visible.FFA.t196.txt
 # 3dROIstats -mask ${subj}.Visible.pSTS.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/STS_FFA05/${subj}.Visible.pSTS.t196.txt
 3dROIstats -mask ${subj}.Visible.aSTS.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/STS_FFA05/${subj}.Visible.aSTS.t196.txt

cd ..
cd ..

end

cd ana4/STS_FFA05

# cat *.Visible.FFA.t196.txt > 20subj_Visible.FFA.t196.txt
# cat *.Visible.pSTS.t196.txt > 20subj_Visible.pSTS.t196.txt
cat *.Visible.aSTS.t196.txt > 20subj_Visible.aSTS.t196.txt

# else
 # echo "Usage: $0 <Subjname>"

# endif
