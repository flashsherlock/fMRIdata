function rating=blind_rate(sub)
% sub is the number of subject
run=6;
times=4;
odornum=8;
if ~ischar(sub)
    sub=sprintf('S%02d',sub);
end
datadir=['/Volumes/WD_F/gufei/blind/behavior/'];
%% intensity and valence
vivid=zeros(times,run,odornum);
% change sub to match filename
sub=[lower(sub) '_run'];
for i=1:run
    data=dir([datadir sub num2str(i) '*.mat']);
    dataname=data(1).name;
    load([datadir filesep dataname]);    
    % rating    
    % get odor labels
    odors=unique(result(:,1));
    for iodors=1:length(odors)
        % vividness
        vivid(:,i,iodors)=result(result(:,1)==odors(iodors),6);
    end
end
% calculate means
vivid(vivid==0)=nan;
rating.vividrun=squeeze(nanmean(vivid,1));
rating.vivid=squeeze(nanmean(reshape(vivid,[],1,odornum),1));

%% RDMs
% vivid range is 1-4, so the max distance is 3
rating.vividRDM=pdist2(rating.vivid,rating.vivid)/3;
end