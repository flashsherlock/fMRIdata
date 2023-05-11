data_dir = '/Volumes/WD_F/gufei/blind/';
[num,txt,raw]=xlsread([data_dir 'question_7.xlsx'],'Sheet1');
% id
[subs, idx]= sort(txt(2:end,7));
num = num(idx,:);
select_sub = 1:length(subs);
% select_sub = [2:4,6:length(subs)];
nsub = length(select_sub);
% ratings for 6 odors
ratings = reshape(num(select_sub,48:65),nsub,3,[]);
% intensity
intensity = squeeze(ratings(:,2,:));
% (val int fam) x (pin app ros min ind gas)
odors = {'pin', 'app', 'ros', 'min', 'ind', 'gas'};
avg = squeeze(mean(ratings,1));
disp([{'';'valence';'intensity';'familiarity'},[odors;num2cell(avg)]])