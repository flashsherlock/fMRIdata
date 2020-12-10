%% load header from edf file
subjID = 's02';
filename='FA0576HS';
filepath='E:/NanChang/sub2_wangmingyuan';
hdr = ft_read_header([filepath filesep filename '.edf']);
%% 