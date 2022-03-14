function [roi_lfp, roi_resp, cur_level_roi] = save_merge_position(data_dir, label, dates, level, trl_type)
    %% load data
    load(label)
    % level=1;
    cur_level_roi = ele_date_alevel{level};
    % ensure ascending order
    dates = sort(dates);
    % remove non interested roi
    roi_focus = cell(4, 1);
    roi_focus{1} = {'HF', 'pAmy', 'spAmy'};
    roi_focus{2} = {'HF', 'vpAmy', 'lpAmy', 'stAmy', 'mAmy', 'pdAmy'};
    roi_focus{3} = {'Pir', 'Hi', 'S', 'fi', ...
                    'BM', 'VCo', 'AHi', 'La', 'APir', 'BL', 'PaL', ...
                    'Ce', 'Me', 'AA', 'EA', 'IPAC', 'STIA'};
    roi_focus{4} = {'Pir', 'Hi', 'S', 'fi', ...
                    'BM', 'VCo', 'AHi', 'LaD', 'LaV', 'APir', 'BLD', 'BLI', 'BLV', 'PaL', ...
                    'Ce', 'Me', 'AA', 'EA', 'IPAC', 'STIA'};
    cur_level_roi = cur_level_roi(ismember(cur_level_roi(:, 1), roi_focus{level}), :);
    % lfp data
    data_lfp = cell(length(dates), 1);
    data_resp = data_lfp;

    for i_date = 1:length(dates)
        file = filenames{dates(i_date)};
        data = load([data_dir file]);
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
    
    % record empty rois
    roi_empty=[];
    for roi_i = 1:roi_num
        locations = cur_level_roi{roi_i, 2};
        % select locations 
        locations = locations(ismember(locations(:,1),dates),:);
        cur_level_roi{roi_i, 2}=locations;
        % change index to current dates order
        for i_date = 1:length(dates)
            locations(locations(:,1)==dates(i_date),1)=i_date;
        end
        
        if isempty(locations)
            roi_empty = [roi_empty roi_i];
            else
            %     loc_dates=unique(locations(:,1));
            lfp = cell(size(locations, 1),1);
            resp = cell(size(locations, 1),1);

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

    % remove empty rois
    roi_lfp(roi_empty)=[];
    roi_resp(roi_empty)=[];
    cur_level_roi(roi_empty,:)=[];
end

% save([data_dir 'roi_odor_resp_5day.mat'],'roi_lfp','roi_resp','cur_level_roi');
