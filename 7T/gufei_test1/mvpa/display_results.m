for i=1:5

run=['run' num2str(i)];

% Set the output directory where data will be saved, e.g. 'c:\exp\results\buttonpress'
dir = ['/Volumes/WD_D/share/7Tdata/mvpa/wholebrain/' run];

load([dir filesep 'res_accuracy_minus_chance.mat']);

disp(run);
disp(results.accuracy_minus_chance.output);
end