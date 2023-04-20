function separated = resp_separate(out,remove, plot)
if nargin < 3
    plot = 0;
end
if nargin < 2
    remove = [];
end
trials = size(out.marker,1);
% baselineCorrectedRespiration inhaleOnsets inhaleOffsets marker
separated = cell(trials,4,length(out.bmObj));
odor_time = 7;
for trial_i=1:trials
    if ~ismember(out.marker(trial_i,1),remove)
        % separate resp and inhalation
        for chan_i=1:length(out.bmObj)
            srate = out.bmObj{chan_i}.srate;
            timel = out.marker(trial_i,2)-odor_time*srate;
            timer = out.marker(trial_i,2)+odor_time*srate;
            % right padding 5s
            separated{trial_i,1,chan_i}=out.bmObj{chan_i}.baselineCorrectedRespiration(timel:timer+5*srate);
            separated{trial_i,2,chan_i}=out.bmObj{chan_i}.inhaleOnsets(ismember(out.bmObj{chan_i}.inhaleOnsets,(timel:timer)))-out.marker(trial_i,2)+odor_time*srate;
            separated{trial_i,3,chan_i}=out.bmObj{chan_i}.inhaleOffsets(ismember(out.bmObj{chan_i}.inhaleOffsets,(timel:timer)))-out.marker(trial_i,2)+odor_time*srate;
            separated{trial_i,4,chan_i}=out.marker(trial_i,1);
        end
    end
    % plot    
    if plot == 1
        trialplot(separated,trial_i);
    end
end
end