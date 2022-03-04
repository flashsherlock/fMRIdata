function results = sample_lfp_decoding(data,condition,trial_num)
    cfg = [];    
    switch condition
        case '5odor'
            cfg.trials  = find(data.trialinfo<=5);
            data = ft_selectdata(cfg, data);
        case 'airodor'
            data.trialinfo(data.trialinfo<=5) = 1;%odor
            data.trialinfo(data.trialinfo==6) = 2;%air
        case 'vaodor'
            cfg.trials  = find(data.trialinfo<=5);
            data = ft_selectdata(cfg, data);
            % unpleasant
            data.trialinfo(data.trialinfo<=3) = 1;
            % pleasant
            data.trialinfo(data.trialinfo==4 | data.trialinfo==5) = 2;
        case 'banana'
            cfg.trials  = find(data.trialinfo<=5);
            data = ft_selectdata(cfg, data);
            % unpleasant
            data.trialinfo(data.trialinfo<=4) = 1;
            % pleasant
            data.trialinfo(data.trialinfo==5) = 2;
    end
    
    % calculate trial numbers
    t=tabulate(data.trialinfo);
    % find min number
    min_trial_num=min(t(:,2));
    % t(:,2)=t(:,2)-min_trial_num;
    % number of trials
    select_num = min(trial_num,min_trial_num);    
    
    for t_i=1:size(t,1)
        % remove first several trials to balance conditions
%        if t(t_i,2)~=0
%           data.trialinfo(find(data.trialinfo==t(t_i,1),t(t_i,2)))=0;          
%        end
        % randomly select trials
       trials=find(data.trialinfo==t(t_i,1));
       trials=trials(datasample(1:t(t_i,2),t(t_i,2)-select_num,'Replace',false));
       data.trialinfo(trials)=0;
    end
    % select trial
    cfg         = [];
    cfg.trials  = find(data.trialinfo~=0);
    data=ft_selectdata(cfg, data);
    % sort data according to conditions
    [data.trialinfo,I] = sort(data.trialinfo);
    label = data.trialinfo;
    sample_data = squeeze(data.trial(I,:,:));
    % zscore
    % passed_data.data=zscore(sample_data,0,2);
    % decoding
    passed_data.data = sample_data;
    [results,~]=odor_decoding_function(passed_data,length(unique(label)));    
end