analysis_all={'pabiode'};
shift=6;
rois={'Amy9_at165','corticalAmy_at165'};
for region=[1 3 5 6 7 8 9 10 15]
    rois=[rois {['Amy_at165' num2str(region) 'seg']}];
end
% S01_yyt
sub='S01_yyt';
decoding_roi_4odors_trial(sub,analysis_all,rois,shift);
decoding_roi_trial(sub,analysis_all,rois,shift);
% S01-S03
for i=1:3
    if i==1
        rois(5)=[];
    end
    sub=sprintf('S%02d',i);
    decoding_roi_4odors_trial(sub,analysis_all,rois,shift);
end

for i=1:3
    if i==1
        rois(5)=[];
    end
    sub=sprintf('S%02d',i);
    decoding_roi_trial(sub,analysis_all,rois,shift);
end
% S01 only has 1 voxel in Amy9_at1656seg and does not have Amy9_at1655seg