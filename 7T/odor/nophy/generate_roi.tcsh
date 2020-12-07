#! /bin/csh

set sub=S01_yyt
set analysis=pade

set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"

cd ${sub}.${analysis}.results

cp -r ../${sub}.paphde.results/mvpamask ./mvpamask