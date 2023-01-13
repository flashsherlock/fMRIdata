function image_name=get_name_afni(userOptions,readPath,subject)

% image folder
folder=fileparts(readPath);
% sub number
subn=userOptions.subn{subject};
% find TRs
timing=findtrs(userOptions.shift,subn);

tr=timing(:,2);
% generate image name
% only remove pol (default)
if isfield(userOptions,'filename')
    image_name=[folder filesep userOptions.filename{1} subn '.' userOptions.analysis userOptions.filename{2}];
else
    image_name=[folder filesep 'NIerrts.' subn '.' userOptions.analysis '.onlypolva+orig.BRIK,'];
end
image_name=strcat(image_name,num2str(tr));
end