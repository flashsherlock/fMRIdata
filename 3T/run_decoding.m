analysis_all={'de'};
shift=[6];
decode = 'odor';
con = 'all';
rois={'Amy8_align','Amy8_at165'};
% rois={'Indiv40'};
for i = 3:29
    sub=sprintf('S%02d',i);
    decoding_roi(sub,analysis_all,rois,shift,decode,con);
    % close figures
    close all
end