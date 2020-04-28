% for OlfacVisuoEmoSuppExpFMRI timing .1D to time points
file=dir('*.1D');
for i=1:length(file)
    %eval(sprintf('timing=load(''%s.%s.1D'');',subjID,con{i}));
    timing=load(file(i).name);
    N=0;
    for j=2:size(timing,1)
        if timing(j,1)==1 && timing(j-1,1)==0
            N=N+1;
            trans(1,N)=(j-1)*2;
        end
    end
    cmd=sprintf('dlmwrite(''%s.txt'',trans,''delimiter'','' '')',file(i).name(1:end-3));
    eval(cmd);
end
