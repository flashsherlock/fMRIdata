function lfp_tfplot(data,cluster,format)
    if nargin < 3
        format = 'png';
    end
    % parameters
    level = 40;
    if exist('cluster','var') && cluster == 1
        map = data.zmapthresh;
        cor = 'cluster';
    else
        map = data.un_zmapthresh;
        cor = 'uncorrected';
    end
    
    % plot by contourf cluster based correction
    figure('Renderer','Painters');
    hold on
    contourf(data.time, data.freq, squeeze(data.powspctrm), level, 'linecolor', 'none');
    yt = logspace(log10(data.freq_range(1)), log10(data.freq_range(2)), 10);
    set(gca, 'ytick', round(yt,2), 'yscale', 'log');
    set(gca, 'ylim', data.freq_range, 'xlim', data.time_range, 'clim', data.clim);
    % colorbarlabel('Baseline-normalized power (dB)')
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colormap jet
    % colormap(bluered(1000))
    % ylabel(colorbar, data.cbarlabel)
    c = colorbar;
    c.Label.String = data.cbarlabel;
    c.Label.FontSize = 18;
    c.Ticks = min(data.clim):1:max(data.clim);
    
    % map
    contour(data.time,data.freq, map ,1,'linecolor','k','LineWidth',1)
    set(gca, 'yminortick', 'off');
    
    % plot baseline
    baseidx(1) = dsearchn(data.time',data.bs(1));
    baseidx(2) = dsearchn(data.time',data.bs(2));
    data.bs = data.time(baseidx(1):baseidx(2));
    plot(data.bs, data.freq_range(1) * ones(size(data.bs)), 'k', 'LineWidth', 5)
    
    % plot respiration
    yyaxis right
    respx = linspace(data.time(1),data.time(end),length(data.resp_mean));
    
    % use shadedEBar to plot resp
    % shadedEBar(respx,squeeze(data.resp_mean),1.96*squeeze(data.resp_sem),...
    %    'lineProps',{'k', 'LineWidth', 2},'patchSaturation',0.2);
    
    % use stdshade to plot resp
    stdshade(squeeze(data.resp_mean)',1.96*squeeze(data.resp_sem)',0.2,hex2rgb('000000'),respx);
    
    % only mean value
    % plot(data.time,data.resp_mean,'k','LineWidth',2)
    
    set(gca, 'xlim', data.time_range, 'ytick', []);
    set(gca,'FontSize',18)    
    % title([data.label '-' cor])
    t=strsplit(data.label,'-');
    title(t{1})
    
    % save
    saveas(gcf, [data.pic_dir cor '-' data.label '.' format], format)
    close all
end