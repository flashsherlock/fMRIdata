masks = {'align','at165','at196'};
voxn = [0.05];
results = cell(length(voxn),length(masks));
ps = results;
for mask_i = 1:3
    for vi = 1:length(voxn)
        [results{vi,mask_i}, ps{vi,mask_i}]=test_corr(masks{mask_i},voxn(vi));
    end
end