%% store results (dates by test)
data_dir = '/Volumes/WD_D/gufei/monkey_data/respiratory/adinstrument/';
dates = {'0301','0316','0412','0414'};
datafile = 'results4day.mat';
if ~exist([data_dir datafile],'file')
    results=cell(length(dates),4);
    for d = 1:length(dates)
        % data filename
        for t = 1:4
            cur_date=dates{d};
            pattern=[data_dir cur_date 'test0' num2str(t) '*' '.mat'];
            adname=dir(pattern);
            % load data
            for i=1:length(adname)
                disp(['Processing... ' adname(i).name]);
                resp = load([data_dir adname(i).name]);
                % convert data
                results{d,t}{i}=resp_convert(resp,t);            
            end       
        end
    end
    save([data_dir datafile],'results')
else
    % load
    load([data_dir datafile])
end
%% separate trials
trials = [];
for  d = 1:size(results,1)
    for t = 1:4
        for i = 1:length(results{d,t})            
            if d==1
                % remove banana
                trialadd = resp_separate(results{d,t}{i},5);
                % trialadd = resp_separate(results{d,t}{i});                               
            else
                trialadd = resp_separate(results{d,t}{i});
            end
            trials = [trials;[trialadd repmat(dates(d),size(trialadd,1),1,size(trialadd,3))]]; 
        end
    end    
    
end
save([data_dir 'trials.mat'],'trials')
%% check resp manually
resp_check()
load([data_dir 'trials_edited.mat'])
%%  analyze average
trials_find = resp_find(trials);
% select monkey by date
% trials_find = trials_find(cellfun(@(x) ismember(x,{'0316','0412'}),trials_find(:,end)),:);
% trials_find = trials_find(cellfun(@(x) ismember(x,{'0414'}),trials_find(:,end)),:,:);
separated = resp_analyze(trials_find);
nchan = length(unique(cell2mat(separated(:,5))));
avg = cell(nchan,2);
for chan_i = 1:nchan    
    trial = unique(cell2mat(separated(cell2mat(separated(:,5))==chan_i,12)))';
    ntrial = length(trial);    
    trials_air = cell(ntrial,7);
    trials_odor = cell(ntrial,7);
    for trial_i = trial
        % select data
        idx = cell2mat(separated(:,5))==chan_i & cell2mat(separated(:,12))==trial_i; %& cell2mat(separated(:,3))<=2;
        data = separated(idx,:);
        % average air and odor
        trials_air{trial_i, 1} = data{1,1};
        trials_odor{trial_i, 1} = data{1,1};
        for col = 2:7
            % air
            if isempty(cell2mat(data(cell2mat(data(:,2))==1,col+4)))
                % deal with empty cells
                trials_air{trial_i, col} = [];
            else
                trials_air{trial_i, col} = mean(cell2mat(data(cell2mat(data(:,2))==1,col+4)),1);
            end
            % odor
            if isempty(cell2mat(data(cell2mat(data(:,2))==2,col+4))) || isempty(trials_air{trial_i, col})
                % deal with empty cells
                trials_odor{trial_i, col} = [];
            else
                trials_odor{trial_i, col} = mean(cell2mat(data(cell2mat(data(:,2))==2,col+4)),1);
                % normalize by air
                if ismember(col,[2])
                    % normalization for 4s resp
                    trials_odor{trial_i, col} = trials_odor{trial_i, col} / (max(trials_air{trial_i, col})-min(trials_air{trial_i, col}));
                    % max
                    % trials_odor{trial_i, col} = trials_odor{trial_i, col} / (max(trials_air{trial_i, col}));
                    % sum
                    % trials_odor{trial_i, col} = trials_odor{trial_i, col} / (sum(trials_air{trial_i, col}));
                else
                    % normalization for other parameters
                    trials_odor{trial_i, col} = (trials_odor{trial_i, col} - trials_air{trial_i, col})./trials_air{trial_i, col};
                end
            end
        end
    end
    avg{chan_i,1}=trials_air(~cellfun(@isempty,trials_air(:,1)),:);
    avg{chan_i,2}=trials_odor(~cellfun(@isempty,trials_odor(:,1)),:);
end
%% average by condition
colors = {'#777DDD', '#69b4d9', '#149ade', '#41AB5D', '#ECB556', '#000000', '#E12A3C', '#777DDD', '#41AB5D','#B2B2B2'};
labels = {'Indole', 'Iso_l', 'Iso_h', 'Peach', 'Banana', 'Unpleasant', 'Pleasant'};
limx = [0,2000];
% channel 1-temperature 2-airflow
for chan_i = 1:nchan 
    data = avg{chan_i,2};
    for con_i=1:5
        [resp4s(con_i,:), datresp{con_i}, semresp4s(con_i,:)] = outmean(cell2mat(data(cell2mat(data(:,1))==con_i,2)),1,2);
        [inhale(con_i,:), datin{con_i}, seminhale(con_i,:)] = outmean(cell2mat(data(cell2mat(data(:,1))==con_i,7)),1,2);
        [param(con_i,:), datpm{con_i}, semparam(con_i,:)] = outmean(cell2mat(data(cell2mat(data(:,1))==con_i,3:6)),1,2);
    end
    % anova for resp curve
    anovap=zeros(1,size(resp4s,2));
    for time_i=1:size(resp4s,2)
        d = [datresp{1}(:,time_i);datresp{2}(:,time_i);datresp{3}(:,time_i);datresp{4}(:,time_i);datresp{5}(:,time_i)];
        group = [ones(size(datresp{1},1),1);2*ones(size(datresp{2},1),1);3*ones(size(datresp{3},1),1);4*ones(size(datresp{4},1),1);5*ones(size(datresp{5},1),1)];
        anovap(time_i)=anova1(d,group,'off');
    end
    % plot respiration
    %respplot(resp4s(1:5,:),semresp4s(1:5,:),anovap,[colors(1:5);labels(1:5)],limx,[data_dir 'resp_odor' num2str(chan_i) '.svg'])
%     xlim(limx)
%     figure('position',[40,340,600,300]);
%     in = plot(inhale(1:5,:)','LineWidth',2);
%     for con_i=1:5
%         set(in(con_i), 'color', hex2rgb(colors{con_i}));
%     end
    % pleasant and unpleasant
    for con_i=6:7
        if con_i==6
            odors = [1 2 3];
        else
            odors = [4 5];
        end
        [resp4s(con_i,:), datresp{con_i}, semresp4s(con_i,:)] = outmean(cell2mat(data(ismember(cell2mat(data(:,1)),odors),2)),1,2);
        [inhale(con_i,:), datin{con_i}, seminhale(con_i,:)] = outmean(cell2mat(data(ismember(cell2mat(data(:,1)),odors),7)),1,2);
        [param(con_i,:), datpm{con_i}, semparam(con_i,:)] = outmean(cell2mat(data(ismember(cell2mat(data(:,1)),odors),3:6)),1,2);
    end
    % ttest for resp curve
    [~,testp,~,~]=ttest2(datresp{6},datresp{7});
    % plot respiration
    %respplot(resp4s(6:7,:),semresp4s(6:7,:),testp,[{'#ea5751','#0891c9'};labels(6:7)],limx,[data_dir 'resp_va' num2str(chan_i) '.svg'])
%     figure('position',[40,340,600,300]);
%     in = plot(inhale(6:7,:)','LineWidth',2);
%     for con_i=1:2
%         set(in(con_i), 'color', hex2rgb(colors{con_i+7}));
%     end
    % ttest
    for i = 1:4
            % compare pleasant and unpleasant
            [~,p,~,~]=ttest2(datpm{6}(:,i),datpm{7}(:,i));
            disp(p)
    end
    for con_i=1:7
        for i = 1:4
            % compare with 0
            [~,ps(con_i,i),~,~]=ttest(datpm{con_i}(:,i));        
        end
    end
    disp([param,ps])
    % output pm for r
    outpm = cat(1,datpm{:});
    outpmcon=[];
    for con_i=1:7
        % add con_i
        outpmcon = [outpmcon;con_i*ones(size(datpm{con_i},1),1)];
    end
    outpm = [outpmcon,outpm];
    % save([data_dir 'pm' num2str(chan_i) '.mat'],'outpm')
end