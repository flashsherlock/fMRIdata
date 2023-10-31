#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
# datafolder=/Volumes/WD_D/allsub/
cd "${datafolder}" || exit

# check $1, if is whole, use bmask.nii as mask
if [ "$1" = "whole" ]; then
      mask=group/mask/bmask.nii
      out=whole
else
      mask=group/mask/Amy8_align.freesurfer+tlrc
      out=Amy
fi
# if $2 esists, use it as suffix
if [ -n "$2" ]; then
      suffix=de.$2
      outsuffix=${out}$2
else
      suffix=de.new
      outsuffix=${out}
fi
# if ttest results exists, delete it
if [ -f  group/ttest_${outsuffix}+tlrc.HEAD ]; then
      rm  group/ttest_${outsuffix}+tlrc*
fi
# 8 conditions
3dttest++ -prefix group/ttest_${outsuffix}                                       \
          -mask ${mask}                                            \
          -setA all                                                \
                01 "S03/S03.de.results/stats.S03.${suffix}+tlrc[1]" \
                02 "S04/S04.de.results/stats.S04.${suffix}+tlrc[1]" \
                03 "S05/S05.de.results/stats.S05.${suffix}+tlrc[1]" \
                04 "S06/S06.de.results/stats.S06.${suffix}+tlrc[1]" \
                05 "S07/S07.de.results/stats.S07.${suffix}+tlrc[1]" \
                06 "S08/S08.de.results/stats.S08.${suffix}+tlrc[1]" \
                07 "S09/S09.de.results/stats.S09.${suffix}+tlrc[1]" \
                08 "S10/S10.de.results/stats.S10.${suffix}+tlrc[1]" \
                09 "S11/S11.de.results/stats.S11.${suffix}+tlrc[1]" \
                10 "S12/S12.de.results/stats.S12.${suffix}+tlrc[1]" \
                11 "S13/S13.de.results/stats.S13.${suffix}+tlrc[1]" \
                12 "S14/S14.de.results/stats.S14.${suffix}+tlrc[1]" \
                13 "S15/S15.de.results/stats.S15.${suffix}+tlrc[1]" \
                14 "S16/S16.de.results/stats.S16.${suffix}+tlrc[1]" \
                15 "S17/S17.de.results/stats.S17.${suffix}+tlrc[1]" \
                16 "S18/S18.de.results/stats.S18.${suffix}+tlrc[1]" \
                17 "S19/S19.de.results/stats.S19.${suffix}+tlrc[1]" \
                18 "S20/S20.de.results/stats.S20.${suffix}+tlrc[1]" \
                19 "S21/S21.de.results/stats.S21.${suffix}+tlrc[1]" \
                20 "S22/S22.de.results/stats.S22.${suffix}+tlrc[1]" \
                21 "S23/S23.de.results/stats.S23.${suffix}+tlrc[1]" \
                22 "S24/S24.de.results/stats.S24.${suffix}+tlrc[1]" \
                23 "S25/S25.de.results/stats.S25.${suffix}+tlrc[1]" \
                24 "S26/S26.de.results/stats.S26.${suffix}+tlrc[1]" \
                25 "S27/S27.de.results/stats.S27.${suffix}+tlrc[1]" \
                26 "S28/S28.de.results/stats.S28.${suffix}+tlrc[1]" \
                27 "S29/S29.de.results/stats.S29.${suffix}+tlrc[1]"
# # if ttest results exists, delete it
# if [ -f  group/ttest_facevis_${outsuffix}+tlrc.HEAD ]; then
#       rm  group/ttest_facevis_${outsuffix}+tlrc*
# fi
# # 8 conditions
# 3dttest++ -prefix group/ttest_facevis_${outsuffix}                                       \
#           -mask ${mask}                                            \
#           -setA all                                                \
#                 01 "S03/S03.de.results/stats.S03.${suffix}+tlrc[37]" \
#                 02 "S04/S04.de.results/stats.S04.${suffix}+tlrc[37]" \
#                 03 "S05/S05.de.results/stats.S05.${suffix}+tlrc[37]" \
#                 04 "S06/S06.de.results/stats.S06.${suffix}+tlrc[37]" \
#                 05 "S07/S07.de.results/stats.S07.${suffix}+tlrc[37]" \
#                 06 "S08/S08.de.results/stats.S08.${suffix}+tlrc[37]" \
#                 07 "S09/S09.de.results/stats.S09.${suffix}+tlrc[37]" \
#                 08 "S10/S10.de.results/stats.S10.${suffix}+tlrc[37]" \
#                 09 "S11/S11.de.results/stats.S11.${suffix}+tlrc[37]" \
#                 10 "S12/S12.de.results/stats.S12.${suffix}+tlrc[37]" \
#                 11 "S13/S13.de.results/stats.S13.${suffix}+tlrc[37]" \
#                 12 "S14/S14.de.results/stats.S14.${suffix}+tlrc[37]" \
#                 13 "S15/S15.de.results/stats.S15.${suffix}+tlrc[37]" \
#                 14 "S16/S16.de.results/stats.S16.${suffix}+tlrc[37]" \
#                 15 "S17/S17.de.results/stats.S17.${suffix}+tlrc[37]" \
#                 16 "S18/S18.de.results/stats.S18.${suffix}+tlrc[37]" \
#                 17 "S19/S19.de.results/stats.S19.${suffix}+tlrc[37]" \
#                 18 "S20/S20.de.results/stats.S20.${suffix}+tlrc[37]" \
#                 19 "S21/S21.de.results/stats.S21.${suffix}+tlrc[37]" \
#                 20 "S22/S22.de.results/stats.S22.${suffix}+tlrc[37]" \
#                 21 "S23/S23.de.results/stats.S23.${suffix}+tlrc[37]" \
#                 22 "S24/S24.de.results/stats.S24.${suffix}+tlrc[37]" \
#                 23 "S25/S25.de.results/stats.S25.${suffix}+tlrc[37]" \
#                 24 "S26/S26.de.results/stats.S26.${suffix}+tlrc[37]" \
#                 25 "S27/S27.de.results/stats.S27.${suffix}+tlrc[37]" \
#                 26 "S28/S28.de.results/stats.S28.${suffix}+tlrc[37]" \
#                 27 "S29/S29.de.results/stats.S29.${suffix}+tlrc[37]"
