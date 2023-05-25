#! /bin/csh

touch command.txt
cat /dev/null >! command.txt

foreach run (`count -dig 2 6 13`)
  echo tcsh deconvolve_REML.tcsh S${run} >> command.txt
end
# cat command.txt

parallel -a command.txt

rm command.txt
