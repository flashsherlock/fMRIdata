#! /bin/csh
set datafolder=/Volumes/WD_D/share/T1Raw
# set datafolder=/Volumes/WD_D/share/20200708_S0_WZHOU
cd "${datafolder}"

foreach subj (`echo $*`)
# foreach subj (`ls -d S*`)

cd ${subj}

3dSkullStrip -input *.nii


cd ..
end
