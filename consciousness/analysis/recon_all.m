% the filename should not contain '-',so change to '_'
for subi = 11:13
sub		   = sprintf('s%02d',subi);
fshome     = '/Applications/freesurfer/7.1.1/';
subdir     = ['/Volumes/WD_D/gufei/consciousness/electrode/use/' sub];
mrfile     = [subdir '/' sub '_MRI_acpc.nii'];
% recon-all can be run parallely
system(['export FREESURFER_HOME=' fshome '; ' ...
'source $FREESURFER_HOME/SetUpFreeSurfer.sh; ' ...
'mri_convert -c -oc 0 0 0 ' mrfile ' ' [subdir '/tmp.nii'] '; ' ...
'recon-all -i ' [subdir '/tmp.nii'] ' -s ' sub ' -sd ' subdir ' -all -parallel -threads 26'])
end