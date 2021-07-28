%% set path and load header from edf file
subjID = 's07';
filepath=['/Volumes/WD_D/gufei/consciousness/electrode/use/' subjID '/' subjID '/brain3D'];
%% generate labels manually
% prefix='POL ';
switch subjID
    case 's01'
    ename=['A' 'H' 'J'];
    enum=[14 12 14];
    case 's02'
    ename=['A' 'H' 'J' 'C' 'I' 'a' 'h'];
    enum=[14 12 12 14 6 12 2];
    case 's03'
    ename=['A' 'H' 'J' 'X'];
    enum=[14 14 12 16];
    case 's04'
    ename=['F' 'G' 'Q' 'R'];
    enum=[14 12 12 14];
    case 's05'
    ename=['A' 'H' 'J' 'O'];
    enum=[14 14 14 16];
    case 's06'
    ename=['A' 'H' 'M' 'T'];
    enum=[14 14 12 12];
    case 's07'
    ename=['A' 'B' 'H' 'I'];
    enum=[14 12 14 12];
end

names=cell(sum(enum),1);
for i=1:length(ename)
% A=[repmat('A',14,1) [1:14]'];
name_tmp=reshape(sprintf([ename(i) '%02d'],1:enum(i)),3,[])';
names(sum(enum(1:i))-enum(i)+1:sum(enum(1:i)),1)=cellstr(name_tmp);
end
elec_mni_fv.label=names;
elec_acpc_f.label=names;
%% load coordinates
% coordinates in mni space
c=load([filepath '/' 'MNI152_coordinates_ras.txt']);
elec_mni_fv.chanpos=c(:,1:3);
elec_mni_fv.elecpos=elec_mni_fv.chanpos;
% elec_mni_fv.channum=c(:,4);

% coordinates in original space
% while ~exist('savecoors','var')
load([filepath '/' 'autocoordinates.mat'],'savecoors');
% end
elec_acpc_f.chanpos = savecoors(:,3:5);
elec_acpc_f.elecpos = elec_acpc_f.chanpos;
% elec_acpc_f.channum = savecoors(:,2);
%% save
matpath='/Volumes/WD_D/gufei/consciousness/data';
save([matpath '/' subjID '_elec_acpc_f.mat'], 'elec_acpc_f');
save([matpath '/' subjID '_elec_mni_fv.mat'], 'elec_mni_fv');
%% save names
proc_elecposition(subjID);
proc_elecname(subjID);