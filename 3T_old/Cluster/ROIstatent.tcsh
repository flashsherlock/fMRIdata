#! /bin/csh
set datafolder=/Volumes/WD_D/allsub
# set datafolder=/Volumes/WD_D/Exp_odor_face/fMRI\ data_supplemental/

set tmark=t196
set t0mark=t196

cd "${datafolder}"

if (! -e ana4/AmyAbove0${t0mark}${tmark}_tent) then
mkdir ana4/AmyAbove0${t0mark}${tmark}_tent
mkdir ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_lateral
mkdir ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_medial
mkdir ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_all
mkdir ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_lateral
mkdir ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_medial
mkdir ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_all
mkdir ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_lateral
mkdir ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_medial
mkdir ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_all
mkdir ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_lateral
mkdir ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_medial
mkdir ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_all
endif

# if ( $# > 0 ) then
# foreach subj (`ls -d S*`)
foreach subj (S04 S05 S06 S07 S08 S11 S14 S15 S16 S19 S21 S22 S23 S24 S25 S26 S27 S28 S29)
#S22 S23 S24 S25 S26 S27 S28
# set subj = $1

cd ${subj}
#mkdir analysis
cd analysis

########################################################################################################################################################################################################
# OdorValence pleasant-unpleasant lateral amygdala
echo start ${subj}

3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_lateral/${subj}.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}_FPI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_lateral/${subj}.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}_FPV.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_lateral/${subj}.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}_FUI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_lateral/${subj}.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}_FUV.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_lateral/${subj}.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}_HPI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_lateral/${subj}.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}_HPV.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_lateral/${subj}.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}_HUI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_lateral/${subj}.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}_HUV.txt
echo finish 1/12
# OdorValence pleasant-unpleasant lateral amygdala
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_medial/${subj}.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}_FPI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_medial/${subj}.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}_FPV.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_medial/${subj}.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}_FUI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_medial/${subj}.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}_FUV.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_medial/${subj}.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}_HPI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_medial/${subj}.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}_HPV.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_medial/${subj}.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}_HUI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_medial/${subj}.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}_HUV.txt
echo finish 2/12
# OdorValence pleasant-unpleasant lateral amygdala
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.AmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_all/${subj}.OdorValenceAb0${t0mark}.AmyPU.${tmark}_FPI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.AmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_all/${subj}.OdorValenceAb0${t0mark}.AmyPU.${tmark}_FPV.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.AmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_all/${subj}.OdorValenceAb0${t0mark}.AmyPU.${tmark}_FUI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.AmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_all/${subj}.OdorValenceAb0${t0mark}.AmyPU.${tmark}_FUV.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.AmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_all/${subj}.OdorValenceAb0${t0mark}.AmyPU.${tmark}_HPI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.AmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_all/${subj}.OdorValenceAb0${t0mark}.AmyPU.${tmark}_HPV.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.AmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_all/${subj}.OdorValenceAb0${t0mark}.AmyPU.${tmark}_HUI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.AmyPU.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorPU_all/${subj}.OdorValenceAb0${t0mark}.AmyPU.${tmark}_HUV.txt
echo finish 3/12

########################################################################################################################################################################################################

# FaceValence Happy-Fear lateral amygdala
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_lateral/${subj}.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}_FPI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_lateral/${subj}.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}_FPV.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_lateral/${subj}.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}_FUI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_lateral/${subj}.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}_FUV.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_lateral/${subj}.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}_HPI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_lateral/${subj}.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}_HPV.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_lateral/${subj}.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}_HUI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_lateral/${subj}.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}_HUV.txt
echo finish 4/12
# FaceValence Happy-Fear lateral amygdala
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_medial/${subj}.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}_FPI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_medial/${subj}.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}_FPV.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_medial/${subj}.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}_FUI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_medial/${subj}.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}_FUV.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_medial/${subj}.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}_HPI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_medial/${subj}.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}_HPV.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_medial/${subj}.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}_HUI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_medial/${subj}.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}_HUV.txt
echo finish 5/12
# FaceValence Happy-Fear lateral amygdala
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.AmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_all/${subj}.FaceValenceAb0${t0mark}.AmyHF.${tmark}_FPI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.AmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_all/${subj}.FaceValenceAb0${t0mark}.AmyHF.${tmark}_FPV.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.AmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_all/${subj}.FaceValenceAb0${t0mark}.AmyHF.${tmark}_FUI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.AmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_all/${subj}.FaceValenceAb0${t0mark}.AmyHF.${tmark}_FUV.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.AmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_all/${subj}.FaceValenceAb0${t0mark}.AmyHF.${tmark}_HPI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.AmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_all/${subj}.FaceValenceAb0${t0mark}.AmyHF.${tmark}_HPV.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.AmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_all/${subj}.FaceValenceAb0${t0mark}.AmyHF.${tmark}_HUI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.AmyHF.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceHF_all/${subj}.FaceValenceAb0${t0mark}.AmyHF.${tmark}_HUV.txt
echo finish 6/12

########################################################################################################################################################################################################

# OdorValence pleasant-unpleasant lateral amygdala
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_lateral/${subj}.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}_FPI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_lateral/${subj}.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}_FPV.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_lateral/${subj}.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}_FUI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_lateral/${subj}.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}_FUV.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_lateral/${subj}.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}_HPI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_lateral/${subj}.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}_HPV.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_lateral/${subj}.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}_HUI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_lateral/${subj}.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}_HUV.txt
echo finish 7/12
# OdorValence pleasant-unpleasant lateral amygdala
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_medial/${subj}.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}_FPI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_medial/${subj}.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}_FPV.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_medial/${subj}.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}_FUI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_medial/${subj}.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}_FUV.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_medial/${subj}.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}_HPI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_medial/${subj}.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}_HPV.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_medial/${subj}.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}_HUI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_medial/${subj}.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}_HUV.txt
echo finish 8/12
# OdorValence pleasant-unpleasant lateral amygdala
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.AmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_all/${subj}.OdorValenceAb0${t0mark}.AmyUP.${tmark}_FPI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.AmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_all/${subj}.OdorValenceAb0${t0mark}.AmyUP.${tmark}_FPV.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.AmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_all/${subj}.OdorValenceAb0${t0mark}.AmyUP.${tmark}_FUI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.AmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_all/${subj}.OdorValenceAb0${t0mark}.AmyUP.${tmark}_FUV.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.AmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_all/${subj}.OdorValenceAb0${t0mark}.AmyUP.${tmark}_HPI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.AmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_all/${subj}.OdorValenceAb0${t0mark}.AmyUP.${tmark}_HPV.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.AmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_all/${subj}.OdorValenceAb0${t0mark}.AmyUP.${tmark}_HUI.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.AmyUP.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_odorUP_all/${subj}.OdorValenceAb0${t0mark}.AmyUP.${tmark}_HUV.txt
echo finish 9/12
########################################################################################################################################################################################################

# OdorValence pleasant-unpleasant lateral amygdala
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_lateral/${subj}.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}_FPI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_lateral/${subj}.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}_FPV.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_lateral/${subj}.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}_FUI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_lateral/${subj}.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}_FUV.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_lateral/${subj}.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}_HPI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_lateral/${subj}.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}_HPV.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_lateral/${subj}.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}_HUI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_lateral/${subj}.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}_HUV.txt
echo finish 10/12
# OdorValence pleasant-unpleasant lateral amygdala
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_medial/${subj}.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}_FPI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_medial/${subj}.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}_FPV.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_medial/${subj}.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}_FUI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_medial/${subj}.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}_FUV.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_medial/${subj}.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}_HPI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_medial/${subj}.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}_HPV.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_medial/${subj}.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}_HUI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_medial/${subj}.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}_HUV.txt
echo finish 11/12
# OdorValence pleasant-unpleasant lateral amygdala
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.AmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_all/${subj}.FaceValenceAb0${t0mark}.AmyFH.${tmark}_FPI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.AmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_all/${subj}.FaceValenceAb0${t0mark}.AmyFH.${tmark}_FPV.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.AmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_all/${subj}.FaceValenceAb0${t0mark}.AmyFH.${tmark}_FUI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.AmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_all/${subj}.FaceValenceAb0${t0mark}.AmyFH.${tmark}_FUV.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.AmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_all/${subj}.FaceValenceAb0${t0mark}.AmyFH.${tmark}_HPI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.AmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_all/${subj}.FaceValenceAb0${t0mark}.AmyFH.${tmark}_HPV.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.AmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_all/${subj}.FaceValenceAb0${t0mark}.AmyFH.${tmark}_HUI.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.AmyFH.${tmark}+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  >! ../../ana4/AmyAbove0${t0mark}${tmark}_tent/tent_faceFH_all/${subj}.FaceValenceAb0${t0mark}.AmyFH.${tmark}_HUV.txt
echo finish 12/12

cd ..
cd ..

echo finish ${subj}

end

# else
#  echo "Usage: $0 <Subjname>"
#
# endif
