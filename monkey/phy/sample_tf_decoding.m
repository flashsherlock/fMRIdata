function results_odor = sample_tf_decoding(data_pca, condition, roi_con, time, time_win, data_time )
% decode data_pca_tf
    % select condition
    switch condition
        case 'intensity'
            % odor_num is the odor condition number
            odor_num = 2;
            data_pca(:,2) = cellfun(@(x) x(2:3,:,:),data_pca(:,2),'UniformOutput',false);
        otherwise
            odor_num = 5;
            data_pca(:,2) = cellfun(@(x) x(1:5,:,:),data_pca(:,2),'UniformOutput',false);
    end
    % number of odor labels
    nlabel = size(data_pca{1,2},1);
    % combine rois    
    switch roi_con
        case 'All'
            roisdata{1,1} = 'All';
            roisdata{1,2} = cat(1,data_pca{:,2});
        case 'HA'
            roisdata{1,1} = 'HF';
            roisdata{1,2} = cat(1,data_pca{ismember(data_pca(:,1),{'Hi','S'}),2});
            roisdata{2,1} = 'Amy';
            roisdata{1,2} = cat(1,data_pca{~ismember(data_pca(:,1),{'Hi','S'}),2});
        otherwise
            % combine to 7 rois
            roi_focus = {{'CoA'},{'APir','VCo'}; {'BA'}, {'BL','PaL'};{'CeMe'},{'Ce','Me'};...
                {'BM'},{'BM'};{'BL'},{'BL'};{'Hi'},{'Hi'};{'S'},{'S'}};
            roisdata = cell(size(roi_focus,1),2);
            for roi_i=1:size(roisdata,1)
                roisdata(roi_i,1) = roi_focus{roi_i,1};
                roisdata{roi_i,2} = cat(1,data_pca{ismember(data_pca(:,1),roi_focus{roi_i,2}),2});
            end
    end
    roi_num = size(roisdata,1);
    results_odor = cell(roi_num,2+length(time));
    results_odor(:,2)=roisdata(:,1);
    % each roi
    for roi_i=1:roi_num
        results_odor{roi_i,1} = condition;
        tmp = roisdata{roi_i,2};                
        parfor time_i = 1:length(time)
            passed_data = [];
            % select time
            time_range = [time(time_i)-time_win/2 time(time_i)+time_win/2];
            time_idx = dsearchn(data_time',time_range');                
            tmpdata = tmp(:,time_idx(1):time_idx(2),:);   
            % data labels
            odors = kron(ones(size(tmpdata,1)/nlabel,size(tmpdata,2)),(1:nlabel)');
            tlabel = kron(ones(size(tmpdata,1),1),1:size(tmpdata,2));
            roi = kron((1:size(tmpdata,1)/nlabel)',ones(nlabel,size(tmpdata,2)));
            labels = cat(3,odors,tlabel,roi);
            % reshape data
            tmpdata = permute(tmpdata,[2,1,3]);
            tmpdata = reshape(tmpdata,[],size(tmpdata,3));
            % sort data
            labels = reshape(permute(labels,[2,1,3]),[],size(labels,3));
            [labels,I] = sortrows(labels,1);
            passed_data.data = tmpdata(I,:);
            % run decoding
            [results_odor{roi_i,time_i+2},~]=odor_decoding_function(passed_data,odor_num,labels(:,2));
        end
    end
end

