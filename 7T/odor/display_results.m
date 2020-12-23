sub='S01_yyt';
analysis='pabiode';
rois={'Amy','Piriform','APC','PPC'};
cfg.analysis = 'roi';
odors={'lim','tra','car','cit'};

% for i=1:length(rois)
    % roi=rois{i};
    % test=['4odors_' roi];
    cfg.results.dir = ['/Volumes/WD_D/gufei/7T_odor/' sub '/' sub '.' analysis '.results/mvpa/' cfg.analysis '/'];

    run=['run' num2str(i)];

    % Set the output directory where data will be saved, e.g. 'c:\exp\results\buttonpress'
    dirs = dir(cfg.results.dir);
for i=1:length(dirs)
    try
        load([cfg.results.dir dirs(i).name filesep 'res_accuracy_minus_chance.mat']);
        % display results first, may be replaced by the confusion matrix
        disp(dirs(i).name);
        disp(results.accuracy_minus_chance.output);
        % confusion_matrix is a cell array that only contains a class*class matrix
        load([cfg.results.dir dirs(i).name filesep 'res_confusion_matrix.mat']);
        % figure;
        % 2017b and later has heatmap function
        % heatmap(results.confusion_matrix.output{1}, 'Colormap', jet)
%         HMobj=HeatMap(results.confusion_matrix.output{1}, 'RowLabels', odors, 'ColumnLabels', odors, 'Colormap', jet);
%         H=addTitle(HMobj,strrep(dirs(i).name,'_','-'));
%         
        disp(results.confusion_matrix.output{1})

    catch
        % if there is no confusion matrix (searchlight .. and .)
        disp(dirs(i).name);
    end
end