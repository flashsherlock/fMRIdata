#! /bin/csh
setenv AFNI_NO_OBLIQUE_WARNING YES

if ( $# > 0 ) then
 # set subj = $1

# setenv AFNI_DICOM_RESCALE YES
# setenv AFNI_DICOM_WINDOW NO

foreach subj (`echo $*`)
# foreach subj (`ls -d S*`)
#S22 S23 S24 S25 S26 S27 S28

cd ${subj}
cd analysis

#ROI情况
afni \
-com "SWITCH_UNDERLAY A.${subj}.str_al+orig" \
-com "OPEN_WINDOW A.axialimage  geom=+100+100" \
-com "OPEN_WINDOW A.coronalimage  geom=+400+100" \
-com "OPEN_WINDOW A.sagittalimage  geom=+800+100" \
-com "SWITCH_UNDERLAY B.FMRI.0007_r_bs1+orig" \
-com "OPEN_WINDOW B.axialimage geom=+100+600" \
-com "OPEN_WINDOW B.coronalimage geom=+400+600" \
-com "OPEN_WINDOW B.sagittalimage geom=+800+600" \
&
# -com "SET_FUNC_AUTORANGE A.-" \

prompt_user -pause "                                     \
   review: check alignment between anat and EPI          \
      - set underlay to anat                             \
      - set overlay to EPI                               \
      - look at gross alignment, maybe with thresholding \
      - turn off 'See Overlay'                           \
      - use 'u' key in image windows to toggle underlay  \
        dataset between anat and EPI                     \
          - CSF should be dark in anat and bright in EPI \
      - follow ventricles and gyral patterns             \
                                                         \
   --- close afni and click OK when finished ---         \
   "
# -com "SET_FUNC_RANGE A.10" \
# afni \
# -com "SWITCH_UNDERLAY FMRI.0007_r_bs1+orig" \
# # killall Xvfb

#motion情况
# 1dplot -sepscl -volreg -jpg ''../../img/motion/${subj}.jpg'' func_s.mot'[1-6]'

#对齐情况
# afni \
# -com 'SET_XHAIRS A.OFF'\
# -com "SWITCH_UNDERLAY ${subj}.str_al+tlrc" \
# -com "SWITCH_OVERLAY ${subj}_func_s+orig" \
# -com "SET_DICOM_XYZ A -23 5 -15"\
# -com "SAVE_JPEG A.coronalimage ../../img/alignment/${subj}_coronal.jpg" \
# -com "SAVE_JPEG A.axialimage ../../img/alignment/${subj}_axial.jpg" \
# -com "SAVE_JPEG A.sagittalimage ../../img/alignment/${subj}_sagittal.jpg" \
# -com "QUIT"

cd ..
cd ..
end

endif
