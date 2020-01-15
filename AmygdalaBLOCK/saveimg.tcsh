#! /bin/csh
foreach subj (`ls -d S*`)
#S22 S23 S24 S25 S26 S27 S28

cd ${subj}
cd analysis

#ROI情况
# afni \
# # -com "OPEN_WINDOW A.axialimage mont=6x6:3 geom=600x600+800+600" \
# -com 'SET_XHAIRS A.OFF'\
# # -com "OPEN_WINDOW A.sagittalimage" \
# -com "SWITCH_UNDERLAY ${subj}.str_al+tlrc" \
# # -com "SET_FUNC_AUTORANGE A.-" \
# # -com "SET_FUNC_RANGE A.10" \
# -com "SWITCH_OVERLAY ${subj}.OdorValenceP_U.t1.64.TT.gf+tlrc" \
# -com "SET_DICOM_XYZ A -23 5 -15"\
# # -com "SET_SUBBRICKS A -1 13 14" \
# # -com "SET_THRESHNEW A .001 *p" \
# -com "SAVE_JPEG A.coronalimage ../../img/${subj}_P_U_coronal.jpg" \
# -com "SAVE_JPEG A.axialimage ../../img/${subj}_P_U_axial.jpg" \
# -com "SAVE_JPEG A.sagittalimage ../../img/${subj}_P_U_sagittal.jpg" \
# -com "SWITCH_OVERLAY ${subj}.OdorValenceU_P.t1.64.TT.gf+tlrc" \
# -com "SAVE_JPEG A.coronalimage ../../img/${subj}_U_P_coronal.jpg" \
# -com "SAVE_JPEG A.axialimage ../../img/${subj}_U_P_axial.jpg" \
# -com "SAVE_JPEG A.sagittalimage ../../img/${subj}_U_P_sagittal.jpg" \
# -com "SWITCH_OVERLAY ${subj}.FaceValenceF_H.t1.64.TT.gf+tlrc" \
# -com "SAVE_JPEG A.coronalimage ../../img/${subj}_F_H_coronal.jpg" \
# -com "SAVE_JPEG A.axialimage ../../img/${subj}_F_H_axial.jpg" \
# -com "SAVE_JPEG A.sagittalimage ../../img/${subj}_F_H_sagittal.jpg" \
# -com "SWITCH_OVERLAY ${subj}.FaceValenceH_F.t1.64.TT.gf+tlrc" \
# -com "SAVE_JPEG A.coronalimage ../../img/${subj}_H_F_coronal.jpg" \
# -com "SAVE_JPEG A.axialimage ../../img/${subj}_H_F_axial.jpg" \
# -com "SAVE_JPEG A.sagittalimage ../../img/${subj}_H_F_sagittal.jpg" \
# -com "QUIT"
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
cp *.jpg ../../img/alignment/
cd ..
cd ..
end
