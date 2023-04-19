function separated = resp_separate(out, plot)
if nargin < 2
    plot = 0;
end
trials = size(out.marker,1);
% baselineCorrectedRespiration inhaleOnsets inhaleOffsets marker
separated = cell(trials,4,length(out.bmObj));
odor_time = 7;
for trial_i=1:trials
    % separate resp and inhalation
    for chan_i=1:length(out.bmObj)
        timel = out.marker(trial_i,2)-odor_time*out.bmObj{chan_i}.srate;
        timer = out.marker(trial_i,2)+odor_time*out.bmObj{chan_i}.srate;
        separated{trial_i,1,chan_i}=out.bmObj{chan_i}.baselineCorrectedRespiration(timel:timer);
        separated{trial_i,2,chan_i}=out.bmObj{chan_i}.inhaleOnsets(ismember(out.bmObj{chan_i}.inhaleOnsets,(timel:timer)))-out.marker(trial_i,2)+7*out.bmObj{chan_i}.srate;
        separated{trial_i,3,chan_i}=out.bmObj{chan_i}.inhaleOffsets(ismember(out.bmObj{chan_i}.inhaleOffsets,(timel:timer)))-out.marker(trial_i,2)+7*out.bmObj{chan_i}.srate;
        separated{trial_i,4,chan_i}=out.marker(trial_i,1);
    end
    % plot    
    if plot == 1
        trialplot(separated,trial_i);
    end
end
end