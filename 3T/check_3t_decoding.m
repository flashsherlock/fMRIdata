%% check decoding results
datafolder='/Volumes/WD_F/gufei/3T_cw/';
subs=3:29;
subnum=length(subs);
rois={'BoxROIext'};
shift=[6];
check = 'odor'; 
if strcmp(check,'odor')
    comb={'all'};
else
    comb={'all';'inv';'vis'};
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
%% generate commands
CWPath = fileparts(mfilename('fullpath'));
cd(CWPath);
f=fopen('result_avg3t.bash','w');
fprintf(f,'#! /bin/bash\n\n');
fprintf(f,'# datafolder=/Volumes/WD_E/gufei/3t_cw\n');
fprintf(f,'datafolder=/Volumes/WD_F/gufei/3t_cw\n');
fprintf(f,'cd "${datafolder}" || exit\n\n');
fprintf(f, 'mask=group/mask/Amy8_align.freesurfer+tlrc\n');
fprintf(f, '%s',['stats="' check '_shift' strrep(num2str(shift),' ','') '"']);
fprintf(f, ['\n' 'statsn="' check '"' '\n\n']);
% 3dtest++
for con_i=1:combn
    con = comb{con_i};
    fprintf(f, ['3dttest++ -prefix group/mvpa/${statsn}_' con ' -mask ${mask} -setA ' con ' \\\n']);
    for sub_i=1:subnum
        sub=sprintf('S%02d',subs(sub_i));
        test=[con '_' rois{1}];
        result = [sub '/' sub '.de.results/mvpa/searchlight_${stats}/' test];
        result_tlrc = [result '/res_accuracy_minus_chance+tlrc'];
        if sub_i == subnum
            fprintf(f, [sprintf('%02d "%s"',sub_i,result_tlrc) ' \n\n']);
        else
            fprintf(f, [sprintf('%02d "%s"',sub_i,result_tlrc) ' \\\n']);
        end
    end
end    
fclose(f);
unix('bash result_avg3t.bash');