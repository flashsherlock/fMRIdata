function dataout=analyze_rating(sub,times)
run=6;
if nargin<2
    times=[8 4];
end
% sub='s01_run';
% datadir=['/Volumes/WD_E/gufei/7T_odor/' sub '/behavior/'];
datadir=['/Volumes/WD_F/gufei/7T_odor/' sub '/behavior/'];
% cd(datadir);
intensity=zeros(run*times(1)/2,times(2));
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
    disp(['analyze' sub num2str(i)]);
    
    % rating    
    % get odor labels
    odors=unique(result(:,1));
    for iodors=1:length(odors)
        % intensity
        intensity((i-1)*times/2+1:i*times/2,iodors)=result(result(:,1)==odors(iodors)&result(:,2)==2,6);
        % valence
        valence((i-1)*times/2+1:i*times/2,iodors)=result(result(:,1)==odors(iodors)&result(:,2)==1,6);
    end
    vo=sum(sum(valence((i-1)*times/2+1:i*times/2,:)==0));
    io=sum(sum(intensity((i-1)*times/2+1:i*times/2,:)==0));
    
    % acc=(vo+io)/6*8*4;
    disp(vo+io);
    % may be affected by unresponsed values
%     disp('valence')
%     disp(mean(valence((i-1)*times/2+1:i*times/2,:)));
%     disp('intensity')
%     disp(mean(intensity((i-1)*times/2+1:i*times/2,:)));
end
vo=sum(valence==0);
io=sum(intensity==0);
% acc=(vo+io)/6*8*4;
disp([sum(vo+io)]);
valence(valence==0)=nan;
intensity(intensity==0)=nan;

disp('valence')
disp(nanmean(valence))
% [p1,tbl1,stats1]=anova1(valence,odors,'on');
disp('intensity')
disp(nanmean(intensity))
% [p2,tbl2,stats2]=anova1(intensity,odors,'on');
dataout.trial=[valence intensity];

runvalence=zeros(run,times(2));
runintensity=runvalence;
for i=1:run
% disp('valence_run')
runvalence(i,:)=nanmean(valence(1+(i-1)*times(1)/2:i*times(1)/2,:));
% disp(runvalence)
% figure
% plot(runvalence,'-d')
% legend(odors)
% title([sub '_valence'],'Interpreter','none')
% axis([1 6 1 7])

% disp('intensity_run')
runintensity(i,:)=nanmean(intensity(1+(i-1)*times(1)/2:i*times(1)/2,:));
end
% disp(runintensity)
dataout.run=[runvalence runintensity];
% figure
% plot(runintensity,'-d')
% legend(odors)
% title([sub '_intensity'],'Interpreter','none')
% axis([1 6 1 7])