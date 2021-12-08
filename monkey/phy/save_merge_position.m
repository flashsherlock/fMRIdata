%% load data
load('/Volumes/WD_D/gufei/monkey_data/IMG/RM035_NMT/RM035_allpos_label5d.mat')
level=2;
cur_level_roi=ele_date_alevel{level};
% remove no label
cur_level_roi=cur_level_roi(~strcmp(cur_level_roi(:,1),'no_label_found'),:);
% lfp data
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm035_ane/mat/';
dates = {'200731', '200807', '200814', '200820', '200828'};
data_lfp = cell(length(dates),1);
data_resp = data_lfp;
for i_date=1:length(dates)
cur_date=dates{i_date};
data=load([data_dir cur_date '_rm035_ane.mat']);
%% cut to trials
lfp=cell(1,length(data.lfp));
resp=lfp;
for i=1:length(data.lfp)
cfg=[];
cfg.trl=data.trl(i).odorresp;
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
data_resp{i_date}=ft_selectdata(cfg,resp);
data_lfp{i_date}=ft_selectdata(cfg,lfp);
end
%% rearrange
roi_num=size(cur_level_roi,1);
roi_resp=cell(roi_num,1);
roi_lfp=roi_resp;
for roi_i=1:roi_num
    locations=cur_level_roi{roi_i,2};
%     loc_dates=unique(locations(:,1));
    lfp=[];
    resp=[];
    for i=1:size(locations,1)
        % select lfp
        cfg=[];
        cfg.channel=locations(i,2);
        lfp{i}=ft_selectdata(cfg,data_lfp{locations(i,1)});
        % rename label to roi name
        lfp{i}.label=cur_level_roi(roi_i,1);
        % copy resp to match each trial of lfp
        resp{i}=data_resp{locations(i,1)};
        resp{i}.label{1}=strjoin([resp{i}.label,cur_level_roi(roi_i,1)],'_');
    end
    % append all locations
    cfg=[];
    cfg.keepsampleinfo='no';
    roi_lfp{roi_i} = ft_appenddata(cfg,lfp{:});
    roi_resp{roi_i} = ft_appenddata(cfg,resp{:});
end
save([data_dir 'roi_odor_resp_5day.mat'],'roi_lfp','roi_resp','cur_level_roi');