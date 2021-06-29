function image_name=get_name_afni(userOptions,readPath,subject)

% image folder
folder=fileparts(readPath);
% sub number
subn=userOptions.subn{subject};
% find TRs
load('/Volumes/WD_E/gufei/7T_odor/yanqing/yanqing.pabiode.results/t.mat');
timing=targets;

tr=timing(:,2);
% generate image name
image_name=[folder filesep 'base+orig.BRIK,'];
image_name=strcat(image_name,num2str(tr));
end