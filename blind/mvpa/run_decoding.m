analysis_all={'pade'};
shift=[6];
% rois
% rois={'Amy8_at165','Pir_new_at165','Pir_old_at165','APC_new_at165','APC_old_at165','PPC_at165','EarlyV_at165','V1_at165','V2_at165','V3_at165'};
rois={'Amy8_align','Pir_new','Pir_old','APC_new','APC_old','PPC','EarlyV','V1','V2','V3'};
subs = [14:16];
for i=subs
    sub=sprintf('S%02d',i);
    decoding_roi_8odors(sub,analysis_all,rois,shift);    
    decoding_roi_pair(sub,analysis_all,rois,shift);
    % close figures
    close all
end