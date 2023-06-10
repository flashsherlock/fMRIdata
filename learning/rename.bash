#! /bin/bash
datafolder=/Volumes/WD_D/gufei/Export
cd "${datafolder}" || exit
# for each file in the folder rename it
for file in *.jpg; do
    # rename to the first 8 characters
    mv "$file" "${file:0:8}.jpg"
done