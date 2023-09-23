#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
cd "${datafolder}" || exit

# for each mask
for out in Amy #Pir fusiformCA FFA_CA insulaCA OFC6mm aSTS_OR FFV_CA
do            
      # for each pvalue
      for p in 0.001 #0.05  
      do    
            # echo to stats
            printf "sub any_inter any_face any_odor anyvis_inter anyvis_face anyvis_odor inv_inter inv_face inv_odor\n" \
                  > count_${out}_${p}.txt  
            # for each sub
            for ub in $(count -dig 2 3 29)
            do
                  sub=S${ub}
                  printf "${sub} " >> count_${out}_${p}.txt            
                  for sig in any anyvis anyinv
                  do
                        for con in inter face odor
                        do
                        name=${sub}/threshold/${out}_${sig}.NN2_bisided.1D
                        # get the last line of the file
                        nvox=$(tail -n 1 ${name})
                        # get the last number of the line
                        # https://unix.stackexchange.com/questions/147560/explain-this-bash-script-echo-1
                        nvox=${nvox##* }
                        # if file exist
                        if [ -f ${sub}/threshold/Cluster${nvox}_${p}_${con}_${sig}_${out}+orig.HEAD ]
                        then
                              # get the last number of the output
                              file=${sub}/threshold/Cluster${nvox}_${p}_${con}_${sig}_${out}+orig
                              nz=$(3dROIstats -nzvoxels -mask  "3dcalc( -a ${file} -expr bool(a) )" ${file} | tail -n 1)
                              printf "%d " ${nz##*0} >> count_${out}_${p}.txt
                              # 3dROIstats -nzvoxels -mask  ${sub}/threshold/Cluster${nvox}_${p}_${con}_${sig}_${out}+orig  ${sub}/threshold/Cluster${nvox}_${p}_${con}_${sig}_${out}+orig
                        # esle print zero
                        else
                              printf "0 " >> count_${out}_${p}.txt
                        fi
                        done
                  done
                  printf "\n" >> count_${out}_${p}.txt
            done
      done
done