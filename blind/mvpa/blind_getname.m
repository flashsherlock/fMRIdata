function image_name=blind_getname(userOptions,readPath,subject)

% image folder
folder=fileparts(readPath);
% sub number
subn=userOptions.subn{subject};
% find TRs
timing = [];
for shift_i = 1:length(userOptions.shift)
    timing=[timing;blind_findtrs(userOptions.shift(shift_i),subn)];
end
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