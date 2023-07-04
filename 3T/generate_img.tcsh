#! /bin/csh

# set sub=S01_yyt
# use input as sub
if ( $# > 0 ) then
# set subraw as last two characters of input
set sub = $1
set subraw = S0`echo $sub | cut -c 2-3`

set datafolder=/Volumes/WD_D/allsub/rawIMG
set outfolder=/Volumes/WD_F/gufei/3T_cw
mkdir -p ${outfolder}/${sub}
cd "${datafolder}"
cd *_${subraw}

# ==========================transform========================== #
@ n=1
foreach run ($2)        
        Dimon -infile_pattern "*FMRI.00${run}.*" \
        -gert_create_dataset \
        -gert_to3d_prefix ${sub}.run${n}.nii \
        -gert_outdir ${outfolder}/${sub} \
        -no_wait
        @ n=$n + 1
end

# ==========================nii format T1 weighted========================== #
# STR
Dimon -infile_pattern "*FMRI.00$3.*" \
-gert_create_dataset \
-gert_to3d_prefix ${sub}.str.nii \
-gert_outdir ${outfolder}/${sub} \
-no_wait

# whole brain epi
Dimon -infile_pattern "*FMRI.00$4.*" \
        -gert_create_dataset \
        -gert_to3d_prefix ${sub}.wb.nii \
        -gert_outdir ${outfolder}/${sub} \
        -no_wait

cd ${outfolder}/${sub}

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
