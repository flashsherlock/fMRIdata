#! /bin/bash

for roi in FFV_CA insulaCA OFC6mm aSTS_OR
do
    bash group_statas.bash de.new ${roi}
    bash group_statas_ppi.bash de.new ${roi}
    bash group_statas.bash de.new ${roi}_at165
    bash group_statas_ppi.bash de.new ${roi}_at165
done
