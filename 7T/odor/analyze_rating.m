run=6;
times=8;
sub='s01_run';
datadir='/Volumes/WD_D/gufei/7T_odor/S01_yyt/behavior/';
cd(datadir);
timing=zeros(run,times,4);
intensity=zeros(run*times/2,4);
valence=intensity;
odors={'Lim','Tra','Car','Cit'};

for i=1:run
    data=dir([sub num2str(i) '*.mat']);
    dataname=data(1).name;
    load(dataname);
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