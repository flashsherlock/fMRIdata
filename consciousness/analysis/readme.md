# analyze iEEG data

## generate_img.tcsh
Convert DICOM files to nii.

## raw2mat.m
Convert edf file to mat format.

## raw2mat_s01.m
Convertion for s01.
These two raw2mat scripts needs to be improved.

## proc_mri.m
Align MRI image to acpc.

## proc_ct.m
Align CT image and fuse it with MRI image.

## proc_electrode.m
Find electrode positions, save to SubjID_elec_acpc_f.mat. Then registrate it to a MNI template and save converted positions to SubjID_elec_mni_fv.mat.

## proc_elecposition.m
Lookup electode positions in a atlas and save the results to SubjID_elec_mni_fv.mat in the field 'position'.

## proc_elecname.m
Generate a cell that contain all the electrode information needed.

* original labels from edf header
* real electrode names
* coordinates in MNI space
* locations obtained from the atlas

## proc_electrode_pediatric.m
Combine steps from convert positions to MNI space (use a pediatric tempate) to the final matrix.