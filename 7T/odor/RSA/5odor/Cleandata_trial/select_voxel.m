function [res_select,perw] = select_voxel( cur_res, voxel_num, actper)
% select voxels that has minimum within condition variance
    if nargin<3
        actper = 0.85;
    end
    if nargin<2
        voxel_num = 0.05;
    end
    % number of voxels
    voxn = size(cur_res,1);
    minnum = 10;
    % number of conditions
    conn = size(cur_res,2);
    runn = 6;
    repeat = 6;
    odorn = conn/runn/repeat;
    if actper<=1
        % add minimum number
        actper = max(minnum,ceil(actper*voxn));
    end
%     act = mean(cur_res,2);    
    % calculate mean z activity
    act = zscore(squeeze(mean(reshape(cur_res',[],odorn,voxn),1)),0,2);
    act = mean(abs(act));
%     [~,actindex]=sort(abs(act),'descend');
%     cur_res = cur_res(actindex(1:min(actper,voxn)),:);
    cur_res = cur_res(act<=2&act>=0.45,:);
    % calculate new voxel number
    voxn = size(cur_res,1);        
%     maximum = 100;
    % if voxel_num<=1, treat it as percentage    
    if voxel_num<=1
        % add minimum number
        voxel_num = max(minnum,ceil(voxel_num*voxn));
%         voxel_num = min(maximum,ceil(voxel_num*voxn));
    end
    % all variance
    ssa=var(cur_res,0,2)*(conn-1);
    % within condition variance
    ssw=var(reshape(cur_res',[],odorn,voxn),0,1)*(conn/odorn-1);
    ssw=squeeze(sum(ssw,2));
    % between condition variance
    ssb=var(mean(reshape(cur_res',[],odorn,voxn),1),0,2)*(odorn-1);
    ssb=squeeze(ssb*(conn/odorn));
    % percent of within variance
    perw=ssw./ssa;
%     % sort by perw
%     [~,indexper]=sort(perw,'ascend');
%     [~,indexw]=sort(ssw,'ascend');
%     [~,indexb]=sort(ssw,'descend');
%     % calculate scores for each voxel
%     numbers = 1:voxn;
%     scores = zeros(voxn,3);
%     scores(indexper, 1) = numbers;
%     scores(indexw, 2) = numbers;
%     scores(indexb, 3) = numbers;
%     scores = mean(scores,2);
%     [~,index]=sort(scores,'ascend');
    [~,index]=sort(perw,'ascend');
    res_select = cur_res(index(1:min(voxel_num,voxn)),:);
    % select by cutoff
%     res_select = cur_res(perw<=max(0.85,perw(index(min(voxel_num,voxn)))),:);
    
    % select mean activation
%     voxn = size(res_select,1);
%     if actper<=1
%         % add minimum number
%         actper = max(minnum,ceil(actper*voxn));
%     end
%     act = mean(res_select,2);
% %     hist(act)
%     [~,actindex]=sort(abs(zscore(act)),'descend');
%     res_select = res_select(actindex(1:min(actper,voxn)),:);
end
