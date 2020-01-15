sub=20;
condition=8;
label={'FPI','FPV','FUI','FUV','HPI','HPV','HUI','HUV','NUM','FP','FU','HP','HU',};
%read subject numbers
subs=unique(textread('20subj_FaceValence.AmyFH.t196.txt', '%s%*[^\n]'),'stable');
subs{1}='sub';
for i=2:sub+1
subs{i}=subs{i}(1:3);
end
subs{end+1}='Mean';
%read and write
xl=dir('*.xlsx');
for i=1:length(xl)
data=xlsread(xl(i).name);
data=data(:,2:3);
%delete nan
data(isnan(data(:,1))==1,:)=[];
%nonzero means
nzmean=reshape(data(:,end-1),condition,sub);
%change to 20 rows 8 columns
nzmean=nzmean';
%voxel number
% number=unique(data(:,end),'stable');
number=reshape(data(:,end),condition,sub);
number=number(1,:)';
results=[nzmean number];
%Inv-Vis
results(:,end+1:end+4)=abs(nzmean(:,1:2:end)-nzmean(:,2:2:end));
results(end+1,:)=nanmean(results);
%joint
out=[subs [label;num2cell(results)]];
output=out;
output(:,2:5)=out(:,2:2:8);
output(:,6:9)=out(:,3:2:9);
xlswrite(xl(i).name, output, 'results', 'A1');
end