data_dir = '/Volumes/WD_F/gufei/blind/';
[num,txt,raw]=xlsread([data_dir 'question_10.xlsx'],'Sheet1');
% sort by id
[subs, idx]= sort(txt(2:end,7));
num = num(idx,:);
txt = txt(1+idx,:);
raw = raw(1+idx,:);
% select sub
select_sub = 1:length(subs);
% select_sub = [2:4,6:length(subs)];
subs = subs(select_sub);
% calculate age from date of birth
t1 = cellfun(@(x) datetime(x,'InputFormat','yyyy/MM/dd HH:mm:ss'),txt(select_sub,2),'UniformOutput',false);
t2 = cellfun(@(x) datetime(x,'InputFormat','yyyy-MM-dd'),txt(select_sub,10),'UniformOutput',false);
age = cellfun(@(x,y) calyears(between(x,y,'years')),t2,t1);
% 1-female 2-male
sex = num(select_sub,9);
nsub = length(select_sub);
subinfo = [select_sub' sex age];
% ratings for 6 odors
ratings = reshape(num(select_sub,48:65),nsub,3,[]);
% intensity
intensity = squeeze(ratings(:,2,:));
% (val int fam) x (pin app ros min ind gas)
odors = {'pin', 'app', 'ros', 'min', 'ind', 'gas'};
avg = squeeze(mean(ratings,1));
disp([{'';'valence';'intensity';'familiarity'},[odors;num2cell(avg)]])