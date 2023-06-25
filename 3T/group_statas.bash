#! /bin/bash

datafolder=/Volumes/WD_D/allsub/
cd "${datafolder}" || exit
suffix=congru
mask=group/mask/Amy8_align.freesurfer+tlrc
outsuffix=freesurfer

# S03 S04 S05 S06 S07 S08 S11 S14 S15 S16 S19 S21 S22 S23 S24 S25 S26 S27 S28 S29
3dROIstats -nzmean -mask ${mask} \
"S03/analysis/S03.analysis.${suffix}+tlrc[25]" \
"S04/analysis/S04.analysis.${suffix}+tlrc[25]" \
"S05/analysis/S05.analysis.${suffix}+tlrc[25]" \
"S06/analysis/S06.analysis.${suffix}+tlrc[25]" \
"S07/analysis/S07.analysis.${suffix}+tlrc[25]" \
"S08/analysis/S08.analysis.${suffix}+tlrc[25]" \
"S11/analysis/S11.analysis.${suffix}+tlrc[25]" \
"S14/analysis/S14.analysis.${suffix}+tlrc[25]" \
"S15/analysis/S15.analysis.${suffix}+tlrc[25]" \
"S16/analysis/S16.analysis.${suffix}+tlrc[25]" \
"S19/analysis/S19.analysis.${suffix}+tlrc[25]" \
"S21/analysis/S21.analysis.${suffix}+tlrc[25]" \
"S22/analysis/S22.analysis.${suffix}+tlrc[25]" \
"S23/analysis/S23.analysis.${suffix}+tlrc[25]" \
"S24/analysis/S24.analysis.${suffix}+tlrc[25]" \
"S25/analysis/S25.analysis.${suffix}+tlrc[25]" \
"S26/analysis/S26.analysis.${suffix}+tlrc[25]" \
"S27/analysis/S27.analysis.${suffix}+tlrc[25]" \
"S28/analysis/S28.analysis.${suffix}+tlrc[25]" \
"S29/analysis/S29.analysis.${suffix}+tlrc[25]" \
> group/congruency_${outsuffix}.txt
# visible
3dROIstats -nzmean -mask ${mask} \
"S03/analysis/S03.analysis.${suffix}+tlrc[28]" \
"S04/analysis/S04.analysis.${suffix}+tlrc[28]" \
"S05/analysis/S05.analysis.${suffix}+tlrc[28]" \
"S06/analysis/S06.analysis.${suffix}+tlrc[28]" \
"S07/analysis/S07.analysis.${suffix}+tlrc[28]" \
"S08/analysis/S08.analysis.${suffix}+tlrc[28]" \
"S11/analysis/S11.analysis.${suffix}+tlrc[28]" \
"S14/analysis/S14.analysis.${suffix}+tlrc[28]" \
"S15/analysis/S15.analysis.${suffix}+tlrc[28]" \
"S16/analysis/S16.analysis.${suffix}+tlrc[28]" \
"S19/analysis/S19.analysis.${suffix}+tlrc[28]" \
"S21/analysis/S21.analysis.${suffix}+tlrc[28]" \
"S22/analysis/S22.analysis.${suffix}+tlrc[28]" \
"S23/analysis/S23.analysis.${suffix}+tlrc[28]" \
"S24/analysis/S24.analysis.${suffix}+tlrc[28]" \
"S25/analysis/S25.analysis.${suffix}+tlrc[28]" \
"S26/analysis/S26.analysis.${suffix}+tlrc[28]" \
"S27/analysis/S27.analysis.${suffix}+tlrc[28]" \
"S28/analysis/S28.analysis.${suffix}+tlrc[28]" \
"S29/analysis/S29.analysis.${suffix}+tlrc[28]" \
> group/congruency_vis_${outsuffix}.txt
# invisible
3dROIstats -nzmean -mask ${mask} \
"S03/analysis/S03.analysis.${suffix}+tlrc[31]" \
"S04/analysis/S04.analysis.${suffix}+tlrc[31]" \
"S05/analysis/S05.analysis.${suffix}+tlrc[31]" \
"S06/analysis/S06.analysis.${suffix}+tlrc[31]" \
"S07/analysis/S07.analysis.${suffix}+tlrc[31]" \
"S08/analysis/S08.analysis.${suffix}+tlrc[31]" \
"S11/analysis/S11.analysis.${suffix}+tlrc[31]" \
"S14/analysis/S14.analysis.${suffix}+tlrc[31]" \
"S15/analysis/S15.analysis.${suffix}+tlrc[31]" \
"S16/analysis/S16.analysis.${suffix}+tlrc[31]" \
"S19/analysis/S19.analysis.${suffix}+tlrc[31]" \
"S21/analysis/S21.analysis.${suffix}+tlrc[31]" \
"S22/analysis/S22.analysis.${suffix}+tlrc[31]" \
"S23/analysis/S23.analysis.${suffix}+tlrc[31]" \
"S24/analysis/S24.analysis.${suffix}+tlrc[31]" \
"S25/analysis/S25.analysis.${suffix}+tlrc[31]" \
"S26/analysis/S26.analysis.${suffix}+tlrc[31]" \
"S27/analysis/S27.analysis.${suffix}+tlrc[31]" \
"S28/analysis/S28.analysis.${suffix}+tlrc[31]" \
"S29/analysis/S29.analysis.${suffix}+tlrc[31]" \
> group/congruency_inv_${outsuffix}.txt
# 8 conditions
3dROIstats -nzmean -mask ${mask} \
"S03/analysis/S03.analysis.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
"S04/analysis/S04.analysis.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
"S05/analysis/S05.analysis.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
"S06/analysis/S06.analysis.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
"S07/analysis/S07.analysis.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
"S08/analysis/S08.analysis.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
"S11/analysis/S11.analysis.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
"S14/analysis/S14.analysis.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
"S15/analysis/S15.analysis.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
"S16/analysis/S16.analysis.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
"S19/analysis/S19.analysis.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
"S21/analysis/S21.analysis.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
"S22/analysis/S22.analysis.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
"S23/analysis/S23.analysis.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
"S24/analysis/S24.analysis.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
"S25/analysis/S25.analysis.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
"S26/analysis/S26.analysis.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
"S27/analysis/S27.analysis.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
"S28/analysis/S28.analysis.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
"S29/analysis/S29.analysis.${suffix}+tlrc[1,4,7,10,13,16,19,22]" \
> group/conditoins_${outsuffix}.txt
