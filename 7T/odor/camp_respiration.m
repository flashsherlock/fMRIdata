respdir='/Volumes/WD_D/gufei/7T_odor/S01_yyt/respiration/';
phydir='/Volumes/WD_D/gufei/7T_odor/S01_yyt/phy';

filename=dir([respdir filesep '*_?.acq']);
phy_file=dir([phydir filesep 'resp*.1D']);

biopac_sprate=500;
fmri_sprate=50;
time=390;
run=6;

for i=1:run
    % acq file
    rawdata=load_acq([respdir filesep filename(i).name]);
    % resample to 50hz, i.e. 50/500
    data=marker_trans_7T(rawdata.data);
    % downsample will destroy makers
    % data=resample(data,50,500);
    start=find(data(:,2)==1);
    data=data(start:start+biopac_sprate*time-1,:);
    % fmri file
    phy=load([phydir filesep phy_file(i).name]);
    % upsample phy
    phy=resample(phy,500,50);
    display(corr(data(:,1),phy));
    % calculate correlation
    save([respdir filesep 'resp0' num2str(i) '.mat'],'data','phy');
end