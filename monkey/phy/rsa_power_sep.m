%% load and reorganize data
monkeys = {'RM035','RM033'};
if length(monkeys) > 1
    m = '2monkey';
else
    m = monkeys{1};
end
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/rsa_power/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
level = 3;
trl_type = 'odorresp';
odor_num=7;
%% load data or generate data
if exist([data_dir 'tf_sep_' m '.mat'],'file')
    load([data_dir 'tf_sep_' m '.mat'])
    % get number of positions
    roi_num=size(cur_level_roi,1);
else
    % combine 2 monkeys
    [roi_lfp,roi_resp,cur_level_roi] = save_sep_2monkey(level,trl_type,monkeys);
    % get number of positions
    roi_num=size(cur_level_roi,1);    
    % TF analysis
    freq_sep_all=cell(roi_num,1);
    for roi_i=1:roi_num
        cur_roi=cur_level_roi{roi_i,1};
        % filt data
        cfg=[];
        cfg.bsfilter    = 'yes';
        cfg.bsfilttype = 'fir';
        cfg.bsfreq      = [99 101;149 151;199 201];
        lfp = ft_preprocessing(cfg,roi_lfp{roi_i});
        % time frequency analysis
        cfgtf=[];
        cfgtf.method     = 'mtmconvol';
        cfgtf.toi        = -3.5:0.05:9.5;
        % cfgtf.foi        = 1:1:100;
        % other wavelet parameters
        cfgtf.foi = logspace(log10(1),log10(200),51);
        % cfgtf.t_ftimwin  = ones(length(cfgtf.foi),1).*0.5;
        cfgtf.t_ftimwin  = 5./cfgtf.foi;
        cfgtf.taper      = 'hanning';
        cfgtf.output     = 'pow';
        cfgtf.keeptrials = 'yes';
        freq_sep_all{roi_i} = ft_freqanalysis(cfgtf, lfp);
    end
    save([data_dir 'tf_sep_' m '.mat'],'freq_sep_all','cur_level_roi','-v7.3')
end
%% analyze mean distance
if exist([pic_dir 'dis_sep_rsa.mat'],'file')
    load([pic_dir 'dis_sep_rsa.mat'])
else
    dis_mean = zeros(roi_num,10,3);
    % 1-no pca, 2 and 3 pca dimension
    for dim_i=1:3
        for roi_i=1:roi_num
            cur_roi = cur_level_roi{roi_i,1};
            % get data
            data = squeeze(freq_sep_all{roi_i}.powspctrm);
            % time range
            time_range = [0 3];
            t_range = [num2str(time_range(1)) '-' num2str(time_range(2)) 's'];
            time_idx = dsearchn(freq_sep_all{roi_i}.time', time_range');
            % frequency below 80Hz
            data = data(:,1:42,time_idx(1):time_idx(2));
            % calculate z score
            data = zscore(data,0,1);
            % label
            label = freq_sep_all{roi_i}.trialinfo;
            % odor mean
            mean_data = zeros(length(unique(label)),size(data,3),size(data,2));
            mean_label = repmat([1:length(unique(label))]',[1,size(data,3)]);
            for odor_i = 1:length(unique(label))
                mean_data(odor_i,:,:) = squeeze(mean(data(label==odor_i,:,:),1))';
            end
            data = reshape(mean_data,[],size(data,2));
            label = reshape(mean_label,[],1);
            % pca or not
            if dim_i ~= 1
                % method
                % mapped = compute_mapping(data,'t-SNE', n_dim, init_dim, perplex);
                [mapped, mapping]= compute_mapping(data,'PCA', size(data,2));   
                mapped = mapped(:,1:dim_i);
                % reshape to odor by time&dim    
                dis_data = reshape(mapped,length(unique(label)),[]);
            else
                dis_data = reshape(data,length(unique(label)),[]);
            end
            % remove air
            dis_data = dis_data(1:end-1,:);
            % distance matrix
            % dis = 'euclidean';
            dis = 'correlation';
            cur_dis = pdist2(dis_data,dis_data,dis);
            dis_mean(roi_i,:,dim_i) = cur_dis(triu(true(size(cur_dis)), 1));
        end
    end
    save([pic_dir 'dis_sep_rsa.mat'],'dis_mean','cur_level_roi')
end
%% correlation with ratings
% load human rating
load('/Volumes/WD_D/gufei/monkey_data/human_rating/rating_inva.mat')
% get field names from stuct rating
fn = fieldnames(rating);
nrate = 5;
fn = fn(1+nrate:end);
% extract rdm data to a matrix
rate = zeros(nrate,10);
for i = 1:nrate
    cur_dis = rating.(fn{i});
    rate(i,:) = cur_dis(triu(true(size(cur_dis)), 1));
end
% correlation between ratings
disp(fn')
disp(corr(rate'))
% rsa
rsa_r = zeros(roi_num,nrate,3);
% 1-no pca, 2 and 3 pca dimension
for dim_i=1:3
    for roi_i=1:roi_num
        rsa_r(roi_i,:,dim_i) = corr(dis_mean(roi_i,:,dim_i)',rate', 'type', 'Spearman');
    end
end
%% output data
file_dir = [data_dir '../IMG/'];
% load coordinates from 5odor distance
dis_data = dlmread([file_dir  '2m_odor5.csv']);
dis_data = [dis_data(:,1:3) reshape(rsa_r,size(rsa_r,1),[])];
dlmwrite([file_dir  '2m_rsa.csv'],dis_data,'delimiter',',');
%% correlation between x,y,z and distances
xl = {'x','y','z'};
yl = strrep(fn,'RDM','');
monkeys = {'RM033','RM035','2m'};
for dim_i=1:3
    for m = 1:length(monkeys)
        figure('position',[20,450,900,1400],'Renderer','Painters');
        % change x to abs(x)
        dis_data_select = dis_data(:,[1:3 4+5*(dim_i-1):8+5*(dim_i-1)]);
        % select roi
    %     index = ~ismember(cur_level_roi(:,2),{'Hi','S'});
    %     dis_data_select = dis_data_select(index,:);
        switch monkeys{m}
            case 'RM033'
                dis_data_select = dis_data_select(dis_data_select(:,1)<0,:);
            case 'RM035'
                dis_data_select = dis_data_select(dis_data_select(:,1)>0,:);
        end
        dis_data_select(:,1) = abs(dis_data_select(:,1));
        % plot 3 coords
        coord = 3;
        for dis=1:nrate
            for j=1:coord
                % get data
                x = dis_data_select(:,j);
                y = dis_data_select(:,3+dis);
                % correlation
                [r,p]=corr(x,y);
                % scatter plot
                subplot(nrate,coord,(dis-1)*coord+j,'align');
                scatter(x,y,'.')
                % add regression line
                hold on
                pfit = polyfit(x, y, 1);
                ycalc = polyval(pfit, x);
                plot(x,ycalc,'k')
                % add r and p values
                xlabel(xl(j))
                ylabel(yl(dis))
                set(gca,'ylim',[-1 1],'xlim',[min(x)-1 max(x)+1],'FontSize',18);
                text(min(x),0.9,[sprintf('r=%0.2f, p=%0.3f',round(r,2),round(p,3))],'Fontsize',18)                
            end
        end
        suptitle([monkeys{m} '-' num2str(dim_i)])
        saveas(gcf, [pic_dir 'corr_' [monkeys{m} '_' num2str(dim_i)] '.svg'],'svg')
        close all
    end
end