% average permutation results
% rois={'OFC_AAL'};
rois={'Amy8_align','OFC_AAL'};
prefix={'face_vis','face_inv','odor_all'};
datafolder='/Volumes/WD_F/gufei/3t_cw/';
nper=1000;
for i = 3:29
    sub=sprintf('S%02d',i);
    for roi_i = 1:length(rois)
        roi = rois{roi_i};
        for con_i = 1:length(prefix)            
            c=prefix{con_i};
            result=zeros(2,2,nper);
            disp([sub ' : ' roi ' : ' c]);
            % load each result
            for suf = 1:nper
                test=[c '_' num2str(suf) '_' roi];
                % Set the output directory where data will be saved, e.g. '/misc/data/mystudy'
                dir = [datafolder sub '/' sub '.de.results/mvpa/roi_roilesionperm_shift6/' test];
                load([dir '/res_confusion_matrix.mat'])
                result(:,:,suf)=results.confusion_matrix.output{1};
            end
            % combine results
            avgmatrix=mean(result,3);
            accs=0.5*(result(1,1,:)+result(2,2,:));
            % save results
            outdir = [datafolder sub '/' sub '.de.results/mvpa/roi_roimeanperm_shift6/' c '_p1_' roi];
            if ~exist(outdir,'dir')
                mkdir(outdir)
            end
            results.confusion_matrix.output{1}=avgmatrix;
            results.roiaccs{1}=accs;
            save([outdir '/res_confusion_matrix.mat'],'results')
        end
    end
end