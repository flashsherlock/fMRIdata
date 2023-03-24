#! /bin/csh

# set sub=S01_yyt
# use input as sub
if ( $# > 0 ) then
set sub = $1

set datafolder=/Volumes/WD_F/gufei/blind/${sub}
cd "${datafolder}"
cd *_${sub}
cd HN*

# ==========================transform========================== #
@ n=1
foreach run ($2)        
        Dimon -infile_pattern "*TASK_00${run}/*" \
        -gert_create_dataset \
        -gert_to3d_prefix ${sub}.run${n}.nii \
        -gert_outdir ../../ \
        -no_wait
        @ n=$n + 1
end

# pa
foreach run ($3)        
        Dimon -infile_pattern "*PA_00${run}/*" \
        -gert_create_dataset \
        -gert_to3d_prefix ${sub}.pa.nii \
        -gert_outdir ../../ \
        -no_wait
end

# ==========================nii format T1 weighted========================== #
# STR
Dimon -infile_pattern "T1_MPRAGE*$4/*" \
-gert_create_dataset \
-gert_to3d_prefix ${sub}.str.nii \
-gert_outdir ../../ \
-no_wait

cd ../../

# processing anatomical image
# may encounter signal 11 error (RAM problems)
# -giant_move can be added
@SSwarper -input   ${sub}.str.nii             \
                   -subid ${sub}                    \
                   -odir  ${sub}_anat_warped        \
                   -base  MNI152_2009_template_SSW.nii.gz

else
 echo "Usage: $0 <Subjname> <runs> <pa> <str>"

endif
