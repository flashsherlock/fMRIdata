function data=bottlerate(sub)
% sub is the number of subject
if nargin<1
    sub=999;
end
% load sequence
fullpath=mfilename('fullpath');
[path,~]=fileparts(fullpath);
load([path './../exp/randrating.mat'])
% load ratings
datafolder='/Volumes/WD_E/gufei/7T_odor/'; 
valence=xlsread([datafolder 'rating.xlsx'],'valence');
intensity=xlsread([datafolder 'rating.xlsx'],'intensity');
similarity=xlsread([datafolder 'rating.xlsx'],'similarity');
% select suquence
si=si(1:size(similarity,1),:);
vi=vi(1:size(valence,1),:);
% get indx
[~,indx_vi]=sort(vi,2);
si=cellfun(@(x) (sort(x)*[10;1]),si);
[~,indx_si]=sort(si,2);
% get odor numbers
odornum=size(vi,2);
% sort ratings
valRDM=zeros(odornum,odornum,size(vi,1));
intRDM=valRDM;
for i=1:size(vi,1)
    valence(i,:)=valence(i,indx_vi(i,:));
    % change to RDM 0-1 distance
    valRDM(:,:,i)=pdist2(valence(i,:)',valence(i,:)')/6;
%     divided by its own maximum
%     valRDM(:,:,i)=pdist2(valence(i,:)',valence(i,:)')/max(valence(i,:));
    % intensity
    intensity(i,:)=intensity(i,indx_vi(i,:));
    intRDM(:,:,i)=pdist2(intensity(i,:)',intensity(i,:)')/6;
%     intRDM(:,:,i)=pdist2(intensity(i,:)',intensity(i,:)')/max(intensity(i,:));
end
simRDM=zeros(odornum,odornum,size(si,1));
for i=1:size(si,1)
    similarity(i,:)=similarity(i,indx_si(i,:));
    % 1-7 similarity to 0-1 distance
    d=(7-similarity(i,:))/6;
%     d=(7-similarity(i,:))/max(7-similarity(i,:));
    % change to RDM
    simRDM(:,:,i)=squareform(d);
end
% save to data
% out put certain subject if specified
if sub>=1 && sub<=size(si,1)
    data.valence=valence(sub,:);
    data.intensity=intensity(sub,:);
    data.similarity=similarity(sub,:);
    data.simRDM=simRDM(:,:,sub);
    data.valRDM=valRDM(:,:,sub);
    data.intRDM=intRDM(:,:,sub);
% is subject not in the range, output all data
else
    data.valence=valence;
    data.intensity=intensity;
    data.similarity=similarity;
    data.simRDM=simRDM;
    data.valRDM=valRDM;
    data.intRDM=intRDM;
end
end