function [mrvalence, mrintensity]=mrivi(sub)
% sub is the number of subject
run=6;
times=6;
if ~ischar(sub)
    sub=sprintf('S%02d',sub);
end
datadir=['/Volumes/WD_F/gufei/7T_odor/' sub '/behavior/'];

%% similarity
if strcmp(sub,'S01_yyt')
    data=dir([datadir lower('S01') '_similarity*.mat']);
else
    data=dir([datadir lower(sub) '_similarity*.mat']);
end
dataname=data(1).name;
load([datadir filesep dataname]);
% change odors to 1-4 and sort columns
result(:,1:2)=sort(result(:,1:2),2)-6;
% sort columns
% result(:,1:2)=sort(result(:,1:2),2);
% get odornumber
odornum=length(unique([result(:,1);result(:,2)]));
% sort rows
result=sortrows(result,[1 2]);
% reshape to 2 rows
similarity=reshape(result(:,6),2,[]);
% calculate means
similarity(similarity==0)=nan;
rating.similarity=nanmean(similarity);

%% intensity and valence
intensity=zeros(times/2,run,odornum);
valence=intensity;
% change sub to match filename
sub=[lower(sub) '_run'];

for i=1:run
    if strcmp(sub,'s01_run')
        % S01 is named from s01_run7
        data=dir([datadir sub num2str(i+6) '*.mat']);
    elseif strcmp(sub,'s01_yyt_run')
        % S01_yyt is named from s01_run1
        data=dir([datadir 's01_run' num2str(i) '*.mat']);
    else
        data=dir([datadir sub num2str(i) '*.mat']);
    end
    dataname=data(1).name;
    load([datadir filesep dataname]);
%     disp(['analyze' sub num2str(i)]);
    
    % rating    
    % get odor labels
    odors=unique(result(:,1));
    for iodors=1:length(odors)
        % intensity
        intensity(:,i,iodors)=result(result(:,1)==odors(iodors)&result(:,2)==2,6);
        % valence
        valence(:,i,iodors)=result(result(:,1)==odors(iodors)&result(:,2)==1,6);
    end
end
% reshape
rating.valence=reshape(valence,[],run*odornum);
rating.intensity=reshape(intensity,[],run*odornum);
%% RDMs
rating.valRDM=pdist2(rating.valence',rating.valence')/6;
rating.intRDM=pdist2(rating.intensity',rating.intensity')/6;
% valence
k=times;
mrvalence = kron(rating.valRDM, ones(k,k));
% intensity
mrintensity = kron(rating.intRDM, ones(k,k));
end