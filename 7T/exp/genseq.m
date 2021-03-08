% generate sequence for valence and intensity rating
vi=[];
for i=1:2
    temp=perms(1:4);
    temp=[randperm(length(temp))' temp];
    temp=sortrows(temp);
    vi=[vi;temp(:,2:end)];
end
% generate sequence for similarity rating
subjs=48;
si=cell(subjs,6);
comb=nchoosek(1:4,2);
temp=perms(1:6);
temp=[randperm(length(temp))' temp];
temp=sortrows(temp);
temp=temp(1:subjs,2:end);
for i=1:numel(temp)
    si{i}=comb(temp(i),randperm(2));
end

save('randrating.mat','vi','si');