function rating=mrirate_quick(sub,times)
% extract ratings for odors presented by olfactometer
% sub is the number of subject
run=6;
if nargin<2
    times=6;
end
if ~ischar(sub)
    sub=sprintf('S%02d',sub);
end
% datadir=['/Volumes/WD_E/gufei/7T_odor/behavior/'];
% quick review after exp
datadir=['/Volumes/WD_F/gufei/7T_odor/behavior/'];
odornum=5;
%% intensity and valence
intensity=zeros(run*times/2,odornum);
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