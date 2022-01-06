function rating=behrate(sub,times)
% extract ratings for odors presented by olfactometer
% sub is the number of subject
run=1;
if nargin<2
    times=6;
end
if ~ischar(sub)
    sub=sprintf('S%02d',sub);
end
datadir=['./behavior/'];

%% similarity
data=dir([datadir lower(sub) '_similarity*.mat']);
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
%% inva
data=dir([datadir lower(sub) '_inva*.mat']);
dataname=data(1).name;
load([datadir filesep dataname]);
in=zeros(1,5);
va=in;
odors=unique(result(:,1));
for iodors=1:length(odors)
    % valence
    temp=result(result(:,1)==iodors&result(:,2)==1,6);
    temp(temp==0)=nan;
    va(iodors)=nanmean(temp);
    % intensity
    temp=result(result(:,1)==iodors&result(:,2)==2,6);
    temp(temp==0)=nan;
    in(iodors)=nanmean(temp);
end
rating.in=in;
rating.va=va;
%% intensity and valence
intensity=zeros(run*times/2,odornum);
valence=intensity;
% change sub to match filename
sub=[lower(sub) '_practice'];

for i=1:run
    data=dir([datadir sub '*.mat']);
    dataname=data(1).name;
    load([datadir filesep dataname]);
%     disp(['analyze' sub num2str(i)]);
    
    % rating    
    % get odor labels
    odors=unique(result(:,1));
    for iodors=1:length(odors)
        % intensity
        intensity((i-1)*times/2+1:i*times/2,iodors)=result(result(:,1)==odors(iodors)&result(:,2)==2,6);
        % valence
        valence((i-1)*times/2+1:i*times/2,iodors)=result(result(:,1)==odors(iodors)&result(:,2)==1,6);
    end
end
% calculate means
valence(valence==0)=nan;
intensity(intensity==0)=nan;

rating.valence=nanmean(valence);
rating.intensity=nanmean(intensity);

end