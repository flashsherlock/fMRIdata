function res_select = select_voxel( cur_res, voxel_num, run )
% select voxels that has minimum within condition variance
    if nargin<3
        run = 0;
    end
    if nargin<2
        voxel_num = 100;
    end
    voxn = size(cur_res,1);
    conn = size(cur_res,2);
    if run == 1
        odorn = 5*6;
    else
        odorn = 5;
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

