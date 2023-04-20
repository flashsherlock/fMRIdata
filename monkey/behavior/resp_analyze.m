ntrial = size(trials_find,1);
separated = [];
% cut respirations
for chan_i=1:size(trials_find,3)
    for trial_i=1:ntrial
        resp = trials_find{trial_i,1,chan_i};
        air_range = trials_find{trial_i,2,chan_i};
        for air_i=1:size(air_range,1)
            data{1}=trials_find{trial_i,4,chan_i};
            % 1-air
            data{2}=1;
            % reverse
            data{3}=size(air_range,1)+1-air_i;            
            data{4}=resp(air_range(air_i,1)+1:air_range(air_i,2)+1);
            data{5}=chan_i;
            separated = [separated;data];
        end
        odor_range = trials_find{trial_i,3,chan_i};
        for air_i=1:size(odor_range,1)
            data{1}=trials_find{trial_i,4,chan_i};
            % 2-odor
            data{2}=2;
            data{3}=air_i;            
            data{4}=resp(odor_range(air_i,1)+1:odor_range(air_i,2)+1);
            data{5}=chan_i;
            separated = [separated;data];
        end
        % analyze AUC,Duration and mean;
        
    end
end