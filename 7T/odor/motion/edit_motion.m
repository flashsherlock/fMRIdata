sub='S01';

datadir=['/Volumes/WD_E/gufei/7T_odor/' sub '/' sub '.pabiocen.results/'];
savedir=['/Volumes/WD_E/gufei/7T_odor/' sub '/behavior_5run/'];
if ~exist(savedir,'dir')
    mkdir(savedir)
end

for i=[1:4 6]
    fname=['mot_demean.r0' num2str(i) '.1D'];
    motion=load([datadir fname]);
    % remove the 5th run
    motion(521:650,:)=[];
    dlmwrite([savedir fname],motion,'delimiter',' ','precision',6);
end
