% generate images, timing files, and phy files for each subject
subs=9:11;
subs_behavior=[21 17 19];
rootfolder='/Volumes/WD_E/gufei/7T_odor/';
% save all subject ratings
% [rate_avg,rate_run]=saverate(subs);
% save([rootfolder 'rating.mat'],'rate_avg','rate_run');
% save 5 odors rating
% [rate_avg,rate_run]=saverate(subs,[6 5]);
% save([rootfolder 'rating5odor.mat'],'rate_avg','rate_run');
% generate files for each subject
for subi=1:length(subs)
    sub=sprintf('S%02d',subs(subi));
    % default settings
    sub_behavior = sprintf('s%02d', subs_behavior(subi));
    runs = 10:2:20;
    pa = 22;
    inv1 = 3;
    inv2 = 5;
    uni = 8;
    % disp(sub)
    datafolder=[rootfolder sub];       
    % define image IDs
    switch subs(subi)
        case 1
            runs=11:2:21;
            pa=23;
            inv1=4;
            inv2=6;
            uni=9;
        case 9
            runs = 11:2:21;
            pa = 23;
        case {4 7 8 11}
            runs=10:2:20;
            pa=22;
            inv1=3;
            inv2=8;
            uni=6;
    end    
    % generate data folder
    if ~exist(datafolder, 'dir')
        genfolder = ['tcsh order_data.tcsh ' [sub ' ' sub_behavior]];
        unix(genfolder)
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
    times=[6 5];
    analyze_timing(sub,times);
    analyze_timing_rating(sub,times);
    analyze_timing_valence(sub,times);
    analyze_timing_valence_avg(sub,times);
    analyze_timing_valence_allavg(sub,times);
    analyze_timing_intensity(sub,times);
    analyze_timing_intensity_avg(sub,times);
    analyze_timing_intensity_allavg(sub,times);

    % generate phy files
    resp_savebio(sub);
    unix(['tcsh phy.tcsh ' sub ' "' num2str(runs) '"'])
    resp_campare(sub);
%     % S03 run2 lose one point 989 at the end 
%     
%     %% use 3dresample in afni to match pa and run
%     input = [datafolder '/' sub '.pa+orig'];
%     output = [datafolder '/' sub '.par+orig'];
%     master = [datafolder '/' sub '.run1+orig'];
%     afni_resample=['3dresample -input ' input ' -master ' master ' -prefix ' output];
%     unix(afni_resample)
end