%% settings
analysis_all={'de'};
shift=[6];
%% normal decoding
% decode = 'face';
% con = {'all','vis','inv'};
decode = 'odor';
con = {'all'};
% rois={'Amy8_align','Amy8_at165','Pir_new','Pir_new_at165','fusiformCA','fusiformCA_at165'};
% rois={'FFV_CA','FFV_CA_at165','OFC6mm','OFC6mm_at165'};
% rois={'aSTS','OFC_AAL'};
% rois={'APC_new','APC_old','PPC'};
% rois={'FFV_CA05','FFV_CA01','FFV_CA005','FFV_CA001'};
% rois = {'pSTS_OR', 'aSTS_OR05', 'aSTS_OR01', 'aSTS_OR005', 'aSTS_OR001'};
% rois = [rois {'Pir_new05', 'Pir_new01', 'Pir_new005', 'Pir_new001'}];
rois = {'FFV_CA_max2v', 'FFV_CA_max3v', 'FFV_CA_max4v', 'FFV_CA_max5v', 'FFV_CA_max6v'};
parfor i = 3:29
    sub=sprintf('S%02d',i);
    for con_i = 1:length(con)
%         try
            decoding_roi(sub,analysis_all,rois,shift,decode,con{con_i});
%         catch
%             disp(sub)
%         end
    end
    % close figures
    close all
end
%% searchlight
rois = {'BoxROIsext'};
parfor i = 3:29
    sub=sprintf('S%02d',i);
    for con_i = 1:length(con)
%         try
        decoding_search(sub,analysis_all,rois,shift,decode,con{con_i});
%         catch
%             disp(sub)
%         end
    end
    % close figures
    close all
end
%% decoding trans
% con = {'con','inc','vis','inv'};
% rois={'Amy8_align','OFC_AAL'};
rois={'FFV_CA001','FFV_CA01','FFV_CA05','FFV_CA_max3v', 'FFV_CA_max4v', 'FFV_CA_max5v', 'FFV_CA_max6v'};
parfor i = 3:29
    sub=sprintf('S%02d',i);
%     for con_i = 1:length(con)
%         decoding_roitrans(sub,analysis_all,rois,shift,decode,con{con_i});
%     end
    decoding_roitrans(sub,analysis_all,rois,shift,'face','vis_inv')
    decoding_roitrans(sub,analysis_all,rois,shift,'face','inv_vis')
    decoding_roitrans(sub,analysis_all,rois,shift,'of','test_vis')
    decoding_roitrans(sub,analysis_all,rois,shift,'of','test_inv')
    decoding_roitrans(sub,analysis_all,rois,shift,'fo','train_vis')
    decoding_roitrans(sub,analysis_all,rois,shift,'fo','train_inv')
    % close figures
    close all
end
%% lesion
rois={'Amy8_align','OFC_AAL'};
prefix={'face_vis','face_inv','odor_all'};
suffix={'p1','p2','l1','l2'};
% combine prefix and suffix
condition=cell(1,length(prefix)*length(suffix));
for rad = 10:2:16
    for i = 1:length(prefix)
        for j = 1:length(suffix)
            % condition{(i-1)*length(suffix)+j}=[prefix{i} '_' suffix{j}];
            condition{(i-1)*length(suffix)+j}=[prefix{i} '_' suffix{j} '_map' num2str(rad)];
        end
    end
    parfor i = 3:29
        sub=sprintf('S%02d',i);
        decoding_roilesion(sub,analysis_all,rois,shift,condition);
        % close figures
        close all
    end
end
%% lesion in test data
rois={'Amy8_align','OFC_AAL'};
prefix={'face_vis','face_inv','odor_all'};
% suffix={'p1','p2','l1','l2'};
suffix={'p1','p2'};
condition=cell(1,length(prefix)*length(suffix));
% for rad = 10:2:16
    for i = 1:length(prefix)
        for j = 1:length(suffix)
            % condition{(i-1)*length(suffix)+j}=[prefix{i} '_' suffix{j}];
            condition{(i-1)*length(suffix)+j}=[prefix{i} '_' suffix{j} '_interacc'];
        end
    end
    parfor i = 3:29
        sub=sprintf('S%02d',i);
%         decoding_roilesiontest(sub,analysis_all,rois,shift,condition);
        decoding_roilesion(sub,analysis_all,rois,shift,condition);
        % close figures
        close all
    end
% end
%% lesion permutation
rois={'Amy8_align','OFC_AAL'};
prefix={'face_vis','face_inv','odor_all'};
parfor i = 3:29
    sub=sprintf('S%02d',i);
    decoding_roilesionperm(sub,analysis_all,rois,shift,prefix);
    close all
end