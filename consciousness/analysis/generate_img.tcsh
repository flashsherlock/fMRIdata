#! /bin/csh

set datafolder=/Volumes/WD_D/gufei/consciousness/electrode
cd "${datafolder}"
cd use
# to3d 结果是有问题的，Dimon比较好
# ==========================transform========================== #
foreach sub (s01)

cd ${sub}

# CT
cd CT
Dimon -infile_pattern 'I*' \
-gert_create_dataset \
-gert_to3d_prefix ${sub}_CT.nii \
-gert_outdir ../ \
-no_wait
cd ..

# MRI
cd MRI
Dimon -infile_pattern 'I*' \
-gert_create_dataset \
-gert_to3d_prefix ${sub}_MRI.nii \
-gert_outdir ../ \
-no_wait
cd ..

end