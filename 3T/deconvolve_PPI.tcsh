#!/bin/tcsh
# set sub=S01_yyt
if ( $# > 0 ) then
set sub = $1
set analysis=de
set datafolder=/Volumes/WD_F/gufei/3T_cw/${sub}
cd "${datafolder}"

# run the regression analysis
set subj = ${sub}.${analysis}
cd ${subj}.results
# deconvolve
set filedec = new
set seed = ${subj}.${filedec}
# remove existing files
rm ppi.${seed}*
set pb = `ls pb0?.*.r01.scale+orig.HEAD | cut -d . -f1`
3dDeconvolve -input ${pb}.$subj.r*.scale+orig.HEAD             \
    -censor motion_${subj}_censor.1D                           \
    -ortvec mot_demean.r01.1D mot_demean_r01                   \
    -ortvec mot_demean.r02.1D mot_demean_r02                   \
    -ortvec mot_demean.r03.1D mot_demean_r03                   \
    -ortvec mot_demean.r04.1D mot_demean_r04                   \
    -ortvec mot_demean.r05.1D mot_demean_r05                   \
    -polort 3 -float -jobs 28                                   \
    -num_stimts 17                                              \
    -stim_times 1 ../behavior/FearPleaVis.txt 'BLOCK(10,1)'        \
    -stim_label 1 FearPleaVis                                  \
    -stim_times 2 ../behavior/FearPleaInv.txt 'BLOCK(10,1)'        \
    -stim_label 2 FearPleaInv                                  \
    -stim_times 3 ../behavior/FearUnpleaVis.txt 'BLOCK(10,1)'      \
    -stim_label 3 FearUnpleaVis                                \
    -stim_times 4 ../behavior/FearUnpleaInv.txt 'BLOCK(10,1)'      \
    -stim_label 4 FearUnpleaInv                                \
    -stim_times 5 ../behavior/HappPleaVis.txt 'BLOCK(10,1)'        \
    -stim_label 5 HappPleaVis                                  \
    -stim_times 6 ../behavior/HappPleaInv.txt 'BLOCK(10,1)'        \
    -stim_label 6 HappPleaInv                                  \
    -stim_times 7 ../behavior/HappUnpleaVis.txt 'BLOCK(10,1)'      \
    -stim_label 7 HappUnpleaVis                                \
    -stim_times 8 ../behavior/HappUnpleaInv.txt 'BLOCK(10,1)'      \
    -stim_label 8 HappUnpleaInv                                \
    -stim_file 9 ppi/p6.$seed.01.FearPleaVis.rall.PPI.1D                   \
    -stim_label 9 PPI.FearPleaVis                                             \
    -stim_file 10 ppi/p6.$seed.02.FearPleaInv.rall.PPI.1D                   \
    -stim_label 10 PPI.FearPleaInv                                             \
    -stim_file 11 ppi/p6.$seed.03.FearUnpleaVis.rall.PPI.1D                   \
    -stim_label 11 PPI.FearUnpleaVis                                             \
    -stim_file 12 ppi/p6.$seed.04.FearUnpleaInv.rall.PPI.1D                   \
    -stim_label 12 PPI.FearUnpleaInv                                             \
    -stim_file 13 ppi/p6.$seed.05.HappPleaVis.rall.PPI.1D                   \
    -stim_label 13 PPI.HappPleaVis                                            \
    -stim_file 14 ppi/p6.$seed.06.HappPleaInv.rall.PPI.1D                   \
    -stim_label 14 PPI.HappPleaInv                                             \
    -stim_file 15 ppi/p6.$seed.07.HappUnpleaVis.rall.PPI.1D                   \
    -stim_label 15 PPI.HappUnpleaVis                                             \
    -stim_file 16 ppi/p6.$seed.08.HappUnpleaInv.rall.PPI.1D                   \
    -stim_label 16 PPI.HappUnpleaInv                                            \
    -stim_file 17 ppi/ppi.seed.$seed.1D                                  \
    -stim_label 17 PPI.seed                                            \
    -num_glt 11	                                 \
        -glt_label 1 con_incon -gltsym 'SYM: PPI.FearUnpleaVis +PPI.HappPleaVis +PPI.FearUnpleaInv +PPI.HappPleaInv -PPI.FearPleaVis -PPI.HappUnpleaVis -PPI.FearPleaInv -PPI.HappUnpleaInv'   \
		-glt_label 2 Viscon_incon -gltsym 'SYM: PPI.FearUnpleaVis +PPI.HappPleaVis -PPI.FearPleaVis -PPI.HappUnpleaVis'   \
        -glt_label 3 Inviscon_incon -gltsym 'SYM: PPI.FearUnpleaInv +PPI.HappPleaInv -PPI.FearPleaInv -PPI.HappUnpleaInv'   \
        -glt_label 4 face -gltsym 'SYM: PPI.FearPleaVis +PPI.FearUnpleaVis +PPI.FearPleaInv +PPI.FearUnpleaInv -PPI.HappPleaVis -PPI.HappUnpleaVis  -PPI.HappPleaInv -PPI.HappUnpleaInv'   \
        -glt_label 5 face_vis -gltsym 'SYM: PPI.FearPleaVis +PPI.FearUnpleaVis -PPI.HappPleaVis -PPI.HappUnpleaVis'   \
        -glt_label 6 face_inv -gltsym 'SYM: PPI.FearPleaInv +PPI.FearUnpleaInv -PPI.HappPleaInv -PPI.HappUnpleaInv'   \
        -glt_label 7 odor -gltsym 'SYM: PPI.FearUnpleaVis +PPI.HappUnpleaVis +PPI.FearUnpleaInv +PPI.HappUnpleaInv -PPI.FearPleaVis -PPI.HappPleaVis -PPI.FearPleaInv -PPI.HappPleaInv'   \
        -glt_label 8 odor_vis -gltsym 'SYM: PPI.FearUnpleaVis +PPI.HappUnpleaVis -PPI.FearPleaVis -PPI.HappPleaVis'   \
        -glt_label 9 odor_inv -gltsym 'SYM: PPI.FearUnpleaInv +PPI.HappUnpleaInv -PPI.FearPleaInv -PPI.HappPleaInv'   \
        -glt_label 10 V_I -gltsym 'SYM: PPI.FearPleaVis +PPI.FearUnpleaVis +PPI.HappPleaVis +PPI.HappUnpleaVis -PPI.FearPleaInv -PPI.FearUnpleaInv -PPI.HappPleaInv -PPI.HappUnpleaInv'   \
        -glt_label 11 all -gltsym 'SYM: PPI.FearPleaVis +PPI.FearUnpleaVis +PPI.HappPleaVis +PPI.HappUnpleaVis +PPI.FearPleaInv +PPI.FearUnpleaInv +PPI.HappPleaInv +PPI.HappUnpleaInv'   \
    -fout -tout -x1D X.xmat.ppi.${filedec}.1D -xjpeg X.ppi.${filedec}.jpg        \
    -x1D_uncensored X.nocensor.xmat.ppi.${filedec}.1D                        \
    -bucket ppi.$seed -errts errts.ppi.$seed
# align data to standard space
set name = ppi.$seed
3dNwarpApply -nwarp "anatQQ.${sub}_WARP.nii anatQQ.${sub}.aff12.1D INV(anatSS.${sub}_al_keep_mat.aff12.1D)"   \
            -source ${name}+orig                                                 \
            -master anatQQ.${sub}+tlrc    \
            -prefix ${name}
# refit type
3drefit -fbuc ${name}+tlrc

else
 echo "Usage: $0 <Subjname>"

endif
