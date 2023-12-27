#! /bin/bash

# datafolder=/Volumes/WD_D/allsub/
datafolder=/Volumes/WD_F/gufei/3T_cw/
cd "${datafolder}" || exit

for roi in Amy OFC_AAL
do
indmask=p2acc_${roi}_inter3
# normalize each sub mask to MNI space
for ub in $(count -dig 2 03 29)
do
sub=S${ub}
fd=${sub}/${sub}.de.results/
3dNwarpApply -nwarp "${fd}anatQQ.${sub}_WARP.nii ${fd}anatQQ.${sub}.aff12.1D INV(${fd}anatSS.${sub}_al_keep_mat.aff12.1D)"   \
            -source ${sub}/mask/${indmask}+orig   \
            -master ${fd}anatQQ.${sub}+tlrc    \
            -prefix ${sub}/mask/${indmask}
done   
# calculate percentage for 27 subjects
3dMean -prefix group/mvpa/percent_${roi}  \
      "S03/mask/${indmask}+tlrc" \
      "S04/mask/${indmask}+tlrc" \
      "S05/mask/${indmask}+tlrc" \
      "S06/mask/${indmask}+tlrc" \
      "S07/mask/${indmask}+tlrc" \
      "S08/mask/${indmask}+tlrc" \
      "S09/mask/${indmask}+tlrc" \
      "S10/mask/${indmask}+tlrc" \
      "S11/mask/${indmask}+tlrc" \
      "S12/mask/${indmask}+tlrc" \
      "S13/mask/${indmask}+tlrc" \
      "S14/mask/${indmask}+tlrc" \
      "S15/mask/${indmask}+tlrc" \
      "S16/mask/${indmask}+tlrc" \
      "S17/mask/${indmask}+tlrc" \
      "S18/mask/${indmask}+tlrc" \
      "S19/mask/${indmask}+tlrc" \
      "S20/mask/${indmask}+tlrc" \
      "S21/mask/${indmask}+tlrc" \
      "S22/mask/${indmask}+tlrc" \
      "S23/mask/${indmask}+tlrc" \
      "S24/mask/${indmask}+tlrc" \
      "S25/mask/${indmask}+tlrc" \
      "S26/mask/${indmask}+tlrc" \
      "S27/mask/${indmask}+tlrc" \
      "S28/mask/${indmask}+tlrc" \
      "S29/mask/${indmask}+tlrc"
done