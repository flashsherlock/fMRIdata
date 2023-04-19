%% store results (dates by test)
data_dir = '/Volumes/WD_D/gufei/monkey_data/respiratory/adinstrument/';
dates = {'0301','0316'};
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
save([data_dir 'results.mat'],'results')
%% load and separate trials
load([data_dir 'results.mat'])
trials = [];
for  d = 1:size(results,1)
    for t = 1:4
        for i = 1:length(results{d,t})
            trials = [trials;resp_separate(results{d,t}{i})];
        end
    end    
end
trials_find = resp_find(trials);
save([data_dir 'trials.mat'],'trials','trials_find')
%%  analyze
