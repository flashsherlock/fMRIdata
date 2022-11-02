% check decoding results
datafolder='/Volumes/WD_F/gufei/7T_odor/';
decode=[reshape(repmat([4:11,13,14,16:29 31:34],10,1),[],1) repmat([1:10]',28,1)];
odors={'lim','tra','car','cit','ind'};
comb=nchoosek(1:length(odors), 2);
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
        cd(result);
        template = ['../../../../anat_final.' sub '.pabiode+tlrc'];
        cmd = ['@auto_tlrc -apar ' template ' -input res_accuracy_minus_chance+orig'];
        unix(cmd);
    end
end
