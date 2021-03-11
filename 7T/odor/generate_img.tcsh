#! /bin/csh

# set sub=S01_yyt
# use input as sub
if ( $# > 0 ) then
set sub = $1

# set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/*_S40_*
set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}
cd "${datafolder}"
cd *_S40_*${sub}
# to3d 结果是有问题的，Dimon比较好
# ==========================transform========================== #
@ n=1
foreach run ($2)        
        Dimon -infile_pattern "*FMRI.00${run}.*" \
        -gert_create_dataset \
        -gert_to3d_prefix ${sub}.run${n} \
        -gert_outdir ../ \
        -no_wait
        @ n=$n + 1
end

# pa
# @ n=1
foreach run ($3)        
        Dimon -infile_pattern "*FMRI.00${run}.*" \
        -gert_create_dataset \
        # -gert_to3d_prefix ${sub}.run${n}.pa \
        -gert_to3d_prefix ${sub}.pa \
        -gert_outdir ../ \
        -no_wait
        # @ n++
end

# ==========================nii format T1 weighted========================== #
# INV1
Dimon -infile_pattern "*FMRI.00$4.*" \
-gert_create_dataset \
-gert_to3d_prefix ${sub}.inv1.nii \
-gert_outdir ../ \
-no_wait

# INV2
Dimon -infile_pattern "*FMRI.00$5.*" \
-gert_create_dataset \
-gert_to3d_prefix ${sub}.inv2.nii \
-gert_outdir ../ \
-no_wait

# UNI
Dimon -infile_pattern "*FMRI.00$6.*" \
-gert_create_dataset \
-gert_to3d_prefix ${sub}.uni.nii \
-gert_outdir ../ \
-no_wait

cd ..
# # denoise
LN_MP2RAGE_DNOISE -INV1 ${sub}.inv1.nii -INV2 ${sub}.inv2.nii -UNI ${sub}.uni.nii -beta 1.5 -output ${sub}.uniden15.nii

else
 echo "Usage: $0 <Subjname> <runs> <pa> <inv1> <inv2> <uni>"

endif
