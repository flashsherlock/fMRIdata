analysis_all={'de'};
shift=[6];
% decode = 'face';
% con = {'all','vis','inv'};
decode = 'odor';
con = {'all'};
rois={'Amy8_align','Amy8_at165'};
% rois={'Indiv40'};
parfor i = 3:29
    sub=sprintf('S%02d',i);
    for con_i = 1:length(con)
%         decoding_roi(sub,analysis_all,rois,shift,decode,con{con_i});
        decoding_search(sub,analysis_all,rois,shift,decode,con{con_i});
    end
    % close figures
    close all
end