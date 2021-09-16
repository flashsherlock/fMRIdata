data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm035_ane/';
odor_num = 6;
sample_rate=500;
cur_date='200731';
channel=num2str(45);
SPK_chan=strcat('SPK',channel);
CON_chan=strcat('WB',channel);
pattern=[data_dir cur_date '_testo' '*' '_rm035_1_01.plx'];
plxname=dir(pattern);
lfp=cell(1,length(plxname));
for i=1:length(plxname)
% test=1;
fl=[data_dir filesep plxname(i).name];
front=strrep(fl,'.plx','');
%按照每导读取数据，频率信息存在raw_freq中，数据信息存在raw_ad中
[raw_freq, raw_n, raw_ts, raw_fn, raw_ad] = plx_ad(fl,CON_chan);
[n, ts, sv] = plx_event_ts(fl, 'Strobed');
%fieldtrip的格式组织数据
lfp{i}=struct('label',{{}},'trial',{{[]}},'time',{{[]}});
ad_time=(1:raw_n)/raw_freq;
lfp{i}.label{end+1}=CON_chan;
lfp{i}.trial{1}=[lfp{i}.trial{1};raw_ad'];
lfp{i}.time{1}(end+1,:)=ad_time';
lfp{i}.fsample=raw_freq;
%得到plx时间下的呼吸时间点
[~,resp_points,odor_time]=find_resp_time(front);
%分割trial 每个test和date是不一样的，但是不同的通道是一样的
label=repmat([1 2 3],[size(resp_points,1) 1]);
label=reshape(label,[],1);
resp_points=reshape(resp_points,[],1);
trl=zeros(length(resp_points),4);
trl(:,1)=resp_points;
trl(:,4)=label;
% resample
cfg=[];
cfg.resamplefs  = 1000;
lfp{i} = ft_resampledata(cfg,lfp{i});
% filt data
cfg=[];
cfg.bpfilter = 'yes';
cfg.bpfilttype = 'fir';
cfg.bpfreq = [0.7 300];
cfg.bsfilter    = 'yes';
cfg.bsfilttype = 'fir';
cfg.bsfreq      = [49 51];
lfp{i} = ft_preprocessing(cfg,lfp{i});
% cut to trials
trl(:,1:2)=round(trl(:,1:2)*lfp{i}.fsample);
trl(:,2)=trl(:,1)+lfp{i}.fsample*2.5;
offset = -2.5;
trl(:,1)=trl(:,1)+lfp{i}.fsample*offset;
trl(:,3)=lfp{i}.fsample*offset;
cfg=[];
cfg.trl=trl;
lfp{i} = ft_redefinetrial(cfg, lfp{i});
end
lfp = ft_appenddata([],lfp{:});
%% time frequency analysis
% inhale
cfgtf=[];
cfgtf.trials = find(lfp.trialinfo==1);
cfgtf.method     = 'mtmconvol';
cfgtf.toi        = -2.5:0.1:2.5;
cfgtf.foi        = 1:1:100;
cfgtf.t_ftimwin  = ones(length(cfgtf.foi),1).*0.5;
cfgtf.taper      = 'hanning';
cfgtf.output     = 'pow';
cfgtf.keeptrials = 'no';
freq = ft_freqanalysis(cfgtf, lfp);
% baseline correction
cfg              = [];
cfg.baseline     = [-1.5 -0.5];
cfg.baselinetype = 'db';
freq_blc = ft_freqbaseline(cfg, freq);
% check if some of the trials drive the results
%             freq_blc.powspctrm=permute(freq_blc.powspctrm,[3 2 1 4]);
%             freq_blc.freq=freq_blc.freq(1):1:freq_blc.freq(1)+194;
% plot
cfg = [];
% cfg.trials = find(freq_blc.trialinfo==1);
cfg.xlim = [-1.5 2];
cfg.zlim = [-2 2];
cfg.colormap = 'jet';
ft_singleplotTFR(cfg, freq_blc);
% exhale
cfgtf.trials = find(lfp.trialinfo==2);
freq2 = ft_freqanalysis(cfgtf, lfp);
cfg              = [];
cfg.baseline     = [-1.5 -0.5];
cfg.baselinetype = 'db';
freq_blc2 = ft_freqbaseline(cfg, freq2);
cfg = [];
% cfg.trials = find(freq_blc.trialinfo==2);
cfg.xlim = [-1.5 2];
cfg.zlim = [-2 2];
cfg.colormap = 'jet';
ft_singleplotTFR(cfg, freq_blc2);
%% ERP
cfg = [];
cfg.keeptrials = 'yes';
erp = ft_timelockanalysis(cfg, lfp);
cfg              = [];
cfg.baseline     = [-2 0];
erp_blc = ft_timelockbaseline(cfg, erp);
cfg = [];
cfg.trials = find(erp_blc.trialinfo==1);
ft_singleplotER(cfg, erp_blc); 