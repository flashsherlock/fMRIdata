data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm035_ane/mat/';
dates={'200731','200807','200814','200820','200828'};
for i_date=1:length(dates)
    cur_date=dates{i_date};
    data=load([data_dir cur_date '_rm035_ane.mat']);
    %% cut to trials
    for i=1:length(data.lfp)
    cfg=[];
    cfg.trl=data.trl(i).resp;
    lfp{i} = ft_redefinetrial(cfg, data.lfp{i});
    resp{i} = ft_redefinetrial(cfg, data.bioresp{i});
    end
    %% append data
    cfg=[];
    cfg.keepsampleinfo='no';
    lfp = ft_appenddata(cfg,lfp{:});
    resp = ft_appenddata(cfg,resp{:});
    % remove trials containing nan values
    cfg=[];
    cfg.trials=~(cellfun(@(x) any(any(isnan(x),2)),lfp.trial)...
        |cellfun(@(x) any(any(isnan(x),2)),resp.trial));
    resp=ft_selectdata(cfg,resp);
    lfp=ft_selectdata(cfg,lfp);
    %% time-frequency analysis
    % inhale
    cfgtf=[];
    cfgtf.method     = 'mtmconvol';
    cfgtf.toi        = -3.5:0.01:9.5;
    % inhalation only
    cfgtf.trials = find(lfp.trialinfo==1);
    % cfgtf.foi        = 1:1:100;
    % other wavelet parameters
    cfgtf.foi = logspace(log10(1),log10(200),51);
    % cfgtf.t_ftimwin  = ones(length(cfgtf.foi),1).*0.5;
    cfgtf.t_ftimwin  = 5./cfgtf.foi;
    cfgtf.taper      = 'hanning';
    cfgtf.output     = 'pow';
    cfgtf.keeptrials = 'yes';
    freq_sep_resp = ft_freqanalysis(cfgtf, lfp);
    save([data_dir cur_date '_resp_tf.mat'],'freq_sep_resp','-v7.3')
    clear lfp resp
end