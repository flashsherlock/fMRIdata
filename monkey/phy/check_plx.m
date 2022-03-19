root_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/';
% out_dir=[root_dir 'merge2monkey/'];
% if check plx and biopac marker time
check_marker_time = 0;
monkeys={'RM035'};
for monkey_i=1:length(monkeys)
    data_dir=[root_dir lower(monkeys{monkey_i}) '_awa/'];
    pattern=[data_dir '*.plx'];
    plxnames=dir(pattern);
    % filename, number of events, plx_time
    % biop_time, time_range
    results = cell(length(plxnames),6);
    for i = 1:length(plxnames)
        try
            results{i,1} = plxnames(i).name;  
            disp(plxnames(i).name)
            %load data
            plxname = [data_dir plxnames(i).name];
            % save number of events (should be 105)
            [n, ts, sv] = plx_event_ts(plxname, 'Strobed');
            results{i,2} = n;
            if check_marker_time~=0
                % load resp
                respname = strrep(plxname,'.plx','.mat');      
                res_data = load(respname);
                sample_rate=500;
                % check marker time
                marker_time=find(res_data.data(:,2)~=0);
                % number of markers should be even number
                remove=0;
                if mod(length(marker_time),2)
                    marker_time(end)=[];
                    if mean(res_data.data(marker_time,2))
                        error('marker error')
                    else        
                        %0820 testo3 01 unpaired markers in the end
                        ts(end+1:105)=ts(end);
                        remove=1;
                    end
                end
                marker_label=res_data.data(marker_time,2);
                marker_info=[marker_label(1:2:end) reshape(marker_time,2,[])'];
                marker_info_old=marker_info;
                % reshape plx time
                plx_time=reshape(ts,7,[]);
                plx_time=reshape(plx_time(3:6,:),2,[])';
                %0820 testo3 01
                if remove
                   plx_time(end,:)=[]; 
                end
                biop_time=marker_info_old(:,2:3)/sample_rate;
                % range of time difference
                time_range=mean(range(plx_time-biop_time));
                results{i,3} = plx_time;
                results{i,4} = biop_time;
                results{i,5} = time_range;
            end
            % check size_diff
            CON_chan = 'WB64';
            [raw_freq, raw_n, raw_ts, raw_fn, raw_ad] = plx_ad_v(plxname,CON_chan);
            % ad_time=(1:raw_n)/raw_freq;
            size_diff = size(raw_ad,1)-raw_n;
            results{i,6} = size_diff;
        catch
            results{i,2} = 0;
        end
    end
    save([data_dir 'check_time_' monkeys{monkey_i} '.mat'],'results')
end