function eeg = ft_concat(data,trial)
    % remove fields
    rmf = setdiff(fieldnames(data),{'label','trialinfo','trial','time','fsample'});
    data = rmfield(data,rmf);
    % select trials
    cfg = [];
    cfg.trials = find(data.trialinfo == trial);
    eeg = ft_selectdata(cfg, data);    
    % set trialinfo
    eeg.trialinfo = trial;
    % concatenate trials
    trials = eeg.trial;
    eeg.trial = cell2mat(trials);
    % set time
    eeg.time = ((1:length(eeg.trial))-1)/eeg.fsample;
end