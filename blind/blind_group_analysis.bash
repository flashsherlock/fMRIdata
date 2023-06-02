#! /bin/bash

datafolder=/Volumes/WD_F/gufei/blind
cd "${datafolder}" || exit
stats=stats
suffix=pade

# if allroi.nii not exists
if [ ! -f group/mask/allroi.nii ]; then
      # resample maxprob_vol.nii
      3dresample \
      -input ProbAtlas_v4/subj_vol_all/maxprob_vol.nii \
      -master group/mask/bmask.nii \
      -rmode NN \
      -prefix group/mask/maxprob_vol.nii

      # mask for allROI
      3dcalc \
      -a group/mask/maxprob_vol.nii \
      -b group/mask/Amy8_align.freesurfer+tlrc \
      -c group/mask/Pir_new.draw+tlrc \
      -expr 'amongst(a,1,2,3,4,5,6)+b+c' \
      -prefix group/mask/allroi.nii
fi

mask=group/mask/allroi.nii

# if anova results exists, delete it
if [ -f group/ANOVA_results+tlrc.HEAD ]; then
      rm group/ANOVA_results+tlrc*
fi
# from 1 to 22 are gas ind ros pin app min fru flo
3dANOVA2                                 \
      -type 3 -alevels 8 -blevels 13  -mask ${mask} \
      -dset 1 1 "S02/S02.pade.results/${stats}.S02.${suffix}+tlrc[1]"        \
      -dset 2 1 "S02/S02.pade.results/${stats}.S02.${suffix}+tlrc[4]"        \
      -dset 3 1 "S02/S02.pade.results/${stats}.S02.${suffix}+tlrc[7]"        \
      -dset 4 1 "S02/S02.pade.results/${stats}.S02.${suffix}+tlrc[10]"       \
      -dset 5 1 "S02/S02.pade.results/${stats}.S02.${suffix}+tlrc[13]"       \
      -dset 6 1 "S02/S02.pade.results/${stats}.S02.${suffix}+tlrc[16]"       \
      -dset 7 1 "S02/S02.pade.results/${stats}.S02.${suffix}+tlrc[19]"       \
      -dset 8 1 "S02/S02.pade.results/${stats}.S02.${suffix}+tlrc[22]"       \
      -dset 1 2 "S03/S03.pade.results/${stats}.S03.${suffix}+tlrc[1]"        \
      -dset 2 2 "S03/S03.pade.results/${stats}.S03.${suffix}+tlrc[4]"        \
      -dset 3 2 "S03/S03.pade.results/${stats}.S03.${suffix}+tlrc[7]"        \
      -dset 4 2 "S03/S03.pade.results/${stats}.S03.${suffix}+tlrc[10]"       \
      -dset 5 2 "S03/S03.pade.results/${stats}.S03.${suffix}+tlrc[13]"       \
      -dset 6 2 "S03/S03.pade.results/${stats}.S03.${suffix}+tlrc[16]"       \
      -dset 7 2 "S03/S03.pade.results/${stats}.S03.${suffix}+tlrc[19]"       \
      -dset 8 2 "S03/S03.pade.results/${stats}.S03.${suffix}+tlrc[22]"       \
      -dset 1 3 "S04/S04.pade.results/${stats}.S04.${suffix}+tlrc[1]"        \
      -dset 2 3 "S04/S04.pade.results/${stats}.S04.${suffix}+tlrc[4]"        \
      -dset 3 3 "S04/S04.pade.results/${stats}.S04.${suffix}+tlrc[7]"        \
      -dset 4 3 "S04/S04.pade.results/${stats}.S04.${suffix}+tlrc[10]"       \
      -dset 5 3 "S04/S04.pade.results/${stats}.S04.${suffix}+tlrc[13]"       \
      -dset 6 3 "S04/S04.pade.results/${stats}.S04.${suffix}+tlrc[16]"       \
      -dset 7 3 "S04/S04.pade.results/${stats}.S04.${suffix}+tlrc[19]"       \
      -dset 8 3 "S04/S04.pade.results/${stats}.S04.${suffix}+tlrc[22]"       \
      -dset 1 4 "S06/S06.pade.results/${stats}.S06.${suffix}+tlrc[1]"        \
      -dset 2 4 "S06/S06.pade.results/${stats}.S06.${suffix}+tlrc[4]"        \
      -dset 3 4 "S06/S06.pade.results/${stats}.S06.${suffix}+tlrc[7]"        \
      -dset 4 4 "S06/S06.pade.results/${stats}.S06.${suffix}+tlrc[10]"       \
      -dset 5 4 "S06/S06.pade.results/${stats}.S06.${suffix}+tlrc[13]"       \
      -dset 6 4 "S06/S06.pade.results/${stats}.S06.${suffix}+tlrc[16]"       \
      -dset 7 4 "S06/S06.pade.results/${stats}.S06.${suffix}+tlrc[19]"       \
      -dset 8 4 "S06/S06.pade.results/${stats}.S06.${suffix}+tlrc[22]"       \
      -dset 1 5 "S07/S07.pade.results/${stats}.S07.${suffix}+tlrc[1]"        \
      -dset 2 5 "S07/S07.pade.results/${stats}.S07.${suffix}+tlrc[4]"        \
      -dset 3 5 "S07/S07.pade.results/${stats}.S07.${suffix}+tlrc[7]"        \
      -dset 4 5 "S07/S07.pade.results/${stats}.S07.${suffix}+tlrc[10]"       \
      -dset 5 5 "S07/S07.pade.results/${stats}.S07.${suffix}+tlrc[13]"       \
      -dset 6 5 "S07/S07.pade.results/${stats}.S07.${suffix}+tlrc[16]"       \
      -dset 7 5 "S07/S07.pade.results/${stats}.S07.${suffix}+tlrc[19]"       \
      -dset 8 5 "S07/S07.pade.results/${stats}.S07.${suffix}+tlrc[22]"       \
      -dset 1 6 "S08/S08.pade.results/${stats}.S08.${suffix}+tlrc[1]"        \
      -dset 2 6 "S08/S08.pade.results/${stats}.S08.${suffix}+tlrc[4]"        \
      -dset 3 6 "S08/S08.pade.results/${stats}.S08.${suffix}+tlrc[7]"        \
      -dset 4 6 "S08/S08.pade.results/${stats}.S08.${suffix}+tlrc[10]"       \
      -dset 5 6 "S08/S08.pade.results/${stats}.S08.${suffix}+tlrc[13]"       \
      -dset 6 6 "S08/S08.pade.results/${stats}.S08.${suffix}+tlrc[16]"       \
      -dset 7 6 "S08/S08.pade.results/${stats}.S08.${suffix}+tlrc[19]"       \
      -dset 8 6 "S08/S08.pade.results/${stats}.S08.${suffix}+tlrc[22]"       \
      -dset 1 7 "S09/S09.pade.results/${stats}.S09.${suffix}+tlrc[1]"        \
      -dset 2 7 "S09/S09.pade.results/${stats}.S09.${suffix}+tlrc[4]"        \
      -dset 3 7 "S09/S09.pade.results/${stats}.S09.${suffix}+tlrc[7]"        \
      -dset 4 7 "S09/S09.pade.results/${stats}.S09.${suffix}+tlrc[10]"       \
      -dset 5 7 "S09/S09.pade.results/${stats}.S09.${suffix}+tlrc[13]"       \
      -dset 6 7 "S09/S09.pade.results/${stats}.S09.${suffix}+tlrc[16]"       \
      -dset 7 7 "S09/S09.pade.results/${stats}.S09.${suffix}+tlrc[19]"       \
      -dset 8 7 "S09/S09.pade.results/${stats}.S09.${suffix}+tlrc[22]"       \
      -dset 1 8 "S10/S10.pade.results/${stats}.S10.${suffix}+tlrc[1]"        \
      -dset 2 8 "S10/S10.pade.results/${stats}.S10.${suffix}+tlrc[4]"        \
      -dset 3 8 "S10/S10.pade.results/${stats}.S10.${suffix}+tlrc[7]"        \
      -dset 4 8 "S10/S10.pade.results/${stats}.S10.${suffix}+tlrc[10]"       \
      -dset 5 8 "S10/S10.pade.results/${stats}.S10.${suffix}+tlrc[13]"       \
      -dset 6 8 "S10/S10.pade.results/${stats}.S10.${suffix}+tlrc[16]"       \
      -dset 7 8 "S10/S10.pade.results/${stats}.S10.${suffix}+tlrc[19]"       \
      -dset 8 8 "S10/S10.pade.results/${stats}.S10.${suffix}+tlrc[22]"       \
      -dset 1 9 "S11/S11.pade.results/${stats}.S11.${suffix}+tlrc[1]"        \
      -dset 2 9 "S11/S11.pade.results/${stats}.S11.${suffix}+tlrc[4]"        \
      -dset 3 9 "S11/S11.pade.results/${stats}.S11.${suffix}+tlrc[7]"        \
      -dset 4 9 "S11/S11.pade.results/${stats}.S11.${suffix}+tlrc[10]"       \
      -dset 5 9 "S11/S11.pade.results/${stats}.S11.${suffix}+tlrc[13]"       \
      -dset 6 9 "S11/S11.pade.results/${stats}.S11.${suffix}+tlrc[16]"       \
      -dset 7 9 "S11/S11.pade.results/${stats}.S11.${suffix}+tlrc[19]"       \
      -dset 8 9 "S11/S11.pade.results/${stats}.S11.${suffix}+tlrc[22]"       \
      -dset 1 10 "S12/S12.pade.results/${stats}.S12.${suffix}+tlrc[1]"       \
      -dset 2 10 "S12/S12.pade.results/${stats}.S12.${suffix}+tlrc[4]"       \
      -dset 3 10 "S12/S12.pade.results/${stats}.S12.${suffix}+tlrc[7]"       \
      -dset 4 10 "S12/S12.pade.results/${stats}.S12.${suffix}+tlrc[10]"      \
      -dset 5 10 "S12/S12.pade.results/${stats}.S12.${suffix}+tlrc[13]"      \
      -dset 6 10 "S12/S12.pade.results/${stats}.S12.${suffix}+tlrc[16]"      \
      -dset 7 10 "S12/S12.pade.results/${stats}.S12.${suffix}+tlrc[19]"      \
      -dset 8 10 "S12/S12.pade.results/${stats}.S12.${suffix}+tlrc[22]"      \
      -dset 1 11 "S13/S13.pade.results/${stats}.S13.${suffix}+tlrc[1]"       \
      -dset 2 11 "S13/S13.pade.results/${stats}.S13.${suffix}+tlrc[4]"       \
      -dset 3 11 "S13/S13.pade.results/${stats}.S13.${suffix}+tlrc[7]"       \
      -dset 4 11 "S13/S13.pade.results/${stats}.S13.${suffix}+tlrc[10]"      \
      -dset 5 11 "S13/S13.pade.results/${stats}.S13.${suffix}+tlrc[13]"      \
      -dset 6 11 "S13/S13.pade.results/${stats}.S13.${suffix}+tlrc[16]"      \
      -dset 7 11 "S13/S13.pade.results/${stats}.S13.${suffix}+tlrc[19]"      \
      -dset 8 11 "S13/S13.pade.results/${stats}.S13.${suffix}+tlrc[22]"      \
      -dset 1 12 "S14/S14.pade.results/${stats}.S14.${suffix}+tlrc[1]"       \
      -dset 2 12 "S14/S14.pade.results/${stats}.S14.${suffix}+tlrc[4]"       \
      -dset 3 12 "S14/S14.pade.results/${stats}.S14.${suffix}+tlrc[7]"       \
      -dset 4 12 "S14/S14.pade.results/${stats}.S14.${suffix}+tlrc[10]"      \
      -dset 5 12 "S14/S14.pade.results/${stats}.S14.${suffix}+tlrc[13]"      \
      -dset 6 12 "S14/S14.pade.results/${stats}.S14.${suffix}+tlrc[16]"      \
      -dset 7 12 "S14/S14.pade.results/${stats}.S14.${suffix}+tlrc[19]"      \
      -dset 8 12 "S14/S14.pade.results/${stats}.S14.${suffix}+tlrc[22]"      \
      -dset 1 13 "S16/S16.pade.results/${stats}.S16.${suffix}+tlrc[1]"       \
      -dset 2 13 "S16/S16.pade.results/${stats}.S16.${suffix}+tlrc[4]"       \
      -dset 3 13 "S16/S16.pade.results/${stats}.S16.${suffix}+tlrc[7]"       \
      -dset 4 13 "S16/S16.pade.results/${stats}.S16.${suffix}+tlrc[10]"      \
      -dset 5 13 "S16/S16.pade.results/${stats}.S16.${suffix}+tlrc[13]"      \
      -dset 6 13 "S16/S16.pade.results/${stats}.S16.${suffix}+tlrc[16]"      \
      -dset 7 13 "S16/S16.pade.results/${stats}.S16.${suffix}+tlrc[19]"      \
      -dset 8 13 "S16/S16.pade.results/${stats}.S16.${suffix}+tlrc[22]"      \
      -amean 1 gas -amean 2 ind -amean 3 ros -amean 4 pin -amean 5 app       \
      -amean 6 min -amean 7 fru -amean 8 flo                                 \
      -adiff 7 8 df_fruflo                                                   \
      -acontr -2 -2 1 1 1 1 0 0 Plea_UnPlea                                  \
      -acontr 0 0 -1 1 1 -1 0 0 pinapp_rosmin                                \
      -acontr 0 0 0 0 0 0 1 -1 Fru_Flo                                       \
      -fa Odors                                                              \
      -bucket group/ANOVA_results
