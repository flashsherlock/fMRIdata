#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
# datafolder=/Volumes/WD_D/allsub/
cd "${datafolder}" || exit

# for each condition odorall faceall facevis faceinv
for brick in odorall faceall facevis faceinv
do
# if ttest results exists, delete it
if [ -f  group/ttest_abs_${brick}+tlrc.HEAD ]; then
      rm  group/ttest_abs_${brick}+tlrc*
fi
# 8 conditions
3dttest++ -prefix group/ttest_abs_${brick}    -setA all        \
                01 "S03/S03.de.results/absolute_${brick}+tlrc" \
                02 "S04/S04.de.results/absolute_${brick}+tlrc" \
                03 "S05/S05.de.results/absolute_${brick}+tlrc" \
                04 "S06/S06.de.results/absolute_${brick}+tlrc" \
                05 "S07/S07.de.results/absolute_${brick}+tlrc" \
                06 "S08/S08.de.results/absolute_${brick}+tlrc" \
                07 "S09/S09.de.results/absolute_${brick}+tlrc" \
                08 "S10/S10.de.results/absolute_${brick}+tlrc" \
                09 "S11/S11.de.results/absolute_${brick}+tlrc" \
                10 "S12/S12.de.results/absolute_${brick}+tlrc" \
                11 "S13/S13.de.results/absolute_${brick}+tlrc" \
                12 "S14/S14.de.results/absolute_${brick}+tlrc" \
                13 "S15/S15.de.results/absolute_${brick}+tlrc" \
                14 "S16/S16.de.results/absolute_${brick}+tlrc" \
                15 "S17/S17.de.results/absolute_${brick}+tlrc" \
                16 "S18/S18.de.results/absolute_${brick}+tlrc" \
                17 "S19/S19.de.results/absolute_${brick}+tlrc" \
                18 "S20/S20.de.results/absolute_${brick}+tlrc" \
                19 "S21/S21.de.results/absolute_${brick}+tlrc" \
                20 "S22/S22.de.results/absolute_${brick}+tlrc" \
                21 "S23/S23.de.results/absolute_${brick}+tlrc" \
                22 "S24/S24.de.results/absolute_${brick}+tlrc" \
                23 "S25/S25.de.results/absolute_${brick}+tlrc" \
                24 "S26/S26.de.results/absolute_${brick}+tlrc" \
                25 "S27/S27.de.results/absolute_${brick}+tlrc" \
                26 "S28/S28.de.results/absolute_${brick}+tlrc" \
                27 "S29/S29.de.results/absolute_${brick}+tlrc"
maskdec_t=3.3011
# if ttest results exists, delete it
if [ -f  group/absmap_${brick}_${maskdec_t}+tlrc.HEAD ]; then
      rm  group/absmap_${brick}_${maskdec_t}+tlrc*
fi
# calculate percentage for 27 subjects
3dMean -prefix group/absmap_${brick}_${maskdec_t}  \
      "S03/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S04/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S05/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S06/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S07/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S08/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S09/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S10/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S11/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S12/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S13/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S14/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S15/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S16/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S17/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S18/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S19/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S20/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S21/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S22/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S23/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S24/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S25/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S26/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S27/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S28/mask/absmap_${brick}_${maskdec_t}+tlrc" \
      "S29/mask/absmap_${brick}_${maskdec_t}+tlrc"
done