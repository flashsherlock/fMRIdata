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
trials_find = resp_find(trials);
separated = resp_analyze(trials_find);
save([data_dir 'trials.mat'],'trials','separated')
%%  analyze average
nchan = length(unique(cell2mat(separated(:,5))));
avg = cell(nchan,2);
for chan_i = 1:nchan    
    trials = unique(cell2mat(separated(cell2mat(separated(:,5))==chan_i,12)))';
    ntrial = length(trials);    
    trials_air = cell(ntrial,7);
    trials_odor = cell(ntrial,7);
    for trial_i = trials
        % select data
        idx = cell2mat(separated(:,5))==chan_i & cell2mat(separated(:,12))==trial_i; %& cell2mat(separated(:,3))<=2;
        data = separated(idx,:);
        % average air and odor
        trials_air{trial_i, 1} = data{1,1};
        trials_odor{trial_i, 1} = data{1,1};
        for col = 2:7
            if isempty(cell2mat(data(cell2mat(data(:,2))==1,col+4)))
                trials_air{trial_i, col} = [];
            else
                trials_air{trial_i, col} = mean(cell2mat(data(cell2mat(data(:,2))==1,col+4)),1);
            end
            if isempty(cell2mat(data(cell2mat(data(:,2))==2,col+4))) || isempty(trials_air{trial_i, col})
                trials_odor{trial_i, col} = [];
            else
                trials_odor{trial_i, col} = mean(cell2mat(data(cell2mat(data(:,2))==2,col+4)),1);
                % normalize by air
                if ismember(col,[2])
                    trials_odor{trial_i, col} = trials_odor{trial_i, col} / (max(trials_air{trial_i, col})-min(trials_air{trial_i, col}));
                else
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
for chan_i = 1%1:nchan 
    data = avg{chan_i,2};
    for con_i=1:5
        resp4s(con_i,:) = outmean(cell2mat(data(cell2mat(data(:,1))==con_i,2)),1,1.65);
        inhale(con_i,:) = outmean(cell2mat(data(cell2mat(data(:,1))==con_i,7)),1,1.65);
        param(con_i,:) = outmean(cell2mat(data(cell2mat(data(:,1))==con_i,3:6)),1,1.65);
    end
    figure('position',[40,40,600,300]);
    r4 = plot(resp4s(1:5,:)','LineWidth',2);
    xlim([0 2500])
    figure('position',[40,340,600,300]);
    in = plot(inhale(1:5,:)','LineWidth',2);
    for con_i=1:5
        set(r4(con_i), 'color', hex2rgb(colors{con_i}));
        set(in(con_i), 'color', hex2rgb(colors{con_i}));
    end
    % pleasant and unpleasant
    for con_i=6:7
        if con_i==6
            odors = [1 2 3];
        else
            odors = [4 5];
        end
        [resp4s(con_i,:), datresp{con_i-5}]= outmean(cell2mat(data(ismember(cell2mat(data(:,1)),odors),2)),1,1.65);
        [inhale(con_i,:), datin{con_i-5}]= outmean(cell2mat(data(ismember(cell2mat(data(:,1)),odors),7)),1,1.65);
        [param(con_i,:), datpm{con_i-5}]= outmean(cell2mat(data(ismember(cell2mat(data(:,1)),odors),3:6)),1,1.65);
    end
    figure('position',[40,40,600,300]);
    r4 = plot(resp4s(6:7,:)','LineWidth',2);
    xlim([0 2500])
    figure('position',[40,340,600,300]);
    in = plot(inhale(6:7,:)','LineWidth',2);
    for con_i=1:2
        set(r4(con_i), 'color', hex2rgb(colors{con_i+7}));
        set(in(con_i), 'color', hex2rgb(colors{con_i+7}));
    end
    % ttest
    for i = 1:4
        [h,p,ci,stats]=ttest2(datpm{1}(:,i),datpm{2}(:,i));
        disp(p)
    end
    
end