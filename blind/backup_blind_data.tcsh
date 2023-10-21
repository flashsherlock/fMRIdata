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
    # make dir to save data
    mkdir "${backfolder}/${sub}"
    # copy files
    cp *.nii "${backfolder}/${sub}"
    cp -r mask "${backfolder}/${sub}"
    cp -r ${sub}_anat_warped "${backfolder}/${sub}"

else
    echo "${datafolder} not exsist"
endif

end
