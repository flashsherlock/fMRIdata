data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm033_ane/unused/';
pattern=[data_dir '*plx'];
plxnames=dir(pattern);
% filename and n
results = cell(length(plxnames),2);
for i =length(plxnames)
    plxname = [data_dir plxnames(i).name];
    disp(plxnames(i).name)
    results{i,1} = plxnames(i).name;
    % number of events
    [n, ts, sv] = plx_event_ts(plxname, 'Strobed');
    % n should be 105
    disp(n)
    results{i,2} = n;
end
save([data_dir 'check_plx.mat'],'results')