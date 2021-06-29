analysis_all={'pabiode'};
shift=6;
% rois={'Amy9_align','corticalAmy_align','CeMeAmy_align','BaLaAmy_align'};
% for region=[1 3 5 6 7 8 9 10 15]
%     rois=[rois {['Amy_align' num2str(region) 'seg']}];
% end
% piriform roi
% rois={'Amy8_at165','corticalAmy_at165','CeMeAmy_at165','BaLaAmy_at165','Pir_new_at165','Pir_old_at165','APC_new_at165','APC_old_at165','PPC_at165'};
rois={'Amy8_align','corticalAmy','CeMeAmy','BaLaAmy','Pir_new','Pir_old','APC_new','APC_old','PPC'};
% S01_yyt
sub='S01_yyt';
decoding_roi_4odors_trial(sub,analysis_all,rois,shift);
decoding_roi_trial(sub,analysis_all,rois,shift);
% S01-S03
for i=1:3
    % if i==1
    %     rois(5)=[];
    % end
    sub=sprintf('S%02d',i);
    decoding_roi_4odors_trial(sub,analysis_all,rois,shift);
    decoding_roi_trial(sub,analysis_all,rois,shift);
end
% S01 only has 1 voxel in Amy9_at1656seg and does not have Amy9_at1655seg