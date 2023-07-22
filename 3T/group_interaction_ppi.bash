#! /bin/bash

# datafolder=/Volumes/WD_D/allsub/
datafolder=/Volumes/WD_F/gufei/3T_cw/
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
      suffix=de
      outsuffix=${out}
fi
# if anova results exists, delete it
if [ -f group/ANOVA_ppi_${outsuffix}+tlrc.HEAD ]; then
      rm group/ANOVA_ppi_${outsuffix}+tlrc*
fi
# ANOVA
3dMVM -prefix group/ANOVA_ppi_${outsuffix} -jobs 28            \
      -wsVars "face*odor*visib"         \
      -mask ${mask}                  \
      -SS_type 3                          \
      -num_glt 7                         \
      -resid   group/errs.ppi.${outsuffix} \
      -gltLabel 1 fointer -gltCode  1 'face : 1*fear -1*happy odor : 1*unplea -1*plea'            \
      -gltLabel 2 fointer_vis -gltCode 2 'face : 1*fear -1*happy odor : 1*unplea -1*plea visib: 1*vis'     \
      -gltLabel 3 fointer_inv -gltCode 3 'face : 1*fear -1*happy odor : 1*unplea -1*plea visib: 1*inv' \
      -gltLabel 4 face_vis -gltCode 4 'face : 1*fear -1*happy visib: 1*vis' \
      -gltLabel 5 face_inv -gltCode 5 'face : 1*fear -1*happy visib: 1*inv' \
      -gltLabel 6 odor_vis -gltCode 6 'odor : 1*unplea -1*plea visib: 1*vis' \
      -gltLabel 7 odor_inv -gltCode 7 'odor : 1*unplea -1*plea visib: 1*inv' \
      -dataTable                                                                                     \
      Subj   face    odor      visib     InputFile                               \
      S03    fear    plea      vis       "S03/S03.de.results/ppi.S03.${suffix}+tlrc[25]"  \
      S03    fear    plea      inv       "S03/S03.de.results/ppi.S03.${suffix}+tlrc[28]"  \
      S03    fear    unplea    vis       "S03/S03.de.results/ppi.S03.${suffix}+tlrc[31]"  \
      S03    fear    unplea    inv       "S03/S03.de.results/ppi.S03.${suffix}+tlrc[34]" \
      S03    happy   plea      vis       "S03/S03.de.results/ppi.S03.${suffix}+tlrc[37]" \
      S03    happy   plea      inv       "S03/S03.de.results/ppi.S03.${suffix}+tlrc[40]" \
      S03    happy   unplea    vis       "S03/S03.de.results/ppi.S03.${suffix}+tlrc[43]" \
      S03    happy   unplea    inv       "S03/S03.de.results/ppi.S03.${suffix}+tlrc[46]" \
      S04    fear    plea      vis       "S04/S04.de.results/ppi.S04.${suffix}+tlrc[25]"  \
      S04    fear    plea      inv       "S04/S04.de.results/ppi.S04.${suffix}+tlrc[28]"  \
      S04    fear    unplea    vis       "S04/S04.de.results/ppi.S04.${suffix}+tlrc[31]"  \
      S04    fear    unplea    inv       "S04/S04.de.results/ppi.S04.${suffix}+tlrc[34]" \
      S04    happy   plea      vis       "S04/S04.de.results/ppi.S04.${suffix}+tlrc[37]" \
      S04    happy   plea      inv       "S04/S04.de.results/ppi.S04.${suffix}+tlrc[40]" \
      S04    happy   unplea    vis       "S04/S04.de.results/ppi.S04.${suffix}+tlrc[43]" \
      S04    happy   unplea    inv       "S04/S04.de.results/ppi.S04.${suffix}+tlrc[46]" \
      S05    fear    plea      vis       "S05/S05.de.results/ppi.S05.${suffix}+tlrc[25]"  \
      S05    fear    plea      inv       "S05/S05.de.results/ppi.S05.${suffix}+tlrc[28]"  \
      S05    fear    unplea    vis       "S05/S05.de.results/ppi.S05.${suffix}+tlrc[31]"  \
      S05    fear    unplea    inv       "S05/S05.de.results/ppi.S05.${suffix}+tlrc[34]" \
      S05    happy   plea      vis       "S05/S05.de.results/ppi.S05.${suffix}+tlrc[37]" \
      S05    happy   plea      inv       "S05/S05.de.results/ppi.S05.${suffix}+tlrc[40]" \
      S05    happy   unplea    vis       "S05/S05.de.results/ppi.S05.${suffix}+tlrc[43]" \
      S05    happy   unplea    inv       "S05/S05.de.results/ppi.S05.${suffix}+tlrc[46]" \
      S06    fear    plea      vis       "S06/S06.de.results/ppi.S06.${suffix}+tlrc[25]"  \
      S06    fear    plea      inv       "S06/S06.de.results/ppi.S06.${suffix}+tlrc[28]"  \
      S06    fear    unplea    vis       "S06/S06.de.results/ppi.S06.${suffix}+tlrc[31]"  \
      S06    fear    unplea    inv       "S06/S06.de.results/ppi.S06.${suffix}+tlrc[34]" \
      S06    happy   plea      vis       "S06/S06.de.results/ppi.S06.${suffix}+tlrc[37]" \
      S06    happy   plea      inv       "S06/S06.de.results/ppi.S06.${suffix}+tlrc[40]" \
      S06    happy   unplea    vis       "S06/S06.de.results/ppi.S06.${suffix}+tlrc[43]" \
      S06    happy   unplea    inv       "S06/S06.de.results/ppi.S06.${suffix}+tlrc[46]" \
      S07    fear    plea      vis       "S07/S07.de.results/ppi.S07.${suffix}+tlrc[25]"  \
      S07    fear    plea      inv       "S07/S07.de.results/ppi.S07.${suffix}+tlrc[28]"  \
      S07    fear    unplea    vis       "S07/S07.de.results/ppi.S07.${suffix}+tlrc[31]"  \
      S07    fear    unplea    inv       "S07/S07.de.results/ppi.S07.${suffix}+tlrc[34]" \
      S07    happy   plea      vis       "S07/S07.de.results/ppi.S07.${suffix}+tlrc[37]" \
      S07    happy   plea      inv       "S07/S07.de.results/ppi.S07.${suffix}+tlrc[40]" \
      S07    happy   unplea    vis       "S07/S07.de.results/ppi.S07.${suffix}+tlrc[43]" \
      S07    happy   unplea    inv       "S07/S07.de.results/ppi.S07.${suffix}+tlrc[46]" \
      S08    fear    plea      vis       "S08/S08.de.results/ppi.S08.${suffix}+tlrc[25]"  \
      S08    fear    plea      inv       "S08/S08.de.results/ppi.S08.${suffix}+tlrc[28]"  \
      S08    fear    unplea    vis       "S08/S08.de.results/ppi.S08.${suffix}+tlrc[31]"  \
      S08    fear    unplea    inv       "S08/S08.de.results/ppi.S08.${suffix}+tlrc[34]" \
      S08    happy   plea      vis       "S08/S08.de.results/ppi.S08.${suffix}+tlrc[37]" \
      S08    happy   plea      inv       "S08/S08.de.results/ppi.S08.${suffix}+tlrc[40]" \
      S08    happy   unplea    vis       "S08/S08.de.results/ppi.S08.${suffix}+tlrc[43]" \
      S08    happy   unplea    inv       "S08/S08.de.results/ppi.S08.${suffix}+tlrc[46]" \
      S09    fear    plea      vis       "S09/S09.de.results/ppi.S09.${suffix}+tlrc[25]"  \
      S09    fear    plea      inv       "S09/S09.de.results/ppi.S09.${suffix}+tlrc[28]"  \
      S09    fear    unplea    vis       "S09/S09.de.results/ppi.S09.${suffix}+tlrc[31]"  \
      S09    fear    unplea    inv       "S09/S09.de.results/ppi.S09.${suffix}+tlrc[34]" \
      S09    happy   plea      vis       "S09/S09.de.results/ppi.S09.${suffix}+tlrc[37]" \
      S09    happy   plea      inv       "S09/S09.de.results/ppi.S09.${suffix}+tlrc[40]" \
      S09    happy   unplea    vis       "S09/S09.de.results/ppi.S09.${suffix}+tlrc[43]" \
      S09    happy   unplea    inv       "S09/S09.de.results/ppi.S09.${suffix}+tlrc[46]" \
      S10    fear    plea      vis       "S10/S10.de.results/ppi.S10.${suffix}+tlrc[25]"  \
      S10    fear    plea      inv       "S10/S10.de.results/ppi.S10.${suffix}+tlrc[28]"  \
      S10    fear    unplea    vis       "S10/S10.de.results/ppi.S10.${suffix}+tlrc[31]"  \
      S10    fear    unplea    inv       "S10/S10.de.results/ppi.S10.${suffix}+tlrc[34]" \
      S10    happy   plea      vis       "S10/S10.de.results/ppi.S10.${suffix}+tlrc[37]" \
      S10    happy   plea      inv       "S10/S10.de.results/ppi.S10.${suffix}+tlrc[40]" \
      S10    happy   unplea    vis       "S10/S10.de.results/ppi.S10.${suffix}+tlrc[43]" \
      S10    happy   unplea    inv       "S10/S10.de.results/ppi.S10.${suffix}+tlrc[46]" \
      S11    fear    plea      vis       "S11/S11.de.results/ppi.S11.${suffix}+tlrc[25]"  \
      S11    fear    plea      inv       "S11/S11.de.results/ppi.S11.${suffix}+tlrc[28]"  \
      S11    fear    unplea    vis       "S11/S11.de.results/ppi.S11.${suffix}+tlrc[31]"  \
      S11    fear    unplea    inv       "S11/S11.de.results/ppi.S11.${suffix}+tlrc[34]" \
      S11    happy   plea      vis       "S11/S11.de.results/ppi.S11.${suffix}+tlrc[37]" \
      S11    happy   plea      inv       "S11/S11.de.results/ppi.S11.${suffix}+tlrc[40]" \
      S11    happy   unplea    vis       "S11/S11.de.results/ppi.S11.${suffix}+tlrc[43]" \
      S11    happy   unplea    inv       "S11/S11.de.results/ppi.S11.${suffix}+tlrc[46]" \
      S12    fear    plea      vis       "S12/S12.de.results/ppi.S12.${suffix}+tlrc[25]"  \
      S12    fear    plea      inv       "S12/S12.de.results/ppi.S12.${suffix}+tlrc[28]"  \
      S12    fear    unplea    vis       "S12/S12.de.results/ppi.S12.${suffix}+tlrc[31]"  \
      S12    fear    unplea    inv       "S12/S12.de.results/ppi.S12.${suffix}+tlrc[34]" \
      S12    happy   plea      vis       "S12/S12.de.results/ppi.S12.${suffix}+tlrc[37]" \
      S12    happy   plea      inv       "S12/S12.de.results/ppi.S12.${suffix}+tlrc[40]" \
      S12    happy   unplea    vis       "S12/S12.de.results/ppi.S12.${suffix}+tlrc[43]" \
      S12    happy   unplea    inv       "S12/S12.de.results/ppi.S12.${suffix}+tlrc[46]" \
      S13    fear    plea      vis       "S13/S13.de.results/ppi.S13.${suffix}+tlrc[25]"  \
      S13    fear    plea      inv       "S13/S13.de.results/ppi.S13.${suffix}+tlrc[28]"  \
      S13    fear    unplea    vis       "S13/S13.de.results/ppi.S13.${suffix}+tlrc[31]"  \
      S13    fear    unplea    inv       "S13/S13.de.results/ppi.S13.${suffix}+tlrc[34]" \
      S13    happy   plea      vis       "S13/S13.de.results/ppi.S13.${suffix}+tlrc[37]" \
      S13    happy   plea      inv       "S13/S13.de.results/ppi.S13.${suffix}+tlrc[40]" \
      S13    happy   unplea    vis       "S13/S13.de.results/ppi.S13.${suffix}+tlrc[43]" \
      S13    happy   unplea    inv       "S13/S13.de.results/ppi.S13.${suffix}+tlrc[46]" \
      S14    fear    plea      vis       "S14/S14.de.results/ppi.S14.${suffix}+tlrc[25]"  \
      S14    fear    plea      inv       "S14/S14.de.results/ppi.S14.${suffix}+tlrc[28]"  \
      S14    fear    unplea    vis       "S14/S14.de.results/ppi.S14.${suffix}+tlrc[31]"  \
      S14    fear    unplea    inv       "S14/S14.de.results/ppi.S14.${suffix}+tlrc[34]" \
      S14    happy   plea      vis       "S14/S14.de.results/ppi.S14.${suffix}+tlrc[37]" \
      S14    happy   plea      inv       "S14/S14.de.results/ppi.S14.${suffix}+tlrc[40]" \
      S14    happy   unplea    vis       "S14/S14.de.results/ppi.S14.${suffix}+tlrc[43]" \
      S14    happy   unplea    inv       "S14/S14.de.results/ppi.S14.${suffix}+tlrc[46]" \
      S15    fear    plea      vis       "S15/S15.de.results/ppi.S15.${suffix}+tlrc[25]"  \
      S15    fear    plea      inv       "S15/S15.de.results/ppi.S15.${suffix}+tlrc[28]"  \
      S15    fear    unplea    vis       "S15/S15.de.results/ppi.S15.${suffix}+tlrc[31]"  \
      S15    fear    unplea    inv       "S15/S15.de.results/ppi.S15.${suffix}+tlrc[34]" \
      S15    happy   plea      vis       "S15/S15.de.results/ppi.S15.${suffix}+tlrc[37]" \
      S15    happy   plea      inv       "S15/S15.de.results/ppi.S15.${suffix}+tlrc[40]" \
      S15    happy   unplea    vis       "S15/S15.de.results/ppi.S15.${suffix}+tlrc[43]" \
      S15    happy   unplea    inv       "S15/S15.de.results/ppi.S15.${suffix}+tlrc[46]" \
      S16    fear    plea      vis       "S16/S16.de.results/ppi.S16.${suffix}+tlrc[25]"  \
      S16    fear    plea      inv       "S16/S16.de.results/ppi.S16.${suffix}+tlrc[28]"  \
      S16    fear    unplea    vis       "S16/S16.de.results/ppi.S16.${suffix}+tlrc[31]"  \
      S16    fear    unplea    inv       "S16/S16.de.results/ppi.S16.${suffix}+tlrc[34]" \
      S16    happy   plea      vis       "S16/S16.de.results/ppi.S16.${suffix}+tlrc[37]" \
      S16    happy   plea      inv       "S16/S16.de.results/ppi.S16.${suffix}+tlrc[40]" \
      S16    happy   unplea    vis       "S16/S16.de.results/ppi.S16.${suffix}+tlrc[43]" \
      S16    happy   unplea    inv       "S16/S16.de.results/ppi.S16.${suffix}+tlrc[46]" \
      S17    fear    plea      vis       "S17/S17.de.results/ppi.S17.${suffix}+tlrc[25]"  \
      S17    fear    plea      inv       "S17/S17.de.results/ppi.S17.${suffix}+tlrc[28]"  \
      S17    fear    unplea    vis       "S17/S17.de.results/ppi.S17.${suffix}+tlrc[31]"  \
      S17    fear    unplea    inv       "S17/S17.de.results/ppi.S17.${suffix}+tlrc[34]" \
      S17    happy   plea      vis       "S17/S17.de.results/ppi.S17.${suffix}+tlrc[37]" \
      S17    happy   plea      inv       "S17/S17.de.results/ppi.S17.${suffix}+tlrc[40]" \
      S17    happy   unplea    vis       "S17/S17.de.results/ppi.S17.${suffix}+tlrc[43]" \
      S17    happy   unplea    inv       "S17/S17.de.results/ppi.S17.${suffix}+tlrc[46]" \
      S18    fear    plea      vis       "S18/S18.de.results/ppi.S18.${suffix}+tlrc[25]"  \
      S18    fear    plea      inv       "S18/S18.de.results/ppi.S18.${suffix}+tlrc[28]"  \
      S18    fear    unplea    vis       "S18/S18.de.results/ppi.S18.${suffix}+tlrc[31]"  \
      S18    fear    unplea    inv       "S18/S18.de.results/ppi.S18.${suffix}+tlrc[34]" \
      S18    happy   plea      vis       "S18/S18.de.results/ppi.S18.${suffix}+tlrc[37]" \
      S18    happy   plea      inv       "S18/S18.de.results/ppi.S18.${suffix}+tlrc[40]" \
      S18    happy   unplea    vis       "S18/S18.de.results/ppi.S18.${suffix}+tlrc[43]" \
      S18    happy   unplea    inv       "S18/S18.de.results/ppi.S18.${suffix}+tlrc[46]" \
      S19    fear    plea      vis       "S19/S19.de.results/ppi.S19.${suffix}+tlrc[25]"  \
      S19    fear    plea      inv       "S19/S19.de.results/ppi.S19.${suffix}+tlrc[28]"  \
      S19    fear    unplea    vis       "S19/S19.de.results/ppi.S19.${suffix}+tlrc[31]"  \
      S19    fear    unplea    inv       "S19/S19.de.results/ppi.S19.${suffix}+tlrc[34]" \
      S19    happy   plea      vis       "S19/S19.de.results/ppi.S19.${suffix}+tlrc[37]" \
      S19    happy   plea      inv       "S19/S19.de.results/ppi.S19.${suffix}+tlrc[40]" \
      S19    happy   unplea    vis       "S19/S19.de.results/ppi.S19.${suffix}+tlrc[43]" \
      S19    happy   unplea    inv       "S19/S19.de.results/ppi.S19.${suffix}+tlrc[46]" \
      S20    fear    plea      vis       "S20/S20.de.results/ppi.S20.${suffix}+tlrc[25]"  \
      S20    fear    plea      inv       "S20/S20.de.results/ppi.S20.${suffix}+tlrc[28]"  \
      S20    fear    unplea    vis       "S20/S20.de.results/ppi.S20.${suffix}+tlrc[31]"  \
      S20    fear    unplea    inv       "S20/S20.de.results/ppi.S20.${suffix}+tlrc[34]" \
      S20    happy   plea      vis       "S20/S20.de.results/ppi.S20.${suffix}+tlrc[37]" \
      S20    happy   plea      inv       "S20/S20.de.results/ppi.S20.${suffix}+tlrc[40]" \
      S20    happy   unplea    vis       "S20/S20.de.results/ppi.S20.${suffix}+tlrc[43]" \
      S20    happy   unplea    inv       "S20/S20.de.results/ppi.S20.${suffix}+tlrc[46]" \
      S21    fear    plea      vis       "S21/S21.de.results/ppi.S21.${suffix}+tlrc[25]"  \
      S21    fear    plea      inv       "S21/S21.de.results/ppi.S21.${suffix}+tlrc[28]"  \
      S21    fear    unplea    vis       "S21/S21.de.results/ppi.S21.${suffix}+tlrc[31]"  \
      S21    fear    unplea    inv       "S21/S21.de.results/ppi.S21.${suffix}+tlrc[34]" \
      S21    happy   plea      vis       "S21/S21.de.results/ppi.S21.${suffix}+tlrc[37]" \
      S21    happy   plea      inv       "S21/S21.de.results/ppi.S21.${suffix}+tlrc[40]" \
      S21    happy   unplea    vis       "S21/S21.de.results/ppi.S21.${suffix}+tlrc[43]" \
      S21    happy   unplea    inv       "S21/S21.de.results/ppi.S21.${suffix}+tlrc[46]" \
      S22    fear    plea      vis       "S22/S22.de.results/ppi.S22.${suffix}+tlrc[25]"  \
      S22    fear    plea      inv       "S22/S22.de.results/ppi.S22.${suffix}+tlrc[28]"  \
      S22    fear    unplea    vis       "S22/S22.de.results/ppi.S22.${suffix}+tlrc[31]"  \
      S22    fear    unplea    inv       "S22/S22.de.results/ppi.S22.${suffix}+tlrc[34]" \
      S22    happy   plea      vis       "S22/S22.de.results/ppi.S22.${suffix}+tlrc[37]" \
      S22    happy   plea      inv       "S22/S22.de.results/ppi.S22.${suffix}+tlrc[40]" \
      S22    happy   unplea    vis       "S22/S22.de.results/ppi.S22.${suffix}+tlrc[43]" \
      S22    happy   unplea    inv       "S22/S22.de.results/ppi.S22.${suffix}+tlrc[46]" \
      S23    fear    plea      vis       "S23/S23.de.results/ppi.S23.${suffix}+tlrc[25]"  \
      S23    fear    plea      inv       "S23/S23.de.results/ppi.S23.${suffix}+tlrc[28]"  \
      S23    fear    unplea    vis       "S23/S23.de.results/ppi.S23.${suffix}+tlrc[31]"  \
      S23    fear    unplea    inv       "S23/S23.de.results/ppi.S23.${suffix}+tlrc[34]" \
      S23    happy   plea      vis       "S23/S23.de.results/ppi.S23.${suffix}+tlrc[37]" \
      S23    happy   plea      inv       "S23/S23.de.results/ppi.S23.${suffix}+tlrc[40]" \
      S23    happy   unplea    vis       "S23/S23.de.results/ppi.S23.${suffix}+tlrc[43]" \
      S23    happy   unplea    inv       "S23/S23.de.results/ppi.S23.${suffix}+tlrc[46]" \
      S24    fear    plea      vis       "S24/S24.de.results/ppi.S24.${suffix}+tlrc[25]"  \
      S24    fear    plea      inv       "S24/S24.de.results/ppi.S24.${suffix}+tlrc[28]"  \
      S24    fear    unplea    vis       "S24/S24.de.results/ppi.S24.${suffix}+tlrc[31]"  \
      S24    fear    unplea    inv       "S24/S24.de.results/ppi.S24.${suffix}+tlrc[34]" \
      S24    happy   plea      vis       "S24/S24.de.results/ppi.S24.${suffix}+tlrc[37]" \
      S24    happy   plea      inv       "S24/S24.de.results/ppi.S24.${suffix}+tlrc[40]" \
      S24    happy   unplea    vis       "S24/S24.de.results/ppi.S24.${suffix}+tlrc[43]" \
      S24    happy   unplea    inv       "S24/S24.de.results/ppi.S24.${suffix}+tlrc[46]" \
      S25    fear    plea      vis       "S25/S25.de.results/ppi.S25.${suffix}+tlrc[25]"  \
      S25    fear    plea      inv       "S25/S25.de.results/ppi.S25.${suffix}+tlrc[28]"  \
      S25    fear    unplea    vis       "S25/S25.de.results/ppi.S25.${suffix}+tlrc[31]"  \
      S25    fear    unplea    inv       "S25/S25.de.results/ppi.S25.${suffix}+tlrc[34]" \
      S25    happy   plea      vis       "S25/S25.de.results/ppi.S25.${suffix}+tlrc[37]" \
      S25    happy   plea      inv       "S25/S25.de.results/ppi.S25.${suffix}+tlrc[40]" \
      S25    happy   unplea    vis       "S25/S25.de.results/ppi.S25.${suffix}+tlrc[43]" \
      S25    happy   unplea    inv       "S25/S25.de.results/ppi.S25.${suffix}+tlrc[46]" \
      S26    fear    plea      vis       "S26/S26.de.results/ppi.S26.${suffix}+tlrc[25]"  \
      S26    fear    plea      inv       "S26/S26.de.results/ppi.S26.${suffix}+tlrc[28]"  \
      S26    fear    unplea    vis       "S26/S26.de.results/ppi.S26.${suffix}+tlrc[31]"  \
      S26    fear    unplea    inv       "S26/S26.de.results/ppi.S26.${suffix}+tlrc[34]" \
      S26    happy   plea      vis       "S26/S26.de.results/ppi.S26.${suffix}+tlrc[37]" \
      S26    happy   plea      inv       "S26/S26.de.results/ppi.S26.${suffix}+tlrc[40]" \
      S26    happy   unplea    vis       "S26/S26.de.results/ppi.S26.${suffix}+tlrc[43]" \
      S26    happy   unplea    inv       "S26/S26.de.results/ppi.S26.${suffix}+tlrc[46]" \
      S27    fear    plea      vis       "S27/S27.de.results/ppi.S27.${suffix}+tlrc[25]"  \
      S27    fear    plea      inv       "S27/S27.de.results/ppi.S27.${suffix}+tlrc[28]"  \
      S27    fear    unplea    vis       "S27/S27.de.results/ppi.S27.${suffix}+tlrc[31]"  \
      S27    fear    unplea    inv       "S27/S27.de.results/ppi.S27.${suffix}+tlrc[34]" \
      S27    happy   plea      vis       "S27/S27.de.results/ppi.S27.${suffix}+tlrc[37]" \
      S27    happy   plea      inv       "S27/S27.de.results/ppi.S27.${suffix}+tlrc[40]" \
      S27    happy   unplea    vis       "S27/S27.de.results/ppi.S27.${suffix}+tlrc[43]" \
      S27    happy   unplea    inv       "S27/S27.de.results/ppi.S27.${suffix}+tlrc[46]" \
      S28    fear    plea      vis       "S28/S28.de.results/ppi.S28.${suffix}+tlrc[25]"  \
      S28    fear    plea      inv       "S28/S28.de.results/ppi.S28.${suffix}+tlrc[28]"  \
      S28    fear    unplea    vis       "S28/S28.de.results/ppi.S28.${suffix}+tlrc[31]"  \
      S28    fear    unplea    inv       "S28/S28.de.results/ppi.S28.${suffix}+tlrc[34]" \
      S28    happy   plea      vis       "S28/S28.de.results/ppi.S28.${suffix}+tlrc[37]" \
      S28    happy   plea      inv       "S28/S28.de.results/ppi.S28.${suffix}+tlrc[40]" \
      S28    happy   unplea    vis       "S28/S28.de.results/ppi.S28.${suffix}+tlrc[43]" \
      S28    happy   unplea    inv       "S28/S28.de.results/ppi.S28.${suffix}+tlrc[46]" \
      S29    fear    plea      vis       "S29/S29.de.results/ppi.S29.${suffix}+tlrc[25]"  \
      S29    fear    plea      inv       "S29/S29.de.results/ppi.S29.${suffix}+tlrc[28]"  \
      S29    fear    unplea    vis       "S29/S29.de.results/ppi.S29.${suffix}+tlrc[31]"  \
      S29    fear    unplea    inv       "S29/S29.de.results/ppi.S29.${suffix}+tlrc[34]" \
      S29    happy   plea      vis       "S29/S29.de.results/ppi.S29.${suffix}+tlrc[37]" \
      S29    happy   plea      inv       "S29/S29.de.results/ppi.S29.${suffix}+tlrc[40]" \
      S29    happy   unplea    vis       "S29/S29.de.results/ppi.S29.${suffix}+tlrc[43]" \
      S29    happy   unplea    inv       "S29/S29.de.results/ppi.S29.${suffix}+tlrc[46]" 
