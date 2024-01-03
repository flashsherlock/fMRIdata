#! /bin/bash

# datafolder=/Volumes/WD_D/allsub/
datafolder=/Volumes/WD_F/gufei/3T_cw/
cd "${datafolder}" || exit

# for roi in Amy OFC_AAL
# do
#       # calculate percentage of intersection 
#       if [ ${roi} = "Amy" ]; then
#             mask=group/mask/Amy8_align.freesurfer+tlrc
#       else
#             mask=group/mask/${roi}+tlrc
#       fi
#       3dROIstats -nzvoxels -mask ${mask} ${mask}
#       3dROIstats -nzvoxels -mask ${mask} group/plotmask/sm_all_masks.nii
#       3dROIstats -nzvoxels -mask group/plotmask/sm_${roi}_inter3.nii group/plotmask/sm_${roi}_inter3.nii
#       for brick in  face_vis face_inv odor_all
#       do
#           3dROIstats -nzvoxels -mask group/mvpa/sm_${roi}_${brick}_0.001+tlrc group/mvpa/sm_${roi}_${brick}_0.001+tlrc
#       done
# done

# count voxels for each subject
# for ub in $(count -dig 2 03 29)
# do
#       sub=S${ub}
#       fd=${sub}/mask/
#       for roi in Amy OFC_AAL
#       do
#             indmask=p2acc_${roi}_inter3+orig
#             if [ ${roi} = "Amy" ]; then
#                   mask=${fd}Amy8_align.freesurfer+orig
#             else
#                   mask=${fd}${roi}+orig
#             fi
#             # get the last number of the output and print to a file
#             3dROIstats -nzvoxels -mask ${fd}${indmask} ${fd}${indmask}  | tail -n 1 | awk '{print $NF}'>> group/mvpa/voxels.txt
#             indmask=${roi}_odor_all_p2_interacc+orig
#             3dROIstats -nzvoxels -mask ${fd}${indmask} ${fd}${indmask}  | tail -n 1 | awk '{print $NF}'>> group/mvpa/voxels.txt
#       done
# done  


# calculate expression 1580+762
# echo "1580+762" | bc
# echo "783+222+138+52" | bc
# echo "1332+541+46" | bc
# echo "200/(2342+1195+1919)" | bc -l
# echo "64319" | bc
# echo "34063+249" | bc
# echo "12970+934+523+222" | bc
# echo "5181/(64319+34312+14649)" | bc -l

# intersection mask
sm=sm_
for roi in Amy OFC_AAL
do
      indmask=p2acc_${roi}_inter3
      # rm group/mvpa/percent_${roi}+tlrc*
      # normalize each sub mask to MNI space
      for ub in $(count -dig 2 03 29)
      do
            sub=S${ub}
            fd=${sub}/${sub}.de.results/
            # rm ${sub}/mask/${indmask}+tlrc*
            # 3dNwarpApply -nwarp "${fd}anatQQ.${sub}_WARP.nii ${fd}anatQQ.${sub}.aff12.1D INV(${fd}anatSS.${sub}_al_keep_mat.aff12.1D)"   \
            #             -source ${sub}/mask/${indmask}+orig   \
            #             -interp NN                            \
            #             -master ${fd}anatQQ.${sub}+tlrc    \
            #             -prefix ${sub}/mask/${indmask}
            # smooth
            3dmerge -1blur_fwhm 3.6 -doall -prefix ${sub}/mask/${sm}${indmask} ${sub}/mask/${indmask}+tlrc
      done
      indmask=${sm}${indmask}
      # calculate percentage for 27 subjects
      3dMean -prefix group/mvpa/${sm}percent_${roi}  \
            "S03/mask/${indmask}+tlrc" \
            "S04/mask/${indmask}+tlrc" \
            "S05/mask/${indmask}+tlrc" \
            "S06/mask/${indmask}+tlrc" \
            "S07/mask/${indmask}+tlrc" \
            "S08/mask/${indmask}+tlrc" \
            "S09/mask/${indmask}+tlrc" \
            "S10/mask/${indmask}+tlrc" \
            "S11/mask/${indmask}+tlrc" \
            "S12/mask/${indmask}+tlrc" \
            "S13/mask/${indmask}+tlrc" \
            "S14/mask/${indmask}+tlrc" \
            "S15/mask/${indmask}+tlrc" \
            "S16/mask/${indmask}+tlrc" \
            "S17/mask/${indmask}+tlrc" \
            "S18/mask/${indmask}+tlrc" \
            "S19/mask/${indmask}+tlrc" \
            "S20/mask/${indmask}+tlrc" \
            "S21/mask/${indmask}+tlrc" \
            "S22/mask/${indmask}+tlrc" \
            "S23/mask/${indmask}+tlrc" \
            "S24/mask/${indmask}+tlrc" \
            "S25/mask/${indmask}+tlrc" \
            "S26/mask/${indmask}+tlrc" \
            "S27/mask/${indmask}+tlrc" \
            "S28/mask/${indmask}+tlrc" \
            "S29/mask/${indmask}+tlrc"
done