#! /bin/csh

set datafolder=/Volumes/WD_D/share/7Tdata/phy
# set datafolder=/Volumes/WD_D/share/20200811_S40_TEST02
cd "${datafolder}"

# 3dDeconvolve                      \
# -input resp02.1D\'                \
# -TR_1D 0.02                       \
# -polort 1                         \
# -num_stimts 1                     \
# -stim_file 1 puls02.1D              \
# -stim_base 1                      \
# -errts regress02

# 3dTfitter -RHS resp02cut.1D -LHS puls02.1D -fitts reg02
# 3dcalc -a resp02cut.1D -b reg02.1D -expr 'a-b' -prefix after
1deval -a resp02cut.1D -b puls02.1D -expr 'a-b' > after1.1D
