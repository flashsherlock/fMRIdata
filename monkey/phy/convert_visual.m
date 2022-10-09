%% load and convert corrdinates
monkeys = {'RM035','RM033'};
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
% elec_dir='/Volumes/WD_D/gufei/monkey_data/IMG/visual/';
elec_dir='/Volumes/WD_D/gufei/monkey_data/IMG/olfactory/';
% load position saved by lfp_odorresp_sep
m = '2monkey';
load([data_dir 'tf_sep_' m '.mat'],'cur_level_roi')
bad_pos = [cur_level_roi{346,1};cur_level_roi{414,1}];
% convert coordinates
for monkey_i=1:2
    load([elec_dir monkeys{monkey_i} '_allpos_coord.mat'])
    elec = cat(1,allpos_l{:,1,:});
    % deal with strange position in RM033
    if monkey_i==2
        elec(ismember(elec,bad_pos(1,:),'rows'),2) = elec(ismember(elec,bad_pos(1,:),'rows'),2)-0.001;
        elec(ismember(elec,bad_pos(2,:),'rows'),1) = elec(ismember(elec,bad_pos(2,:),'rows'),1)-0.001;
        % no label position
        % elec(ismember(elec,elec(260,:),'rows'),2) = elec(ismember(elec,elec(260,:),'rows'),2)-0.001;        
    end
    file_dir = [data_dir '../IMG/' monkeys{monkey_i}];   
    infile = [elec_dir '_elec_LPI.1D'];
    outfile = [elec_dir '_elec_STD.1D'];
    % convert
    warp = ['' file_dir '_2NMT_WARP.nii.gz' ''];
    dlmwrite(infile,[-1 -1 1].*elec,'delimiter',' ');
    cmd = ['3dNwarpXYZ -nwarp ' warp ' -iwarp ' infile ' > ' outfile];
    unix(cmd);
    % load results    
    elec_n = [-1 -1 1].*dlmread(outfile);
    elec_n = reshape(mat2cell(elec_n,ones(1,size(elec_n,1)),3),size(allpos_l,1),1,[]);
    allpos_norm = cat(2,allpos_l,elec_n);
    save([elec_dir monkeys{monkey_i} '_allpos_norm.mat'],'allpos_norm');
end
%% plot
file_dir = [data_dir '../IMG/'];
right_AH = ft_read_headshape([file_dir 'right_AH_level5.stl'],'format','stl');
right_AH.coordsys = 'acpc';
left_AH = ft_read_headshape([file_dir 'left_AH_level5.stl'],'format','stl');
left_AH.coordsys = 'acpc';
meshcolor = 0.75*[1 1 1];
meshalpha = 0.2; 
figure
hold on 
% separate left and right
ft_plot_mesh(right_AH,'facecolor',meshcolor,'facealpha',meshalpha);    
ft_plot_mesh(left_AH,'facecolor',meshcolor,'facealpha',meshalpha);
for monkey_i=1:2
    load([elec_dir monkeys{monkey_i} '_allpos_norm.mat'])
    elec_n = cat(1,allpos_norm{:,6,:});
    scatter3(elec_n(:,1),elec_n(:,2),elec_n(:,3),25,'r','filled')
end