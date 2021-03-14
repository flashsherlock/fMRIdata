% process data
for subi=2:3
    sub=sprintf('S%02d',subi);
    % disp(sub)
    datafolder=['/Volumes/WD_E/gufei/7T_odor/' sub];
    
    cmd=['tcsh proc_fmri2xsmooth.tcsh '  sub];
    unix(cmd)
    unix([cmd ' bio'])
end