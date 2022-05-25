%% set path
monkeys = {'RM035','RM033'};
if length(monkeys)>1
    m = '2monkey';
else
    m = monkeys{1};
end
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/respiration_odor/' m '/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
cur_roi = 'resp';
%% load data
resp_monkey=cell(1,length(monkeys));
for monkey_i = 1:length(monkeys)
    monkey = monkeys{monkey_i};
    file_dir = ['/Volumes/WD_D/gufei/monkey_data/yuanliu/' ...
                lower(monkey) '_ane/mat/'];
    label = [file_dir monkey '_datpos_label.mat'];
    load(label);
    data_resp = cell(length(filenames),1);
    for i_date = 1:length(filenames)
    file = filenames{i_date};
    data = load([file_dir file]);
    %% cut to trials
    resp=cell(1,length(data.lfp));
    for i=1:length(data.lfp)
    cfg=[];
    cfg.trl=data.trl(i).odorresp;
    resp{i} = ft_redefinetrial(cfg, data.bioresp{i});
    end
    %% append data
    cfg=[];
    cfg.keepsampleinfo='no';
    resp = ft_appenddata(cfg,resp{:});
    % remove trials containing nan values
    cfg.trials=~(cellfun(@(x) any(any(isnan(x),2)),resp.trial));
    data_resp{i_date}=ft_selectdata(cfg,resp);
    end
    resp_monkey{monkey_i} = ft_appenddata(cfg,data_resp{:});
end
resp=[];
resp=ft_appenddata(cfg,resp_monkey{:});
%% average and statistics
% % resample
% cfg=[];
% cfg.resamplefs  = 100;
% resp = ft_resampledata(cfg,resp);
% baseline correction
cfg = [];
cfg.keeptrials = 'yes';
erph = ft_timelockanalysis(cfg, resp);
cfg              = [];
cfg.baseline     = [-0.2 0];
bs=linspace(cfg.baseline(1),cfg.baseline(2),100);
erp_blch = ft_timelockbaseline(cfg, erph);

erp_h_blc=cell(1,9);
for i=1:9
% average resperation
cfg=[];
switch i
    case 7
    cfg.trials = find(resp.trialinfo~=6);
    case 8
        cfg.trials = find(resp.trialinfo<=3);
    case 9
        cfg.trials = find(resp.trialinfo==4|resp.trialinfo==5);
    otherwise
    cfg.trials = find(resp.trialinfo==i);
end
% average trials
cfg.avgoverrpt =  'yes';
erp_h_blc{i}=ft_selectdata(cfg,erp_blch);
erp_h_blc{i}.sem = std(squeeze(erp_blch.trial(cfg.trials,:,:)))/sqrt(size(cfg.trials,1));
end

% 5odor+air vs. odor plea vs. unplea
stat_t=cell(1,7);
for odor_i=1:7
    design=erp_blch.trialinfo;
    if odor_i==6
        design(design~=6)=1;
        design(design==6)=2;
    elseif odor_i==7
        design(design<=3)=1;
        design(design==4|design==5)=2;
    else
        design(design==odor_i)=1;
        design(design==6)=2;
    end    
    cfg           = [];
    cfg.method    = 'analytic'; % using a parametric test
    cfg.statistic = 'ft_statfun_indepsamplesT'; % using independent samples
    cfg.correctm  = 'no'; % no multiple comparisons correction
    cfg.alpha     = 0.05;
    cfg.design    = design;
    cfg.ivar      = 1; 
    stat_t{odor_i} = ft_timelockstatistics(cfg, erp_blch);
end
save([pic_dir 'resp_figure_data.mat'],'erp_h_blc','stat_t');
%% plot setting
colors = {'#777DDD', '#69b4d9', '#149ade', '#41AB5D', '#ECB556', '#000000', '#E12A3C', '#777DDD', '#41AB5D', '#DE7B14'};
colors_cp = colors([1:5 7 10]);
%linewidth
lw=cell(1,9);
%linestyle
ls=lw;
for i=1:9
    if i<=5
        lw{i}=1.5;
        if i<=3
            ls{i}='-';
        else
            ls{i}='-';
        end

    else
        lw{i}=1.5;
        ls{i}='-';
    end
end
ls{8}='-';
ls{9}='-';
%% plot
smooth_win=1;
time_range = [-0.2 4];
% plot 5 odors and air
% set renderer to generate vector image
figure('position',[20,0,450,400],'Renderer', 'Painters');
subplot(2,1,1)
hold on
for i=1:7
plot(erp_h_blc{1}.time,smooth(erp_h_blc{i}.trial,smooth_win),'LineStyle',ls{i},'Color',hex2rgb(colors{i}),'LineWidth',lw{i})
% shadedEBar(erp_h_blc{1}.time,squeeze(erp_h_blc{i}.trial),1.96*squeeze(erp_h_blc{i}.sem),...
%     'lineProps',{'LineStyle',ls{i},'Color',hex2rgb(colors{i}),'LineWidth',lw{i}},'patchSaturation',0.2)
end
ylabel('Voltage (V)')
set(gca,'xlim',time_range);
set(gca, 'FontSize', 18);
title([cur_roi '-odor'])
legend('Ind','Iso_l','Iso_h','Pea','Ban','Air','Odor','Location','eastoutside')
hold off
% pvalue
subplot(2,1,2)
hold on
for odor_i=1:6
    % replace 0 with eps
    stat_t{odor_i}.prob=max(stat_t{odor_i}.prob,eps);
    plot(stat_t{odor_i}.time, smooth(stat_t{odor_i}.prob,smooth_win),'Color',hex2rgb(colors_cp{odor_i}),'linewidth', lw{i})
end
time_num=length(stat_t{odor_i}.time);
% number of comparision
% cmp_num=sum(stat_t{odor_i}.time >time_range(1) & stat_t{odor_i}.time <time_range(2));
plot(stat_t{odor_i}.time,0.05*ones(1,time_num),'k','linestyle','--','LineWidth',2)
% plot(stat_t{odor_i}.time,0.05/cmp_num*ones(1,time_num),'r','linestyle','--','LineWidth',2)
set(gca,'ytick',10.^(-2:0),'yscale','log');
set(gca,'ylim',[1e-2 1]);
set(gca,'yminortick','off');
set(gca,'xlim',time_range);
xlabel('Time (s)')
ylabel('p')
legend('Ind','Iso_l','Iso_h','Pea','Ban','Odor','0.05','Location','eastoutside')
set(gca, 'FontSize', 18);
saveas(gcf, [pic_dir cur_roi '-5odor', '.fig'],'fig')
saveas(gcf, [pic_dir cur_roi '-5odor', '.png'],'png')
saveas(gcf, [pic_dir cur_roi '-5odor', '.pdf'],'pdf')
% print(gcf, [pic_dir cur_roi '-5odor', '.pdf'],'-dpdf')
close all

%% power spectrum analysis
cfg         = [];
cfg.latency = [0 9.5];
resp_s=ft_selectdata(cfg, resp);
% frequency spectrum
cfg         = [];
cfg.output  = 'pow';
cfg.method  = 'mtmfft';
cfg.taper   = 'hanning';
cfg.keeptrials = 'yes';
cfg.foilim = [0.1 5];
% cfg.foi = 0.1:0.1:5;
spectr_resp_all  = ft_freqanalysis(cfg, resp_s);
%% average each condition
odor_num=7;
spectr_resp=cell(odor_num);
spectr_respz=spectr_resp;
for odor_i=1:odor_num
    resp_select = spectr_resp_all;
    % frequency spectrum
    cfg         = [];
    cfg.avgoverrpt =  'yes';
    if odor_i==7
        cfg.trials  = find(resp_select.trialinfo~=6);
    else
        cfg.trials  = find(resp_select.trialinfo==odor_i);
    end
    spectr_resp{odor_i} = ft_selectdata(cfg, resp_select);
    
    % zscore
    resp_select.powspctrm = zscore(resp_select.powspctrm,0,1);
    spectr_respz{odor_i} = ft_selectdata(cfg, resp_select);
end
%% statisticss
spectr_resp_p=cell(odor_num-1);
for odor_i=1:odor_num-1
% odor vs. air
design=spectr_resp_all.trialinfo;
if odor_i==odor_num-1
    design(design~=6)=1;
else
    design(design==odor_i)=1;
end
design(design==6)=2;
cfg           = [];
cfg.method    = 'analytic'; % using a parametric test
cfg.statistic = 'ft_statfun_indepsamplesT'; % using independent samples
cfg.correctm  = 'no'; % no multiple comparisons correction
cfg.alpha     = 0.05;
cfg.design    = design;
cfg.ivar      = 1;
spectr_resp_p{odor_i} = ft_freqstatistics(cfg, spectr_resp_all);
end
%% plot
colors = {'#777DDD', '#69b4d9', '#149ade', '#41AB5D', '#ECB556', '#000000', '#E12A3C', '#777DDD', '#41AB5D'};
colors_cp = colors([1:5 7]);
smooth_win=1;
freq_win=[0.1 5];
line_wid=1.5;
% plot raw power
figure('position',[20,20,600,600]);
subplot(3,1,1)
hold on;
for odor_i=1:odor_num
    plot(spectr_resp{odor_i}.freq, smooth(mean(spectr_resp{odor_i}.powspctrm,1),smooth_win),'Color',hex2rgb(colors{odor_i}),'linewidth', line_wid)
end
set(gca,'yscale','log');
set(gca,'xlim',freq_win);
title('respiration')
legend('Ind','Iso_l','Iso_h','Peach','Banana','Air','Odor')
ylabel('Power')
% plot zscore
subplot(3,1,2)
hold on;
for odor_i=1:odor_num
    plot(spectr_respz{odor_i}.freq, smooth(mean(spectr_respz{odor_i}.powspctrm,1),smooth_win),'Color',hex2rgb(colors{odor_i}),'linewidth', line_wid)
end
set(gca,'xlim',freq_win);
ylabel('ZPower')
% plot p value
subplot(3,1,3)
hold on
for odor_i=1:odor_num-1
    % replace 0 with eps
    spectr_resp_p{odor_i}.prob=max(spectr_resp_p{odor_i}.prob,eps);
    plot(spectr_resp_p{odor_i}.freq, smooth(spectr_resp_p{odor_i}.prob,smooth_win),'Color',hex2rgb(colors_cp{odor_i}),'linewidth', line_wid)
end
freq_num=length(spectr_resp_p{odor_i}.freq);
% number of comparision
cmp_num=sum(spectr_resp_p{odor_i}.freq >freq_win(1) & spectr_resp_p{odor_i}.freq <freq_win(2));
plot(spectr_resp_p{odor_i}.freq,0.05*ones(1,freq_num),'k','linestyle','--','LineWidth',2)
plot(spectr_resp_p{odor_i}.freq,0.05/cmp_num*ones(1,freq_num),'r','linestyle','--','LineWidth',2)
set(gca,'yscale','log');
set(gca,'ylim',[0 1]);
set(gca,'xlim',freq_win);
xlabel('Frequency (Hz)')
ylabel('p')
saveas(gcf, [pic_dir 'respiration' '-zpower(0-9.5s)', '.fig'], 'fig')
saveas(gcf, [pic_dir 'respiration' '-zpower(0-9.5s)', '.png'], 'png')
close all