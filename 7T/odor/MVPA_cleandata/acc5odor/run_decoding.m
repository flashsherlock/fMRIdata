analysis_all={'pabiode'};
shift=[3 6 9];
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
% decode=[reshape(repmat([13:18],10,1),[],1) repmat([1:10]',6,1)];
% for i=1:60    
%     try
%     sub=sprintf('S%02d',decode(i,1));
%     decoding_searchlight_trial(sub,analysis_all,rois,shift,decode(i,2));
%     catch
%         disp(decode(i,:))
%     end
% end
% S04-S08
for i=[4:11,13,14,16:18]
    sub=sprintf('S%02d',i);
    try
    decoding_roi_5odors_trial(sub,analysis_all,rois,shift);    
    decoding_roi_trial(sub,analysis_all,rois,shift);
    catch
    disp(['error in' sub]);
    end
%     searchlight
%     decoding_searchlight_5odors_trial(sub,analysis_all,rois,shift);
%     decoding_searchlight_trial(sub,analysis_all,rois,shift);
end