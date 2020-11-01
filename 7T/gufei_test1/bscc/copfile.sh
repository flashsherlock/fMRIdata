#!/bin/bash
mkdir results.5runs
for run in $(seq 1 5)
do
dirname=gufei.run${run}.pade.results
mkdir results.5runs/${dirname}
cp ${dirname}/stats.gufei.run${run}.pade* results.5runs/${dirname}/
cp ${dirname}/pb04.gufei.run${run}.pade.r01.volreg* results.5runs/${dirname}/
cp ${dirname}/anat_final.gufei.run${run}.pade* results.5runs/${dirname}/
echo $run
done