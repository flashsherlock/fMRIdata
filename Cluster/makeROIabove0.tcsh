#! /bin/csh
# if ( $# > 0 ) then
# t=1.64 正负显著激活的区域合在一起
# foreach subj (`echo $*`)
# foreach subj (S29)

# set datafolder=/Volumes/WD_D/allsub
set datafolder=/Volumes/WD_D/Exp_odor_face/fMRI\ data_supplemental/
cd "${datafolder}"

if (! -e ana4/AmyAbove0) then
mkdir ana4/AmyAbove0
endif

foreach subj (`ls -d S*`)
#S22 S23 S24 S25 S26 S27 S28

cd ${subj}

cd analysis
# 38F0 41H0 44P0 47U0
3dcalc -a ${subj}.analysis.+tlrc'[47]' -b ${subj}.OdorValence.lateralAmyUP.t196+tlrc -expr '(step(a-1.96))*b' -prefix ${subj}.OdorValenceAb0.lateralAmyUP.t196
3dcalc -a ${subj}.analysis.+tlrc'[47]' -b ${subj}.OdorValence.medialAmyUP.t196+tlrc -expr '(step(a-1.96))*b' -prefix ${subj}.OdorValenceAb0.medialAmyUP.t196
3dcalc -a ${subj}.analysis.+tlrc'[47]' -b ${subj}.OdorValence.AmyUP.t196+tlrc -expr '(step(a-1.96))*b' -prefix ${subj}.OdorValenceAb0.AmyUP.t196

3dcalc -a ${subj}.analysis.+tlrc'[38]' -b ${subj}.FaceValence.lateralAmyFH.t196+tlrc -expr '(step(a-1.96))*b' -prefix ${subj}.FaceValenceAb0.lateralAmyFH.t196
3dcalc -a ${subj}.analysis.+tlrc'[38]' -b ${subj}.FaceValence.medialAmyFH.t196+tlrc -expr '(step(a-1.96))*b' -prefix ${subj}.FaceValenceAb0.medialAmyFH.t196
3dcalc -a ${subj}.analysis.+tlrc'[38]' -b ${subj}.FaceValence.AmyFH.t196+tlrc -expr '(step(a-1.96))*b' -prefix ${subj}.FaceValenceAb0.AmyFH.t196

#reverse
3dcalc -a ${subj}.analysis.+tlrc'[44]' -b ${subj}.OdorValence.lateralAmyPU.t196+tlrc -expr '(step(a-1.96))*b' -prefix ${subj}.OdorValenceAb0.lateralAmyPU.t196
3dcalc -a ${subj}.analysis.+tlrc'[44]' -b ${subj}.OdorValence.medialAmyPU.t196+tlrc -expr '(step(a-1.96))*b' -prefix ${subj}.OdorValenceAb0.medialAmyPU.t196
3dcalc -a ${subj}.analysis.+tlrc'[44]' -b ${subj}.OdorValence.AmyPU.t196+tlrc -expr '(step(a-1.96))*b' -prefix ${subj}.OdorValenceAb0.AmyPU.t196

3dcalc -a ${subj}.analysis.+tlrc'[41]' -b ${subj}.FaceValence.lateralAmyHF.t196+tlrc -expr '(step(a-1.96))*b' -prefix ${subj}.FaceValenceAb0.lateralAmyHF.t196
3dcalc -a ${subj}.analysis.+tlrc'[41]' -b ${subj}.FaceValence.medialAmyHF.t196+tlrc -expr '(step(a-1.96))*b' -prefix ${subj}.FaceValenceAb0.medialAmyHF.t196
3dcalc -a ${subj}.analysis.+tlrc'[41]' -b ${subj}.FaceValence.AmyHF.t196+tlrc -expr '(step(a-1.96))*b' -prefix ${subj}.FaceValenceAb0.AmyHF.t196

3dROIstats -mask ${subj}.OdorValenceAb0.lateralAmyPU.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0/${subj}.OdorValenceAb0.lateralAmyPU.t196.txt
3dROIstats -mask ${subj}.OdorValenceAb0.medialAmyPU.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0/${subj}.OdorValenceAb0.medialAmyPU.t196.txt
3dROIstats -mask ${subj}.OdorValenceAb0.AmyPU.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0/${subj}.OdorValenceAb0.AmyPU.t196.txt

3dROIstats -mask ${subj}.FaceValenceAb0.lateralAmyHF.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0/${subj}.FaceValenceAb0.lateralAmyHF.t196.txt
3dROIstats -mask ${subj}.FaceValenceAb0.medialAmyHF.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0/${subj}.FaceValenceAb0.medialAmyHF.t196.txt
3dROIstats -mask ${subj}.FaceValenceAb0.AmyHF.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0/${subj}.FaceValenceAb0.AmyHF.t196.txt
##################

3dROIstats -mask ${subj}.OdorValenceAb0.lateralAmyUP.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0/${subj}.OdorValenceAb0.lateralAmyUP.t196.txt
3dROIstats -mask ${subj}.OdorValenceAb0.medialAmyUP.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0/${subj}.OdorValenceAb0.medialAmyUP.t196.txt
3dROIstats -mask ${subj}.OdorValenceAb0.AmyUP.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0/${subj}.OdorValenceAb0.AmyUP.t196.txt

3dROIstats -mask ${subj}.FaceValenceAb0.lateralAmyFH.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0/${subj}.FaceValenceAb0.lateralAmyFH.t196.txt
3dROIstats -mask ${subj}.FaceValenceAb0.medialAmyFH.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0/${subj}.FaceValenceAb0.medialAmyFH.t196.txt
3dROIstats -mask ${subj}.FaceValenceAb0.AmyFH.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0/${subj}.FaceValenceAb0.AmyFH.t196.txt


cd ..
cd ..

end

cd ana4/AmyAbove0

cat *.OdorValenceAb0.lateralAmyUP.t196.txt >! 20subj_OdorValence.lateralAmyUP.t196.txt
cat *.OdorValenceAb0.medialAmyUP.t196.txt >! 20subj_OdorValence.medialAmyUP.t196.txt
cat *.OdorValenceAb0.AmyUP.t196.txt >! 20subj_OdorValence.AmyUP.t196.txt

cat *.FaceValenceAb0.lateralAmyFH.t196.txt >! 20subj_FaceValence.lateralAmyFH.t196.txt
cat *.FaceValenceAb0.medialAmyFH.t196.txt >! 20subj_FaceValence.medialAmyFH.t196.txt
cat *.FaceValenceAb0.AmyFH.t196.txt >! 20subj_FaceValence.AmyFH.t196.txt

cat *.OdorValenceAb0.lateralAmyPU.t196.txt >! 20subj_OdorValence.lateralAmyPU.t196.txt
cat *.OdorValenceAb0.medialAmyPU.t196.txt >! 20subj_OdorValence.medialAmyPU.t196.txt
cat *.OdorValenceAb0.AmyPU.t196.txt >! 20subj_OdorValence.AmyPU.t196.txt

cat *.FaceValenceAb0.lateralAmyHF.t196.txt >! 20subj_FaceValence.lateralAmyHF.t196.txt
cat *.FaceValenceAb0.medialAmyHF.t196.txt >! 20subj_FaceValence.medialAmyHF.t196.txt
cat *.FaceValenceAb0.AmyHF.t196.txt >! 20subj_FaceValence.AmyHF.t196.txt

# else
 # echo "Usage: $0 <Subjname>"

# endif
