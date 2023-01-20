%% load and reorganize data
monkeys = {'RM035','RM033'};
% monkeys = {'RM033'};
if length(monkeys) > 1
    m = '2monkey';
else
    m = monkeys{1};
end
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/decoding/tf/' m '/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
% load time-frequency data
% load([data_dir 'tf_level5_' m '.mat'],'freq_sep_all')
% load([data_dir 'pic/trial_count/odorresp_level5_trial_count_' m '.mat'],'cur_level_roi')
% load pca data
load([data_dir 'pic/pca_power/noair/' m '/data_pca-33.mat'])
load([data_dir 'pic/pca_power/noair/' m '/data_pca_per-33.mat'])
%% analysis
% get number of roi
roi_con = {'All','each'};
roi_connum=length(roi_con);
data_time=[-3:0.05:3];
% time before -1s (41) may contain nan
time=[-0.25:0.05:2.5];
% each tf data point represent 0.05s
time_win=0.5;
conditions = {'5odor'};
results = cell(roi_connum,length(conditions));
% run decoding for each condition
for condition_i = 1:length(conditions)
    condition = conditions{condition_i};        
    % each roi_condition
    for roi_coni=1:roi_connum
        % select condition
        switch condition
            case 'intensity'
                nlabel = 2;
                data_pca(:,2) = cellfun(@(x) x(2:3,:,:),data_pca(:,2),'UniformOutput',false);
            otherwise
                nlabel = 5;
                data_pca(:,2) = cellfun(@(x) x(1:5,:,:),data_pca(:,2),'UniformOutput',false);
        end
        % combine rois
        roisdata = {};
        switch roi_con{roi_coni}
            case 'All'
                roisdata{1,1} = 'All';
                roisdata{1,2} = cat(1,data_pca{:,2});
            case 'HA'
                roisdata{1,1} = 'HF';
                roisdata{1,2} = cat(1,data_pca{ismember(data_pca(:,1),{'Hi','S'}),2});
                roisdata{2,1} = 'Amy';
                roisdata{1,2} = cat(1,data_pca{~ismember(data_pca(:,1),{'Hi','S'}),2});
            otherwise
                roisdata = data_pca(:,1:2);
        end
        roi_num = size(roisdata,1);
        results_odor = cell(roi_num,2+length(time));
        results_odor(:,2)=roisdata(:,1);
        % each roi
        for roi_i=1:roi_num
            results_odor{roi_i,1} = condition;
            for time_i = 1:length(time)
                % select time
                time_range = [time(time_i)-time_win/2 time(time_i)+time_win/2];
                time_idx = dsearchn(data_time',time_range');
                tmpdata = roisdata{roi_i,2};
                tmpdata = tmpdata(:,time_idx(1):time_idx(2),:);   
                % data labels
                odors = kron(ones(size(tmpdata,1)/nlabel,size(tmpdata,2)),(1:nlabel)');
                tlabel = kron(ones(size(tmpdata,1),1),1:size(tmpdata,2));
                roi = kron((1:size(tmpdata,1)/nlabel)',ones(nlabel,size(tmpdata,2)));
                labels = cat(3,odors,tlabel,roi);
                % reshape data
                tmpdata = permute(tmpdata,[2,1,3]);
                tmpdata = reshape(tmpdata,[],size(tmpdata,3));
                % sort data
                labels = reshape(permute(labels,[2,1,3]),[],size(labels,3));
                [labels,I] = sortrows(labels,1);                
                passed_data.data = tmpdata(I,:);
                % run decoding
                [results_odor{roi_i,time_i+2},~]=odor_decoding_function(passed_data,nlabel);
            end
            % save results for this condition
            results{roi_coni,condition_i}=results_odor;
        end
    end
end
%% plot
for condition_i = 1:length(conditions)
    condition = conditions{condition_i};        
    % each roi_condition
    for roi_coni=1:roi_connum
        roic = roi_con{roi_coni};
        results_odor = results{roi_coni,condition_i};
        % get acc minus chance
        acc = cellfun(@(x) x.accuracy_minus_chance.output,results_odor(:,3:end));
        figure
        plot(time,acc')
        legend(results_odor(:,2))
        title([roic '-' condition])
    end
end