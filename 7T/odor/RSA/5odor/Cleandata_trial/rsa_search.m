outdatadir = '/Volumes/WD_F/gufei/7T_odor/figures/';
% masks = {'align','at165','at196'};
masks = {'at165'};
voxn = [0.05];
ncon = 180;
results = cell(length(voxn),length(masks));
ps = results;
for mask_i = 1:length(masks)
    for vi = 1:length(voxn)
        [results{vi,mask_i}, ps{vi,mask_i}]=test_corr(masks{mask_i},voxn(vi),ncon);
        dlmwrite([outdatadir 'rsa_' num2str(ncon) '_' masks{mask_i} '.txt'],results{vi,mask_i},'delimiter',' ');
    end
end