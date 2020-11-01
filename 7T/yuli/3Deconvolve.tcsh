#! /bin/csh
set subj=Yuli.run1
set datafolder=/Volumes/WD_D/share/7T/${subj}.results
# set datafolder=/Volumes/WD_D/share/20200708_S0_WZHOU
cd "${datafolder}"

rm X.xmat.1D
rm X.jpg
rm fitts.$subj*
rm errts.${subj}*
rm stats.$subj*

3dDeconvolve -input pb04.$subj.r*.scale+orig.HEAD              \
    -ortvec mot_demean.r01.1D mot_demean_r01                   \
    -polort 3                                                  \
    -num_stimts 2                                              \
    -stim_times 1 ../../7Tdata/run1_fear.txt 'BLOCK(15,1)'          \
    -stim_label 1 fear                                        \
    -stim_times 2 ../../7Tdata/run1_neutral.txt 'BLOCK(15,1)'       \
    -stim_label 2 neutral                                      \
    -jobs 12                                                   \
    -gltsym 'SYM: fear -neutral'                              \
    -glt_label 1 F-N                                           \
    -fout -tout -x1D X.xmat.1D -xjpeg X.jpg                    \
    -fitts fitts.$subj                                         \
    -errts errts.${subj}                                       \
    -bucket stats.$subj
