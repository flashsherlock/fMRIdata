analysis_all={'pabio5r'};
shift=6;
run=[1:4,6];
rois={'Amy9_align','corticalAmy_align','CeMeAmy_align','BaLaAmy_align'};
for region=[1 3 5 6 7 8 9 10 15]
    rois=[rois {['Amy_align' num2str(region) 'seg']}];
end
% S01
% sub='S01';
% decoding_roi_4odors_trial(sub,analysis_all,rois,shift);
% decoding_roi_trial(sub,analysis_all,rois,shift);
% 5run
sub='S01';
% decoding_roi_4odors_trial(sub,analysis_all,rois,shift,run);
decoding_roi_trial(sub,analysis_all,rois,shift,run);