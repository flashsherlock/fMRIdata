function [roi_lfp, roi_resp, level_roi] = save_merge_2monkey(level, trl_type, monkeys)
    %     level=1;
    %     trl_type='odor';
    %% init
    if nargin < 3
        monkeys = {'RM035', 'RM033'};
    end
    roi_focus = cell(4, 1);
    roi_focus{1} = {'HF', 'pAmy', 'spAmy'};
    roi_focus{2} = {'HF', 'vpAmy', 'lpAmy', 'stAmy', 'mAmy', 'pdAmy'};
    roi_focus{3} = {'Pir', 'Hi', 'S', 'fi', ...
                    'BM', 'VCo', 'AHi', 'La', 'APir', 'BL', 'PaL', ...
                    'Ce', 'Me', 'AA', 'EA', 'IPAC', 'STIA'};
    roi_focus{4} = {'Pir', 'Hi', 'S', 'fi', ...
                    'BM', 'VCo', 'AHi', 'LaD', 'LaV', 'APir', 'BLD', 'BLI', 'BLV', 'PaL', ...
                    'Ce', 'Me', 'AA', 'EA', 'IPAC', 'STIA'};
    roi_focus{5} = {'Hi', 'S', ...
                    'BM', 'VCo','La', 'APir', 'BL', 'PaL', ...
                    'Ce', 'Me'};
    roi_focus{6} = roi_focus{1};
    comb{1} = {{'CoA'},{'APir','VCo'}; {'BA'}, {'BL','PaL'};{'CeMe'},{'Ce','Me'}};
    comb{2} = {{'HF'},{'HF'}; {'Amy'}, {'pAmy', 'spAmy'}};
    data_roi_lfp = cell(1, length(monkeys));
    data_resp_lfp = data_roi_lfp;
    data_cur_level_roi = data_roi_lfp;
    all_roi = {};
    %% load data
    for monkey_i = 1:length(monkeys)
        monkey = monkeys{monkey_i};
        file_dir = ['/Volumes/WD_D/gufei/monkey_data/yuanliu/' ...
                    lower(monkey) '_ane/mat/'];
        label = [file_dir monkey '_datpos_label.mat'];
        load(label);
        % current roi for certain level
        if level >= 5 && level ~= 6
            cur_level_roi = ele_date_alevel{3};
        elseif level == 6
            cur_level_roi = ele_date_alevel{1};
        else 
            cur_level_roi = ele_date_alevel{level};
        end
        % remove non interested roi
        cur_level_roi = cur_level_roi(ismember(cur_level_roi(:, 1), roi_focus{level}), :);
        % lfp data
        data_lfp = cell(length(filenames), 1);
        data_resp = data_lfp;

        for i_date = 1:length(filenames)
            file = filenames{i_date};
            data = load([file_dir file]);
            %% cut to trials
            lfp = cell(1, length(data.lfp));
            resp = lfp;

            for i = 1:length(data.lfp)
                cfg = [];

                switch trl_type
                    case 'odor'
                        cfg.trl = data.trl(i).odor;
                    case 'resp'
                        cfg.trl = data.trl(i).resp;
                    otherwise
                        cfg.trl = data.trl(i).odorresp;
                end

                lfp{i} = ft_redefinetrial(cfg, data.lfp{i});
                % block
                lfp{i}.trialinfo(:,2) = i;
                % date (diff in monkeys)
                lfp{i}.trialinfo(:,3) = i_date+(1+strcmp(monkey,'RM035'))*100;
                resp{i} = ft_redefinetrial(cfg, data.bioresp{i});
                resp{i}.trialinfo(:,2) = i;
                resp{i}.trialinfo(:,3) = i_date;
            end

            %% append data
            cfg = [];
            cfg.keepsampleinfo = 'no';
            lfp = ft_appenddata(cfg, lfp{:});
            resp = ft_appenddata(cfg, resp{:});
            % remove trials containing nan values
            cfg = [];
            cfg.trials = ~(cellfun(@(x) any(any(isnan(x), 2)), lfp.trial) ...
                | cellfun(@(x) any(any(isnan(x), 2)), resp.trial));
            data_resp{i_date} = ft_selectdata(cfg, resp);
            data_lfp{i_date} = ft_selectdata(cfg, lfp);
        end

        data_roi_lfp{monkey_i} = data_resp;
        data_resp_lfp{monkey_i} = data_lfp;
        data_cur_level_roi{monkey_i} = cur_level_roi;
        all_roi = [all_roi; cur_level_roi(:, 1)];
    end

    % combine 2 monkeys
    all_roi = unique(combine_roi(all_roi,comb{level-4},level));
    roi_num = size(all_roi, 1);
    roi_resp = cell(roi_num, 1);
    roi_lfp = roi_resp;
    level_roi = cell(roi_num, 1 + length(monkeys));
    %% rearrange
    for roi_i = 1:roi_num
        cur_roi = all_roi{roi_i};
        level_roi{roi_i, 1} = cur_roi;
        lfp = {};
        resp = {};
        i = 1;

        for monkey_i = 1:length(monkeys)
            % current roi name
            cur_level_roi = data_cur_level_roi{monkey_i};
            % current data
            data_resp = data_roi_lfp{monkey_i};
            data_lfp = data_resp_lfp{monkey_i};
            % index for current roi
            index = strcmp(combine_roi(cur_level_roi(:, 1),comb{level-4},level), cur_roi);
            % if contain current roi
            if any(index)
                % combine some of the area
                locations = cell2mat(cur_level_roi(index, 2));
                level_roi{roi_i, 1 + monkey_i} = locations;

                for loc_i = 1:size(locations, 1)
                    % select lfp
                    cfg = [];
                    cfg.channel = locations(loc_i, 2);
                    lfp{i} = ft_selectdata(cfg, data_lfp{locations(loc_i, 1)});
                    % rename label to roi name
                    lfp{i}.label = {cur_roi};
                    % channel (diff in monkeys)
                    lfp{i}.trialinfo(:,4) = locations(loc_i, 2)+(1+strcmp(monkey,'RM035'))*100;
                    % copy resp to match each trial of lfp
                    resp{i} = data_resp{locations(loc_i, 1)};
                    resp{i}.label{1} = strjoin([resp{i}.label, lfp{i}.label], '_');
                    i = i + 1;
                end

            end

        end

        % append all locations
        cfg = [];
        cfg.keepsampleinfo = 'no';
        roi_lfp{roi_i} = ft_appenddata(cfg, lfp{:});
        roi_resp{roi_i} = ft_appenddata(cfg, resp{:});
        % save additional trialinfo to another variable
        roi_lfp{roi_i}.trialinfo_add = roi_lfp{roi_i}.trialinfo;
        roi_resp{roi_i}.trialinfo_add = roi_resp{roi_i}.trialinfo;
        % remove additional info from trialinfo field
        roi_lfp{roi_i}.trialinfo = roi_lfp{roi_i}.trialinfo(:,1);
        roi_resp{roi_i}.trialinfo = roi_resp{roi_i}.trialinfo(:,1);
    end

end

% save([data_dir 'roi_odor_resp_5day.mat'],'roi_lfp','roi_resp','cur_level_roi');

function roi_b = combine_roi(roi_a, comb,level)
    roi_b = roi_a;
    % combine roi if level>=5
    if level >= 5
        for i = 1:length(comb)
            roi_b(ismember(roi_a,comb{i,2}))=comb{i,1};
        end
    end
end