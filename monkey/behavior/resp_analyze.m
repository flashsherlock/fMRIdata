function separated = resp_analyze(trials_find)
ntrial = size(trials_find,1);
separated = [];
win = 4;
srate = 1000;
% cut respirations
for chan_i=1:size(trials_find,3)
    for trial_i=1:ntrial
        % raw respiration
        resp = trials_find{trial_i,1,chan_i};
        % air
        air_range = trials_find{trial_i,2,chan_i};
        for air_i=1:size(air_range,1)
            data{1}=trials_find{trial_i,4,chan_i};
            % 1-air
            data{2}=1;
            % reverse
            data{3}=size(air_range,1)+1-air_i;            
            data{4}=resp(air_range(air_i,1)+1:air_range(air_i,2)+1);
            data{5}=chan_i;
            data{6}=resp(air_range(air_i,1)+1:air_range(air_i,1)+1+win*srate);
            separated = [separated;data];
        end
        % odor
        odor_range = trials_find{trial_i,3,chan_i};
        for air_i=1:size(odor_range,1)
            data{1}=trials_find{trial_i,4,chan_i};
            % 2-odor
            data{2}=2;
            data{3}=air_i;            
            data{4}=resp(odor_range(air_i,1)+1:odor_range(air_i,2)+1);
            data{5}=chan_i;
            data{6}=resp(odor_range(air_i,1)+1:odor_range(air_i,1)+1+win*srate);
            separated = [separated;data];
        end
    end
end
% analyze AUC,Duration and etc.
for resp_i = 1:size(separated,1)
    % set min resp to 0
    resp = separated{resp_i,4};
    resp = resp-min(resp);
    % AUC
    separated{resp_i,7} = sum(resp)/srate;
    % duration
    separated{resp_i,8} = length(resp)/srate;
    % max
    separated{resp_i,9} = max(resp);
    % speed
    separated{resp_i,10} = sum(resp)/length(resp);
    % resample to 100
    separated{resp_i,11} = resample(resp,500,length(resp));
end
end