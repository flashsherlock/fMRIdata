% process data
for subi=1:3
    sub=sprintf('S%02d',subi);
    analysis={'pade','paphde','pabiode'};
%     analysis={'pade'};
    % disp(sub)
    datafolder=['/Volumes/WD_E/gufei/7T_odor/' sub];
    
    % corrected by phy
    if ismember('paphde',analysis)
        cmd=['tcsh proc_fmri2xsmooth.tcsh '  sub];
        unix(cmd)
    end
    % corrected by bio
    if ismember('pabiode',analysis)
        unix([cmd ' bio'])
    end
    
    % nophy analysis
    if ismember('pade',analysis)
        cmd=['tcsh ./nophy/proc_fmri2xsmooth.tcsh '  sub];
        unix(cmd)
    end
    
    % generate commands for parallel
    for i=1:length(analysis)
        subj=[sub '.' analysis{i}];
        fid=fopen([datafolder '/../' analysis{i} '.txt'],'a+');
        cmd=['cd ' sub ' && tcsh -xef proc.' subj ' |& tee output.proc.' subj];
        fprintf(fid,'%s\n',cmd);
        fclose(fid);
    end
end