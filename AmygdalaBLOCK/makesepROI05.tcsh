#! /bin/csh
# if ( $# > 0 ) then
# t=1.96 正负显著激活的区域分开
# foreach subj (`echo $*`)
# foreach subj (S29)
foreach subj (`ls -d S*`)
#S22 S23 S24 S25 S26 S27 S28

cd ${subj}
#mkdir analysis
cd analysis
 # 26U_P 29F_H 32VisU_P 35VisF_H Tstatis
 3dcalc -a ${subj}.analysis.+tlrc'[32]' -b ../../BN_atlas/lAmyg+tlrc -expr '(step(a-1.96))*b' -prefix ${subj}.OdorValence.lateralAmyUP.t196
 3dcalc -a ${subj}.analysis.+tlrc'[32]' -b ../../BN_atlas/mAmyg+tlrc -expr '(step(a-1.96))*b' -prefix ${subj}.OdorValence.medialAmyUP.t196
 3dcalc -a ${subj}.analysis.+tlrc'[32]' -b ../../BN_atlas/BN_Amyg+tlrc -expr '(step(a-1.96))*b' -prefix ${subj}.OdorValence.AmyUP.t196

 3dcalc -a ${subj}.analysis.+tlrc'[35]' -b ../../BN_atlas/lAmyg+tlrc -expr '(step(a-1.96))*b' -prefix ${subj}.FaceValence.lateralAmyFH.t196
 3dcalc -a ${subj}.analysis.+tlrc'[35]' -b ../../BN_atlas/mAmyg+tlrc -expr '(step(a-1.96))*b' -prefix ${subj}.FaceValence.medialAmyFH.t196
 3dcalc -a ${subj}.analysis.+tlrc'[35]' -b ../../BN_atlas/BN_Amyg+tlrc -expr '(step(a-1.96))*b' -prefix ${subj}.FaceValence.AmyFH.t196

#reverse
 3dcalc -a ${subj}.analysis.+tlrc'[32]' -b ../../BN_atlas/lAmyg+tlrc -expr '(step(-a-1.96))*b' -prefix ${subj}.OdorValence.lateralAmyPU.t196
 3dcalc -a ${subj}.analysis.+tlrc'[32]' -b ../../BN_atlas/mAmyg+tlrc -expr '(step(-a-1.96))*b' -prefix ${subj}.OdorValence.medialAmyPU.t196
 3dcalc -a ${subj}.analysis.+tlrc'[32]' -b ../../BN_atlas/BN_Amyg+tlrc -expr '(step(-a-1.96))*b' -prefix ${subj}.OdorValence.AmyPU.t196

 3dcalc -a ${subj}.analysis.+tlrc'[35]' -b ../../BN_atlas/lAmyg+tlrc -expr '(step(-a-1.96))*b' -prefix ${subj}.FaceValence.lateralAmyHF.t196
 3dcalc -a ${subj}.analysis.+tlrc'[35]' -b ../../BN_atlas/mAmyg+tlrc -expr '(step(-a-1.96))*b' -prefix ${subj}.FaceValence.medialAmyHF.t196
 3dcalc -a ${subj}.analysis.+tlrc'[35]' -b ../../BN_atlas/BN_Amyg+tlrc -expr '(step(-a-1.96))*b' -prefix ${subj}.FaceValence.AmyHF.t196

 3dROIstats -mask ${subj}.OdorValence.lateralAmyPU.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.OdorValence.lateralAmyPU.t196.txt
 3dROIstats -mask ${subj}.OdorValence.medialAmyPU.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.OdorValence.medialAmyPU.t196.txt
 3dROIstats -mask ${subj}.OdorValence.AmyPU.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.OdorValence.AmyPU.t196.txt

 3dROIstats -mask ${subj}.FaceValence.lateralAmyHF.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.FaceValence.lateralAmyHF.t196.txt
 3dROIstats -mask ${subj}.FaceValence.medialAmyHF.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.FaceValence.medialAmyHF.t196.txt
 3dROIstats -mask ${subj}.FaceValence.AmyHF.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.FaceValence.AmyHF.t196.txt
##################

 3dROIstats -mask ${subj}.OdorValence.lateralAmyUP.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.OdorValence.lateralAmyUP.t196.txt
 3dROIstats -mask ${subj}.OdorValence.medialAmyUP.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.OdorValence.medialAmyUP.t196.txt
 3dROIstats -mask ${subj}.OdorValence.AmyUP.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.OdorValence.AmyUP.t196.txt

 3dROIstats -mask ${subj}.FaceValence.lateralAmyFH.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.FaceValence.lateralAmyFH.t196.txt
 3dROIstats -mask ${subj}.FaceValence.medialAmyFH.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.FaceValence.medialAmyFH.t196.txt
 3dROIstats -mask ${subj}.FaceValence.AmyFH.t196+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' > ../../ana4/${subj}.FaceValence.AmyFH.t196.txt





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

cd ana4

cat *.OdorValence.lateralAmyUP.t196.txt > 20subj_OdorValence.lateralAmyUP.t196.txt
cat *.OdorValence.medialAmyUP.t196.txt > 20subj_OdorValence.medialAmyUP.t196.txt
cat *.OdorValence.AmyUP.t196.txt > 20subj_OdorValence.AmyUP.t196.txt

cat *.FaceValence.lateralAmyFH.t196.txt > 20subj_FaceValence.lateralAmyFH.t196.txt
cat *.FaceValence.medialAmyFH.t196.txt > 20subj_FaceValence.medialAmyFH.t196.txt
cat *.FaceValence.AmyFH.t196.txt > 20subj_FaceValence.AmyFH.t196.txt

cat *.OdorValence.lateralAmyPU.t196.txt > 20subj_OdorValence.lateralAmyPU.t196.txt
cat *.OdorValence.medialAmyPU.t196.txt > 20subj_OdorValence.medialAmyPU.t196.txt
cat *.OdorValence.AmyPU.t196.txt > 20subj_OdorValence.AmyPU.t196.txt

cat *.FaceValence.lateralAmyHF.t196.txt > 20subj_FaceValence.lateralAmyHF.t196.txt
cat *.FaceValence.medialAmyHF.t196.txt > 20subj_FaceValence.medialAmyHF.t196.txt
cat *.FaceValence.AmyHF.t196.txt > 20subj_FaceValence.AmyHF.t196.txt
# cat *.OdorValenceU_P.t1.64.TT_signal.gf.txt > 8subj_OdorValenceU_P.t1.64.TT_signal.gf.txt
# cat *.FaceValenceF_H.t1.64.TT_signal.gf.txt > 8subj_FaceValenceF_H.t1.64.TT_signal.gf.txt
# cat *.OdorValenceP_U.t1.64.TT_signal.gf.txt > 8subj_OdorValenceP_U.t1.64.TT_signal.gf.txt
# cat *.FaceValenceH_F.t1.64.TT_signal.gf.txt > 8subj_FaceValenceH_F.t1.64.TT_signal.gf.txt

# else
 # echo "Usage: $0 <Subjname>"

# endif
