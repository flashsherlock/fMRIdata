function res_select = select_voxel( cur_res, voxel_num, run, zrun )
% select voxels that has minimum within condition variance
    if nargin<4
        zrun = 0;
    end
    if nargin<3
        run = 0;
    end
    if nargin<2
        voxel_num = 100;
    end
    voxn = size(cur_res,1);
    conn = size(cur_res,2);
    runn = 6;
    if run == 1
        odorn = 5*runn;
    else
        odorn = 5;
    end
    % zscore witin runs
    if zrun == 1
        cur_res = reshape(cur_res',[],runn,5,voxn);
        cur_res = permute(cur_res,[1 3 2 4]);
        cur_res = reshape(cur_res,[],runn,voxn);
        cur_res = zscore(cur_res,0,1);
        cur_res = reshape(cur_res,[],5,runn,voxn);
        cur_res = permute(cur_res,[1 3 2 4]);
        cur_res = reshape(cur_res,[],voxn)';
    elseif zrun == 2
        cur_res = reshape(cur_res',[],5,voxn);
        cur_res = zscore(cur_res,0,2);
        cur_res = reshape(cur_res,[],voxn)';
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
    % sort by perw
    [~,index]=sort(perw,'ascend');
    res_select = cur_res(index(1:min(voxel_num,voxn)),:);
end

