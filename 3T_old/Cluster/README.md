# These are the scripts for Cluster analysis
First let the betas in two conditions larger than zero (Finished), then choose clusters with peak value for each side (Unfinished).
## 3Deconvolve
Add 4 contrast
* -glt_label 5 VisFaceF0 -gltsym 'SYM: 0.5*FearPleaVis +0.5*FearUnpleaVis'   
* -glt_label 6 VisFaceH0 -gltsym 'SYM: 0.5*HappPleaVis +0.5*HappUnpleaVis'   
* -glt_label 7 VisOdorP0 -gltsym 'SYM: 0.5*FearPleaVis +0.5*HappPleaVis'   
* -glt_label 8 VisOdorU0 -gltsym 'SYM: 0.5*FearUnpleaVis +0.5*HappUnpleaVis'

## makeROIabove0
Generate masks and use `3dROIstats` to print the mean $\beta$ value to txt files.
* Masks are named as `${subj}.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}`
* `${t0mark}` stands for the criteria of *t* value to define voxels that activate positively to faces.
* `${tmark}` stands for the criteria of *t* value to define voxels that prefer a certain kind of valance.

## fcluster
Use `3dClusterize` to find clusters.

## ROIstatent
Use `3dROIstats` to print the mean $\beta$ value to txt files. Add outputs of status.
* The folder of txt results is named as `AmyAbove0${t0mark}${tmark}`
* Result files for each subject are named as `${subj}.FaceValenceAb0${t0mark}.AmyFH.${tmark}.txt`

## catxt
Concatenate txt files of 20 subjects to one file for each condition. Use the same filename as the first analysis.
* Result files for all subjects are named as `20subj_OdorValence.lateralAmyUP.${tmark}.txt`

## extract_block
Get data from the txt file.
Data are stored in `AmyAbove0${t0mark}${tmark}.RData`

## extract_tent
Get data from the txt file.
Because the structures of data generated by tent and block function are different, extract_block.R can not be used here.
Data are stored in `AmyAbove0${t0mark}${tmark}_tent.RData`

## analyzeR
Analyze data stored in RData file and generate All.RData
Data are stored in `All.RData`

## analyzeRtent
Analyze data stored in tent.RData file and generate Alltent.RData
Data are stored in `Alltent.RData`

## ../AmygdalaTENT/analyzeRtent
Analyze data stored in tent.RData file and generate Alltent.RData

## plot_Amy
Analyze data stored in All.RData and ../AmygdalaTENT/Alltent.RData, then generate a html file with plots
![plot](plot_Amy_files/figure-html/unnamed-chunk-4-1.png)

## PPI
PPI analysis.

## Other files
These files have been used but are not crucial in data analysis

### parallelproc.tcsh
Run commands in parallel.