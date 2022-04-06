function [roi_lfp, roi_resp, level_roi] = save_sep_2monkey(level, trl_type, monkeys)
    %     level=3;
    %     trl_type='odorresp';
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
    roi_lfp={};
    roi_resp={};
    level_roi={};
    data_i=1;
    %% load data
    for monkey_i = 1:length(monkeys)
        monkey = monkeys{monkey_i};
        file_dir = ['/Volumes/WD_D/gufei/monkey_data/yuanliu/' ...
                    lower(monkey) '_ane/mat/'];
        label = [file_dir monkey '_datpos_label.mat'];
        pos = [file_dir monkey '_allpos_coord.mat'];
        load(label);
        load(pos);
        % get coordinates
        allpos_l=permute(allpos_l,[3 1 2]);
        allpos_l=[output(1,:,1);allpos_l(:,:,1)];
        switch monkey
        case 'RM035'
            select=[1:3 7:21];
        case 'RM033'
            select=[1:25];
        end
        allpos_l=allpos_l(select,:);
        % current roi for certain level
        cur_level_roi = ele_date_alevel{level};
        % combine coordinates and labels
        allpos_l = cat(3,allpos_l,output(:,:,level));
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
        
        % transform and combine same locations
        % all_int_pos: interested position index,2 columns
        all_int_pos=cell2mat(cur_level_roi(:,2));
        % find unique values in allpos_l
        coord=zeros(size(all_int_pos,1),3);
        for pos_i=1:size(all_int_pos,1)
            % note that the first row is elect label
            coord(pos_i,:) = allpos_l{all_int_pos(pos_i, 1)+1, all_int_pos(pos_i, 2),1};
        end
        % uni_cor=coord(icood)
        [uni_cor,icood,iunique] = unique(coord,'rows');
        % build information cell
        data_info=cell(size(uni_cor,1),4);
        % find the corresponding label and channel
        for pos_i = 1:size(uni_cor,1)
            % coord
            data_info{pos_i,1}=uni_cor(pos_i,:);            
            % label
            data_info{pos_i,2}=allpos_l{all_int_pos(icood(pos_i),1)+1, all_int_pos(icood(pos_i), 2),2};
            % monkey
            data_info{pos_i,3}=monkey;
            % location indez
            locations = all_int_pos(iunique==pos_i,:);
            data_info{pos_i,4}=locations;
            % select data
            lfp={};
            resp={};
            for i = 1:size(locations, 1)
                % select lfp
                cfg = [];
                cfg.channel = locations(i, 2);
                lfp{i} = ft_selectdata(cfg, data_lfp{locations(i, 1)});
                % rename label to roi name
                lfp{i}.label = {sprintf('%s_%.4f',data_info{pos_i,2},data_info{pos_i,1}(1))};
                % copy resp to match each trial of lfp
                resp{i} = data_resp{locations(i, 1)};
                resp{i}.label{1} = strjoin([resp{i}.label, lfp{i}.label], '_');                
            end
            % combine data from the same location
            cfg = [];
            cfg.keepsampleinfo = 'no';
            roi_lfp{data_i} = ft_appenddata(cfg, lfp{:});
            roi_resp{data_i}= ft_appenddata(cfg, resp{:});
            data_i = data_i + 1;
        end        
        % combine data_info
        level_roi = [level_roi;data_info];
    end    
end

% % check number of trials in each roi
% pos = find(strcmp(cur_level_roi(:,2),'VCo'));
% % get number of trials from roi_lfp
% roi_num_trials = cellfun(@(x) size(x.trialinfo, 1), roi_lfp(pos);
% sum(roi_num_trials)
% save([data_dir 'roi_odor_resp_sep.mat'],'roi_lfp','roi_resp','level_roi');
