%% load and reorganize data
% monkeys = {'RM035','RM033'};
monkeys = {'RM035'};
if length(monkeys) > 1
    m = '2monkey';
else
    m = monkeys{1};
end
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/coherence/' m '/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
% generate data
level = 3;
trl_type = 'odor';
% combine 2 monkeys
[roi_lfp,roi_resp,cur_level_roi] = save_merge_2monkey(level,trl_type);

% one monkey data
% one_data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm035_ane/mat/';
% label=[one_data_dir 'RM035_datpos_label.mat'];
% dates=16;
% [roi_lfp,roi_resp,cur_level_roi] = save_merge_position(one_data_dir,label,dates,level,trl_type);

%% parameters 
% number of roi
roi_num=size(cur_level_roi,1);
odor_num=7;
% 1-respiration 2-theta
low={'-respiration','-theta'};
cross_freq_result=cell(roi_num,length(low));
% time and method
latency = [0 7];
method = 'mi';
nper=1000;
% plot 
colors = {'#777DDD', '#69b4d9', '#149ade', '#41AB5D', '#ECB556', '#000000', '#E12A3C', '#777DDD', '#41AB5D'};
line_wid = 1.5;
%% cross frequency analysis
for roi_i=1:roi_num
    % must have the same label
    roi_resp{roi_i}.label = roi_lfp{roi_i}.label;
    % frequency analysis
    cfg=[];
    cfg.output='fourier';
    cfg.method='mtmconvol';
    cfg.taper='hanning';
    cfg.toi = -3.5:0.05:9.5; 
    cfg.keeptrials='yes';
    % resp
    cfg.foi=0.1:10;
    cfg.t_ftimwin = ones(length(cfg.foi),1).*0.5;
    resp_freq=ft_freqanalysis(cfg,roi_resp{roi_i});
    % lfp
    cfg.foi=1:200;
    cfg.t_ftimwin = ones(length(cfg.foi),1).*0.5;
    lfp_freq=ft_freqanalysis(cfg,roi_lfp{roi_i});

    % select 7s
    cfg = [];
    cfg.latency= latency;
    resp_freq = ft_selectdata(cfg,resp_freq);
    lfp_freq = ft_selectdata(cfg,lfp_freq);
    % modulation index
    cfg=[];
    cfg.freqlow = [0 10];
    cfg.freqhigh = [1 200];
    cfg.method = method;
    cfg.keeptrials = 'yes';
    cross_freq_result{roi_i,1} = ft_crossfrequencyanalysis(cfg, resp_freq, lfp_freq);
    cfg.freqlow = [4 8];
    cfg.freqhigh = [13 200];
    cross_freq_result{roi_i,2} = ft_crossfrequencyanalysis(cfg, lfp_freq);
    
    % TODO: permutation test
    
    % add trialinfo and remove cfg
    for low_i=1:length(low)
        cross_freq_result{roi_i,low_i}.trialinfo = roi_lfp{roi_i}.trialinfo;
        cross_freq_result{roi_i,low_i} = rmfield(cross_freq_result{roi_i,low_i}, 'cfg');
        end
    
    end

%% plot
for roi_i=1:roi_num
    % respiration and theta
    for low_i=1:length(low)        
        
        figure('position',[20,20,600,600]);
        % modulation index
        subplot(2,1,1)
        hold on;
        title([cur_level_roi{roi_i,1} low{low_i}])
        freqs=cross_freq_result{roi_i,low_i}.freqhigh;
        
        % calculate mean modulation index and plot
        for odor_i=1:odor_num
            % slect trials
            if odor_i==7
                trials  = find(cross_freq_result{roi_i,low_i}.trialinfo~=6);
            else
                trials  = find(cross_freq_result{roi_i,low_i}.trialinfo==odor_i);
            end       
            % rpt_chan_freqlow_freqhigh
            plv=cross_freq_result{roi_i,low_i}.crsspctrm(trials,:,:,:);
            plot(freqs,squeeze(mean(mean(plv,1),3)),...
                'Color',hex2rgb(colors{odor_i}),'linewidth', line_wid)
        end
        set(gca,'xlim',[13 80]);
        set(gca,'XTick',[13 20:10:80]);
        set(gca,'XTickLabel',[13 20:10:80]);
        legend('Ind','Iso_l','Iso_h','Peach','Banana','Air','Odor')
        ylabel('Modulation Index')
        
        % p-value
        subplot(2,1,2)
        hold on;
        for odor_i=1:odor_num
            plot(freqs,cross_freq_result{roi_i,odor_i}.MIp(low_i,2:end),...
                'Color',hex2rgb(colors{odor_i}),'linewidth', line_wid)
        end
        % 0.05
        plot(freqs,0.05*ones(1,length(freqs)),'k','linestyle','--','LineWidth',2)
        set(gca,'xlim',[freqs(1) freqs(end)]);
        ylabel('p')
        xlabel('Frequency(Hz)')  
        % save picture
        saveas(gcf, [pic_dir cur_level_roi{roi_i,1} low{low_i} '-mi', '.fig'], 'fig')
        saveas(gcf, [pic_dir cur_level_roi{roi_i,1} low{low_i} '-mi', '.png'], 'png')
        close all
    end  
end
save([pic_dir 'coherence_8s.mat'],'cross_freq_result')