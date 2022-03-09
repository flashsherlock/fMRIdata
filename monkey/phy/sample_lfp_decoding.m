function results = sample_lfp_decoding(data,condition,trial_num)
    cfg = [];    
    switch condition
        case '5odor'
            cfg.trials  = find(data.trialinfo<=5);
            data = ft_selectdata(cfg, data);
        case '6odor'
            % do nothing
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
        case 'fakeva'
            cfg.trials  = find(data.trialinfo<=5);
            data = ft_selectdata(cfg, data);
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
    % sample_data = squeeze(data.trial(I,:,:));
    % zscore
    % passed_data.data=zscore(sample_data,0,2);
    % decoding
    passed_data.data = squeeze(data.trial(I,:,:));
    clear data
    [results,~]=odor_decoding_function(passed_data,length(unique(label)));
    % return condtion and number of selection
    results.analysis=[condition '_' num2str(select_num)];
end