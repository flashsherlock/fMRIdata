% generate images, timing files for each subject
subs=1:4;
rootfolder='/Volumes/WD_F/gufei/blind/';
% generate files for each subject
for subi=1:length(subs)
    sub=sprintf('S%02d',subs(subi));
    % default settings
    runs = 14:1:19;
    pa = 20;
    str = 21;
    % disp(sub)
    datafolder=[rootfolder sub];       
    % define image IDs
    switch subs(subi)
        case 1
            % 5 runs
            runs = [17 18 23 24 25];
            pa = 26;
            str = 5;
        case {3 4}
            runs = 15:1:20;
            pa = 21;
            str = 22;
    end
    % generate images if they are not exist
    if ~exist([datafolder filesep sub '.str.nii'],'file') 
        strimg=sprintf('%02d',str);
        genimage=['tcsh generate_img.tcsh ' sub ' "' num2str(runs) '" ' num2str(pa) strimg];
        unix(genimage)
    else
        disp(['Images of ' sub ' has already been generated!'])
    end
    % generate time files
    blind_timing(sub,length(runs));
    blind_timing_rating(sub,length(runs));
    
end