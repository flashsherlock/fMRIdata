# MVPA decoding analysis
There are two functions that perform MVPA decoding for all 4 odors and 6 odor pairs, generating predicted and true labels for further analysis, espesially confusion matrices. Parameters are listed below.

* sub: subject string.
* analysis_all: phy corrections.
* rois: ROI mask names.
* shift: time(s) after stimuli(green cross) onset.

## decoding_roi_4odors_trial.m
Decode all 4 odors for each ROI.

## decoding_roi_trial.m
Decode 6 odors pairs for each ROI.

## decoding_searchlight_4odors_trial.m
Run searchlignt to 4 odors pairs in a box ROI.

## decoding_searchlight_trial.m
Run searchlignt to decode 6 odors pairs in a box ROI.

## run_decoding.m
Use two functions above to run MVPA decoding for each subject.

## results_search.tcsh
Use 3dmaskdump to export searchlight results to a txt file.

## results_search.Rmd
Load and analyze the txt file that contains searchlight results.