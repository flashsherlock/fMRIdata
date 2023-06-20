% generate images, timing files for each subject
subs=23:25;
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
        case {3 4 9 11 14 18 19}
            runs = 15:1:20;
            pa = 21;
            str = 22;
        case 5
            runs = 16:1:21;
            pa = 22;
            str = 24;
        case 6
            str = 22;
        case 7
            runs = [14:1:16 18:1:20];
            pa = 21;
            str = 22;
        case 8
            runs = [14:1:17 19:1:20];
            pa = 21;
            str = 22;
        case 12
            runs = [15 17:1:19 21:1:22];
            pa = 23;
            str = 24;
        case 13
            runs = [15:1:16 18:1:21];
            pa = 22;
            str = 17;
        case 15
            runs = [15:1:16 19:1:22];
            pa = 23;
            str = 24;
        case 16
            runs = [15 17 19:1:22];
            pa = 23;
            str = 24;
        case 17
            runs = [17 18 20:1:23];
            pa = 24;
            str = 25;
        case 21
            runs = [16:1:18 20 21 23];
            pa = 24;
            str = 26;
        case 22
            runs = [17:1:20 22 23];
            pa = 24;
            str = 25;
        case 23
            runs = [15 21:1:25];
            pa = 26;
            str = 27;
        case 24
            runs = [15 21:1:25];
            pa = 18;
            str = 19;
        case 25
            runs = [10:1:13 15 17];
            pa = 18;
            str = 19;
    end
    % generate images if they are not exist
    if ~exist([datafolder filesep sub '.str.nii'],'file') 
        strimg=sprintf('%02d',str);
        genimage=['tcsh generate_img.tcsh ' sub ' "' num2str(runs) '" ' num2str(pa) ' ' strimg];
        unix(genimage)
    else
        disp(['Images of ' sub ' has already been generated!'])
    end
    % generate time files
    blind_timing(sub,length(runs));
    blind_timing_rating(sub,length(runs));
    
end