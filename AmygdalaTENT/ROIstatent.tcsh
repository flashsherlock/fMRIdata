#! /bin/csh
set datafolder=/Volumes/WD_D/allsub
cd ${datafolder}

# if ( $# > 0 ) then
foreach subj (`ls -d S*`)
# foreach subj (S03)
#S22 S23 S24 S25 S26 S27 S28
# set subj = $1

cd ${subj}
#mkdir analysis
cd analysis

########################################################################################################################################################################################################
# mkdir ../../ana4/tent_odorPU_lateral
# mkdir ../../ana4/tent_odorPU_medial
# mkdir ../../ana4/tent_odorPU_all
# mkdir ../../ana4/tent_faceHF_lateral
# mkdir ../../ana4/tent_faceHF_medial
# mkdir ../../ana4/tent_faceHF_all
# mkdir ../../ana4/tent_odorUP_lateral
# mkdir ../../ana4/tent_odorUP_medial
# mkdir ../../ana4/tent_odorUP_all
# mkdir ../../ana4/tent_faceFH_lateral
# mkdir ../../ana4/tent_faceFH_medial
# mkdir ../../ana4/tent_faceFH_all
# OdorValence pleasant-unpleasant lateral amygdala
3dROIstats -mask ${subj}.OdorValence.lateralAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" > ../../ana4/tent_odorPU_lateral/${subj}.OdorValence.lateralAmyPU.t196_FPI.txt
3dROIstats -mask ${subj}.OdorValence.lateralAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  > ../../ana4/tent_odorPU_lateral/${subj}.OdorValence.lateralAmyPU.t196_FPV.txt
3dROIstats -mask ${subj}.OdorValence.lateralAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  > ../../ana4/tent_odorPU_lateral/${subj}.OdorValence.lateralAmyPU.t196_FUI.txt
3dROIstats -mask ${subj}.OdorValence.lateralAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  > ../../ana4/tent_odorPU_lateral/${subj}.OdorValence.lateralAmyPU.t196_FUV.txt
3dROIstats -mask ${subj}.OdorValence.lateralAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  > ../../ana4/tent_odorPU_lateral/${subj}.OdorValence.lateralAmyPU.t196_HPI.txt
3dROIstats -mask ${subj}.OdorValence.lateralAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  > ../../ana4/tent_odorPU_lateral/${subj}.OdorValence.lateralAmyPU.t196_HPV.txt
3dROIstats -mask ${subj}.OdorValence.lateralAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  > ../../ana4/tent_odorPU_lateral/${subj}.OdorValence.lateralAmyPU.t196_HUI.txt
3dROIstats -mask ${subj}.OdorValence.lateralAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  > ../../ana4/tent_odorPU_lateral/${subj}.OdorValence.lateralAmyPU.t196_HUV.txt

# OdorValence pleasant-unpleasant lateral amygdala
3dROIstats -mask ${subj}.OdorValence.medialAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" > ../../ana4/tent_odorPU_medial/${subj}.OdorValence.medialAmyPU.t196_FPI.txt
3dROIstats -mask ${subj}.OdorValence.medialAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  > ../../ana4/tent_odorPU_medial/${subj}.OdorValence.medialAmyPU.t196_FPV.txt
3dROIstats -mask ${subj}.OdorValence.medialAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  > ../../ana4/tent_odorPU_medial/${subj}.OdorValence.medialAmyPU.t196_FUI.txt
3dROIstats -mask ${subj}.OdorValence.medialAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  > ../../ana4/tent_odorPU_medial/${subj}.OdorValence.medialAmyPU.t196_FUV.txt
3dROIstats -mask ${subj}.OdorValence.medialAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  > ../../ana4/tent_odorPU_medial/${subj}.OdorValence.medialAmyPU.t196_HPI.txt
3dROIstats -mask ${subj}.OdorValence.medialAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  > ../../ana4/tent_odorPU_medial/${subj}.OdorValence.medialAmyPU.t196_HPV.txt
3dROIstats -mask ${subj}.OdorValence.medialAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  > ../../ana4/tent_odorPU_medial/${subj}.OdorValence.medialAmyPU.t196_HUI.txt
3dROIstats -mask ${subj}.OdorValence.medialAmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  > ../../ana4/tent_odorPU_medial/${subj}.OdorValence.medialAmyPU.t196_HUV.txt

# OdorValence pleasant-unpleasant lateral amygdala
3dROIstats -mask ${subj}.OdorValence.AmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" > ../../ana4/tent_odorPU_all/${subj}.OdorValence.AmyPU.t196_FPI.txt
3dROIstats -mask ${subj}.OdorValence.AmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  > ../../ana4/tent_odorPU_all/${subj}.OdorValence.AmyPU.t196_FPV.txt
3dROIstats -mask ${subj}.OdorValence.AmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  > ../../ana4/tent_odorPU_all/${subj}.OdorValence.AmyPU.t196_FUI.txt
3dROIstats -mask ${subj}.OdorValence.AmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  > ../../ana4/tent_odorPU_all/${subj}.OdorValence.AmyPU.t196_FUV.txt
3dROIstats -mask ${subj}.OdorValence.AmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  > ../../ana4/tent_odorPU_all/${subj}.OdorValence.AmyPU.t196_HPI.txt
3dROIstats -mask ${subj}.OdorValence.AmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  > ../../ana4/tent_odorPU_all/${subj}.OdorValence.AmyPU.t196_HPV.txt
3dROIstats -mask ${subj}.OdorValence.AmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  > ../../ana4/tent_odorPU_all/${subj}.OdorValence.AmyPU.t196_HUI.txt
3dROIstats -mask ${subj}.OdorValence.AmyPU.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  > ../../ana4/tent_odorPU_all/${subj}.OdorValence.AmyPU.t196_HUV.txt


########################################################################################################################################################################################################

# FaceValence Happy-Fear lateral amygdala
3dROIstats -mask ${subj}.FaceValence.lateralAmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" > ../../ana4/tent_faceHF_lateral/${subj}.FaceValence.lateralAmyHF.t196_FPI.txt
3dROIstats -mask ${subj}.FaceValence.lateralAmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  > ../../ana4/tent_faceHF_lateral/${subj}.FaceValence.lateralAmyHF.t196_FPV.txt
3dROIstats -mask ${subj}.FaceValence.lateralAmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  > ../../ana4/tent_faceHF_lateral/${subj}.FaceValence.lateralAmyHF.t196_FUI.txt
3dROIstats -mask ${subj}.FaceValence.lateralAmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  > ../../ana4/tent_faceHF_lateral/${subj}.FaceValence.lateralAmyHF.t196_FUV.txt
3dROIstats -mask ${subj}.FaceValence.lateralAmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  > ../../ana4/tent_faceHF_lateral/${subj}.FaceValence.lateralAmyHF.t196_HPI.txt
3dROIstats -mask ${subj}.FaceValence.lateralAmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  > ../../ana4/tent_faceHF_lateral/${subj}.FaceValence.lateralAmyHF.t196_HPV.txt
3dROIstats -mask ${subj}.FaceValence.lateralAmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  > ../../ana4/tent_faceHF_lateral/${subj}.FaceValence.lateralAmyHF.t196_HUI.txt
3dROIstats -mask ${subj}.FaceValence.lateralAmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  > ../../ana4/tent_faceHF_lateral/${subj}.FaceValence.lateralAmyHF.t196_HUV.txt

# FaceValence Happy-Fear lateral amygdala
3dROIstats -mask ${subj}.FaceValence.medialAmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" > ../../ana4/tent_faceHF_medial/${subj}.FaceValence.medialAmyHF.t196_FPI.txt
3dROIstats -mask ${subj}.FaceValence.medialAmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  > ../../ana4/tent_faceHF_medial/${subj}.FaceValence.medialAmyHF.t196_FPV.txt
3dROIstats -mask ${subj}.FaceValence.medialAmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  > ../../ana4/tent_faceHF_medial/${subj}.FaceValence.medialAmyHF.t196_FUI.txt
3dROIstats -mask ${subj}.FaceValence.medialAmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  > ../../ana4/tent_faceHF_medial/${subj}.FaceValence.medialAmyHF.t196_FUV.txt
3dROIstats -mask ${subj}.FaceValence.medialAmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  > ../../ana4/tent_faceHF_medial/${subj}.FaceValence.medialAmyHF.t196_HPI.txt
3dROIstats -mask ${subj}.FaceValence.medialAmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  > ../../ana4/tent_faceHF_medial/${subj}.FaceValence.medialAmyHF.t196_HPV.txt
3dROIstats -mask ${subj}.FaceValence.medialAmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  > ../../ana4/tent_faceHF_medial/${subj}.FaceValence.medialAmyHF.t196_HUI.txt
3dROIstats -mask ${subj}.FaceValence.medialAmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  > ../../ana4/tent_faceHF_medial/${subj}.FaceValence.medialAmyHF.t196_HUV.txt

# FaceValence Happy-Fear lateral amygdala
3dROIstats -mask ${subj}.FaceValence.AmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" > ../../ana4/tent_faceHF_all/${subj}.FaceValence.AmyHF.t196_FPI.txt
3dROIstats -mask ${subj}.FaceValence.AmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  > ../../ana4/tent_faceHF_all/${subj}.FaceValence.AmyHF.t196_FPV.txt
3dROIstats -mask ${subj}.FaceValence.AmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  > ../../ana4/tent_faceHF_all/${subj}.FaceValence.AmyHF.t196_FUI.txt
3dROIstats -mask ${subj}.FaceValence.AmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  > ../../ana4/tent_faceHF_all/${subj}.FaceValence.AmyHF.t196_FUV.txt
3dROIstats -mask ${subj}.FaceValence.AmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  > ../../ana4/tent_faceHF_all/${subj}.FaceValence.AmyHF.t196_HPI.txt
3dROIstats -mask ${subj}.FaceValence.AmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  > ../../ana4/tent_faceHF_all/${subj}.FaceValence.AmyHF.t196_HPV.txt
3dROIstats -mask ${subj}.FaceValence.AmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  > ../../ana4/tent_faceHF_all/${subj}.FaceValence.AmyHF.t196_HUI.txt
3dROIstats -mask ${subj}.FaceValence.AmyHF.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  > ../../ana4/tent_faceHF_all/${subj}.FaceValence.AmyHF.t196_HUV.txt


########################################################################################################################################################################################################

# OdorValence pleasant-unpleasant lateral amygdala
3dROIstats -mask ${subj}.OdorValence.lateralAmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" > ../../ana4/tent_odorUP_lateral/${subj}.OdorValence.lateralAmyUP.t196_FPI.txt
3dROIstats -mask ${subj}.OdorValence.lateralAmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  > ../../ana4/tent_odorUP_lateral/${subj}.OdorValence.lateralAmyUP.t196_FPV.txt
3dROIstats -mask ${subj}.OdorValence.lateralAmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  > ../../ana4/tent_odorUP_lateral/${subj}.OdorValence.lateralAmyUP.t196_FUI.txt
3dROIstats -mask ${subj}.OdorValence.lateralAmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  > ../../ana4/tent_odorUP_lateral/${subj}.OdorValence.lateralAmyUP.t196_FUV.txt
3dROIstats -mask ${subj}.OdorValence.lateralAmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  > ../../ana4/tent_odorUP_lateral/${subj}.OdorValence.lateralAmyUP.t196_HPI.txt
3dROIstats -mask ${subj}.OdorValence.lateralAmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  > ../../ana4/tent_odorUP_lateral/${subj}.OdorValence.lateralAmyUP.t196_HPV.txt
3dROIstats -mask ${subj}.OdorValence.lateralAmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  > ../../ana4/tent_odorUP_lateral/${subj}.OdorValence.lateralAmyUP.t196_HUI.txt
3dROIstats -mask ${subj}.OdorValence.lateralAmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  > ../../ana4/tent_odorUP_lateral/${subj}.OdorValence.lateralAmyUP.t196_HUV.txt

# OdorValence pleasant-unpleasant lateral amygdala
3dROIstats -mask ${subj}.OdorValence.medialAmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" > ../../ana4/tent_odorUP_medial/${subj}.OdorValence.medialAmyUP.t196_FPI.txt
3dROIstats -mask ${subj}.OdorValence.medialAmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  > ../../ana4/tent_odorUP_medial/${subj}.OdorValence.medialAmyUP.t196_FPV.txt
3dROIstats -mask ${subj}.OdorValence.medialAmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  > ../../ana4/tent_odorUP_medial/${subj}.OdorValence.medialAmyUP.t196_FUI.txt
3dROIstats -mask ${subj}.OdorValence.medialAmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  > ../../ana4/tent_odorUP_medial/${subj}.OdorValence.medialAmyUP.t196_FUV.txt
3dROIstats -mask ${subj}.OdorValence.medialAmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  > ../../ana4/tent_odorUP_medial/${subj}.OdorValence.medialAmyUP.t196_HPI.txt
3dROIstats -mask ${subj}.OdorValence.medialAmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  > ../../ana4/tent_odorUP_medial/${subj}.OdorValence.medialAmyUP.t196_HPV.txt
3dROIstats -mask ${subj}.OdorValence.medialAmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  > ../../ana4/tent_odorUP_medial/${subj}.OdorValence.medialAmyUP.t196_HUI.txt
3dROIstats -mask ${subj}.OdorValence.medialAmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  > ../../ana4/tent_odorUP_medial/${subj}.OdorValence.medialAmyUP.t196_HUV.txt

# OdorValence pleasant-unpleasant lateral amygdala
3dROIstats -mask ${subj}.OdorValence.AmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" > ../../ana4/tent_odorUP_all/${subj}.OdorValence.AmyUP.t196_FPI.txt
3dROIstats -mask ${subj}.OdorValence.AmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  > ../../ana4/tent_odorUP_all/${subj}.OdorValence.AmyUP.t196_FPV.txt
3dROIstats -mask ${subj}.OdorValence.AmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  > ../../ana4/tent_odorUP_all/${subj}.OdorValence.AmyUP.t196_FUI.txt
3dROIstats -mask ${subj}.OdorValence.AmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  > ../../ana4/tent_odorUP_all/${subj}.OdorValence.AmyUP.t196_FUV.txt
3dROIstats -mask ${subj}.OdorValence.AmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  > ../../ana4/tent_odorUP_all/${subj}.OdorValence.AmyUP.t196_HPI.txt
3dROIstats -mask ${subj}.OdorValence.AmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  > ../../ana4/tent_odorUP_all/${subj}.OdorValence.AmyUP.t196_HPV.txt
3dROIstats -mask ${subj}.OdorValence.AmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  > ../../ana4/tent_odorUP_all/${subj}.OdorValence.AmyUP.t196_HUI.txt
3dROIstats -mask ${subj}.OdorValence.AmyUP.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  > ../../ana4/tent_odorUP_all/${subj}.OdorValence.AmyUP.t196_HUV.txt

########################################################################################################################################################################################################

# OdorValence pleasant-unpleasant lateral amygdala
3dROIstats -mask ${subj}.FaceValence.lateralAmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" > ../../ana4/tent_faceFH_lateral/${subj}.FaceValence.lateralAmyFH.t196_FPI.txt
3dROIstats -mask ${subj}.FaceValence.lateralAmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  > ../../ana4/tent_faceFH_lateral/${subj}.FaceValence.lateralAmyFH.t196_FPV.txt
3dROIstats -mask ${subj}.FaceValence.lateralAmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  > ../../ana4/tent_faceFH_lateral/${subj}.FaceValence.lateralAmyFH.t196_FUI.txt
3dROIstats -mask ${subj}.FaceValence.lateralAmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  > ../../ana4/tent_faceFH_lateral/${subj}.FaceValence.lateralAmyFH.t196_FUV.txt
3dROIstats -mask ${subj}.FaceValence.lateralAmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  > ../../ana4/tent_faceFH_lateral/${subj}.FaceValence.lateralAmyFH.t196_HPI.txt
3dROIstats -mask ${subj}.FaceValence.lateralAmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  > ../../ana4/tent_faceFH_lateral/${subj}.FaceValence.lateralAmyFH.t196_HPV.txt
3dROIstats -mask ${subj}.FaceValence.lateralAmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  > ../../ana4/tent_faceFH_lateral/${subj}.FaceValence.lateralAmyFH.t196_HUI.txt
3dROIstats -mask ${subj}.FaceValence.lateralAmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  > ../../ana4/tent_faceFH_lateral/${subj}.FaceValence.lateralAmyFH.t196_HUV.txt

# OdorValence pleasant-unpleasant lateral amygdala
3dROIstats -mask ${subj}.FaceValence.medialAmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" > ../../ana4/tent_faceFH_medial/${subj}.FaceValence.medialAmyFH.t196_FPI.txt
3dROIstats -mask ${subj}.FaceValence.medialAmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  > ../../ana4/tent_faceFH_medial/${subj}.FaceValence.medialAmyFH.t196_FPV.txt
3dROIstats -mask ${subj}.FaceValence.medialAmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  > ../../ana4/tent_faceFH_medial/${subj}.FaceValence.medialAmyFH.t196_FUI.txt
3dROIstats -mask ${subj}.FaceValence.medialAmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  > ../../ana4/tent_faceFH_medial/${subj}.FaceValence.medialAmyFH.t196_FUV.txt
3dROIstats -mask ${subj}.FaceValence.medialAmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  > ../../ana4/tent_faceFH_medial/${subj}.FaceValence.medialAmyFH.t196_HPI.txt
3dROIstats -mask ${subj}.FaceValence.medialAmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  > ../../ana4/tent_faceFH_medial/${subj}.FaceValence.medialAmyFH.t196_HPV.txt
3dROIstats -mask ${subj}.FaceValence.medialAmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  > ../../ana4/tent_faceFH_medial/${subj}.FaceValence.medialAmyFH.t196_HUI.txt
3dROIstats -mask ${subj}.FaceValence.medialAmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  > ../../ana4/tent_faceFH_medial/${subj}.FaceValence.medialAmyFH.t196_HUV.txt

# OdorValence pleasant-unpleasant lateral amygdala
3dROIstats -mask ${subj}.FaceValence.AmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" > ../../ana4/tent_faceFH_all/${subj}.FaceValence.AmyFH.t196_FPI.txt
3dROIstats -mask ${subj}.FaceValence.AmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  > ../../ana4/tent_faceFH_all/${subj}.FaceValence.AmyFH.t196_FPV.txt
3dROIstats -mask ${subj}.FaceValence.AmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  > ../../ana4/tent_faceFH_all/${subj}.FaceValence.AmyFH.t196_FUI.txt
3dROIstats -mask ${subj}.FaceValence.AmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  > ../../ana4/tent_faceFH_all/${subj}.FaceValence.AmyFH.t196_FUV.txt
3dROIstats -mask ${subj}.FaceValence.AmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  > ../../ana4/tent_faceFH_all/${subj}.FaceValence.AmyFH.t196_HPI.txt
3dROIstats -mask ${subj}.FaceValence.AmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  > ../../ana4/tent_faceFH_all/${subj}.FaceValence.AmyFH.t196_HPV.txt
3dROIstats -mask ${subj}.FaceValence.AmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  > ../../ana4/tent_faceFH_all/${subj}.FaceValence.AmyFH.t196_HUI.txt
3dROIstats -mask ${subj}.FaceValence.AmyFH.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  > ../../ana4/tent_faceFH_all/${subj}.FaceValence.AmyFH.t196_HUV.txt

end

# else
#  echo "Usage: $0 <Subjname>"
#
# endif
