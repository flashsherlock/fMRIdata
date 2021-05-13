function image_name=get_name_afni(userOptions,readPath,subject)

% image folder
folder=fileparts(readPath);
% sub number
subn=userOptions.subn{subject};
% find TRs
% timing=findtrs(userOptions.shift,subn);
run=[1:10 12];
timing1 = findtrs(userOptions.shift,'S01_yyt');
timing2 = findtrs(userOptions.shift,subn,run(7:end)-6);
timing2(:,2)=timing2(:,2)+780;
timing = [timing1;timing2];
timing = sortrows(timing);
tr=timing(:,2);
% generate image name
image_name=[folder filesep 'NIerrts.' subn '.' userOptions.analysis '.odorVIva' num2str(length(run)) 'run_noblur+orig.BRIK,'];
image_name=strcat(image_name,num2str(tr));
end