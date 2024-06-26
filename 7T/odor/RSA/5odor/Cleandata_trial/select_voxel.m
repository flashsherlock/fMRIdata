function [res_select,perw] = select_voxel( cur_res, voxel_num, actper)
% select voxels that has minimum within condition variance
    if nargin<3
        actper = 0.95;
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
    % calculate z activity
    act = zscore(reshape(cur_res',[],voxn),0,1);
%     act = zscore(reshape(cur_res',[],odorn,voxn),0,1);
%     act = reshape(act,[],voxn);
    cutoff = 3;
    outindex = all(abs(act)<=cutoff);
    % if too much zeros in outindex
    if sum(outindex) < 2
        outindex = all(abs(act-mean(act,2))<=cutoff);
    end
    cur_res = cur_res(outindex,:);
    voxn = size(cur_res,1);
    % calculate mean z activity
%     act = zscore(squeeze(mean(reshape(cur_res',[],odorn,voxn),1)),0,2);
%     outindex = all(abs(act)<=4);
%     cur_res = cur_res(outindex,:);
%     voxn = size(cur_res,1);
    % averaged act
%     act = mean(abs(zscore(squeeze(mean(reshape(cur_res',[],odorn,voxn),1)),0,2)));
%     [~,actindex]=sort(abs(act),'descend');
%     cur_res = cur_res(actindex(1:min(actper,size(cur_res,1))),:);
%     cur_res = cur_res(act<=2&act>=0.45,:);
%     voxn = size(cur_res,1);

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
%     res_select = cur_res(perw<=max(0,perw(index(min(voxel_num,voxn)))),:);
    
    % select mean activation
%     voxn = size(res_select,1);
% %     act = zscore(squeeze(mean(reshape(res_select',[],odorn,voxn),1)),0,2);
%     act = act(:,index(1:min(voxel_num,voxn)));
%     % remove outliers
%     outindex = all(abs(act)<=5);
%     if sum(outindex)>=minnum
%         res_select = res_select(outindex,:);
%     end
%     act = mean(abs(act(:,outindex)));
%     [~,actindex]=sort(abs(act),'descend');
%     res_select = res_select(actindex(1:min(actper,size(res_select,1))),:);
%     res_select = res_select(act>=0.45,:);
%     res_select = res_select(act<=2&act>=0.45,:);
end
