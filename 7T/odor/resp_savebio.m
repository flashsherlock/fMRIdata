function resp_savebio(sub,rev,scale)
% fieldtrip filter: data stores in each row
% fieldtrip的滤波器 每一行是一组数据
% default values are 0
if nargin < 2
    rev = 0;
end
if nargin < 3
    scale = 0;
end
% respdir = ['/Volumes/WD_E/gufei/7T_odor/' sub '/respiration/'];
% phydir = ['/Volumes/WD_E/gufei/7T_odor/' sub '/phy/'];
respdir = ['/Volumes/WD_F/gufei/7T_odor/' sub '/respiration/'];
phydir = ['/Volumes/WD_F/gufei/7T_odor/' sub '/phy/'];
% make phy dir
if ~exist(phydir,'dir')
    mkdir(phydir)
end
% filename = dir([respdir filesep 'resp*.mat']);
filename=dir([respdir filesep '*.acq']);
% sort by time modified
[~,indx]=sort([filename.datenum],'ascend');
filename=filename(indx);
% remove hx (huxi)
filename(contains(string({filename.name}),'hx.acq'))=[];

biopac_sprate=500;
fmri_sprate=50;
lowpass = 10;
time = 396;
run = 6;

for i = 1:run

%     load([respdir filesep filename(i).name]);
    % acq file
    if ~exist([respdir filesep 'resp0' num2str(i) '.mat'],'file') 
        rawdata=load_acq([respdir filesep filename(i).name]);
        % resample to 50hz, i.e. 50/500
        data=marker_trans_7T(rawdata.data);
        data(:, 1) = ft_preproc_lowpassfilter(data(:, 1)', biopac_sprate, lowpass)';
        % cut according to mark 1
        start=find(data(:,2)==1);
        data=data(start:start+biopac_sprate*time-1,:);
        save([respdir filesep 'resp0' num2str(i) '.mat'],'data');
    else
        load([respdir filesep 'resp0' num2str(i) '.mat'])
    end
    % downsample to match puls
    data = resample(data(:, 1), fmri_sprate, biopac_sprate);
    % flip biopac data if rev==1
    if rev==1
        data(:, 1)=-data(:, 1);
    end
    % rescale data if scale==1
    if scale == 1
        data(:, 1) = rescale(data(:, 1));
    end

    dlmwrite([phydir 'biop0' num2str(i) '.1D'], data(:, 1))

end
end