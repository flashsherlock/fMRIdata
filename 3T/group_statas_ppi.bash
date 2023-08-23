#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
# datafolder=/Volumes/WD_D/allsub/
cd "${datafolder}" || exit
suffix=${1}
outsuffix=${2}
# define mask according to the second input
if [[ "${2}" == Amy* ]]; then
    mask="${2}.freesurfer"
# if start with Pir
elif [[ "${2}" == Pir* ]]; then
    mask="${2}.draw"
# if start with Pir
elif [[ "${2}" == FFA* ]]; then
    mask="${2}"
# otherwise exit
else
    # echo "Please input the correct mask name!"
    # exit
    echo "Use the default mask: ${2}*"
    mask="${2}*"
fi

# 8 conditions for each subject
# if file exsit then remove it
if [ -e "stats/indi8conppi_${outsuffix}.txt" ]; then
    rm stats/indi8conppi_${outsuffix}.txt
fi
for sub in S{03..29}
do
    analysis=de
    subj=${sub}.${analysis}
        
    # if is the first loop then add header
    if [ "${sub}" == "S03" ]; then
        3dROIstats -nzmean -mask ${sub}/mask/${mask}+orig.HEAD \
            "${sub}/${subj}.results/ppi.${sub}.${suffix}+orig[25,28,31,34,37,40,43,46]" \
            >> stats/indi8conppi_${outsuffix}.txt
    else
        # remove the first row
        3dROIstats -nzmean -mask ${sub}/mask/${mask}+orig.HEAD \
            "${sub}/${subj}.results/ppi.${sub}.${suffix}+orig[25,28,31,34,37,40,43,46]" \
            | sed '1d' >> stats/indi8conppi_${outsuffix}.txt
    fi
done
