analysis_all={'pabiode'};
shift=[6];
% rois={'Amy9_align','corticalAmy_align','CeMeAmy_align','BaLaAmy_align'};
% for region=[1 3 5 6 7 8 9 10 15]
%     rois=[rois {['Amy_align' num2str(region) 'seg']}];
% end
% piriform roi
rois={'Amy8_at165','corticalAmy_at165','CeMeAmy_at165','BaLaAmy_at165','Pir_new_at165','Pir_old_at165','APC_new_at165','APC_old_at165','PPC_at165'};
% rois={'Amy8_at196','corticalAmy_at196','CeMeAmy_at196','BaLaAmy_at196','Pir_new_at196','Pir_old_at196','APC_new_at196','APC_old_at196','PPC_at196'};
% rois={'Amy8_align','corticalAmy','CeMeAmy','BaLaAmy','Pir_new','Pir_old','APC_new','APC_old','PPC'};
% rois={'Amy8_align','corticalAmy','CeMeAmy','BaLaAmy'};
% rois={'whole_brain'};
% decoding_roi_4odors_trial('s01_yyt', analysis_all, rois, shift);
% decoding_roi_trial('s01_yyt', analysis_all, rois, shift);

decode = [reshape(repmat([1:4], 6, 1), [], 1) repmat([1:6]', 4, 1)];

for i = 1:24
    if decode(i, 1)==4
        sub = 's01_yyt';
    else
        sub = sprintf('S%02d', decode(i, 1));
    end
    try
    decoding_searchlight_trial(sub, analysis_all, rois, shift, decode(i, 2));
    catch
        disp(decode(i,:))
    end
end
% S01-S03
% for i=1:3
%     sub=sprintf('S%02d',i);
%     decoding_roi_4odors_trial(sub,analysis_all,rois,shift);
%     decoding_roi_trial(sub,analysis_all,rois,shift);
    % searchlight
%     decoding_searchlight_5odors_trial(sub,analysis_all,rois,shift);
%     decoding_searchlight_trial(sub,analysis_all,rois,shift);
% end