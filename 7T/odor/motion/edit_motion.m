sub='S01';

datadir=['/Volumes/WD_E/gufei/7T_odor/' sub '/' sub '.pabio12run.results/'];
savedir=['/Volumes/WD_E/gufei/7T_odor/' sub '/behavior_11run/'];
if ~exist(savedir,'dir')
    mkdir(savedir)
end

for i=[1:10 12]
%     fname=['mot_demean.r0' num2str(i) '.1D'];
    fname=sprintf('mot_demean.r%02d.1D',i);
    motion=load([datadir fname]);
    % remove the 5th run
    motion(end-259:end-130,:)=[];
    dlmwrite([savedir fname],motion,'delimiter',' ','precision',6);
end
