#! /bin/bash

# datafolder=/Volumes/WD_E/gufei/7T_odor
datafolder=/Volumes/WD_F/gufei/7T_odor/group/mask
cd "${datafolder}" || exit

# calculate mask combining  and 
3dcalc \
-a "OLFDTI_L_lateral_olfactory_tract.nii.gz" \
-b "OLFDTI_R_lateral_olfactory_tract.nii.gz" \
-expr "a+b" \
-prefix "tract"

# resample
3dresample -master all.seg+tlrc -prefix tract_resample -input tract+tlrc

# find the boundary of the mask
3dAutobox -extent -noclust tract+tlrc

# dump tract to text file
3dmaskdump                \
-noijk -xyz               \
-mask all.seg+tlrc        \
all.seg+tlrc              \
tract_resample+tlrc       \
"../stats_val+tlrc[0]"       \
> ../tract.txt