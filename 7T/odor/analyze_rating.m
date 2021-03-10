function analyze_rating(sub)
run=6;
times=8;
% sub='s01_run';
datadir=['/Volumes/WD_E/gufei/7T_odor/' sub '/behavior/'];
% cd(datadir);
timing=zeros(run,times,4);
intensity=zeros(run*times/2,4);
valence=intensity;
odors={'Lim','Tra','Car','Cit'};
% change sub to match filename
sub=[lower(sub) '_run'];

for i=1:run
    if strcmp(sub,'s01_run')
        % S01 is named from run7
        data=dir([datadir sub num2str(i+6) '*.mat']);
    else
        data=dir([datadir sub num2str(i) '*.mat']);
    end
    dataname=data(1).name;
    load([datadir filesep dataname]);
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
    % may be affected by unresponsed values
%     disp('valence')
%     disp(mean(valence((i-1)*times/2+1:i*times/2,:)));
%     disp('intensity')
%     disp(mean(intensity((i-1)*times/2+1:i*times/2,:)));
end

valence(valence==0)=nan;
intensity(intensity==0)=nan;

disp('valence')
disp(nanmean(valence))
[p1,tbl1,stats1]=anova1(valence,odors,'on');
disp('intensity')
disp(nanmean(intensity))
[p2,tbl2,stats2]=anova1(intensity,odors,'on');

disp('valence_run')
runvalence(1,:)=nanmean(valence(1:4,:));
runvalence(2,:)=nanmean(valence(5:8,:));
runvalence(3,:)=nanmean(valence(9:12,:));
runvalence(4,:)=nanmean(valence(13:16,:));
runvalence(5,:)=nanmean(valence(17:20,:));
runvalence(6,:)=nanmean(valence(21:24,:));
disp(runvalence)
plot(runvalence,'-d')
legend(odors)
axis([1 6 4.5 7])
disp('intensity_run')
runintensity(1,:)=nanmean(intensity(1:4,:));
runintensity(2,:)=nanmean(intensity(5:8,:));
runintensity(3,:)=nanmean(intensity(9:12,:));
runintensity(4,:)=nanmean(intensity(13:16,:));
runintensity(5,:)=nanmean(intensity(17:20,:));
runintensity(6,:)=nanmean(intensity(21:24,:));
disp(runintensity)
plot(runintensity,'-d')
legend(odors)
axis([1 6 4.5 7])