#! /bin/csh
set datafolder=/Volumes/WD_D/allsub
# set datafolder=/Volumes/WD_D/Exp_odor_face/fMRI\ data_supplemental/

set tmark=t196
set t0mark=t196

cd "${datafolder}"
#converge all txt file

cd ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_lateral
# rm 20subj*.txt

cat *.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}_FPI.txt >! 20subj_OdorValence.lateralAmyPU.${tmark}_FPI.txt
cat *.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}_FPV.txt >! 20subj_OdorValence.lateralAmyPU.${tmark}_FPV.txt
cat *.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}_FUI.txt >! 20subj_OdorValence.lateralAmyPU.${tmark}_FUI.txt
cat *.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}_FUV.txt >! 20subj_OdorValence.lateralAmyPU.${tmark}_FUV.txt
cat *.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}_HPI.txt >! 20subj_OdorValence.lateralAmyPU.${tmark}_HPI.txt
cat *.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}_HPV.txt >! 20subj_OdorValence.lateralAmyPU.${tmark}_HPV.txt
cat *.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}_HUI.txt >! 20subj_OdorValence.lateralAmyPU.${tmark}_HUI.txt
cat *.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}_HUV.txt >! 20subj_OdorValence.lateralAmyPU.${tmark}_HUV.txt
cd ../tent_odorPU_medial
# rm 20subj*.txt
cat *.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}_FPI.txt >! 20subj_OdorValence.medialAmyPU.${tmark}_FPI.txt
cat *.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}_FPV.txt >! 20subj_OdorValence.medialAmyPU.${tmark}_FPV.txt
cat *.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}_FUI.txt >! 20subj_OdorValence.medialAmyPU.${tmark}_FUI.txt
cat *.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}_FUV.txt >! 20subj_OdorValence.medialAmyPU.${tmark}_FUV.txt
cat *.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}_HPI.txt >! 20subj_OdorValence.medialAmyPU.${tmark}_HPI.txt
cat *.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}_HPV.txt >! 20subj_OdorValence.medialAmyPU.${tmark}_HPV.txt
cat *.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}_HUI.txt >! 20subj_OdorValence.medialAmyPU.${tmark}_HUI.txt
cat *.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}_HUV.txt >! 20subj_OdorValence.medialAmyPU.${tmark}_HUV.txt
cd ../tent_odorPU_all
# rm 20subj*.txt
cat *.OdorValenceAb0${t0mark}.AmyPU.${tmark}_FPI.txt >! 20subj_OdorValence.AmyPU.${tmark}_FPI.txt
cat *.OdorValenceAb0${t0mark}.AmyPU.${tmark}_FPV.txt >! 20subj_OdorValence.AmyPU.${tmark}_FPV.txt
cat *.OdorValenceAb0${t0mark}.AmyPU.${tmark}_FUI.txt >! 20subj_OdorValence.AmyPU.${tmark}_FUI.txt
cat *.OdorValenceAb0${t0mark}.AmyPU.${tmark}_FUV.txt >! 20subj_OdorValence.AmyPU.${tmark}_FUV.txt
cat *.OdorValenceAb0${t0mark}.AmyPU.${tmark}_HPI.txt >! 20subj_OdorValence.AmyPU.${tmark}_HPI.txt
cat *.OdorValenceAb0${t0mark}.AmyPU.${tmark}_HPV.txt >! 20subj_OdorValence.AmyPU.${tmark}_HPV.txt
cat *.OdorValenceAb0${t0mark}.AmyPU.${tmark}_HUI.txt >! 20subj_OdorValence.AmyPU.${tmark}_HUI.txt
cat *.OdorValenceAb0${t0mark}.AmyPU.${tmark}_HUV.txt >! 20subj_OdorValence.AmyPU.${tmark}_HUV.txt



cd ../tent_faceHF_lateral
# rm 20subj*.txt
cat *.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}_FPI.txt >! 20subj_FaceValence.lateralAmyHF.${tmark}_FPI.txt
cat *.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}_FPV.txt >! 20subj_FaceValence.lateralAmyHF.${tmark}_FPV.txt
cat *.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}_FUI.txt >! 20subj_FaceValence.lateralAmyHF.${tmark}_FUI.txt
cat *.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}_FUV.txt >! 20subj_FaceValence.lateralAmyHF.${tmark}_FUV.txt
cat *.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}_HPI.txt >! 20subj_FaceValence.lateralAmyHF.${tmark}_HPI.txt
cat *.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}_HPV.txt >! 20subj_FaceValence.lateralAmyHF.${tmark}_HPV.txt
cat *.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}_HUI.txt >! 20subj_FaceValence.lateralAmyHF.${tmark}_HUI.txt
cat *.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}_HUV.txt >! 20subj_FaceValence.lateralAmyHF.${tmark}_HUV.txt
cd ../tent_faceHF_medial
# rm 20subj*.txt
cat *.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}_FPI.txt >! 20subj_FaceValence.medialAmyHF.${tmark}_FPI.txt
cat *.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}_FPV.txt >! 20subj_FaceValence.medialAmyHF.${tmark}_FPV.txt
cat *.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}_FUI.txt >! 20subj_FaceValence.medialAmyHF.${tmark}_FUI.txt
cat *.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}_FUV.txt >! 20subj_FaceValence.medialAmyHF.${tmark}_FUV.txt
cat *.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}_HPI.txt >! 20subj_FaceValence.medialAmyHF.${tmark}_HPI.txt
cat *.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}_HPV.txt >! 20subj_FaceValence.medialAmyHF.${tmark}_HPV.txt
cat *.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}_HUI.txt >! 20subj_FaceValence.medialAmyHF.${tmark}_HUI.txt
cat *.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}_HUV.txt >! 20subj_FaceValence.medialAmyHF.${tmark}_HUV.txt
cd ../tent_faceHF_all
# rm 20subj*.txt
cat *.FaceValenceAb0${t0mark}.AmyHF.${tmark}_FPI.txt >! 20subj_FaceValence.AmyHF.${tmark}_FPI.txt
cat *.FaceValenceAb0${t0mark}.AmyHF.${tmark}_FPV.txt >! 20subj_FaceValence.AmyHF.${tmark}_FPV.txt
cat *.FaceValenceAb0${t0mark}.AmyHF.${tmark}_FUI.txt >! 20subj_FaceValence.AmyHF.${tmark}_FUI.txt
cat *.FaceValenceAb0${t0mark}.AmyHF.${tmark}_FUV.txt >! 20subj_FaceValence.AmyHF.${tmark}_FUV.txt
cat *.FaceValenceAb0${t0mark}.AmyHF.${tmark}_HPI.txt >! 20subj_FaceValence.AmyHF.${tmark}_HPI.txt
cat *.FaceValenceAb0${t0mark}.AmyHF.${tmark}_HPV.txt >! 20subj_FaceValence.AmyHF.${tmark}_HPV.txt
cat *.FaceValenceAb0${t0mark}.AmyHF.${tmark}_HUI.txt >! 20subj_FaceValence.AmyHF.${tmark}_HUI.txt
cat *.FaceValenceAb0${t0mark}.AmyHF.${tmark}_HUV.txt >! 20subj_FaceValence.AmyHF.${tmark}_HUV.txt



cd ../tent_odorUP_lateral
# rm 20subj*.txt
cat *.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}_FPI.txt >! 20subj_OdorValence.lateralAmyUP.${tmark}_FPI.txt
cat *.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}_FPV.txt >! 20subj_OdorValence.lateralAmyUP.${tmark}_FPV.txt
cat *.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}_FUI.txt >! 20subj_OdorValence.lateralAmyUP.${tmark}_FUI.txt
cat *.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}_FUV.txt >! 20subj_OdorValence.lateralAmyUP.${tmark}_FUV.txt
cat *.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}_HPI.txt >! 20subj_OdorValence.lateralAmyUP.${tmark}_HPI.txt
cat *.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}_HPV.txt >! 20subj_OdorValence.lateralAmyUP.${tmark}_HPV.txt
cat *.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}_HUI.txt >! 20subj_OdorValence.lateralAmyUP.${tmark}_HUI.txt
cat *.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}_HUV.txt >! 20subj_OdorValence.lateralAmyUP.${tmark}_HUV.txt
cd ../tent_odorUP_medial
# rm 20subj*.txt
cat *.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}_FPI.txt >! 20subj_OdorValence.medialAmyUP.${tmark}_FPI.txt
cat *.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}_FPV.txt >! 20subj_OdorValence.medialAmyUP.${tmark}_FPV.txt
cat *.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}_FUI.txt >! 20subj_OdorValence.medialAmyUP.${tmark}_FUI.txt
cat *.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}_FUV.txt >! 20subj_OdorValence.medialAmyUP.${tmark}_FUV.txt
cat *.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}_HPI.txt >! 20subj_OdorValence.medialAmyUP.${tmark}_HPI.txt
cat *.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}_HPV.txt >! 20subj_OdorValence.medialAmyUP.${tmark}_HPV.txt
cat *.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}_HUI.txt >! 20subj_OdorValence.medialAmyUP.${tmark}_HUI.txt
cat *.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}_HUV.txt >! 20subj_OdorValence.medialAmyUP.${tmark}_HUV.txt
cd ../tent_odorUP_all
# rm 20subj*.txt
cat *.OdorValenceAb0${t0mark}.AmyUP.${tmark}_FPI.txt >! 20subj_OdorValence.AmyUP.${tmark}_FPI.txt
cat *.OdorValenceAb0${t0mark}.AmyUP.${tmark}_FPV.txt >! 20subj_OdorValence.AmyUP.${tmark}_FPV.txt
cat *.OdorValenceAb0${t0mark}.AmyUP.${tmark}_FUI.txt >! 20subj_OdorValence.AmyUP.${tmark}_FUI.txt
cat *.OdorValenceAb0${t0mark}.AmyUP.${tmark}_FUV.txt >! 20subj_OdorValence.AmyUP.${tmark}_FUV.txt
cat *.OdorValenceAb0${t0mark}.AmyUP.${tmark}_HPI.txt >! 20subj_OdorValence.AmyUP.${tmark}_HPI.txt
cat *.OdorValenceAb0${t0mark}.AmyUP.${tmark}_HPV.txt >! 20subj_OdorValence.AmyUP.${tmark}_HPV.txt
cat *.OdorValenceAb0${t0mark}.AmyUP.${tmark}_HUI.txt >! 20subj_OdorValence.AmyUP.${tmark}_HUI.txt
cat *.OdorValenceAb0${t0mark}.AmyUP.${tmark}_HUV.txt >! 20subj_OdorValence.AmyUP.${tmark}_HUV.txt



cd ../tent_faceFH_lateral
# rm 20subj*.txt
cat *.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}_FPI.txt >! 20subj_FaceValence.lateralAmyFH.${tmark}_FPI.txt
cat *.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}_FPV.txt >! 20subj_FaceValence.lateralAmyFH.${tmark}_FPV.txt
cat *.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}_FUI.txt >! 20subj_FaceValence.lateralAmyFH.${tmark}_FUI.txt
cat *.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}_FUV.txt >! 20subj_FaceValence.lateralAmyFH.${tmark}_FUV.txt
cat *.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}_HPI.txt >! 20subj_FaceValence.lateralAmyFH.${tmark}_HPI.txt
cat *.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}_HPV.txt >! 20subj_FaceValence.lateralAmyFH.${tmark}_HPV.txt
cat *.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}_HUI.txt >! 20subj_FaceValence.lateralAmyFH.${tmark}_HUI.txt
cat *.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}_HUV.txt >! 20subj_FaceValence.lateralAmyFH.${tmark}_HUV.txt
cd ../tent_faceFH_medial
# rm 20subj*.txt
cat *.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}_FPI.txt >! 20subj_FaceValence.medialAmyFH.${tmark}_FPI.txt
cat *.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}_FPV.txt >! 20subj_FaceValence.medialAmyFH.${tmark}_FPV.txt
cat *.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}_FUI.txt >! 20subj_FaceValence.medialAmyFH.${tmark}_FUI.txt
cat *.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}_FUV.txt >! 20subj_FaceValence.medialAmyFH.${tmark}_FUV.txt
cat *.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}_HPI.txt >! 20subj_FaceValence.medialAmyFH.${tmark}_HPI.txt
cat *.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}_HPV.txt >! 20subj_FaceValence.medialAmyFH.${tmark}_HPV.txt
cat *.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}_HUI.txt >! 20subj_FaceValence.medialAmyFH.${tmark}_HUI.txt
cat *.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}_HUV.txt >! 20subj_FaceValence.medialAmyFH.${tmark}_HUV.txt
cd ../tent_faceFH_all
# rm 20subj*.txt
cat *.FaceValenceAb0${t0mark}.AmyFH.${tmark}_FPI.txt >! 20subj_FaceValence.AmyFH.${tmark}_FPI.txt
cat *.FaceValenceAb0${t0mark}.AmyFH.${tmark}_FPV.txt >! 20subj_FaceValence.AmyFH.${tmark}_FPV.txt
cat *.FaceValenceAb0${t0mark}.AmyFH.${tmark}_FUI.txt >! 20subj_FaceValence.AmyFH.${tmark}_FUI.txt
cat *.FaceValenceAb0${t0mark}.AmyFH.${tmark}_FUV.txt >! 20subj_FaceValence.AmyFH.${tmark}_FUV.txt
cat *.FaceValenceAb0${t0mark}.AmyFH.${tmark}_HPI.txt >! 20subj_FaceValence.AmyFH.${tmark}_HPI.txt
cat *.FaceValenceAb0${t0mark}.AmyFH.${tmark}_HPV.txt >! 20subj_FaceValence.AmyFH.${tmark}_HPV.txt
cat *.FaceValenceAb0${t0mark}.AmyFH.${tmark}_HUI.txt >! 20subj_FaceValence.AmyFH.${tmark}_HUI.txt
cat *.FaceValenceAb0${t0mark}.AmyFH.${tmark}_HUV.txt >! 20subj_FaceValence.AmyFH.${tmark}_HUV.txt
