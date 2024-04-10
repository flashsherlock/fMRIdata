#! /bin/csh
set datafolder=/Volumes/WD_D/allsub
cd ${datafolder}
# if ( $# > 0 ) then
# foreach subj (S03)
#S22 S23 S24 S25 S26 S27 S28
# set subj = $1

# mkdir ana4/tent_FFA
# mkdir ana4/tent_STS
foreach subj (`ls -d S*`)
cd ${subj}
#mkdir analysis
cd analysis

# Visibility Visible-Invisible aSTS
3dROIstats -mask ${subj}.Visible.aSTS.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" > ../../ana4/tent_STS/${subj}.Visible.aSTS.t196_FPI.txt
3dROIstats -mask ${subj}.Visible.aSTS.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  > ../../ana4/tent_STS/${subj}.Visible.aSTS.t196_FPV.txt
3dROIstats -mask ${subj}.Visible.aSTS.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  > ../../ana4/tent_STS/${subj}.Visible.aSTS.t196_FUI.txt
3dROIstats -mask ${subj}.Visible.aSTS.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  > ../../ana4/tent_STS/${subj}.Visible.aSTS.t196_FUV.txt
3dROIstats -mask ${subj}.Visible.aSTS.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  > ../../ana4/tent_STS/${subj}.Visible.aSTS.t196_HPI.txt
3dROIstats -mask ${subj}.Visible.aSTS.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  > ../../ana4/tent_STS/${subj}.Visible.aSTS.t196_HPV.txt
3dROIstats -mask ${subj}.Visible.aSTS.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  > ../../ana4/tent_STS/${subj}.Visible.aSTS.t196_HUI.txt
3dROIstats -mask ${subj}.Visible.aSTS.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  > ../../ana4/tent_STS/${subj}.Visible.aSTS.t196_HUV.txt

# Visibility Visible-Invisible FFA
3dROIstats -mask ${subj}.Visible.FFA.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 1 2 20`21]" > ../../ana4/tent_FFA/${subj}.Visible.FFA.t196_FPI.txt
3dROIstats -mask ${subj}.Visible.FFA.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 24 2 43`44]"  > ../../ana4/tent_FFA/${subj}.Visible.FFA.t196_FPV.txt
3dROIstats -mask ${subj}.Visible.FFA.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 47 2 66`67]"  > ../../ana4/tent_FFA/${subj}.Visible.FFA.t196_FUI.txt
3dROIstats -mask ${subj}.Visible.FFA.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 70 2 89`90]"  > ../../ana4/tent_FFA/${subj}.Visible.FFA.t196_FUV.txt
3dROIstats -mask ${subj}.Visible.FFA.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 93 2 112`113]"  > ../../ana4/tent_FFA/${subj}.Visible.FFA.t196_HPI.txt
3dROIstats -mask ${subj}.Visible.FFA.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 116 2 135`136]"  > ../../ana4/tent_FFA/${subj}.Visible.FFA.t196_HPV.txt
3dROIstats -mask ${subj}.Visible.FFA.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 139 2 158`159]"  > ../../ana4/tent_FFA/${subj}.Visible.FFA.t196_HUI.txt
3dROIstats -mask ${subj}.Visible.FFA.t196+tlrc -nzmean ${subj}.analysis.tent+tlrc"[`seq -s , 162 2 181`182]"  > ../../ana4/tent_FFA/${subj}.Visible.FFA.t196_HUV.txt

cd ..
cd ..

end

cd ana4/tent_FFA
cat *.Visible.FFA.t196_FPI.txt > 20subj_Visible.FFA.t196_FPI.txt
cat *.Visible.FFA.t196_FPV.txt > 20subj_Visible.FFA.t196_FPV.txt
cat *.Visible.FFA.t196_FUI.txt > 20subj_Visible.FFA.t196_FUI.txt
cat *.Visible.FFA.t196_FUV.txt > 20subj_Visible.FFA.t196_FUV.txt
cat *.Visible.FFA.t196_HPI.txt > 20subj_Visible.FFA.t196_HPI.txt
cat *.Visible.FFA.t196_HPV.txt > 20subj_Visible.FFA.t196_HPV.txt
cat *.Visible.FFA.t196_HUI.txt > 20subj_Visible.FFA.t196_HUI.txt
cat *.Visible.FFA.t196_HUV.txt > 20subj_Visible.FFA.t196_HUV.txt
cd ..
cd ..
cd ana4/tent_STS
cat *.Visible.aSTS.t196_FPI.txt > 20subj_Visible.aSTS.t196_FPI.txt
cat *.Visible.aSTS.t196_FPV.txt > 20subj_Visible.aSTS.t196_FPV.txt
cat *.Visible.aSTS.t196_FUI.txt > 20subj_Visible.aSTS.t196_FUI.txt
cat *.Visible.aSTS.t196_FUV.txt > 20subj_Visible.aSTS.t196_FUV.txt
cat *.Visible.aSTS.t196_HPI.txt > 20subj_Visible.aSTS.t196_HPI.txt
cat *.Visible.aSTS.t196_HPV.txt > 20subj_Visible.aSTS.t196_HPV.txt
cat *.Visible.aSTS.t196_HUI.txt > 20subj_Visible.aSTS.t196_HUI.txt
cat *.Visible.aSTS.t196_HUV.txt > 20subj_Visible.aSTS.t196_HUV.txt

# else
#  echo "Usage: $0 <Subjname>"
#
# endif
