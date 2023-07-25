#! /bin/bash

datafolder=/Volumes/WD_F/gufei/blind
cd "${datafolder}" || exit

# for each sub
for ub in $(count -dig 2 ${1} ${2}); do
      sub=S${ub}
      # if sub folder not exsist then continue
      if [[ ! -e "${sub}" ]]; then
            echo "${sub} not exsist"
            continue
            # else cd to sub folder
      else
            echo ${sub}
            cd "${sub}" || exit
      # check gird
      3dinfo -prefix -header_line -same_all_grid  ${sub}.run*
      # find volreg number
      pbvol=$(ls ${sub}.pade.results/pb0?.*.r01.volreg+orig.HEAD | cut -d / -f2 | cut -c1-4)
      # echo ${pbvol}
      3dinfo -prefix -header_line -same_all_grid  ${sub}.pade.results/${pbvol}.${sub}.pade.r*.volreg+orig.HEAD
      cd ..
      fi
done

# cd S14/mask
# # resample visual_area
# 3dresample -master all.seg+orig -prefix EarlyV_resample -input EarlyV+orig
# # refit orient
# 3dcopy EarlyV+orig EarlyV_refit+orig
# 3drefit -duporigin all.seg+orig EarlyV_refit+orig
# transform piriform mask
# calculate matrix
# 3dAllineate \
# -source ${datafolder}/Subs_remove/S14/S14.pade.results/anat_final.S14.pade+orig \
# -base ${datafolder}/S14/S14.pade.results/anat_final.S14.pade+orig \
# -1Dmatrix_save ${datafolder}/Subs_remove/S14/S14.pade.results/new.1D
# apply matrix
# 3dAllineate -input ${datafolder}/Subs_remove/S14/S14.pade.results/COPY_anat_final.S14.pade+orig \
#                 -master ${datafolder}/S14/S14.pade.results/anat_final.S14.pade+orig      \
#                 -final NN                                \
#                 -prefix ${datafolder}/S14/S14.pade.results/COPY_anat_final.S14.pade+orig \
#                 -1Dmatrix_apply ${datafolder}/Subs_remove/S14/S14.pade.results/new.1D

# refit orient
# sub=S35
# cd "${sub}" || exit
# for r in {2..6}; do
#       3drefit -duporigin ${sub}.run1.nii ${sub}.run${r}.nii
# done
# 3drefit -duporigin ${sub}.run1.nii ${sub}.pa.nii