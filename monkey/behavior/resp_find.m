function separated = resp_find(trials)
ntrial = size(trials,1);
nchan = size(trials,3);
separated = cell(ntrial,4,nchan);
separated(:,1,:) = trials(:,1,:);
separated(:,4,:) = trials(:,4,:);
separated(:,5,:) = trials(:,5,:);
mid = 7000;
for channel_i = 1:nchan
    for trial_i=1:ntrial    
        % find complete respirations in this trial
        for time_i = 1:2
            time = [0 mid + 1];
            % 0:mid or mid+1:mid*2
            trange = time(time_i):(mid-1)+time(time_i);
            on = trials{trial_i,2,channel_i};
            on = on(ismember(on,trange));
            off = trials{trial_i,3,channel_i};
            off = off(ismember(off,trange));
            % find onset and offset pairs
            for i = 1:length(on)
                off_i = find(off>on(i),1,'first');
                if ~isempty(off_i)
                    separated{trial_i, time_i+1, channel_i} = [separated{trial_i, time_i+1, channel_i};[on(i) off(off_i)]];
                end
            end
        end
    end
end
end