%% load and reorganize data
monkeys = {'RM035','RM033'};
if length(monkeys) > 1
    m = '2monkey';
else
    m = monkeys{1};
end
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/coherence/sep_elec/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
% odor conditions
odor_num=4;
% 1-respiration 2-theta
low={'respiration','theta'};
%% generate data
if exist([pic_dir 'coherence_sep_7s.mat'],'file')
    load([pic_dir 'coherence_sep_7s.mat'])
else
    level = 3;
    trl_type = 'odorresp';
    % combine 2 monkeys
    [roi_lfp,roi_resp,cur_level_roi] = save_sep_2monkey(level,trl_type,monkeys);
    % parameters 
    % number of roi
    roi_num=size(cur_level_roi,1);    
    % odor and air condition
    cross_freq_result=cell(roi_num,length(low),odor_num);
    % time and method
    latency = [0 7];
    freqhigh = 80;
    method = 'mi';
    nper=1000;
    %% cross frequency analysis
    for roi_i=1:roi_num
        % display progress
        len = 50;
        fin = floor(len*roi_i/roi_num);
        disp([num2str(roi_i) repmat('=',1,fin) '>' repmat('_',1,len-fin) num2str(roi_num)])
        % must have the same label
        roi_resp{roi_i}.label = roi_lfp{roi_i}.label;
        % select 7s
        cfg = [];
        cfg.latency= latency;
        for con_i = 1:odor_num
            % concatenate trials manually
            lfp = ft_concat(ft_selectdata(cfg,roi_lfp{roi_i}), con_i+5);
            resp = ft_concat(ft_selectdata(cfg,roi_resp{roi_i}), con_i+5);
            time = resp.time;
            % frequency analysis
            cfg_tf=[];
            cfg_tf.output='fourier';
            cfg_tf.method='mtmconvol';
            cfg_tf.taper='hanning';
            cfg_tf.toi = [0:1:time(end)]; 
            cfg_tf.keeptrials='yes';
            % cfg_tf.pad = 'nextpow2';
            % resp
            cfg_tf.foi=0.2:0.1:0.5;
            % cfg_tf.t_ftimwin = ones(length(cfg_tf.foi),1).*2;
            cfg_tf.t_ftimwin = 5./cfg_tf.foi;
            resp_freq=ft_freqanalysis(cfg_tf,resp);
            % lfp
            cfg_tf.foi=1:freqhigh;
            % cfg_tf.t_ftimwin = ones(length(cfg_tf.foi),1).*1;
            cfg_tf.t_ftimwin = 5./cfg_tf.foi;
            lfp_freq=ft_freqanalysis(cfg_tf,lfp);

            resp_freq.dimord = 'rpt_chan_freq_time';
            lfp_freq.dimord = 'rpt_chan_freq_time';

            % select non nan data
            cfg = [];
            cfg.latency= [15 time(end)-15];
            resp_freq = ft_selectdata(cfg,resp_freq);
            lfp_freq = ft_selectdata(cfg,lfp_freq);

            % modulation index
            cfg=[];
            cfg.freqlow = [0.1 1];
            cfg.freqhigh = [1 freqhigh];
            cfg.method = method;
            cfg.keeptrials = 'yes';
            cross_freq_result{roi_i,1,con_i} = ft_crossfrequencyanalysis(cfg, resp_freq, lfp_freq);
            cfg.freqlow = [4 8];
            cfg.freqhigh = [13 freqhigh];
            cross_freq_result{roi_i,2,con_i} = ft_crossfrequencyanalysis(cfg, lfp_freq, lfp_freq);
            % remove cfg
            for low_i=1:length(low)
                cross_freq_result{roi_i,low_i,con_i} = rmfield(cross_freq_result{roi_i,low_i,con_i}, 'cfg');        
            end
            %% permutation test

            cross_resp_per=zeros([size(squeeze(cross_freq_result{roi_i,1,con_i}.crsspctrm)) nper]);
            cross_theta_per=zeros([size(squeeze(cross_freq_result{roi_i,2,con_i}.crsspctrm)) nper]);

            parfor per_i=1:nper
                lfp_per_freq = lfp_freq;
                % cut and move
                time_len = length(lfp_per_freq.time);
                    cutp=randi([2 time_len],size(lfp_per_freq.fourierspctrm,1),1);
                for trial_i=1:size(lfp_per_freq.fourierspctrm,1)
                    temp=lfp_per_freq.fourierspctrm(trial_i,:,:,:);
                    lfp_per_freq.fourierspctrm(trial_i,:,:,:)=temp(:,:,:,[cutp(trial_i):time_len 1:cutp(trial_i)-1]);
                end
                % coherence
                cfg=[];
                cfg.freqlow = [0.1 1];
                cfg.freqhigh = [1 freqhigh];
                cfg.method = method;
                cfg.keeptrials = 'yes';
                temp = ft_crossfrequencyanalysis(cfg, resp_freq, lfp_per_freq);
                % save results to matrix
                    cross_resp_per(:,:,per_i) = squeeze(temp.crsspctrm);
                % theta
                cfg.freqlow = [4 8];
                cfg.freqhigh = [13 freqhigh];
                temp = ft_crossfrequencyanalysis(cfg, lfp_freq, lfp_per_freq);
                % save results to matrix        
                    cross_theta_per(:,:,per_i) = squeeze(temp.crsspctrm);
            end
            % save to a field in cross_freq_results
            cross_freq_result{roi_i,1,con_i}.permute = cross_resp_per;
            cross_freq_result{roi_i,2,con_i}.permute = cross_theta_per;
        end
    end
    save([pic_dir 'coherence_sep_7s.mat'],'cross_freq_result','cur_level_roi','-v7.3')
end
%% calculate normalized results
roi_num=size(cur_level_roi,1);
zmi = cell(roi_num,length(low),odor_num);
for roi_i=1:size(cross_freq_result,1)
    % respiration and theta
    for low_i=1:length(low)        
        % calculate normalized mi
        for odor_i=1:odor_num            
            % rpt_chan_freqlow_freqhigh
            plv=cross_freq_result{roi_i,low_i,odor_i}.crsspctrm;
            % chan_freqlow_freqhigh_nper
            plv_per=cross_freq_result{roi_i,low_i,odor_i}.permute;
            % calculate zscore according to permutated distribution
            mean_per = mean(plv_per,3);
            std_per = std(plv_per,0,3);
            zmi{roi_i,low_i,odor_i} = mean((squeeze(plv)-mean_per)./std_per);           
        end
    end
end
%% output data
file_dir = [data_dir '../IMG/'];
% load coordinates from 5odor distance
dis_data = dlmread([file_dir  '2m_odor5.csv']);
for low_i=1:length(low)
    dis_data = [dis_data(:,1:3) reshape(cell2mat(zmi(:,low_i,:)),roi_num,[])];
    dlmwrite([file_dir  '2m_coherence_' low{low_i} '.csv'],dis_data,'delimiter',',');
end
%% correlation between x,y,z and distances
xl = {'x','y','z'};
yl = {'Air','Odor','UnPlea','Plea','Odor-Air'};
freq = {[13:80]};
monkeys = {'RM033','RM035','2m'};
plot_data = cell(length(low),length(freq));
for low_i=1:length(low)
    % select data
    dis_data_select = cell2mat(zmi(:,low_i,:));
    for freq_i=1:length(freq)
        % select frequency
        if size(dis_data_select,2)==68
            freqs = 13:80;
        else
            freqs = 1:80;
        end
        dis_data_select = [dis_data(:,1:3) squeeze(mean(dis_data_select(:,ismember(freqs,freq{freq_i}),:),2))];        
        % condition 5:odor-air
        dis_data_select(:,3+odor_num+1) = dis_data_select(:,3+2)-dis_data_select(:,3+1);
        plot_data{low_i,freq_i}=dis_data_select;
        % monkey
        for m = 1:length(monkeys)
            figure('position',[20,450,900,1400],'Renderer','Painters');
            % select roi
        %     index = ~ismember(cur_level_roi(:,2),{'Hi','S'});
        %     dis_data_select = dis_data_select(index,:);
            switch monkeys{m}
                case 'RM033'
                    dis_data_select = dis_data_select(dis_data_select(:,1)<0,:);
                case 'RM035'
                    dis_data_select = dis_data_select(dis_data_select(:,1)>0,:);
            end
            % odor condition
            for odor_i=1:odor_num+1                
                % change x to abs(x)
                dis_data_select(:,1) = abs(dis_data_select(:,1));
                % plot 3 coords
                coord = 3;                         
                for j=1:coord
                    % get data
                    x = dis_data_select(:,j);
                    y = dis_data_select(:,3+odor_i);
                    % correlation
                    [r,p]=corr(x,y);
                    % scatter plot
                    subplot(odor_num+1,coord,(odor_i-1)*coord+j,'align');
                    scatter(x,y,'.')
                    % add regression line
                    hold on
                    pfit = polyfit(x, y, 1);
                    ycalc = polyval(pfit, x);
                    plot(x,ycalc,'k')
                    % add r and p values
                    xlabel(xl(j))
                    ylabel(yl(odor_i))
                    set(gca,'xlim',[min(x)-1 max(x)+1],'FontSize',18);
                    position = get(gca,'ylim');
                    text(min(x),max(max(y)+1,position(2)-1),[sprintf('r=%0.2f, p=%0.3f',round(r,2),round(p,3))],'Fontsize',18)                
                end
            end
            suptitle([monkeys{m} '-' low{low_i}])
            saveas(gcf, [pic_dir 'corr_' [monkeys{m} '-' low{low_i}] '.svg'],'svg')
            close all
        end
    end
end
%% plot each distance
right_AH = ft_read_headshape([file_dir 'right_AH_level5.stl'],'format','stl');
right_AH.coordsys = 'acpc';
left_AH = ft_read_headshape([file_dir 'left_AH_level5.stl'],'format','stl');
left_AH.coordsys = 'acpc';
meshcolor = 0.75*[1 1 1];
meshalpha = 0.2; 
for dim_i=1:length(low)
    for freq_i=1:length(freq)
        for dis=1:5
            % data to be ploted
            color_data = plot_data{dim_i,freq_i};
            color_data = color_data(:,3+dis);
            for plot_i = 1:2
                % scatter3 plot plot_data and use color_data to color
                figure
                hold on    
                ft_plot_mesh(right_AH,'facecolor',meshcolor,'facealpha',meshalpha);
                if plot_i == 2
                    % separate left and right
                    ft_plot_mesh(left_AH,'facecolor',meshcolor,'facealpha',meshalpha);
                    scatter3(dis_data(:,1),dis_data(:,2),dis_data(:,3),25,color_data,'filled')
                else
                    % flip RM033 to right side
                    scatter3(abs(dis_data(:,1)),dis_data(:,2),dis_data(:,3),25,color_data,'filled')
                end
                % set colorscale
                set(gca,'clim',[-1 1],'FontSize',18)
        %         set(gca,'xlim',[-15 15],'ylim',[10 25],'zlim',[0 10])
                colormap(bluered(1000))
                ylabel(colorbar,[yl{dis} '-' num2str(dim_i)])
                xlabel('x')
                ylabel('y')
                zlabel('z')
                view(125,30)%37.5,30
                title([yl{dis} '-' num2str(dim_i)])
                saveas(gcf, [pic_dir num2str(plot_i) 'side_'  yl{dis} '_' num2str(dim_i) '.png'],'png')
                saveas(gcf, [pic_dir num2str(plot_i) 'side_'  yl{dis} '_' num2str(dim_i) '.fig'],'fig')
                close all
            end
        end
    end
end