% generate images, timing files for each subject
subs=3:1:29;
rootfolder='/Volumes/WD_F/gufei/3T_cw/';
% generate files for each subject
for subi=1:length(subs)
    sub=sprintf('S%02d',subs(subi));
    % default settings
    runs = 3:7;
    wb = 8;
    str = 2;
    % disp(sub)
    datafolder=[rootfolder sub];       
    % define image IDs
    switch subs(subi)
        case 7
            runs = 4:8;
            wb = 9;
        case 19
            runs = 7:11;
            wb = 12;
        case 22
            runs = 5:9;
        case 23
            runs = [3 4 6:8];
    end
    % generate images if they are not exist
    if ~exist([datafolder filesep sub '.str.nii'],'file') 
        task = sprintf('%02d %02d %02d %02d %02d',runs);
        strimg = sprintf('%02d',str);
        if subs(subi) < 22
            % not whole brain, scan wb
            genimage = ['tcsh generate_img.tcsh ' sub ' "' task '" ' strimg ' ' sprintf('%02d',wb)];
        else
            % no wb
            genimage = ['tcsh generate_img.tcsh ' sub ' "' task '" ' strimg];
        end
        unix(genimage)
    else
        disp(['Images of ' sub ' has already been generated!'])
    end
    % generate time files
    timing_3t(sub);
    
end