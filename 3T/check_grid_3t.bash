#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
cd "${datafolder}" || exit

# for each sub
for sub in S{03..29}; do
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
      cd ..
      fi
done
