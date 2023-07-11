#! /bin/csh

touch command.txt
cat /dev/null >! command.txt

foreach run (`count -dig 2 8 21`)
  echo tcsh proc_3tanat.tcsh S${run} >> command.txt
end
# cat command.txt

parallel -a command.txt

rm command.txt
