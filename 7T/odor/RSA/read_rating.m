function rating = read_rating( subjID )
% read intensity and valence ratings
%   return a n_odors × 2(valence, intensity) matrix
run=6;
times=8;
% file name prefix for each run
sub=sprintf('s%02d_run',subjID);
% data folder
datadir=dir(sprintf('/Volumes/WD_D/gufei/7T_odor/S%02d*/behavior',subjID));
datadir=datadir(1).folder;
data=dir([datadir '/' sub '*.mat']);

intensity=zeros(run*times/2,4);
valence=intensity;
% odors={'Lim','Tra','Car','Cit'};

for i=1:run    
    dataname=data(i).name;
    load([datadir '/' dataname]);
    disp(['analyze' sub num2str(i)]);
    
    % rating    
    % intensity=mean(result(result(:,1)==10&result(:,2)==2&result(:,6)~=0,6));
    intensity((i-1)*times/2+1:i*times/2,1)=result(result(:,1)==7&result(:,2)==2,6);
    intensity((i-1)*times/2+1:i*times/2,2)=result(result(:,1)==8&result(:,2)==2,6);
    intensity((i-1)*times/2+1:i*times/2,3)=result(result(:,1)==9&result(:,2)==2,6);
    intensity((i-1)*times/2+1:i*times/2,4)=result(result(:,1)==10&result(:,2)==2,6);
    % valence
    valence((i-1)*times/2+1:i*times/2,1)=result(result(:,1)==7&result(:,2)==1,6);
    valence((i-1)*times/2+1:i*times/2,2)=result(result(:,1)==8&result(:,2)==1,6);
    valence((i-1)*times/2+1:i*times/2,3)=result(result(:,1)==9&result(:,2)==1,6);
    valence((i-1)*times/2+1:i*times/2,4)=result(result(:,1)==10&result(:,2)==1,6);    
end

valence(valence==0)=nan;
intensity(intensity==0)=nan;

rating=[nanmean(valence)' nanmean(intensity)'];
end

