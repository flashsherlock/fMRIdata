#!/bin/tcsh
# set sub=S04
if ( $# > 0 ) then
set sub = $1
set analysis=pade
set datafolder=/Volumes/WD_F/gufei/blind/${sub}

cd "${datafolder}"

set subj = ${sub}.${analysis}
cd ${subj}.results
# run the REML regression analysis
set pb=`ls pb0?.*.r01.scale+orig.HEAD | cut -d . -f1`
set mat=X.xmat.1D
# use multiple threads to speed up the analysis
setenv OMP_NUM_THREADS 4
# no mask on the individual level was recommended
# https://afni.nimh.nih.gov/afni/community/board/read.php?1,70967
# -mask mask_anat.${subj}+orig
3dREMLfit \
 -input "${pb}.${subj}.r01.scale+orig.HEAD ${pb}.${subj}.r02.scale+orig.HEAD ${pb}.${subj}.r03.scale+orig.HEAD ${pb}.${subj}.r04.scale+orig.HEAD ${pb}.${subj}.r05.scale+orig.HEAD ${pb}.${subj}.r06.scale+orig.HEAD" \
 -matrix  ${mat}\
 -fout -tout -Rbuck stats.${subj}_REML
# align to nomalized Anatomical img
@auto_tlrc -apar anat_final.${subj}+tlrc -input stats.${subj}_REML+orig

else
 echo "Usage: $0 <Subjname>"

endif
