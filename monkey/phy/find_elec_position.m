subjID = 'RM035';
filepath = '/Volumes/WD_D/gufei/monkey_data/IMG/';
load([filepath '/' subjID '_elec.mat']);
level=3:4;
position = find_elec_label(subjID,elec_acpc_f,level);
%% save position
% add a new field and save
elec_acpc_f.position=position;
atlas_coord=cell2mat(position(:,1));
% atlas_coord=elec_acpc_f.elecpos;
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
anat=[filepath '/' subjID '_MRI_acpc.nii'];
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
exp=cell(1,length(atlas_coord)/2);
for i_elec=1:length(atlas_coord)/2
    i_vector=atlas_coord(i_elec,:)-atlas_coord(i_elec+length(atlas_coord)/2,:);    
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