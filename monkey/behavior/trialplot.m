function trialplot(separated,trial_i)
    p_data = [separated{trial_i,1,1};separated{trial_i,1,2}];
    p_time = (1:size(p_data,2))-1;
    figure('position',[40,40,1500,600]);
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