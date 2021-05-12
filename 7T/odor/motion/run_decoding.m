shift=6;
% rois={'Amy9_align','corticalAmy_align','CeMeAmy_align','BaLaAmy_align'};
% for region=[1 3 5 6 7 8 9 10 15]
%     rois=[rois {['Amy_align' num2str(region) 'seg']}];
% end
rois={'Amy8_align','Pir_new','Pir_old','APC_new','APC_old','PPC'};
% % S01
% sub='S01';
% analysis_all={'pabiocen'};
% decoding_roi_4odors_trial(sub,analysis_all,rois,shift);
% decoding_roi_trial(sub,analysis_all,rois,shift);
% 5run
sub='S01';
analysis_all={'pabio5r'};
run=[1:4,6];
% fname='odorVIva5run_noblur';
decoding_roi_4odors_trial(sub,analysis_all,rois,shift,run);
decoding_roi_trial(sub,analysis_all,rois,shift,run);

% % S01 12run
% sub='S01';
% analysis_all={'pabio12run'};
% run=1:12;
% decoding_roi_4odors_trial(sub,analysis_all,rois,shift,run);
% decoding_roi_trial(sub,analysis_all,rois,shift,run);
% 
% % S01 11run
% sub='S01';
% analysis_all={'pabio11run'};
% fname='odorVIva11run_noblur';
% run=[1:10 12];
% decoding_roi_4odors_trial(sub,analysis_all,rois,shift,run,fname);
% decoding_roi_trial(sub,analysis_all,rois,shift,run,fname);
