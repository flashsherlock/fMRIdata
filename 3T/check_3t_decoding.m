%% check decoding results
datafolder='/Volumes/WD_F/gufei/3T_cw/';
subs=3:29;
subnum=length(subs);
rois={'BoxROIext'};
shift=[6];
check = 'face'; 
if strcmp(check,'odor')
    comb={'all'};
else
    comb={'inv';'vis'};
end
combn=size(comb,1);
decode=[reshape(repmat(subs,combn,1),[],1) repmat([1:combn]',subnum,1)];
%% check if decoding finished and normalize to standard space
disp(check)
decode_need = zeros(size(decode,1),1);
for i=1:size(decode,1)
    sub=sprintf('S%02d',decode(i,1));
    test=[comb{decode(i,2)} '_' rois{1}];
    result = [datafolder sub '/' sub '.de.results/mvpa/searchlight_' check '_shift' strrep(num2str(shift),' ','') '/' test];
    if ~exist([result '/res_accuracy_minus_chance+orig.BRIK'],'file')
        decode_need(i)=1;
        disp([num2str(i) ' ' sub ' ' test]);
    else
        % align results to standard space
        cd(result);
        nw = ['../../../anatQQ.' sub '_WARP.nii ../../../anatQQ.' sub '.aff12.1D INV(../../../anatSS.' sub '_al_keep_mat.aff12.1D)'];
        nm = 'res_accuracy_minus_chance';
        cmd = ['3dNwarpApply -nwarp ' ['"' nw '"'] ' -source ' nm  '+orig -master ../../../anatQQ.' sub '+tlrc -prefix ' nm];
        unix(cmd);
    end
end
