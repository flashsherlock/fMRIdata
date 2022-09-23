freq_hi = freq_sep_all{5};
pow_hi = squeeze(freq_hi.powspctrm);
% unusual 1.75s 106
for i = 106:107
    pow_hi_sus = squeeze(pow_hi(:,:,i));
    data_air = pow_hi_sus(freq_hi.trialinfo==6,:);
    mean_air = mean(data_air);
    std_air = std(data_air);
    z = (pow_hi_sus-mean_air)./std_air;
%     max(z)
%     figure
%     hist(z(:,45),100)
    out = find(any(z>40,2));
    freq_hi.trialinfo(any(z>40,2))
    cfg = [];
    cfg.trials = any(z>40,2);
    lfp = ft_selectdata(cfg, roi_lfp{5});
    cfg          = [];
    cfg.method   = 'trial';
    dummy        = ft_rejectvisual(cfg,lfp);
    cfg = [];
    cfg.viewmode = 'vertical';
    cfg.ylim = 'maxmin';
    eegplot = ft_databrowser(cfg,lfp);
end