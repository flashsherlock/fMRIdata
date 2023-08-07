#! /bin/bash
# rename behavior results files
datafolder=/Volumes/WD_D/allsub/behavior/
cd "${datafolder}" || exit
# for each file in the folder rename it
for file in *.mat; do
    # rename file start with "s0" or "s10" to name start with s
    if [[ ${file:0:2} == "s0" ]]; then
        mv "$file" "${file/s0/s}"
        # echo "${file/s0/s}"
    else
        mv "$file" "${file/s10/s}"
        # echo "${file/s10/s}"
    fi
done
