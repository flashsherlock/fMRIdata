datafolder='/Volumes/WD_E/gufei/7T_odor/results_RSA/';
pattern={'odor_va_trial','odor_trial'};
for rsa_i=1:length(pattern)    
    load([datafolder pattern{rsa_i} filesep '/RDMs/Cleandata_RDMs.mat']);
    sRDMs = rsa.rdm.averageRDMs_subjectSession(RDMs, 'session');
    % RDMs  = rsa.rdm.averageRDMs_subjectSession(sRDMs, 'subject');
    [nroi,nsub]=size(sRDMs);
    label=cell(nroi,nsub,9);
    l9=cell(1,9);
    a={'within','between','diff'};
    b={'all','w_run','b_run'};
    for l=1:3
       l9(l*3-2:l*3) = strcat(a{l},'|', b);
    end
    
    results=zeros(nroi,nsub,9);
    for i=1:nroi
        for j=1:nsub
            label(i,j,:)=strcat(strrep(sRDMs(i,j).name,'-','_'),' | ',l9);
            distance=rclass(sRDMs(i,j).RDM);
            % compute r
            r=1-distance;
            results(i,j,:)=[r(1,:), r(2,:), r(1,:)-r(2,:)];
        end
    end
    label=reshape(label,[],1,1);
    results=reshape(results,[],1,1);
    datafile=[datafolder pattern{rsa_i} '.mat'];
    save(datafile,'label','results');
end