function resp_campare(sub)
% respdir = ['/Volumes/WD_E/gufei/7T_odor/' sub '/respiration/'];
% phydir = ['/Volumes/WD_E/gufei/7T_odor/' sub '/phy/'];
respdir = ['/Volumes/WD_F/gufei/7T_odor/' sub '/respiration/'];
phydir = ['/Volumes/WD_F/gufei/7T_odor/' sub '/phy/'];

filename=dir([respdir filesep 'resp*.mat']);
phy_file=dir([phydir filesep 'resp*.1D']);

biopac_sprate=500;
fmri_sprate=50;

time=396;
run=6;

for i=1:run
    % acq file
%     rawdata=load_acq([respdir filesep filename(i).name]);
    % resample to 50hz, i.e. 50/500
%     data=marker_trans_7T(rawdata.data);
    % downsample will destroy makers
    % data=resample(data,50,500);
    
    % load from mat generated by resp_savebio
    load([respdir filesep filename(i).name]);
%     start=find(data(:,2)==1);
%     data=data(start:start+biopac_sprate*time-1,:);
    % fmri file
    phy=load([phydir filesep phy_file(i).name]);
    % upsample phy
    phy=resample(phy,biopac_sprate,fmri_sprate);
    % calculate correlation
    display([sub ' run ' num2str(i)]);
    display(corr(data(:,1),phy));
    save([respdir filesep 'resp0' num2str(i) '.mat'],'data','phy');
end
end