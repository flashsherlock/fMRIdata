#! /bin/csh
# foreach ub (`count -dig 2 17 19`)
# from the first to the second input
foreach ub (`count -dig 2 $1 $2`)

set sub = S${ub}
set datafolder=/Volumes/WD_F/gufei/blind/${sub}
set backfolder="/Volumes/Promise Disk/gf/data/blind"
# if datafolder exist
if ( -d "${datafolder}" ) then
    cd "${datafolder}"
    # make dir to save data if not exist
    if ( ! -d "${backfolder}/${sub}" ) then
        mkdir "${backfolder}/${sub}"
    endif
    # copy files
    # if nii file not exist
    if ( ! -f "${backfolder}/${sub}/${sub}.str.nii" ) then
        echo ${sub}: backup nii files
        cp *.nii "${backfolder}/${sub}"
    endif
    # if mask folder not exist
    # if ( ! -f "${backfolder}/${sub}/mask/voxels.txt" ) then
    if ( ! -f "${backfolder}/${sub}/mask/Piriform.seg+orig.HEAD" ) then
        echo ${sub}: backup masks
        cp -r mask "${backfolder}/${sub}"
    endif
    # if folder not exist
    if ( ! -d "${backfolder}/${sub}/${sub}_anat_warped" ) then
        echo ${sub}: backup freesurfer files
        cp -r ${sub}_anat_warped "${backfolder}/${sub}"
    endif

else
    echo "${datafolder} not exsist"
endif

end
