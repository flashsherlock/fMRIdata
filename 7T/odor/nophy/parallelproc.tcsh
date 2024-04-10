#! /bin/csh
# set datafolder=/Volumes/WD_D/allsub/
# cd "${datafolder}"

touch command.txt
cat /dev/null >! command.txt

foreach run (`count -dig 2 5 11` 13 14 `count -dig 2 16 29` 31 32 33 34)
  echo tcsh proc_fmri2xsmooth.tcsh S${run} >> command.txt
end
# cat command.txt

parallel -a command.txt

rm command.txt

# for run in 32 33 34
# do
#   tcsh proc_fmri2xsmooth.tcsh S${run}
# done

# for run in 10 11 13 14
# do
#   tcsh deconvolve_censor_odorva.tcsh S${run}
# done