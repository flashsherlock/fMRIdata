%% load data
subjID = 'RM035';
filepath = '/Volumes/WD_D/gufei/monkey_data/IMG/';
% anat=[filepath '/' subjID '_MRI_acpc.nii'];
% position before transformation
% load([filepath '/' subjID '_elec.mat']);
% load([atpath subjID '_NMT/' subjID '_transfrom.mat']);
% elec_acpc_f.chanpos=ft_warp_apply(inv(spm_matrix(x(:)')), elec_acpc_f.chanpos, 'homogenous');
% elec_acpc_f.elecpos=elec_acpc_f.chanpos;
% save([filepath '/' subjID '_elec_atlas.mat'], 'elec_acpc_f');
% transformed position
load([filepath '/' subjID '_elec_atlas.mat'])
[num,txt,raw]=xlsread([filepath '/' subjID '_position.xlsx'],'A1:X21');
filepath = ['/Volumes/WD_D/gufei/monkey_data/IMG/' subjID '_NMT/'];
anat=[filepath '/' subjID '_anat.nii'];
atlas_coord=elec_acpc_f.elecpos;
num_elec=length(atlas_coord)/2;

%% find and save initial position
level=3:4;
position = find_elec_label(subjID,elec_acpc_f,level);
% add a new field and save
elec_acpc_f.position=position;
% atlas_coord=cell2mat(position(:,1));
save([filepath '/' subjID '_elec_label.mat'], 'elec_acpc_f');
%% plot electrodes on nii
% recording points
r2=0.4^2;
exp=cell(1,length(atlas_coord));
for i_elec=1:length(atlas_coord)
    x=['(x-' num2str(atlas_coord(i_elec,1)) ')'];
    y=['(y-' num2str(atlas_coord(i_elec,2)) ')'];
    z=['(z-' num2str(atlas_coord(i_elec,3)) ')'];
    exp{i_elec}=['step(' num2str(r2) '-' x '*' x '-' y '*' y '-' z '*' z ')'];
end
exp=['''or(' strjoin(exp,',') ')'''];
% anat=[filepath '/' subjID '_MRI_acpc.nii'];
cmd=['3dcalc -a ' anat ' -LPI -expr ' exp ' -prefix ' [filepath '/' subjID '_MRI_elec.nii']];
unix(cmd);

% electrode orientation
% how to calculate cylinder formula
% https://zhidao.baidu.com/question/1388181926988339500.html
% point (x1,y1,z1), vector (a,b,c), radius r
syms x1 y1 z1 a b c r x y z real
% assume([x1 y1 z1 a b c r x y z],'real')
p=[x1 y1 z1];
vector=[a b c];
cylinder=[x y z];
cy=(r*(norm(vector)))^2-norm(cross(cylinder-p,vector))^2;
r_cylinder=0.4;
exp=cell(1,num_elec);
for i_elec=1:num_elec
    i_vector=atlas_coord(i_elec,:)-atlas_coord(i_elec+num_elec,:);    
    formula=simplify(subs(cy,[x1 y1 z1 a b c r],single([atlas_coord(i_elec,:) i_vector r_cylinder])));
    % convert fraction to decimal
    formula=vpa(formula,4);
    % replace ^2 with *
    f=strrep(char(formula),' ','');
    expression = '(\([^\^]*\))\^2';
    replace = '$1\*$1';
    f=regexprep(f,expression,replace);
    % match = regexp(f,expression,'match');
    exp{i_elec}=['step(' f ')'];
end
exp=['''10*or(' strjoin(exp,',') ')'''];
% anat=[filepath '/' subjID '_MRI_acpc.nii'];
cmd=['3dcalc -a ' anat ' -LPI -expr ' exp ' -prefix ' [filepath '/' subjID '_MRI_orien.nii']];
unix(cmd);

%% calculate movement
num_date = size(num, 1)-1;
% check order
tf=zeros(1,num_elec);
for i_channel=1:num_elec
    tf(i_channel)=strcmp(strcat('WB',num2str(num(1,i_channel))),elec_acpc_f.label{i_channel});
end

if all(tf)
    relpos=num(2:end,:)'-35; 
else
    error('Electrodes mismatch!')
end

% direction vector
vec = atlas_coord(1:num_elec, :) - atlas_coord(num_elec+1:end, :);
vec_norm=sqrt(vec(:,1).^2+vec(:,2).^2+vec(:,3).^2);
% all electrodes positions
all_pos=zeros([num_elec 3 num_date]);
for i_date=1:num_date
    % add fraction.*vec to original position
    fraction=relpos(:,i_date)./vec_norm;
    all_pos(:,:,i_date)=atlas_coord(1:num_elec,:)+fraction.*vec;   
end
% all_pos_uni=unique(reshape(permute(all_pos,[1 3 2]),[],3),'rows')；
%% plot all electrodes
% recording points
r=0.4;
exp=cell(1,num_elec*num_date);
for i_date=1:num_date
    for i_elec=1:num_elec
        x=['(x-' num2str(all_pos(i_elec,1,i_date)) ')'];
        y=['(y-' num2str(all_pos(i_elec,2,i_date)) ')'];
        z=['(z-' num2str(all_pos(i_elec,3,i_date)) ')'];
        exp{(i_date - 1) * num_elec + i_elec} = ['step(' num2str(r2) '-' x '*' x '-' y '*' y '-' z '*' z ')'];
    end
end
txtname=[filepath '/' subjID '_allpos.txt'];
dlmwrite(txtname,reshape(permute(all_pos,[1 3 2]),[],3),'delimiter',' ');
% anat=[filepath '/' subjID '_MRI_acpc.nii'];
cmd=['3dundump -master ' anat ' -prefix ' [filepath '/' subjID '_MRI_allpos.nii'] ' -dval 1 -orient LPI -srad ' num2str(r) ' -xyz ' txtname];
unix(cmd);
%% lookup all positions
level=3:6;
% 1 coord + labels
allpos_l=cell(num_elec,1+length(level),num_date);
for i_date=1:num_date
    elec_all=elec_acpc_f;
    elec_all.chanpos=all_pos(:,:,i_date);
    elec_all.elecpos=elec_all.chanpos;
    allpos_l(:,:,i_date) = find_elec_label(subjID,elec_all,level);
end
% save labels
save([filepath '/' subjID '_allpos_label.mat'], 'allpos_l');