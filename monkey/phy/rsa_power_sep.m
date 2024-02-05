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
    pca_data = cell(roi_num,3);
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
            % store to pca_data
            pca_data{roi_i,dim_i} = dis_data;
            % remove air
            dis_data = dis_data(1:end-1,:);
            % distance matrix
            dis = 'euclidean';
%             dis = 'correlation';
            cur_dis = pdist2(dis_data,dis_data,dis);
            dis_mean(roi_i,:,dim_i) = cur_dis(triu(true(size(cur_dis)), 1));
        end
    end
    save([pic_dir 'dis_sep_rsa.mat'],'dis_mean','cur_level_roi','pca_data')
end
%% correlation with ratings
% load human rating
% load('/Volumes/WD_D/gufei/monkey_data/human_rating/rating_inva.mat')
load('/Volumes/WD_D/gufei/monkey_data/description/rating_inva.mat')
% get field names from stuct rating
fn = fieldnames(rating);
nrate = 5;
% get ratings
orate = zeros(5,nrate+1);
orate(:,1) = 1:5;
for i = 1:nrate
    orate(:,i+1) = mean(rating.(fn{i}));
end
% remove air
dim = 2;
pca_dim = cellfun(@(x) x(1:end-1,:),pca_data(:,dim),'UniformOutput',false);
% select roi
pca_select = cell2mat(pca_dim(~ismember(cur_level_roi(:,2),{'Hi','S'}),:));
pca_select = [pca_select,kron(ones(size(pca_select,1)/5,1),orate)];
% extract rdm data to a matrix
fn = fn(1+nrate:end);
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
% add each RDM to x
x=[];
b=cell(roi_num,2);
stats=cell(roi_num,2);
resid=cell(roi_num,1);
% get field of struct
fname=fieldnames(rating);
for i=6:length(fname)    
    x=[x rating.(fname{i})(triu(true(size(rating.(fname{i}))), 1))];
end
% 1-no pca, 2 and 3 pca dimension
for dim_i=2%1:3
    for roi_i=1:roi_num
        y=dis_mean(roi_i,:,dim_i)';
        rsa_r(roi_i,:,dim_i) = corr(y,rate', 'type', 'Spearman');
        [b{roi_i,1},~,stats{roi_i,1}] = glmfit(x(:,[1 2]),y,'normal');
        resid{roi_i}=stats{roi_i}.resid';
        [b{roi_i,2},~,stats{roi_i,2}] = glmfit(x(:,[1 2 6]),y,'normal');
    end
end
% residual
[h,p,ci,stats]=ttest(cell2mat(resid(ismember(cur_level_roi(:,2),{'Hi','S'}),1)))
[h,p,ci,stats]=ttest(cell2mat(resid(ismember(cur_level_roi(:,2),{'BM'}),1)))
% betas
[h,p,ci,stats]=ttest(reshape(cell2mat(b(~ismember(cur_level_roi(:,2),{'Hi','S'}),2)),4,[])')
[h,p,ci,stats]=ttest(reshape(cell2mat(b(~ismember(cur_level_roi(:,2),{'Hi','S'}),1)),3,[])')
[h,p,ci,stats]=ttest(reshape(cell2mat(b(ismember(cur_level_roi(:,2),{'Hi','S'}),1)),3,[])')
[h,p,ci,stats]=ttest(reshape(cell2mat(b(ismember(cur_level_roi(:,2),{'BM'}),1)),3,[])')
%% fit for each roi
% monkeys = {'RM033'};
monkeys = {'2m'};
roi_select = {'Amy','HF'};
% roi_select = {'CoA','CeMe','BA','BM','La'};
roi_select = {'CoA','CeMe','BA','BM','La','Hi','S'};
b=cell(length(roi_select),2);
stats=cell(length(roi_select),2);
y=cell(1,length(roi_select));
nelec=zeros(length(roi_select),1);
for dim_i=2%1:3
for roi_i = 1:length(roi_select)
    for m = 1:length(monkeys)
        % select roi
        switch roi_select{roi_i}
            case 'Amy'
                index = ~ismember(cur_level_roi(:,2),{'Hi','S'});
            case 'HF'
                index = ismember(cur_level_roi(:,2),{'Hi','S'});
            case 'CoA'
                index = ismember(cur_level_roi(:,2),{'APir','VCo'});
            case 'BA'
                index = ismember(cur_level_roi(:,2),{'BL','PaL'});
            case 'CeMe'
                index = ismember(cur_level_roi(:,2),{'Ce','Me'});
%             case 'BM'
%                 index = ismember(cur_level_roi(:,2),{'BM'});
%             case 'La'
%                 index = ismember(cur_level_roi(:,2),{'La'});  
            case 'All'
                index = 1:length(cur_level_roi(:,2));  
            otherwise
                index = ismember(cur_level_roi(:,2),{roi_select{roi_i}});
        end
        nelec(roi_i)=length(find(index)==1);
        % select monkeys
        if ~strcmp(monkeys{m},'2m')
                index = index&ismember(cur_level_roi(:,3),monkeys{m});
        end
        y{roi_i}=mean(dis_mean(index,:,dim_i),1)';
        [b{roi_i,1},~,stats{roi_i,1}] = glmfit(x(:,[1 2]),y{roi_i},'normal');
        [b{roi_i,2},~,stats{roi_i,2}] = glmfit(x(:,[1 2 6]),y{roi_i},'normal');
    end
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
%% plot each distance
right_AH = ft_read_headshape([file_dir 'right_AH_level5.stl'],'format','stl');
right_AH.coordsys = 'acpc';
left_AH = ft_read_headshape([file_dir 'left_AH_level5.stl'],'format','stl');
left_AH.coordsys = 'acpc';
meshcolor = 0.75*[1 1 1];
meshalpha = 0.2; 
for dim_i=1:3
    for dis=1:5
        % data to be ploted
        color_data = dis_data(:,3+5*(dim_i-1)+dis);
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