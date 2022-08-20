#! /bin/csh

set sub=S01_yyt
set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"

cd ${sub}.*.results
# ==========================processing========================== # 
# ls stats.S01_yyt.paphde+orig*
3drefit -sublabel 25 'cit-lim_GLT#0_Coef' -sublabel 26 'cit-lim_GLT#0_Tstat' -sublabel 27 'cit-lim_GLT_Fstat' stats.S01_yyt.paphde+orig                          

