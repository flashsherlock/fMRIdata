function results = sample_lfp_decoding(data,condition,trial_num)
    cfg = [];
    balence = 0;
    switch condition
        case '5odor'
            cfg.trials  = find(data.trialinfo<=5);
            data = ft_selectdata(cfg, data);
        case '6odor'
            % do nothing
        case 'airodor'
            balence = 1;
            weight = [ones(1,5)/5 1];
            data.trialinfo(data.trialinfo<=5) = 1;%odor
            data.trialinfo(data.trialinfo==6) = 2;%air
        case 'vaodor'
            balence = 1;
            weight = [0.5 0.25 0.25 0.5 0.5];
            cfg.trials  = find(data.trialinfo<=5);
            data = ft_selectdata(cfg, data);
            % original trialinfo
            orig_info = data.trialinfo;
            % unpleasant
            data.trialinfo(data.trialinfo<=3) = 1;
            % pleasant
            data.trialinfo(data.trialinfo==4 | data.trialinfo==5) = 2;        
        case 'banana'
            balence = [ones(1,4)/4 1];
            cfg.trials  = find(data.trialinfo<=5);
            data = ft_selectdata(cfg, data);
            % original trialinfo
            orig_info = data.trialinfo;
            % unpleasant
            data.trialinfo(data.trialinfo<=4) = 1;
            % pleasant
            data.trialinfo(data.trialinfo==5) = 2;
        case 'fakeva'
            balence = 1;
            weight = [0.25 0.5 0.5 0.25 0.5];
            cfg.trials  = find(data.trialinfo<=5);
            data = ft_selectdata(cfg, data);
            % original trialinfo
            orig_info = data.trialinfo;
            % ind iso_l pea
            data.trialinfo(data.trialinfo<=2 | data.trialinfo==4) = 1;
            % iso_h ban
            data.trialinfo(data.trialinfo==3 | data.trialinfo==5) = 2;
        case 'intensity'
            cfg.trials  = find(data.trialinfo==2 | data.trialinfo==3);
            data = ft_selectdata(cfg, data);
            % change to 1 and 2 to avoid 0 count of 1 in tabulate
            data.trialinfo = data.trialinfo-1;
    end
    % calculate trial numbers
    if balence == 0    
        info=data.trialinfo;
        t=tabulate(data.trialinfo);
        % find select number
        min_trial_num=min(t(:,2));
        select_num = min(trial_num,min_trial_num)*ones(size(t,1),1);
    else
        info=orig_info;
        t=tabulate(orig_info);
        % find select number
        actual = t(:,2)./weight';        
        if any(actual < trial_num)
            select_num = min(actual)*weight';
        else
            select_num = trial_num*weight';
            % check whether select_num is an integer array
            if any(mod(select_num,1))~=0
                error('Inappropriate trial number!');
            end
        end
    end
    % find min number
    % min_trial_num=min(t(:,2));
    % t(:,2)=t(:,2)-min_trial_num;
    % number of trials
    % select_num = min(trial_num,min_trial_num);    
    
    for t_i=1:size(t,1)
        % remove first several trials to balance conditions
%        if t(t_i,2)~=0
%           data.trialinfo(find(data.trialinfo==t(t_i,1),t(t_i,2)))=0;          
%        end
        % randomly select trials
       trials=find(info==t(t_i,1));
       trials=trials(datasample(1:t(t_i,2),t(t_i,2)-select_num(t_i),'Replace',false));
       data.trialinfo(trials)=0;
    end
    % select trial
    cfg         = [];
    cfg.trials  = find(data.trialinfo~=0);
    data=ft_selectdata(cfg, data);
    % sort data according to conditions
    [data.trialinfo,I] = sort(data.trialinfo);
    label = data.trialinfo;
    % sample_data = squeeze(data.trial(I,:,:));
    % zscore
    % passed_data.data=zscore(sample_data,0,2);
    % decoding
    passed_data.data = squeeze(data.trial(I,:,:));
    clear data
    [results,~]=odor_decoding_function(passed_data,length(unique(label)));
    % return condtion and number of selection
    results.analysis=[condition '_' num2str(select_num')];
end