#These are the scripts for FFA&STS analysis
## 3Deconvolve
use 3dDeconvolve to get these results and align to structural image
* Visible > Invisible
* InvisibleFearful > InvisibleHappy
* InvisibleUnpleasant > InvisiblePleasant
## makeROI05
use 3dcalc to generate masks and use 3dROIstats to print the mean value to txt files

## ROIresample
Generate masks from BN_atlas and ROIresample
* STS_right
* FFA_right

<!-- ## 3Deconvolvetent
get the same results as 3Deconvolve but use tent function -->

## ROIstatent
use 3dROIstats to print the mean value to txt files

## extract_block
get data from the txt file.
Because the structures of data generated from tent and block function are different, extract_block.R can not be used here.

## analyzeR
analyze data stored in RData file
