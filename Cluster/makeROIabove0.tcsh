#! /bin/csh
# if ( $# > 0 ) then
# t=1.64 正负显著激活的区域合在一起
# foreach subj (`echo $*`)
# foreach subj (S29)

# set datafolder=/Volumes/WD_D/allsub
set datafolder=/Volumes/WD_D/Exp_odor_face/fMRI\ data_supplemental/
cd "${datafolder}"

foreach subj (`ls -d S*`)
#S22 S23 S24 S25 S26 S27 S28

cd ${subj}
#mkdir analysis
cd analysis
 # 26U_P 29F_H 32VisU_P 35VisF_H Tstatis
 3dcalc -a ${subj}.analysis.+tlrc'[32]' -b ../../BN_atlas/lAmyg+tlrc -expr '(step(a-1.64)+step(-a-1.64))*b' -prefix ${subj}.OdorValence.lateralAmy
 3dcalc -a ${subj}.analysis.+tlrc'[32]' -b ../../BN_atlas/mAmyg+tlrc -expr '(step(a-1.64)+step(-a-1.64))*b' -prefix ${subj}.OdorValence.medialAmy
 3dcalc -a ${subj}.analysis.+tlrc'[32]' -b ../../BN_atlas/BN_Amyg+tlrc -expr '(step(a-1.64)+step(-a-1.64))*b' -prefix ${subj}.OdorValence.Amy

 3dcalc -a ${subj}.analysis.+tlrc'[35]' -b ../../BN_atlas/lAmyg+tlrc -expr '(step(a-1.64)+step(-a-1.64))*b' -prefix ${subj}.FaceValence.lateralAmy
 3dcalc -a ${subj}.analysis.+tlrc'[35]' -b ../../BN_atlas/mAmyg+tlrc -expr '(step(a-1.64)+step(-a-1.64))*b' -prefix ${subj}.FaceValence.medialAmy
 3dcalc -a ${subj}.analysis.+tlrc'[35]' -b ../../BN_atlas/BN_Amyg+tlrc -expr '(step(a-1.64)+step(-a-1.64))*b' -prefix ${subj}.FaceValence.Amy
cd ..
cd ..

end

# else
 # echo "Usage: $0 <Subjname>"

# endif
