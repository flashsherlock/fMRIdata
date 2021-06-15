sub='S06';
run=6;
% datadir=['/Volumes/WD_E/gufei/7T_odor/' sub '/behavior/'];
datadir='D:\exp\Data\';
% change sub to match filename
sub=[lower(sub) '_run'];

for i=1:run
    data=dir([datadir sub num2str(i) '*.mat']);
    load([datadir filesep data(1).name]);
    result(:,1)=result(:,1)-6;
    result(result(:,1)==6,1)=5;
    save([datadir filesep data(1).name],'result','response');
end