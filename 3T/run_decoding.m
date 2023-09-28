analysis_all={'de'};
shift=[6];
% decode = 'face';
% con = {'all','vis','inv'};
decode = 'odor';
con = {'all'};
% rois={'Amy8_align','Amy8_at165','Pir_new','Pir_new_at165','fusiformCA','fusiformCA_at165'};
rois={'FFV_CA','FFV_CA_at165','OFC6mm','OFC6mm_at165'};
% rois={'Indiv40'};
parfor i = 3:29
    sub=sprintf('S%02d',i);
    for con_i = 1:length(con)
%         try
%             decoding_roi(sub,analysis_all,rois,shift,decode,con{con_i});
        decoding_search(sub,analysis_all,rois,shift,decode,con{con_i});
%         catch
%             disp(sub)
%         end
    end
    % close figures
    close all
end
% decoding trans
con = {'con','inc','vis','inv'};
parfor i = 3:29
    sub=sprintf('S%02d',i);
    for con_i = 1:length(con)
        decoding_roitrans(sub,analysis_all,rois,shift,decode,con{con_i});
    end
    % close figures
    close all
end