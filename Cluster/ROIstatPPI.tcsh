#! /bin/csh
set mask=AmyPU
set datafolder=/Volumes/WD_D/allsub
# set datafolder=/Volumes/WD_D/Exp_odor_face/fMRI\ data_supplemental/
# 双引号避免空格路径问题
cd "${datafolder}"

# if ( $# > 0 ) then
# foreach subj (S03)
#S22 S23 S24 S25 S26 S27 S28
# set subj = $1

foreach subj (`ls -d S*`)
    cd ${subj}
    #mkdir analysis
    cd ppi
    # 需要 FFA aSTS 的mask
    mv ../analysis/*aSTS* ./
    mv ../analysis/*FFA* ./

    3dROIstats -mask {$subj}.Visible.aSTS.t196+tlrc \
    -nzmean -nzvoxels ${subj}.${mask}_PPI+tlrc'[11,14,12,15]' \
    > ../../ana4/PPI/{$subj}.${mask}.aSTS.txt

    3dROIstats -mask {$subj}.Visible.FFA.t196+tlrc \
    -nzmean -nzvoxels ${subj}.${mask}_PPI+tlrc'[11,14,12,15]' \
    > ../../ana4/PPI/{$subj}.${mask}.FFA.txt

    # 放回两个mask
    mv *aSTS* ../analysis/
    mv *FFA* ../analysis/

    cd ..
    cd ..

end

cd ana4/PPI/
cat S*.${mask}.aSTS.txt > 20subj_${mask}.aSTS.txt
cat S*.${mask}.FFA.txt > 20subj_${mask}.FFA.txt
