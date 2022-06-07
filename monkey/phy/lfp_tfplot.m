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
    ylabel(colorbar, data.cbarlabel)
    
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
    shadedEBar(respx,squeeze(data.resp_mean),1.96*squeeze(data.resp_sem),...
        'lineProps',{'k', 'LineWidth', 2},'patchSaturation',0.2);
    % plot(data.time,data.resp_mean,'k','LineWidth',2)
    set(gca, 'xlim', data.time_range, 'ytick', []);
    title([data.label '-' cor])
    
    % save
    saveas(gcf, [data.pic_dir cor '-' data.label '.' format], format)
    close all
end