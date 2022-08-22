function [freq, cur_level_roi] = roi_merge_tf(monkey, level)
% merge freq data according to roi level
    % default level is 6
    if nargin < 2
        level = 6;
    end
    % merge based on old_level data
    old_level = 5;
    data_dir = '/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
    load([data_dir 'tf_level' num2str(old_level) '_' monkey '.mat'])
    % comb{1} = {{'CoA'}, {'APir', 'VCo'}; {'BA'}, {'BL', 'PaL'}; {'CeMe'}, {'Ce', 'Me'}};
    comb = {{'Amy'}, {'CoA', 'BA', 'LA', 'BM', 'CeMe'}; {'HF'}, {'Hi', 'S'}};
    % create freq to store data
    freq = cell(size(comb, 1), 1);
    cur_level_roi = cell(size(comb, 1), 1);
    % for each new roi
    for roi_i = 1:length(freq)
        % change label to new roi
        idx = [];
        for old_i = 1:length(freq_sep_all)
            if ismember(freq_sep_all{old_i}.label, comb{roi_i,2})
                freq_sep_all{old_i}.label = comb{roi_i,1};
                % record index
                idx = [idx old_i];
                cur_level_roi{roi_i} = comb{roi_i, 1};
            end
        end
        % merge freq data
        freq{roi_i} = ft_appendfreq([], freq_sep_all{idx});
    end
end

