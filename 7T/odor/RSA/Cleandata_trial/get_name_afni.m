function image_name=get_name_afni(userOptions,readPath,subject)

% image folder
folder=fileparts(readPath);
% sub number
subn=userOptions.subn{subject};
% find TRs
timing=findtrs(userOptions.shift,subn);

tr=timing(:,2);
% generate image name
image_name=[folder filesep 'NIerrts.' subn '.' userOptions.analysis '.odorVIva_noblur+orig.BRIK,'];
image_name=strcat(image_name,num2str(tr));
end