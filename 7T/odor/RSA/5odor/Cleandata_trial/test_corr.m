% load response patterns
datafolder = '/Volumes/WD_F/gufei/7T_odor/results_RSA/5odor_rmpolort_trial/';
load([datafolder 'ImageData/Cleandata_responsePatterns.mat']);
load([datafolder 'RDMs/Cleandata_Models.mat']);
% fields and subs
fields = fieldnames(responsePatterns);
subn = [4:11 13 14 16:18 19:29 31:34];
subs = cell(1,length(subn));
for sub_i = 1:length(subn)
    subs{sub_i} = sprintf('S%02d', subn(sub_i));
end

% plot the response pattern
% for field_i = 1:length(fields)    
%     % for each sub
%     for sub_i = 1:length(subn)
%         figure;
%         imagesc(responsePatterns.(fields{field_i}).(subs{sub_i}));
%         title([fields{field_i} ' : ' subs{sub_i}], 'Interpreter', 'none');
%         colormap gray
%         close all
%     end 
% end

% pariwise correlation for all subjects
colms = [];
cormat = [];
for sub_i = 1:length(subn)
    for field_i = 1:length(fields)
        cur_res = responsePatterns.(fields{field_i}).(subs{sub_i});
        % RDM
        cur_res = 1-corr(cur_res);
        colms(:, field_i) = cur_res(triu(true(size(cur_res)), 1));
    end

    for m_i = 1:size(Models,1)
        cur_res = Models(m_i, sub_i).RDM;
        colms(:, length(fields)+m_i) = cur_res(triu(true(size(cur_res)), 1));
    end
    cormat(:, :, sub_i) = corr(colms, 'type', 'Spearman');
end
