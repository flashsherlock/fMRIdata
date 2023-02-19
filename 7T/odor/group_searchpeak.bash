#! /bin/bash

# datafolder=/Volumes/WD_E/gufei/7T_odor
datafolder=/Volumes/WD_F/gufei/7T_odor
cd "${datafolder}" || exit
stats=ARodor_l1_labelbase
threshold=0.05
tthr=$(ccalc -expr "cdf2stat(0.975,3,27,0,0)")
# make dir image if not exist
if [ ! -d ./group/searchpeak ]; then
    mkdir ./group/searchpeak
fi

# calculate mask that lim-car and lim-cit are both significant
# 3dcalc \
# -a ./group/mvpa/${stats}_lim-car+tlrc[1] \
# -b ./group/mvpa/${stats}_lim-cit+tlrc[1] \
# -c ./group/mask/Amy8_align.freesurfer+tlrc \
# -expr "step(a-${tthr})*step(b-${tthr})*c" \
# -prefix ./group/searchpeak/all_sig

# calculate lim-cit - lim-car
# 3dcalc \
# -a ./group/mvpa/${stats}_lim-car+tlrc[0] \
# -b ./group/mvpa/${stats}_lim-cit+tlrc[0] \
# -expr "(step(b)*b-step(a)*a)*step(step(b)*b-step(a)*a)" \
# -prefix ./group/searchpeak/lim-cit

# 3dcalc \
# -a ./group/mvpa/${stats}_lim-car+tlrc[0] \
# -b ./group/mvpa/${stats}_lim-cit+tlrc[0] \
# -expr "(step(a)*a-step(b)*b)*step(step(a)*a-step(b)*b)" \
# -prefix ./group/searchpeak/lim-car
# # normalized by lim-cit + lim-car
# 3dcalc \
# -a ./group/mvpa/${stats}_lim-car+tlrc[0] \
# -b ./group/mvpa/${stats}_lim-cit+tlrc[0] \
# -expr "((step(b)*b-step(a)*a)*step(step(b)*b-step(a)*a))/(step(b)*b+step(a)*a)" \
# -prefix ./group/searchpeak/lim-cit_norm

# 3dcalc \
# -a ./group/mvpa/${stats}_lim-car+tlrc[0] \
# -b ./group/mvpa/${stats}_lim-cit+tlrc[0] \
# -expr "((step(a)*a-step(b)*b)*step(step(a)*a-step(b)*b))/(step(b)*b+step(a)*a)" \
# -prefix ./group/searchpeak/lim-car_norm

# remove existing file
rm ./group/searchpeak/Amy_allsig_${threshold}.csv

mask=./group/mask/Amy8_align.freesurfer+tlrc
# mask=./group/searchpeak/all_sig+tlrc
for odor in lim-car lim-cit
do
    # 3dClusterize -nosum -orient LPI \
    # -mask ${mask} \
    # -inset ./group/searchpeak/${odor}+tlrc \
    # -idat 0 -ithr 0 -NN 1 -clust_nvox 10 -within_range -100 100 \
    # Amy cit-lim
    3dClusterize -nosum -orient LPI \
    -mask ${mask} \
    -inset ./group/mvpa/${stats}_${odor}+tlrc \
    -idat 0 -ithr 1 -NN 1 -clust_nvox 40 -1sided RIGHT_TAIL p=0.025 \
    | awk 'BEGIN {
            plus=1
            minus=1
            OFS = ","
        }             
            !/^#/ {
            
            if ($(NF-2)>0 && plus>0){
                plus-=1
                print $(NF-2),$(NF-1),$NF,"'$odor'",$1,$2,$3,$4
            }
            else if ($(NF-2)<0 && minus>0){
                minus-=1
                print $(NF-2),$(NF-1),$NF,"'$odor'",$1,$2,$3,$4
            }
        }'
done >> group/searchpeak/Amy_allsig_${threshold}.csv

