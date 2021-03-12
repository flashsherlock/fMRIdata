% generate images, timing files, and phy files for each subject
for subi=3
    sub=sprintf('S%02d',subi);
    % disp(sub)
    datafolder=['/Volumes/WD_E/gufei/7T_odor/' sub];       
    % define image IDs
    switch subi
        case 1
            runs=11:2:21;
            pa=23;
            inv1=4;
            inv2=6;
            uni=9;
        otherwise
            runs=10:2:20;
            pa=22;
            inv1=3;
            inv2=5;
            uni=8;
    end    
    % generate images if they are not exist
    if ~exist([datafolder filesep sub '.uniden15.nii'],'file') 
        strimg=sprintf(' %02d %02d %02d',inv1,inv2,uni);
        genimage=['tcsh generate_img.tcsh ' sub ' "' num2str(runs) '" ' num2str(pa) strimg];
        unix(genimage)
    else
        disp(['Images of ' sub ' has already been generated!'])
    end
    
    % generate timing files
    analyze_timing(sub);
    analyze_timing_rating(sub);
    analyze_rating(sub)

    % generate phy files
    resp_savebio(sub);
    unix(['tcsh phy.tcsh ' sub ' "' num2str(runs) '"'])
    resp_campare(sub);
    % S03 run2 lose one point 989 at the end 
end