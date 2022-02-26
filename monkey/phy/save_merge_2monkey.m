function [roi_lfp, roi_resp, cur_level_roi] = save_merge_2monkey(level, trl_type)
    %% load data
    monkeys = {'RM035', 'RM033'};
    roi_focus = cell(4, 1);
    roi_focus{1} = {'HF', 'pAmy', 'spAmy'};
    roi_focus{2} = {'HF', 'vpAmy', 'lpAmy', 'stAmy', 'mAmy', 'pdAmy'};
    roi_focus{3} = {'Pir', 'Hi', 'S', 'fi', 'pAmy', 'spAmy'};
    roi_focus{4} = {'Pir', 'Hi', 'S', 'fi', 'pAmy', 'spAmy'};

    for monkey_i = 1:length(monkeys)
        monkey = monkeys{monkey_i};
        file_dir = [' / Volumes / WD_D / gufei / monkey_data / yuanliu / ' ...
                lower(monkey) '_ane/mat/'];
        label = [file_dir monkey '_datpos_label.mat'];
        load(label);
        % level=1;
        cur_level_roi = ele_date_alevel{level};
        % remove no label
        cur_level_roi = cur_level_roi(~strcmp(cur_level_roi(:, 1), 'no_label_found'), :);
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
                resp{i} = ft_redefinetrial(cfg, data.bioresp{i});
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

        %% rearrange
        roi_num = size(cur_level_roi, 1);
        roi_resp = cell(roi_num, 1);
        roi_lfp = roi_resp;

        for roi_i = 1:roi_num
            locations = cur_level_roi{roi_i, 2};
            %     loc_dates=unique(locations(:,1));
            lfp = [];
            resp = [];

            for i = 1:size(locations, 1)
                % select lfp
                cfg = [];
                cfg.channel = locations(i, 2);
                lfp{i} = ft_selectdata(cfg, data_lfp{locations(i, 1)});
                % rename label to roi name
                lfp{i}.label = cur_level_roi(roi_i, 1);
                % copy resp to match each trial of lfp
                resp{i} = data_resp{locations(i, 1)};
                resp{i}.label{1} = strjoin([resp{i}.label, cur_level_roi(roi_i, 1)], '_');
            end

            % append all locations
            cfg = [];
            cfg.keepsampleinfo = 'no';
            roi_lfp{roi_i} = ft_appenddata(cfg, lfp{:});
            roi_resp{roi_i} = ft_appenddata(cfg, resp{:});
        end

    end

end

% save([data_dir 'roi_odor_resp_5day.mat'],'roi_lfp','roi_resp','cur_level_roi');
