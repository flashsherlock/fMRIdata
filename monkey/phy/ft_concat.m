function eeg = ft_concat(data,condition)
    % remove fields
    rmf = setdiff(fieldnames(data),{'label','trialinfo','trial','time','fsample'});
    data = rmfield(data,rmf);
    % select trials
    cfg = [];
    if condition<=6
        % air
        cfg.trials = find(data.trialinfo==condition);
    else
        % odor
        cfg.trials = find(data.trialinfo~=6);
    end
    eeg = ft_selectdata(cfg, data);    
    % set trialinfo
    eeg.trialinfo = condition;
    % concatenate trials
    trials = eeg.trial;
    eeg.trial = cell2mat(trials);          
    % resample
    fsnew = 200;
    eeg.trial = resample(eeg.trial,fsnew,eeg.fsample);
    eeg.fsample = fsnew;
    % set time
    eeg.time = ((1:length(eeg.trial))-1)/eeg.fsample;
end