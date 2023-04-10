data_dir = '/Volumes/WD_D/gufei/monkey_data/respiratory/adinstrument/';
dates = {'0301','0316'};

% store results (dates by test)
results=cell(length(dates),4);
for d = 1:length(dates)
    %data filename
    for t = 1:4
        cur_date=dates{d};
        pattern=[data_dir cur_date 'test0' num2str(t) '*' '.mat'];
        adname=dir(pattern);
        % load data
        for i=1:length(adname)
            disp(['Processing... ' adname(i).name]);
            resp = load([data_dir adname(i).name]);
            
        end
        
    end
end