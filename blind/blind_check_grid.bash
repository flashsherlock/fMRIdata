#! /bin/bash

datafolder=/Volumes/WD_F/gufei/blind
cd "${datafolder}" || exit

# for each sub
for sub in S{01..16}; do
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