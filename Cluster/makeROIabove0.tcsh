#! /bin/csh
# if ( $# > 0 ) then
# t=1.64 正负显著激活的区域合在一起
# foreach subj (`echo $*`)
# foreach subj (S29)

set datafolder=/Volumes/WD_D/allsub
# set datafolder=/Volumes/WD_D/Exp_odor_face/fMRI\ data_supplemental/
cd "${datafolder}"
# 效价偏好的t值
set t=1.65
set tmark=t165
# 减数大于0的t值
set t0=1.96
set tmark0=t196

if (! -e ana4/AmyAbove0${tmark}) then
mkdir ana4/AmyAbove0${tmark}
endif

foreach subj (`ls -d S*`)
#S22 S23 S24 S25 S26 S27 S28

cd ${subj}

cd analysis

# 减数大于0的mask
# 38F0 41H0 44P0 47U0
# if (! -e ${subj}.FaceValenceF0.${tmark0}*.BRIK) then
#
# 3dcalc -a ${subj}.analysis.+tlrc'[38]' -expr 'step(a-${t0})' -prefix ${subj}.FaceValenceF0.${tmark0}
# 3dcalc -a ${subj}.analysis.+tlrc'[41]' -expr 'step(a-${t0})' -prefix ${subj}.FaceValenceH0.${tmark0}
# 3dcalc -a ${subj}.analysis.+tlrc'[44]' -expr 'step(a-${t0})' -prefix ${subj}.OdorValenceP0.${tmark0}
# 3dcalc -a ${subj}.analysis.+tlrc'[47]' -expr 'step(a-${t0})' -prefix ${subj}.OdorValenceU0.${tmark0}
#
# endif

#两个mask相交
# 38F0 41H0 44P0 47U0
set expr="(step(c-${t0}))*b*(step(a-${t}))"
set expr_r="(step(c-${t0}))*b*(step(-a-${t}))"

# 使用双引号在表达式中应用变量
3dcalc -a ${subj}.analysis.+tlrc'[32]' -b ../../BN_atlas/lAmyg+tlrc -c ${subj}.analysis.+tlrc'[47]' -expr "${expr}" -prefix ${subj}.OdorValenceAb0.lateralAmyUP.${tmark}
3dcalc -a ${subj}.analysis.+tlrc'[32]' -b ../../BN_atlas/mAmyg+tlrc -c ${subj}.analysis.+tlrc'[47]' -expr "${expr}" -prefix ${subj}.OdorValenceAb0.medialAmyUP.${tmark}
3dcalc -a ${subj}.analysis.+tlrc'[32]' -b ../../BN_atlas/BN_Amyg+tlrc -c ${subj}.analysis.+tlrc'[47]' -expr "${expr}" -prefix ${subj}.OdorValenceAb0.AmyUP.${tmark}

3dcalc -a ${subj}.analysis.+tlrc'[35]' -b ../../BN_atlas/lAmyg+tlrc -c ${subj}.analysis.+tlrc'[38]' -expr "${expr}" -prefix ${subj}.FaceValenceAb0.lateralAmyFH.${tmark}
3dcalc -a ${subj}.analysis.+tlrc'[35]' -b ../../BN_atlas/mAmyg+tlrc -c ${subj}.analysis.+tlrc'[38]' -expr "${expr}" -prefix ${subj}.FaceValenceAb0.medialAmyFH.${tmark}
3dcalc -a ${subj}.analysis.+tlrc'[35]' -b ../../BN_atlas/BN_Amyg+tlrc -c ${subj}.analysis.+tlrc'[38]' -expr "${expr}" -prefix ${subj}.FaceValenceAb0.AmyFH.${tmark}

#reverse
3dcalc -a ${subj}.analysis.+tlrc'[32]' -b ../../BN_atlas/lAmyg+tlrc -c ${subj}.analysis.+tlrc'[44]' -expr "${expr_r}" -prefix ${subj}.OdorValenceAb0.lateralAmyPU.${tmark}
3dcalc -a ${subj}.analysis.+tlrc'[32]' -b ../../BN_atlas/mAmyg+tlrc -c ${subj}.analysis.+tlrc'[44]' -expr "${expr_r}" -prefix ${subj}.OdorValenceAb0.medialAmyPU.${tmark}
3dcalc -a ${subj}.analysis.+tlrc'[32]' -b ../../BN_atlas/BN_Amyg+tlrc -c ${subj}.analysis.+tlrc'[44]' -expr "${expr_r}" -prefix ${subj}.OdorValenceAb0.AmyPU.${tmark}

3dcalc -a ${subj}.analysis.+tlrc'[35]' -b ../../BN_atlas/lAmyg+tlrc -c ${subj}.analysis.+tlrc'[41]' -expr "${expr_r}" -prefix ${subj}.FaceValenceAb0.lateralAmyHF.${tmark}
3dcalc -a ${subj}.analysis.+tlrc'[35]' -b ../../BN_atlas/mAmyg+tlrc -c ${subj}.analysis.+tlrc'[41]' -expr "${expr_r}" -prefix ${subj}.FaceValenceAb0.medialAmyHF.${tmark}
3dcalc -a ${subj}.analysis.+tlrc'[35]' -b ../../BN_atlas/BN_Amyg+tlrc -c ${subj}.analysis.+tlrc'[41]' -expr "${expr_r}" -prefix ${subj}.FaceValenceAb0.AmyHF.${tmark}

3dROIstats -mask ${subj}.OdorValenceAb0.lateralAmyPU.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${tmark}/${subj}.OdorValenceAb0.lateralAmyPU.${tmark}.txt
3dROIstats -mask ${subj}.OdorValenceAb0.medialAmyPU.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${tmark}/${subj}.OdorValenceAb0.medialAmyPU.${tmark}.txt
3dROIstats -mask ${subj}.OdorValenceAb0.AmyPU.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${tmark}/${subj}.OdorValenceAb0.AmyPU.${tmark}.txt

3dROIstats -mask ${subj}.FaceValenceAb0.lateralAmyHF.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${tmark}/${subj}.FaceValenceAb0.lateralAmyHF.${tmark}.txt
3dROIstats -mask ${subj}.FaceValenceAb0.medialAmyHF.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${tmark}/${subj}.FaceValenceAb0.medialAmyHF.${tmark}.txt
3dROIstats -mask ${subj}.FaceValenceAb0.AmyHF.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${tmark}/${subj}.FaceValenceAb0.AmyHF.${tmark}.txt
##################

3dROIstats -mask ${subj}.OdorValenceAb0.lateralAmyUP.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${tmark}/${subj}.OdorValenceAb0.lateralAmyUP.${tmark}.txt
3dROIstats -mask ${subj}.OdorValenceAb0.medialAmyUP.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${tmark}/${subj}.OdorValenceAb0.medialAmyUP.${tmark}.txt
3dROIstats -mask ${subj}.OdorValenceAb0.AmyUP.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${tmark}/${subj}.OdorValenceAb0.AmyUP.${tmark}.txt

3dROIstats -mask ${subj}.FaceValenceAb0.lateralAmyFH.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${tmark}/${subj}.FaceValenceAb0.lateralAmyFH.${tmark}.txt
3dROIstats -mask ${subj}.FaceValenceAb0.medialAmyFH.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${tmark}/${subj}.FaceValenceAb0.medialAmyFH.${tmark}.txt
3dROIstats -mask ${subj}.FaceValenceAb0.AmyFH.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${tmark}/${subj}.FaceValenceAb0.AmyFH.${tmark}.txt


cd ..
cd ..

end

cd ana4/AmyAbove0${tmark}

cat *.OdorValenceAb0.lateralAmyUP.${tmark}.txt >! 20subj_OdorValence.lateralAmyUP.${tmark}.txt
cat *.OdorValenceAb0.medialAmyUP.${tmark}.txt >! 20subj_OdorValence.medialAmyUP.${tmark}.txt
cat *.OdorValenceAb0.AmyUP.${tmark}.txt >! 20subj_OdorValence.AmyUP.${tmark}.txt

cat *.FaceValenceAb0.lateralAmyFH.${tmark}.txt >! 20subj_FaceValence.lateralAmyFH.${tmark}.txt
cat *.FaceValenceAb0.medialAmyFH.${tmark}.txt >! 20subj_FaceValence.medialAmyFH.${tmark}.txt
cat *.FaceValenceAb0.AmyFH.${tmark}.txt >! 20subj_FaceValence.AmyFH.${tmark}.txt

cat *.OdorValenceAb0.lateralAmyPU.${tmark}.txt >! 20subj_OdorValence.lateralAmyPU.${tmark}.txt
cat *.OdorValenceAb0.medialAmyPU.${tmark}.txt >! 20subj_OdorValence.medialAmyPU.${tmark}.txt
cat *.OdorValenceAb0.AmyPU.${tmark}.txt >! 20subj_OdorValence.AmyPU.${tmark}.txt

cat *.FaceValenceAb0.lateralAmyHF.${tmark}.txt >! 20subj_FaceValence.lateralAmyHF.${tmark}.txt
cat *.FaceValenceAb0.medialAmyHF.${tmark}.txt >! 20subj_FaceValence.medialAmyHF.${tmark}.txt
cat *.FaceValenceAb0.AmyHF.${tmark}.txt >! 20subj_FaceValence.AmyHF.${tmark}.txt

# else
 # echo "Usage: $0 <Subjname>"

# endif
