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
        p_data = [separated{trial_i,1,1};separated{trial_i,1,2}];
        p_time = 1:size(p_data,2);
        figure;    
        hold on;
        % plot inhalation
        color=[0.5 0.5 0.5;0 0.74902 1];
        for channel_resp = 1:2
            plot(p_time,p_data(channel_resp,:),'Color',color(channel_resp,:),'LineWidth',1.5);
            onpoint = nan(size(p_data,2),1);
            onpoint(separated{trial_i,2,channel_resp})=p_data(channel_resp,separated{trial_i,2,channel_resp});    
            offpoint = nan(size(p_data,2),1);
            offpoint(separated{trial_i,3,channel_resp})=p_data(channel_resp,separated{trial_i,3,channel_resp});
            plot(onpoint,'>','MarkerFaceColor','g','MarkerSize',5*channel_resp);
            plot(offpoint,'^','MarkerFaceColor','k','MarkerSize',5*channel_resp);
        end
        xlim([p_time(1) p_time(end)]);
        % set major tick
        set(gca,'XTick',p_time(1):1000:p_time(end));
        set(gca,'XGrid','on');
        set(gca,'XMinorGrid','on');
    end
end
end