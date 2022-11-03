% check decoding results
datafolder='/Volumes/WD_F/gufei/7T_odor/';
subs=[4:11,13,14,16:29 31:34];
subnum=length(subs);

odors={'lim','tra','car','cit','ind'};
comb=nchoosek(1:length(odors), 2);
combn=size(comb,1);
decode=[reshape(repmat(subs,combn,1),[],1) repmat([1:combn]',subnum,1)];
rois={'BoxROI'};
shift=[6];
% check = '_VIvaodor_l1_label_';
check = '_ARodor_l1_labelpolandva_';
for i=1:size(decode,1)
    sub=sprintf('S%02d',decode(i,1));
    odornumber=comb(decode(i,2),:);
    labelname1 = odors{odornumber(1)};
    labelname2 = odors{odornumber(2)};
    test=[rois{1} '/' '2odors_' labelname1 '_' labelname2];
    result = [datafolder sub '/' sub '.pabiode.results/mvpa/searchlight' check num2str(shift) '/' test];
    if ~exist([result '/res_accuracy_minus_chance+orig.BRIK'],'file')
        disp([num2str(i) ' ' sub ' ' test]);
    else
        % align results to standard space
%         cd(result);
%         template = ['../../../../anat_final.' sub '.pabiode+tlrc'];
%         cmd = ['@auto_tlrc -apar ' template ' -input res_accuracy_minus_chance+orig'];
%         unix(cmd);
    end
end

% generate commands
CWPath = fileparts(mfilename('fullpath'));
cd(CWPath);
f=fopen('result_avg.bash','w');
fprintf(f,'#! /bin/bash\n\n');
fprintf(f,'# datafolder=/Volumes/WD_E/gufei/7T_odor\n');
fprintf(f,'datafolder=/Volumes/WD_F/gufei/7T_odor\n');
fprintf(f,'cd "${datafolder}" || exit\n\n');
fprintf(f, 'mask=group/mask/allROI+tlrc\n');
fprintf(f, ['stats=' check(2:end-1) '\n']);
% 3dtest++
for con_i=1:combn
    con = [odors{comb(con_i,1)} '-' odors{comb(con_i,2)}];
    fprintf(f, ['3dttest++ -prefix group/mvpa/${stats}_' con ' -mask ${mask} -setA ' con '\\\n']);
    for sub_i=1:subnum
        sub=sprintf('S%02d',subs(sub_i));
        test=[rois{1} '/' '2odors_' odors{comb(con_i,1)} '_' odors{comb(con_i,2)}];
        result = ['./' sub '/' sub '.pabiode.results/mvpa/searchlight' check num2str(shift) '/' test];
        result_tlrc = [result '/res_accuracy_minus_chance+tlrc'];
        fprintf(f, [sprintf('%02d "%s"',sub_i,result_tlrc) ' \\\n']);
    end
end    
fclose(f);