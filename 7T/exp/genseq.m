% number of odors
odornum=5;
% generate sequence for valence and intensity rating
vi=[];
for i=1:2
    % perms returns all possible sequences
    temp=perms(1:odornum);
    % add a rand sequence to the first column
    temp=[randperm(length(temp))' temp];
    % sortrows and return
    temp=sortrows(temp);
    vi=[vi;temp(:,2:end)];
end
% generate sequence for similarity rating
subjs=48;
si=cell(subjs,6);
comb=nchoosek(1:odornum,2);
temp=perms(1:6);
temp=[randperm(length(temp))' temp];
temp=sortrows(temp);
temp=temp(1:subjs,2:end);
for i=1:numel(temp)
    si{i}=comb(temp(i),randperm(2));
end

save('randrating.mat','vi','si');