#! /bin/csh

# use input as sub
if ( $# > 0 ) then
set sub = $1
set sub_beh = $2
# change to lowercase
set sub_l=`echo ${sub} | tr '[A-Z]' '[a-z]'`
set datafolder=/Volumes/WD_E/gufei/7T_odor/
cd "${datafolder}"

# make folders
mkdir ${sub}
mkdir ${sub}/behavior
mkdir ${sub}/respiration
mkdir ${sub}/phy
# move images
mv *S40_${sub} ${sub}/
# rename and move behavior data
cd behavior
foreach file (`ls ${sub_beh}*`)
    # extract name
    set name=`echo ${file} | cut -d _ -f 2`
    mv ${file} ${sub_l}_${name}
end
cd ..
mv behavior/${sub_l}* ${sub}/behavior/
# move respiration data
mv respiration/${sub_l}* ${sub}/respiration/

else
 echo "Usage: $0 <Sub_mri> <Sub_behavior>"

endif
