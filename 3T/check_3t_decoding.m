%% check decoding results
datafolder='/Volumes/WD_F/gufei/3T_cw/';
subs=3:29;
subnum=length(subs);
% rois={'BoxROIsext'};
rois={'epi_anat'};
shift=[6];
check = 'odor'; 
check = 'trans';
if strcmp(check,'odor')
    comb={'all'};
elseif strcmp(check,'trans')
    comb={'test_inv';'train_inv'};
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
        % check if aligned
        if ~exist([result '/res_accuracy_minus_chance+tlrc.HEAD'],'file')
            nw = ['../../../anatQQ.' sub '_WARP.nii ../../../anatQQ.' sub '.aff12.1D INV(../../../anatSS.' sub '_al_keep_mat.aff12.1D)'];
            nm = 'res_accuracy_minus_chance';
            cmd = ['3dNwarpApply -nwarp ' ['"' nw '"'] ' -source ' nm  '+orig -master ../../../anatQQ.' sub '+tlrc -prefix ' nm];
            unix(cmd);
        end
        % smooth results
        if ~exist([result '/res_accuracy_minus_chance_sm+tlrc.HEAD'],'file')
            cmd = ['3dmerge -1blur_fwhm 3.6 -doall -prefix ' 'res_accuracy_minus_chance_sm ' 'res_accuracy_minus_chance+tlrc'];
            unix(cmd);
        end
        % if check is trans
        if strcmp(check, 'trans') && decode(i,2)==2
            if ~exist([result '/../res_accuracy_minus_chance_avg+tlrc.HEAD'],'file')
                cmd = ['3dcalc -a res_accuracy_minus_chance+tlrc -b ../test_inv_epi_anat/res_accuracy_minus_chance+tlrc -expr ''(a+b)/2'' -prefix ../res_accuracy_minus_chance_avg'];
                unix(cmd);
            end
            % smooth results
            if ~exist([result '/../res_accuracy_minus_chance_avgsm+tlrc.HEAD'],'file')
                cmd = ['3dcalc -a res_accuracy_minus_chance_sm+tlrc -b ../test_inv_epi_anat/res_accuracy_minus_chance_sm+tlrc -expr ''(a+b)/2'' -prefix ../res_accuracy_minus_chance_avgsm'];
                unix(cmd);
            end
            
        end
    end
end
%% generate commands
CWPath = fileparts(mfilename('fullpath'));
cd(CWPath);
filename=['result_avg3t_' check '.bash'];
f=fopen(filename,'w');
fprintf(f,'#! /bin/bash\n\n');
fprintf(f,'# datafolder=/Volumes/WD_E/gufei/3t_cw\n');
fprintf(f,'datafolder=/Volumes/WD_F/gufei/3t_cw\n');
fprintf(f,'cd "${datafolder}" || exit\n\n');
% fprintf(f, 'mask=group/mask/Amy8_align.freesurfer+tlrc\n');
fprintf(f, 'mask=group/mask/bmask.nii\n');
% whether smooth
fprintf(f, ['sm=' '""' '\n']);
% combine mask and smooth
fprintf(f, 'out=whole${sm}\n');
fprintf(f, '%s',['stats="' check '_shift' strrep(num2str(shift),' ','') '"']);
fprintf(f, ['\n' 'statsn="' check '"' '\n\n']);
% 3dtest++
for con_i=1:combn
    con = comb{con_i};
    outname = ['${statsn}_' con '_${out}4r'];
    fprintf(f, ['3dttest++ -prefix group/mvpa/' outname ' -mask ${mask} -resid group/mvpa/errs_' outname ' -setA ' con ' \\\n']);
    for sub_i=1:subnum
        sub=sprintf('S%02d',subs(sub_i));
        test=[con '_' rois{1}];
        result = [sub '/' sub '.de.results/mvpa/searchlight_${stats}/' test];
        result_tlrc = [result '/res_accuracy_minus_chance' '${sm}' '+tlrc'];
        if sub_i == subnum
            fprintf(f, [sprintf('%02d "%s"',sub_i,result_tlrc) ' \n\n']);
        else
            fprintf(f, [sprintf('%02d "%s"',sub_i,result_tlrc) ' \\\n']);
        end
    end
end    
fclose(f);
% unix(['bash ' filename]);