#! /bin/bash

datafolder=/Volumes/WD_D/allsub/
cd "${datafolder}" || exit
suffix=congru

mask=group/mask/Amy8_align.freesurfer+tlrc

# if anova results exists, delete it
if [ -f group/ANOVA_results+tlrc.HEAD ]; then
      rm group/ANOVA_results+tlrc*
fi
# S03 S04 S05 S06 S07 S08 S11 S14 S15 S16 S19 S21 S22 S23 S24 S25 S26 S27 S28 S29
3dMVM -prefix group/ANOVA_results -jobs 16            \
      -wsVars "face*odor*visib"         \
      -mask ${mask}                  \
      -SS_type 3                          \
      -num_glt 3                         \
      -gltLabel 1 fointer -gltCode  1 'face : 1*fear -1*happy odor : 1*unplea -1*plea'            \
      -gltLabel 2 fointer_vis -gltCode 2 'face : 1*fear -1*happy odor : 1*unplea -1*plea visib: 1*vis'     \
      -gltLabel 3 fointer_inv -gltCode 3 'face : 1*fear -1*happy odor : 1*unplea -1*plea visib: 1*inv' \
      -num_glf 3                         \
      -glfLabel 1 fointer_f -glfCode 1 'face : 1*fear -1*happy odor : 1*unplea -1*plea' \
      -glfLabel 2 f2ointer_f -glfCode 2 'face : 1*fear & 1*happy odor : 1*unplea -1*plea' \
      -glfLabel 3 f2o2inter_f -glfCode 3 'face : 1*fear & 1*happy odor : 1*unplea & 1*plea' \
      -dataTable                                                                                     \
      Subj   face    odor      visib     InputFile                               \
      S03    fear    plea      inv       "S03/analysis/S03.analysis.${suffix}+tlrc[1]"  \
      S03    fear    plea      vis       "S03/analysis/S03.analysis.${suffix}+tlrc[4]"  \
      S03    fear    unplea    inv       "S03/analysis/S03.analysis.${suffix}+tlrc[7]"  \
      S03    fear    unplea    vis       "S03/analysis/S03.analysis.${suffix}+tlrc[10]" \
      S03    happy   plea      inv       "S03/analysis/S03.analysis.${suffix}+tlrc[13]" \
      S03    happy   plea      vis       "S03/analysis/S03.analysis.${suffix}+tlrc[16]" \
      S03    happy   unplea    inv       "S03/analysis/S03.analysis.${suffix}+tlrc[19]" \
      S03    happy   unplea    vis       "S03/analysis/S03.analysis.${suffix}+tlrc[22]" \
      S04    fear    plea      inv       "S04/analysis/S04.analysis.${suffix}+tlrc[1]"  \
      S04    fear    plea      vis       "S04/analysis/S04.analysis.${suffix}+tlrc[4]"  \
      S04    fear    unplea    inv       "S04/analysis/S04.analysis.${suffix}+tlrc[7]"  \
      S04    fear    unplea    vis       "S04/analysis/S04.analysis.${suffix}+tlrc[10]" \
      S04    happy   plea      inv       "S04/analysis/S04.analysis.${suffix}+tlrc[13]" \
      S04    happy   plea      vis       "S04/analysis/S04.analysis.${suffix}+tlrc[16]" \
      S04    happy   unplea    inv       "S04/analysis/S04.analysis.${suffix}+tlrc[19]" \
      S04    happy   unplea    vis       "S04/analysis/S04.analysis.${suffix}+tlrc[22]" \
      S05    fear    plea      inv       "S05/analysis/S05.analysis.${suffix}+tlrc[1]"  \
      S05    fear    plea      vis       "S05/analysis/S05.analysis.${suffix}+tlrc[4]"  \
      S05    fear    unplea    inv       "S05/analysis/S05.analysis.${suffix}+tlrc[7]"  \
      S05    fear    unplea    vis       "S05/analysis/S05.analysis.${suffix}+tlrc[10]" \
      S05    happy   plea      inv       "S05/analysis/S05.analysis.${suffix}+tlrc[13]" \
      S05    happy   plea      vis       "S05/analysis/S05.analysis.${suffix}+tlrc[16]" \
      S05    happy   unplea    inv       "S05/analysis/S05.analysis.${suffix}+tlrc[19]" \
      S05    happy   unplea    vis       "S05/analysis/S05.analysis.${suffix}+tlrc[22]" \
      S06    fear    plea      inv       "S06/analysis/S06.analysis.${suffix}+tlrc[1]"  \
      S06    fear    plea      vis       "S06/analysis/S06.analysis.${suffix}+tlrc[4]"  \
      S06    fear    unplea    inv       "S06/analysis/S06.analysis.${suffix}+tlrc[7]"  \
      S06    fear    unplea    vis       "S06/analysis/S06.analysis.${suffix}+tlrc[10]" \
      S06    happy   plea      inv       "S06/analysis/S06.analysis.${suffix}+tlrc[13]" \
      S06    happy   plea      vis       "S06/analysis/S06.analysis.${suffix}+tlrc[16]" \
      S06    happy   unplea    inv       "S06/analysis/S06.analysis.${suffix}+tlrc[19]" \
      S06    happy   unplea    vis       "S06/analysis/S06.analysis.${suffix}+tlrc[22]" \
      S07    fear    plea      inv       "S07/analysis/S07.analysis.${suffix}+tlrc[1]"  \
      S07    fear    plea      vis       "S07/analysis/S07.analysis.${suffix}+tlrc[4]"  \
      S07    fear    unplea    inv       "S07/analysis/S07.analysis.${suffix}+tlrc[7]"  \
      S07    fear    unplea    vis       "S07/analysis/S07.analysis.${suffix}+tlrc[10]" \
      S07    happy   plea      inv       "S07/analysis/S07.analysis.${suffix}+tlrc[13]" \
      S07    happy   plea      vis       "S07/analysis/S07.analysis.${suffix}+tlrc[16]" \
      S07    happy   unplea    inv       "S07/analysis/S07.analysis.${suffix}+tlrc[19]" \
      S07    happy   unplea    vis       "S07/analysis/S07.analysis.${suffix}+tlrc[22]" \
      S08    fear    plea      inv       "S08/analysis/S08.analysis.${suffix}+tlrc[1]"  \
      S08    fear    plea      vis       "S08/analysis/S08.analysis.${suffix}+tlrc[4]"  \
      S08    fear    unplea    inv       "S08/analysis/S08.analysis.${suffix}+tlrc[7]"  \
      S08    fear    unplea    vis       "S08/analysis/S08.analysis.${suffix}+tlrc[10]" \
      S08    happy   plea      inv       "S08/analysis/S08.analysis.${suffix}+tlrc[13]" \
      S08    happy   plea      vis       "S08/analysis/S08.analysis.${suffix}+tlrc[16]" \
      S08    happy   unplea    inv       "S08/analysis/S08.analysis.${suffix}+tlrc[19]" \
      S08    happy   unplea    vis       "S08/analysis/S08.analysis.${suffix}+tlrc[22]" \
      S11    fear    plea      inv       "S11/analysis/S11.analysis.${suffix}+tlrc[1]"  \
      S11    fear    plea      vis       "S11/analysis/S11.analysis.${suffix}+tlrc[4]"  \
      S11    fear    unplea    inv       "S11/analysis/S11.analysis.${suffix}+tlrc[7]"  \
      S11    fear    unplea    vis       "S11/analysis/S11.analysis.${suffix}+tlrc[10]" \
      S11    happy   plea      inv       "S11/analysis/S11.analysis.${suffix}+tlrc[13]" \
      S11    happy   plea      vis       "S11/analysis/S11.analysis.${suffix}+tlrc[16]" \
      S11    happy   unplea    inv       "S11/analysis/S11.analysis.${suffix}+tlrc[19]" \
      S11    happy   unplea    vis       "S11/analysis/S11.analysis.${suffix}+tlrc[22]" \
      S14    fear    plea      inv       "S14/analysis/S14.analysis.${suffix}+tlrc[1]"  \
      S14    fear    plea      vis       "S14/analysis/S14.analysis.${suffix}+tlrc[4]"  \
      S14    fear    unplea    inv       "S14/analysis/S14.analysis.${suffix}+tlrc[7]"  \
      S14    fear    unplea    vis       "S14/analysis/S14.analysis.${suffix}+tlrc[10]" \
      S14    happy   plea      inv       "S14/analysis/S14.analysis.${suffix}+tlrc[13]" \
      S14    happy   plea      vis       "S14/analysis/S14.analysis.${suffix}+tlrc[16]" \
      S14    happy   unplea    inv       "S14/analysis/S14.analysis.${suffix}+tlrc[19]" \
      S14    happy   unplea    vis       "S14/analysis/S14.analysis.${suffix}+tlrc[22]" \
      S15    fear    plea      inv       "S15/analysis/S15.analysis.${suffix}+tlrc[1]"  \
      S15    fear    plea      vis       "S15/analysis/S15.analysis.${suffix}+tlrc[4]"  \
      S15    fear    unplea    inv       "S15/analysis/S15.analysis.${suffix}+tlrc[7]"  \
      S15    fear    unplea    vis       "S15/analysis/S15.analysis.${suffix}+tlrc[10]" \
      S15    happy   plea      inv       "S15/analysis/S15.analysis.${suffix}+tlrc[13]" \
      S15    happy   plea      vis       "S15/analysis/S15.analysis.${suffix}+tlrc[16]" \
      S15    happy   unplea    inv       "S15/analysis/S15.analysis.${suffix}+tlrc[19]" \
      S15    happy   unplea    vis       "S15/analysis/S15.analysis.${suffix}+tlrc[22]" \
      S16    fear    plea      inv       "S16/analysis/S16.analysis.${suffix}+tlrc[1]"  \
      S16    fear    plea      vis       "S16/analysis/S16.analysis.${suffix}+tlrc[4]"  \
      S16    fear    unplea    inv       "S16/analysis/S16.analysis.${suffix}+tlrc[7]"  \
      S16    fear    unplea    vis       "S16/analysis/S16.analysis.${suffix}+tlrc[10]" \
      S16    happy   plea      inv       "S16/analysis/S16.analysis.${suffix}+tlrc[13]" \
      S16    happy   plea      vis       "S16/analysis/S16.analysis.${suffix}+tlrc[16]" \
      S16    happy   unplea    inv       "S16/analysis/S16.analysis.${suffix}+tlrc[19]" \
      S16    happy   unplea    vis       "S16/analysis/S16.analysis.${suffix}+tlrc[22]" \
      S19    fear    plea      inv       "S19/analysis/S19.analysis.${suffix}+tlrc[1]"  \
      S19    fear    plea      vis       "S19/analysis/S19.analysis.${suffix}+tlrc[4]"  \
      S19    fear    unplea    inv       "S19/analysis/S19.analysis.${suffix}+tlrc[7]"  \
      S19    fear    unplea    vis       "S19/analysis/S19.analysis.${suffix}+tlrc[10]" \
      S19    happy   plea      inv       "S19/analysis/S19.analysis.${suffix}+tlrc[13]" \
      S19    happy   plea      vis       "S19/analysis/S19.analysis.${suffix}+tlrc[16]" \
      S19    happy   unplea    inv       "S19/analysis/S19.analysis.${suffix}+tlrc[19]" \
      S19    happy   unplea    vis       "S19/analysis/S19.analysis.${suffix}+tlrc[22]" \
      S21    fear    plea      inv       "S21/analysis/S21.analysis.${suffix}+tlrc[1]"  \
      S21    fear    plea      vis       "S21/analysis/S21.analysis.${suffix}+tlrc[4]"  \
      S21    fear    unplea    inv       "S21/analysis/S21.analysis.${suffix}+tlrc[7]"  \
      S21    fear    unplea    vis       "S21/analysis/S21.analysis.${suffix}+tlrc[10]" \
      S21    happy   plea      inv       "S21/analysis/S21.analysis.${suffix}+tlrc[13]" \
      S21    happy   plea      vis       "S21/analysis/S21.analysis.${suffix}+tlrc[16]" \
      S21    happy   unplea    inv       "S21/analysis/S21.analysis.${suffix}+tlrc[19]" \
      S21    happy   unplea    vis       "S21/analysis/S21.analysis.${suffix}+tlrc[22]" \
      S22    fear    plea      inv       "S22/analysis/S22.analysis.${suffix}+tlrc[1]"  \
      S22    fear    plea      vis       "S22/analysis/S22.analysis.${suffix}+tlrc[4]"  \
      S22    fear    unplea    inv       "S22/analysis/S22.analysis.${suffix}+tlrc[7]"  \
      S22    fear    unplea    vis       "S22/analysis/S22.analysis.${suffix}+tlrc[10]" \
      S22    happy   plea      inv       "S22/analysis/S22.analysis.${suffix}+tlrc[13]" \
      S22    happy   plea      vis       "S22/analysis/S22.analysis.${suffix}+tlrc[16]" \
      S22    happy   unplea    inv       "S22/analysis/S22.analysis.${suffix}+tlrc[19]" \
      S22    happy   unplea    vis       "S22/analysis/S22.analysis.${suffix}+tlrc[22]" \
      S23    fear    plea      inv       "S23/analysis/S23.analysis.${suffix}+tlrc[1]"  \
      S23    fear    plea      vis       "S23/analysis/S23.analysis.${suffix}+tlrc[4]"  \
      S23    fear    unplea    inv       "S23/analysis/S23.analysis.${suffix}+tlrc[7]"  \
      S23    fear    unplea    vis       "S23/analysis/S23.analysis.${suffix}+tlrc[10]" \
      S23    happy   plea      inv       "S23/analysis/S23.analysis.${suffix}+tlrc[13]" \
      S23    happy   plea      vis       "S23/analysis/S23.analysis.${suffix}+tlrc[16]" \
      S23    happy   unplea    inv       "S23/analysis/S23.analysis.${suffix}+tlrc[19]" \
      S23    happy   unplea    vis       "S23/analysis/S23.analysis.${suffix}+tlrc[22]" \
      S24    fear    plea      inv       "S24/analysis/S24.analysis.${suffix}+tlrc[1]"  \
      S24    fear    plea      vis       "S24/analysis/S24.analysis.${suffix}+tlrc[4]"  \
      S24    fear    unplea    inv       "S24/analysis/S24.analysis.${suffix}+tlrc[7]"  \
      S24    fear    unplea    vis       "S24/analysis/S24.analysis.${suffix}+tlrc[10]" \
      S24    happy   plea      inv       "S24/analysis/S24.analysis.${suffix}+tlrc[13]" \
      S24    happy   plea      vis       "S24/analysis/S24.analysis.${suffix}+tlrc[16]" \
      S24    happy   unplea    inv       "S24/analysis/S24.analysis.${suffix}+tlrc[19]" \
      S24    happy   unplea    vis       "S24/analysis/S24.analysis.${suffix}+tlrc[22]" \
      S25    fear    plea      inv       "S25/analysis/S25.analysis.${suffix}+tlrc[1]"  \
      S25    fear    plea      vis       "S25/analysis/S25.analysis.${suffix}+tlrc[4]"  \
      S25    fear    unplea    inv       "S25/analysis/S25.analysis.${suffix}+tlrc[7]"  \
      S25    fear    unplea    vis       "S25/analysis/S25.analysis.${suffix}+tlrc[10]" \
      S25    happy   plea      inv       "S25/analysis/S25.analysis.${suffix}+tlrc[13]" \
      S25    happy   plea      vis       "S25/analysis/S25.analysis.${suffix}+tlrc[16]" \
      S25    happy   unplea    inv       "S25/analysis/S25.analysis.${suffix}+tlrc[19]" \
      S25    happy   unplea    vis       "S25/analysis/S25.analysis.${suffix}+tlrc[22]" \
      S26    fear    plea      inv       "S26/analysis/S26.analysis.${suffix}+tlrc[1]"  \
      S26    fear    plea      vis       "S26/analysis/S26.analysis.${suffix}+tlrc[4]"  \
      S26    fear    unplea    inv       "S26/analysis/S26.analysis.${suffix}+tlrc[7]"  \
      S26    fear    unplea    vis       "S26/analysis/S26.analysis.${suffix}+tlrc[10]" \
      S26    happy   plea      inv       "S26/analysis/S26.analysis.${suffix}+tlrc[13]" \
      S26    happy   plea      vis       "S26/analysis/S26.analysis.${suffix}+tlrc[16]" \
      S26    happy   unplea    inv       "S26/analysis/S26.analysis.${suffix}+tlrc[19]" \
      S26    happy   unplea    vis       "S26/analysis/S26.analysis.${suffix}+tlrc[22]" \
      S27    fear    plea      inv       "S27/analysis/S27.analysis.${suffix}+tlrc[1]"  \
      S27    fear    plea      vis       "S27/analysis/S27.analysis.${suffix}+tlrc[4]"  \
      S27    fear    unplea    inv       "S27/analysis/S27.analysis.${suffix}+tlrc[7]"  \
      S27    fear    unplea    vis       "S27/analysis/S27.analysis.${suffix}+tlrc[10]" \
      S27    happy   plea      inv       "S27/analysis/S27.analysis.${suffix}+tlrc[13]" \
      S27    happy   plea      vis       "S27/analysis/S27.analysis.${suffix}+tlrc[16]" \
      S27    happy   unplea    inv       "S27/analysis/S27.analysis.${suffix}+tlrc[19]" \
      S27    happy   unplea    vis       "S27/analysis/S27.analysis.${suffix}+tlrc[22]" \
      S28    fear    plea      inv       "S28/analysis/S28.analysis.${suffix}+tlrc[1]"  \
      S28    fear    plea      vis       "S28/analysis/S28.analysis.${suffix}+tlrc[4]"  \
      S28    fear    unplea    inv       "S28/analysis/S28.analysis.${suffix}+tlrc[7]"  \
      S28    fear    unplea    vis       "S28/analysis/S28.analysis.${suffix}+tlrc[10]" \
      S28    happy   plea      inv       "S28/analysis/S28.analysis.${suffix}+tlrc[13]" \
      S28    happy   plea      vis       "S28/analysis/S28.analysis.${suffix}+tlrc[16]" \
      S28    happy   unplea    inv       "S28/analysis/S28.analysis.${suffix}+tlrc[19]" \
      S28    happy   unplea    vis       "S28/analysis/S28.analysis.${suffix}+tlrc[22]" \
      S29    fear    plea      inv       "S29/analysis/S29.analysis.${suffix}+tlrc[1]"  \
      S29    fear    plea      vis       "S29/analysis/S29.analysis.${suffix}+tlrc[4]"  \
      S29    fear    unplea    inv       "S29/analysis/S29.analysis.${suffix}+tlrc[7]"  \
      S29    fear    unplea    vis       "S29/analysis/S29.analysis.${suffix}+tlrc[10]" \
      S29    happy   plea      inv       "S29/analysis/S29.analysis.${suffix}+tlrc[13]" \
      S29    happy   plea      vis       "S29/analysis/S29.analysis.${suffix}+tlrc[16]" \
      S29    happy   unplea    inv       "S29/analysis/S29.analysis.${suffix}+tlrc[19]" \
      S29    happy   unplea    vis       "S29/analysis/S29.analysis.${suffix}+tlrc[22]" 
