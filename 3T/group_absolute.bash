#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
# datafolder=/Volumes/WD_D/allsub/
cd "${datafolder}" || exit
bmask=group/mask/bmask.nii
# for each condition odorall faceall facevis faceinv
for brick in odorvis odorinv odorall faceall facevis faceinv
do
      for maskdec_t in 1.9625 1.6465
      do
            for pre in absweight0 #absweightrev #absolute
            do
                  if [ "${pre}" = "absolute" ]; then
                        brickn=${brick}
                  else
                        brickn=${brick}_${maskdec_t}
                  fi
                  # if ttest results exists, delete it
                  if [ -f  group/ttest_${pre}_${brickn}+tlrc.HEAD ]; then
                        rm  group/ttest_${pre}_${brickn}+tlrc*
                  fi
                  # 8 conditions
                  3dttest++ -prefix group/ttest_${pre}_${brickn}    \
                        -mask ${bmask}       -setA all        \
                        01 "S03/S03.de.results/${pre}_${brickn}+tlrc" \
                        02 "S04/S04.de.results/${pre}_${brickn}+tlrc" \
                        03 "S05/S05.de.results/${pre}_${brickn}+tlrc" \
                        04 "S06/S06.de.results/${pre}_${brickn}+tlrc" \
                        05 "S07/S07.de.results/${pre}_${brickn}+tlrc" \
                        06 "S08/S08.de.results/${pre}_${brickn}+tlrc" \
                        07 "S09/S09.de.results/${pre}_${brickn}+tlrc" \
                        08 "S10/S10.de.results/${pre}_${brickn}+tlrc" \
                        09 "S11/S11.de.results/${pre}_${brickn}+tlrc" \
                        10 "S12/S12.de.results/${pre}_${brickn}+tlrc" \
                        11 "S13/S13.de.results/${pre}_${brickn}+tlrc" \
                        12 "S14/S14.de.results/${pre}_${brickn}+tlrc" \
                        13 "S15/S15.de.results/${pre}_${brickn}+tlrc" \
                        14 "S16/S16.de.results/${pre}_${brickn}+tlrc" \
                        15 "S17/S17.de.results/${pre}_${brickn}+tlrc" \
                        16 "S18/S18.de.results/${pre}_${brickn}+tlrc" \
                        17 "S19/S19.de.results/${pre}_${brickn}+tlrc" \
                        18 "S20/S20.de.results/${pre}_${brickn}+tlrc" \
                        19 "S21/S21.de.results/${pre}_${brickn}+tlrc" \
                        20 "S22/S22.de.results/${pre}_${brickn}+tlrc" \
                        21 "S23/S23.de.results/${pre}_${brickn}+tlrc" \
                        22 "S24/S24.de.results/${pre}_${brickn}+tlrc" \
                        23 "S25/S25.de.results/${pre}_${brickn}+tlrc" \
                        24 "S26/S26.de.results/${pre}_${brickn}+tlrc" \
                        25 "S27/S27.de.results/${pre}_${brickn}+tlrc" \
                        26 "S28/S28.de.results/${pre}_${brickn}+tlrc" \
                        27 "S29/S29.de.results/${pre}_${brickn}+tlrc"
            done
            
            # if ttest results exists, delete it
            if [ -f  group/absmap_${brick}_${maskdec_t}+tlrc.HEAD ]; then
                  rm  group/absmap*${brick}_${maskdec_t}+tlrc*
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
            3dcalc -a group/absmap_${brick}_${maskdec_t}+tlrc \
                  -b ${bmask} \
                  -expr "a*b" \
                  -prefix group/absmapb_${brick}_${maskdec_t}
      done
done