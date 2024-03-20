#! /bin/bash
# datafolder=/Volumes/WD_E/gufei/7T_odor
datafolder=/Volumes/WD_F/gufei/7T_odor
cd "${datafolder}" || exit
# two kinds of values
for filedec in orig tlrc
do
      for ub in {04..11} {13..14} {16..29} {31..34}
      do
            sub=S${ub}
            analysis=pabiode
            subj=${sub}.${analysis}
            # file names
            betafile=${sub}/${subj}.results/stats.${subj}.odorVI+${filedec}
            mvpafile=${sub}/${subj}.results/mvpa/searchlight_ARodor_l1_labelbase_-6-36/BoxROI
            outfile=stats/${sub}/allvalue_${filedec}.txt
            mvpaname=res_accuracy_minus_chance+${filedec}
            # output file
            if [ "$filedec" = "orig" ]; then
                  mask=${sub}/mask/allROI+orig
                  seg=${sub}/mask/all.seg+orig
            else
                  mask=group/mask/allROI+tlrc
                  seg=group/mask/all.seg+tlrc
            fi      
            # dumpvalues car-lim cit-lim lim-tra ind-lim val int
            3dmaskdump                                      \
            -noijk -xyz                                     \
            -mask ${mask}                   \
            ${seg}                         \
            ${betafile}"[31]"           \
            ${betafile}"[34]"           \
            ${betafile}"[22]"           \
            ${betafile}"[40]"           \
            ${betafile}"[16]"           \
            ${betafile}"[19]"           \
            ${betafile}"[32]"           \
            ${betafile}"[35]"           \
            ${betafile}"[23]"           \
            ${betafile}"[41]"           \
            ${betafile}"[17]"           \
            ${betafile}"[20]"           \
            ${mvpafile}/2odors_lim_tra/${mvpaname}          \
            ${mvpafile}/2odors_lim_car/${mvpaname}           \
            ${mvpafile}/2odors_lim_cit/${mvpaname}           \
            ${mvpafile}/2odors_lim_ind/${mvpaname}           \
            ${mvpafile}/2odors_tra_car/${mvpaname}           \
            ${mvpafile}/2odors_tra_cit/${mvpaname}           \
            ${mvpafile}/2odors_tra_ind/${mvpaname}           \
            ${mvpafile}/2odors_car_cit/${mvpaname}           \
            ${mvpafile}/2odors_car_ind/${mvpaname}           \
            ${mvpafile}/2odors_cit_ind/${mvpaname}           \
            > ${outfile}
      done
done