#! /bin/bash

for sub in S{06..10}; do
    datafolder=/Volumes/WD_F/gufei/3T_cw/${sub}
    cd "${datafolder}" || exit
    # echo "${datafolder}"
    tcsh -xef proc."${sub}".de 2>&1 | tee output.proc."${sub}".de
done

# for sub in S{07..25}; do
#     datafolder=/Volumes/WD_F/gufei/3T_cw/${sub}/${sub}.de.results
#     # if datafolder not exist wait 1minute then check again
#     while [[ ! -d "${datafolder}" ]]; do
#         echo folder not exsist
#         sleep 60
#     done
#     # if file scale not exsist wait 1minute then check again
#     while [[ ! -e "${datafolder}"/pb05.${sub}.de.r05.scale+orig.HEAD ]]; do
#         echo file not exsist
#         sleep 60
#     done
#     tcsh /Volumes/mac/Documents/GitHub/fMRIdata/3T/deconvolve_censor_TENT.tcsh "${sub}"
# done