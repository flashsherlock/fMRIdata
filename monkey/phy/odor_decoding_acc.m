function [acc, rois, chance]=odor_decoding_acc(results_odor)
%% calculate acc
% row-roi column-repeat
repeat_num = size(results_odor,2);
roi_num = size(results_odor,1);
% return acc and rois
acc=zeros(roi_num,repeat_num);
rois=cell(roi_num,1);
% return chance level
chance=results_odor{1,1}.accuracy_minus_chance.chancelevel;
for roi_i=1:size(results_odor,1)
    % roi label only in the first column
    roi=strsplit(results_odor{roi_i,1}.analysis,'_');
    rois{roi_i}=roi{1};    
    % get acc fron results
    for repeat_i=1:size(results_odor,2)
        % acc minus chance
        acc(roi_i,repeat_i)=results_odor{roi_i,repeat_i}.accuracy_minus_chance.output;
        % true acc
        acc(roi_i,repeat_i)=acc(roi_i,repeat_i)+results_odor{roi_i,repeat_i}.accuracy_minus_chance.chancelevel;
    end
end
end