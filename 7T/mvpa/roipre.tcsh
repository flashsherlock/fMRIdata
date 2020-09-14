#! /bin/csh
# 将roi的mask变换
foreach num (1)

    set run=run${num}
    set subj=gufei.${run}.pa
    set datafolder=/Volumes/WD_D/share/7T/${subj}.results
    cd "${datafolder}"
    rm testamy*
    # 对于整数的数据-final使用NN来避免插值
    # -master 用来改变输出的grid
    3dAllineate -input ../roitest.nii.gz                       \
                -master anat_final.gufei.run1.pa+orig       \
                -final NN                                \
                -prefix testamy                             \
                -1Dmatrix_apply gufei.uniden15_brain_al_keep_mat.aff12.1D

end