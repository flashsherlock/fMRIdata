% load elec labels
monkey='RM033';
label=['/Volumes/WD_D/gufei/monkey_data/IMG/'...
    monkey '_NMT/' monkey '_allpos_label.mat'];
load(label);
% select labels (1st row is elec num)
switch monkey
    case 'RM035'
        select=[1:3 7:21];
    case 'RM033'
        select=[1:24];
end
output=output(select,:,:);
level=3:6;
% frequency of each position
ele_date_alevel=cell(length(level),1);
for i_level=1:length(level)
    t=tabulate(reshape(output(2:end,:,i_level),[],1));
    ele_date=cell(size(t,1),2);
    ele_date(:,1)=t(:,1);
    for i_label=1:size(t,1)
        row_col=zeros(t{i_label,2},2);
        [row_col(:,1),row_col(:,2)]=find(strcmp(output(2:end,:,i_level), t{i_label,1}));
        ele_date{i_label,2}=row_col;
    end
    ele_date_alevel{i_level}=ele_date;
end
% find filenames
file_dir=['/Volumes/WD_D/gufei/monkey_data/yuanliu/'...
    lower(monkey) '_ane/mat/'];
file=dir([file_dir '*_ane.mat']);
filenames=struct2cell(file);
filenames=filenames(1,:);
% save
save([file_dir monkey '_datpos_label.mat'],'output','ele_date_alevel','filename');
