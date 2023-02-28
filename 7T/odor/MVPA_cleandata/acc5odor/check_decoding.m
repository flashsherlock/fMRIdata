%% check decoding results
datafolder='/Volumes/WD_F/gufei/7T_odor/';
subs=[4:11,13,14,16:29 31:34];
subnum=length(subs);
 
odors={'lim','tra','car','cit','ind'};
comb=nchoosek(1:length(odors), 2);
combn=size(comb,1);
decode=[reshape(repmat(subs,combn,1),[],1) repmat([1:combn]',subnum,1)];
rois={'BoxROIext'};
shift=[-6 -3 6];
% check = '_VIvaodor_l1_label_';
% check = '_ARodor_l1_labelpolandva_';
% check = '_ARodor_l1_labelpolva_';
check = '_ARodor_l1_labelbase_';
%% check if decoding finished and normalize to standard space
decode_need = zeros(size(decode,1),1);
for i=1:size(decode,1)
    sub=sprintf('S%02d',decode(i,1));
    odornumber=comb(decode(i,2),:);
    labelname1 = odors{odornumber(1)};
    labelname2 = odors{odornumber(2)};
    test=[rois{1} '/' '2odors_' labelname1 '_' labelname2];
    result = [datafolder sub '/' sub '.pabiode.results/mvpa/searchlight' check strrep(num2str(shift),' ','') '/' test];
    if ~exist([result '/res_accuracy_minus_chance+orig.BRIK'],'file')
        decode_need(i)=1;
        disp([num2str(i) ' ' sub ' ' test]);
    else
        % align results to standard space
        cd(result);
        template = ['../../../../anat_final.' sub '.pabiode+tlrc'];
        cmd = ['@auto_tlrc -apar ' template ' -input res_accuracy_minus_chance+orig'];
        unix(cmd);
    end
end
%% rename folders to remove space
% for subi=1:subnum
%     sub=sprintf('S%02d',subs(subi));
%     new = [datafolder sub '/' sub '.pabiode.results/mvpa/searchlight' check strrep(num2str(shift),' ','')];
%     old = [datafolder sub '/' sub '.pabiode.results/mvpa/searchlight' check num2str(shift)];
%     unix(['mv "' old '" "' new '"'])
% end
%% calculate lim-cit - lim-car
for subi = 1:subnum
    sub = sprintf('S%02d', subs(subi));
    result = [datafolder sub '/' sub '.pabiode.results/mvpa/searchlight' check strrep(num2str(shift), ' ', '') '/' rois{1}];
    % lim-cit
    cit = [result '/2odors_lim_cit/res_accuracy_minus_chance+tlrc'];
    % lim-car
    car = [result '/2odors_lim_car/res_accuracy_minus_chance+tlrc'];
    % lim-cit - lim-car
    cmd = ['3dcalc -a ' cit ' -b ' car ' -expr "a*step(a)-b*step(b)" -prefix ' result ' / citcar'];
    unix(cmd)
    % lim-cit - lim-car normalized by lim-cit + lim-car
    cmd = ['3dcalc -a ' cit ' -b ' car ' -expr "(a*step(a)-b*step(b))/(a*step(a)+b*step(b))" -prefix ' result ' / citcar_norm'];
    unix(cmd)
end
%% generate commands
CWPath = fileparts(mfilename('fullpath'));
cd(CWPath);
f=fopen('result_avg.bash','w');
fprintf(f,'#! /bin/bash\n\n');
fprintf(f,'# datafolder=/Volumes/WD_E/gufei/7T_odor\n');
fprintf(f,'datafolder=/Volumes/WD_F/gufei/7T_odor\n');
fprintf(f,'cd "${datafolder}" || exit\n\n');
fprintf(f, 'mask=group/mask/allROI+tlrc\n');
fprintf(f, '%s',['stats="' check(2:end-1) '_' strrep(num2str(shift),' ','') '"']);
fprintf(f, ['\n' 'statsn="' check(2:end-1) '"' '\n\n']);
% 3dtest++
for con_i=1:combn+2
    if con_i <= combn
        con = [odors{comb(con_i,1)} '-' odors{comb(con_i,2)}];
    elseif con_i == combn+1
        con = 'citcar';
    elseif con_i == combn+2
        con = 'citcar_norm';
    end
    fprintf(f, ['3dttest++ -prefix group/mvpa/${statsn}_' con ' -mask ${mask} -setA ' con ' \\\n']);
    for sub_i=1:subnum
        sub=sprintf('S%02d',subs(sub_i));
        if con_i <= combn
            test=[rois{1} '/' '2odors_' odors{comb(con_i,1)} '_' odors{comb(con_i,2)}];
            result = [sub '/' sub '.pabiode.results/mvpa/searchlight_${stats}/' test];
            result_tlrc = [result '/res_accuracy_minus_chance+tlrc'];
        else
            result = [sub '/' sub '.pabiode.results/mvpa/searchlight_${stats}/' rois{1}];
            result_tlrc = [result '/' con '+tlrc'];
        end
        if sub_i == subnum
            fprintf(f, [sprintf('%02d "%s"',sub_i,result_tlrc) ' \n\n']);
        else
            fprintf(f, [sprintf('%02d "%s"',sub_i,result_tlrc) ' \\\n']);
        end
    end
end    
fclose(f);
unix('bash result_avg.bash');