analysis_all={'de'};
shift=[6];
% rois={'Amy8_at165'};
rois={'Amy8_align'};
for i = 4:29
    sub=sprintf('S%02d',i);
    decoding_roi(sub,analysis_all,rois,shift);
    % close figures
    close all
end