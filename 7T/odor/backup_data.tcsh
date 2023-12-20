#! /bin/csh

# 28 subjects
# foreach ub (`count -dig 2 4 11` 13 14 `count -dig 2 16 29` 31 32 33 34)
foreach ub (`count -dig 2 $1 $2`)

set sub = S${ub}
set datafolder=/Volumes/WD_F/gufei/7T_odor/${sub}
set backfolder="/Volumes/Promise Disk/gf/data/7T_odor"
echo $sub

cd "${backfolder}"
# if datafolder exist
if ( -d "${datafolder}" ) then
    # make dir to save data if not exist
    if ( ! -d "./${sub}" ) then
        mkdir "./${sub}"
    endif     

    # images
    if ( ! -f "./${sub}/${sub}.uniden15.nii" ) then
        echo ${sub}: backup nii files
        cp ${datafolder}/${sub}.uniden15.nii "./${sub}/${sub}_str.nii"
        # for run1 to run 6
        foreach run (`count -dig 1 1 6`)
            3dcopy ${datafolder}/${sub}.run${run}+orig "./${sub}/${sub}_run${run}.nii"
        end
    endif

    # all behavior data
    # if ( ! -d "./behavior" ) then
    #     mkdir "./behavior"
    # endif
    # echo ${sub}: backup mat files
    # # make folder
    # cp ${datafolder}/behavior/*.mat "./behavior"

    # # mask files
    # if ( ! -f "./${sub}/mask/Amy_seg.nii" ) then
    #     echo ${sub}: backup masks        
    #     # make folder if not exist
    #     if ( ! -d "./${sub}/mask" ) then
    #         mkdir "./${sub}/mask"
    #     endif
    #     # segmentation masks
    #     3dcopy ${datafolder}/${sub}.pabiode.results/Amy.seg.freesurfer+orig "./${sub}/mask/Amy_seg.nii"
    #     3dcopy ${datafolder}/${sub}.pabiode.results/COPY_anat_final.${sub}.pabiode+orig "./${sub}/mask/Pir_seg.nii"
    # endif
    
    # # for each folder
    # foreach folder (behavior phy respiration ${sub}_anat_warped)
    #     # if folder not exist
    #     if ( ! -d "./${sub}/${folder}" ) then
    #         echo ${sub}: backup ${folder}
    #         cp -r ${datafolder}/${folder} "./${sub}"
    #     endif
    # end
    
else
    echo "${datafolder} not exsist"
endif

end