% fieldtrip的滤波器 每一行是一组数据
clc;
clear
respdir = '/Volumes/WD_D/gufei/7T_odor/S01_yyt/respiration/';
phydir = '/Volumes/WD_D/gufei/7T_odor/S01_yyt/phy/';
filename = dir([respdir filesep 'resp*.mat']);

sprate = 500;
fmri_sprate=50;
lowpass = 10;
time = 390;
run = 6;
scale = 0;

for i = 1:run

    load([respdir filesep filename(i).name]);
    data(:, 1) = ft_preproc_lowpassfilter(data(:, 1)', sprate, lowpass)';
    % downsample to match puls
    data = resample(data(:, 1), fmri_sprate, sprate);
    % flip biopac data
    if scale == 1
        data(:, 1) = rescale(-data(:, 1));
    else
        data(:, 1) = -data(:, 1);
    end

    dlmwrite([phydir 'biop0' num2str(i) '.1D'], data(:, 1))

end
