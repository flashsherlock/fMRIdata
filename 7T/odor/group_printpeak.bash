#! /bin/bash

# datafolder=/Volumes/WD_E/gufei/7T_odor
datafolder=/Volumes/WD_F/gufei/7T_odor
cd "${datafolder}" || exit
stats=stats
threshold=0.05

# make dir image if not exist
if [ ! -d ./group/peak ]; then
    mkdir ./group/peak
fi

# copy masks: Amy8 and Pir_new
# 3dcopy ./group/mask/Amy8_align.freesurfer+tlrc ./group/peak/Amy.nii
# 3dcopy ./group/mask/Pir_new.draw+tlrc ./group/peak/Pir_new.nii

# remove existing file
rm ./group/peak/*.csv

for sub in {04..11} {13..14} {16..29} {31..34}
do
    subj=S${sub}.pabiode
    # Amy cit-lim
    3dClusterize -nosum -orient LPI \
    -mask ./group/mask/Amy8_align.freesurfer+tlrc \
    -inset ./S${sub}/${subj}.results/${stats}.${subj}.odorVI+tlrc \
    -idat 34 -ithr 35 -NN 2 -clust_nvox 40 -bisided p=${threshold} \
    | awk 'BEGIN {
            plus=1
            minus=1
            OFS = ","
        }             
            !/^#/ {
            
            if ($(NF-2)>0 && plus>0){
                plus-=1
                print $(NF-2),$(NF-1),$NF,"'$sub'"*1,$1,$2,$3,$4
            }
            else if ($(NF-2)<0 && minus>0){
                minus-=1
                print $(NF-2),$(NF-1),$NF,"'$sub'"*1,$1,$2,$3,$4
            }
        }'
    # Amy car-lim
    3dClusterize -nosum -orient LPI \
    -mask ./group/mask/Amy8_align.freesurfer+tlrc \
    -inset ./S${sub}/${subj}.results/${stats}.${subj}.odorVI+tlrc \
    -idat 31 -ithr 32 -NN 2 -clust_nvox 40 -bisided p=${threshold} \
    | awk 'BEGIN {
            plus=1
            minus=1
            OFS = ","
        }             
            !/^#/ {
            
            if ($(NF-2)>0 && plus>0){
                plus-=1
                print $(NF-2),$(NF-1),$NF,"'$sub'"*-1,$1*-1,$2,$3,$4
            }
            else if ($(NF-2)<0 && minus>0){
                minus-=1
                print $(NF-2),$(NF-1),$NF,"'$sub'"*-1,$1*-1,$2,$3,$4
            }
        }'
done >> group/peak/Amy_peak_${threshold}.csv

# Pir_new
for sub in {04..11} {13..14} {16..29} {31..34}
do
    subj=S${sub}.pabiode
    # Pir_new cit-lim
    3dClusterize -nosum -orient LPI \
    -mask ./group/mask/Pir_new.draw+tlrc \
    -inset ./S${sub}/${subj}.results/${stats}.${subj}.odorVI+tlrc \
    -idat 34 -ithr 35 -NN 2 -clust_nvox 40 -bisided p=${threshold} \
    | awk 'BEGIN {
            plus=1
            minus=1
            OFS = ","
        }             
            !/^#/ {
            
            if ($(NF-2)>0 && plus>0){
                plus-=1
                print $(NF-2),$(NF-1),$NF,"'$sub'"*1,$1,$2,$3,$4
            }
            else if ($(NF-2)<0 && minus>0){
                minus-=1
                print $(NF-2),$(NF-1),$NF,"'$sub'"*1,$1,$2,$3,$4
            }
        }'
    # Pir_new car-lim
    3dClusterize -nosum -orient LPI \
    -mask ./group/mask/Pir_new.draw+tlrc \
    -inset ./S${sub}/${subj}.results/${stats}.${subj}.odorVI+tlrc \
    -idat 31 -ithr 32 -NN 2 -clust_nvox 40 -bisided p=${threshold} \
    | awk 'BEGIN {
            plus=1
            minus=1
            OFS = ","
        }             
            !/^#/ {
            
            if ($(NF-2)>0 && plus>0){
                plus-=1
                print $(NF-2),$(NF-1),$NF,"'$sub'"*-1,$1*-1,$2,$3,$4
            }
            else if ($(NF-2)<0 && minus>0){
                minus-=1
                print $(NF-2),$(NF-1),$NF,"'$sub'"*-1,$1*-1,$2,$3,$4
            }
        }'
done >> group/peak/Pir_new_peak_${threshold}.csv
