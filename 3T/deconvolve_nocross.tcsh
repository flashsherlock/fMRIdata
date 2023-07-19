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
set filedec = new
set pb = `ls pb0?.*.r01.scale+orig.HEAD | cut -d . -f1`
3dDeconvolve -input ${pb}.$subj.r*.scale+orig.HEAD             \
    -censor motion_${subj}_censor.1D                           \
    -ortvec mot_demean.r01.1D mot_demean_r01                   \
    -ortvec mot_demean.r02.1D mot_demean_r02                   \
    -ortvec mot_demean.r03.1D mot_demean_r03                   \
    -ortvec mot_demean.r04.1D mot_demean_r04                   \
    -ortvec mot_demean.r05.1D mot_demean_r05                   \
    -polort 3 -float -jobs 28                                   \
    -num_stimts 8                                              \
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
    -num_glt 10	                                 \
        -glt_label 1 con_incon -gltsym 'SYM: FearUnpleaVis +HappPleaVis +FearUnpleaInv +HappPleaInv -FearPleaVis -HappUnpleaVis -FearPleaInv -HappUnpleaInv'   \
		-glt_label 2 Viscon_incon -gltsym 'SYM: FearUnpleaVis +HappPleaVis -FearPleaVis -HappUnpleaVis'   \
        -glt_label 3 Inviscon_incon -gltsym 'SYM: FearUnpleaInv +HappPleaInv -FearPleaInv -HappUnpleaInv'   \
        -glt_label 4 face -gltsym 'SYM: FearPleaVis +FearUnpleaVis +FearPleaInv +FearUnpleaInv -HappPleaVis -HappUnpleaVis  -HappPleaInv -HappUnpleaInv'   \
        -glt_label 5 face_vis -gltsym 'SYM: FearPleaVis +FearUnpleaVis -HappPleaVis -HappUnpleaVis'   \
        -glt_label 6 face_inv -gltsym 'SYM: FearPleaInv +FearUnpleaInv -HappPleaInv -HappUnpleaInv'   \
        -glt_label 7 odor -gltsym 'SYM: FearUnpleaVis +HappUnpleaVis +FearUnpleaInv +HappUnpleaInv -FearPleaVis -HappPleaVis -FearPleaInv -HappPleaInv'   \
        -glt_label 8 odor_vis -gltsym 'SYM: FearUnpleaVis +HappUnpleaVis -FearPleaVis -HappPleaVis'   \
        -glt_label 9 odor_inv -gltsym 'SYM: FearUnpleaInv +HappUnpleaInv -FearPleaInv -HappPleaInv'   \
        -glt_label 10 V_I -gltsym 'SYM: FearPleaVis +FearUnpleaVis +HappPleaVis +HappUnpleaVis -FearPleaInv -FearUnpleaInv -HappPleaInv -HappUnpleaInv'   \
    -fout -tout -x1D X.xmat.${filedec}.1D -xjpeg X.${filedec}.jpg        \
    -x1D_uncensored X.nocensor.xmat.${filedec}.1D                        \
    -bucket stats.$subj.${filedec} -errts errts.$subj.${filedec}

else
 echo "Usage: $0 <Subjname>"

endif
