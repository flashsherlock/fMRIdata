% load data
monkey = 'RM033';
root_dir = '/Volumes/WD_D/gufei/monkey_data/yuanliu/';
data_dir = [root_dir monkey '_spk/'];
pic_dir = [root_dir 'merge2monkey/spk/' monkey '/'];
if ~exist(pic_dir, 'dir')
    mkdir(pic_dir);
end
con='_anaes';
dig='c12'; 
% dates
dates = {'200227'};
for date_i = 1:length(dates)
    cur_date = dates{date_i};
    front = dir([data_dir cur_date '*.plx']);
    fl = strcat(data_dir, front.name);

    % channel unit information
    s_MUA = [38 39 40 41 42 44 45 47 51 54 57 58 60 61 62 63];
    s_SUA = [43 55];
    SUA_MUA = [];
    channellist = [s_MUA, s_SUA, SUA_MUA];
    Spike.Channellabel = cell(length(channellist) + length(SUA_MUA), 3);
    Spike.data = Spike.Channellabel;

    for s = 1:length(channellist)

        if ismember (channellist(s), s_MUA)
            Spike.Channellabel{s, 1} = strcat('SPK', num2str(channellist(s)));
            Spike.Channellabel{s, 2} = 'MUA';
            Spike.Channellabel{s, 3} = 1;
        elseif ismember (channellist(s), s_SUA)
            Spike.Channellabel{s, 1} = strcat('SPK', num2str(channellist(s)));
            Spike.Channellabel{s, 2} = 'SUA';
            Spike.Channellabel{s, 3} = 1;
        end

    end

    ind = length(s_MUA) + length(s_SUA) + 1;

    for ss = 1:length(SUA_MUA)
        Spike.Channellabel{ind, 1} = strcat('SPK', num2str(SUA_MUA(ss)));
        Spike.Channellabel{ind, 2} = 'SUA';
        Spike.Channellabel{ind, 3} = 1;
        Spike.Channellabel{ind + 1, 1} = strcat('SPK', num2str(SUA_MUA(ss)));
        Spike.Channellabel{ind + 1, 2} = 'MUA';
        Spike.Channellabel{ind + 1, 3} = 2;
        ind = ind + 2;
    end

    % use plx_event_ts to load events
    [n, ts, sv] = plx_event_ts(fl, 'Strobed');
    
    % reshape ts to check time alignment
    % plx_timets=reshape(ts,7,[]);
    % plx_timets=reshape(plx_timets(3:6,:),2,[])';
    
    % start and stop time for each test
    [~,start] = plx_event_ts(fl, 'Start');
    [n_file,stop] = plx_event_ts(fl, 'Stop');
    duration_spk = stop - start;
    
    % read spike time(plx,s),0-unsorted unit , 1-unit a
    for chan = 1:length(Spike.Channellabel)
        unit = Spike.Channellabel{chan, 3};
        % plx_spike_info(fl)
        [nspk, tspk] = plx_ts(fl, Spike.Channellabel{chan, 1}, unit);
        Spike.data{chan, 1} = tspk';
    end

    %plxtime for 4 tests
    plxtime = zeros(4, 1);
    bioresp = cell(4, 1);
    valid_res_time = cell(6, 4);
    odor_time = cell(6, 4);

    for test = 1:4
        % get odor time and durations of each file
        resplace = [root_dir lower(monkey) '_ane/'];
        resname = [cur_date '_testo' num2str(test) '_' lower(monkey) '_1'];
        front_res = strcat(resplace, resname);
        [valid_res_time(:,test), resp_points, odor_time(:, test), bioresp{test}] = find_resp_time(front_res);
        plx = strcat(front_res, '.plx');
        [~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, plxtime(test), ~] = plx_information(plx);
    end
    % check duration
    if any(abs(plxtime - duration_spk)>0.1)
        error('Duration mismatch');
    end
    % save bioresp
    Spike.bioresp = bioresp;

    % 5air+5odor
    sorted_res = cell(10, 4);

    for test = 1:4
        for airr = 1:5
            for rpt = 1:length(odor_time{airr, test})
                
                start = odor_time{airr, test}(rpt, 1) - 13;% TODO: may not accurate
                endin = odor_time{airr, test}(rpt, 1);
                % TODO: simplify
                for air_res = 1:length(valid_res_time{6, test})
                    % only select resp before odor delivery
                    if valid_res_time{6, test}(air_res, 1) > start && ...
                            valid_res_time{6, test}(air_res, 3) < endin
                        sorted_res{airr, test}(end + 1, 1) = valid_res_time{6, test}(air_res, 1);
                        sorted_res{airr, test}(end, 2) = valid_res_time{6, test}(air_res, 2);
                        sorted_res{airr, test}(end, 3) = valid_res_time{6, test}(air_res, 3);
                    end
                end
            end
            % 1-5 air 6-10 odor
            sorted_res{airr + 5, test} = valid_res_time{airr, test};
        end
    end

    % resp time plus plxtime duration
    real_sorted_res = sorted_res;
    for test = 2:4
        % add duration to each time
        for od = 1:10
            real_sorted_res{od, test} = sum(plxtime(1:test-1)) + sorted_res{od, test};
        end
    end

    % TODO: simplify
    % combine 4 tests
    Spike.wi = cell(10, 2);
    for od = 1:10
        Spike.wi{od, 1} = od;
        Spike.wi{od, 2} = cat(1,real_sorted_res{od, 1:end});
    end

    % change order and marker
    Spike.or_wi = cell(10, 3);
    for od = 1:5
        % air label 61-65
        Spike.or_wi{(2 * od - 1), 1} = od + 60;
        Spike.or_wi{(2 * od - 1), 2} = Spike.wi{od, 2};
        % 3 respiration time minus start
        start = Spike.wi{od, 2}(:, 1);
        Spike.or_wi{2 * od-1, 3} = Spike.wi{od, 2} - start;
        % odor label 1-5
        Spike.or_wi{2 * od, 1} = od;
        Spike.or_wi{2 * od, 2} = Spike.wi{od + 5, 2};
        start = Spike.wi{od + 5, 2}(:, 1);
        Spike.or_wi{2 * od, 3} = Spike.wi{od + 5, 2} - start;
    end

    % select spike by resp, to unit2
    valid_res_spike = cell(10, 2);    
    for unit = 1:length(Spike.data)
        % spike data
        tspk = Spike.data{unit, 1};
        for od = 1:10
            % label
            valid_res_spike{od, 1} = Spike.or_wi{od, 1};
            trl = length(Spike.or_wi{od, 2});
            valid_res_spike{od, 2} = zeros(trl, 50); % TODO: ?can not exceed 50

            for l = 1:length(Spike.or_wi{od, 2})
                ref = Spike.or_wi{od, 2}(l, 1);
                half = Spike.or_wi{of, 3}(l, 2);
                post = Spike.or_wi{od, 2}(l, 3);
                % spike time relative to the start of inhalation
                spikenumber = length(tspk(tspk >= ref & tspk <= post));
                valid_res_spike{od, 2}(l, 1:spikenumber) = tspk(tspk >= ref & tspk <= post) - ref;
            end
        end
        Spike.data{unit, 2} = valid_res_spike;
    end

    % change time to phase, unit3
    for unit = 1:length(Spike.data)
        Spiketheta = cell(10, 2);
        resspk = Spike.data{unit, 2};
        for of = 1:10            
            for trl = 1:length(Spike.or_wi{of, 2})                
                half = Spike.or_wi{of, 3}(trl, 2);
                ending = Spike.or_wi{of, 3}(trl, 3);
                for n = 1:50                    
                    if resspk{of, 2}(trl, n) <= half
                        % [0,1]
                        Spiketheta{of, 2}(trl, n) = resspk{of, 2}(trl, n) ./ half;
                    elseif resspk{of, 2}(trl, n) > half
                        % (1,2]
                        Spiketheta{of, 2}(trl, n) = (resspk{of, 2}(trl, n) - half) ./ ...
                            (ending - half) + 1;
                    end
                end
            end
        end
        Spike.data{unit, 3} = Spiketheta;
    end

    % 10° bin
    thetabin = linspace(0, 2, 37);
    bin_number = 36;
    count = cell(10, 1);

    for unit = 1:length(Spike.data)

        for od = 1:10

            for trl = 1:size((Spike.data{unit, 3}{od, 2}), 1)
                spks = Spike.data{unit, 3}{od, 2}(trl, 1:end);
                number = [];

                for nu = 1:bin_number
                    number(nu) = length(spks(spks > thetabin(nu) & spks <= thetabin(nu + 1)));
                    count{od, 1}{trl, 1} = number;
                end

            end

        end
        Spike.count{unit, 1} = count;
    end

    % calculate spike rate by time window
    for unit = 1:length(Spike.count)

        for of = 1:10

            for trl = 1:length(Spike.count{unit, 1}{of, 1})
                half_bin = Spike.or_wi{of, 3}(trl, 2) / 18;
                ending_bin = Spike.or_wi{of, 3}(trl, 3) / 18 - half_bin;
                Spike.rate{unit, 1}{of, 1}{trl, 1}(1, 1:18) = Spike.count{unit, 1}{of, 1}{trl, 1}(1, 1:18) / half_bin;
                Spike.rate{unit, 1}{of, 1}{trl, 1}(1, 19:36) = Spike.count{unit, 1}{of, 1}{trl, 1}(1, 19:36) / ending_bin;
            end
        end
    end

    % reorganize to matrix
    for unit = 1:length(Spike.rate)

        for o = 1:10
            Spike.rate{unit, 2}{o, 1} = cell2mat(Spike.rate{unit, 1}{o, 1});
        end

    end

    % delete zeros, unit4
    for unit = 1:size((Spike.data), 1)

        for ip = 1:10
            % TODO: at least 3 spikes? may cause error?
            select = Spike.data{unit, 3}{ip, 2}(:, 3) > 0;
            Spike.data{unit, 4}{ip, 2} = Spike.data{unit, 3}{ip, 2}(select, :);            
            Spike.rate{unit, 3}{ip, 1} = Spike.rate{unit, 2}{ip, 1}(select, :);
        end

    end

    % unit5 randomly select samples according to unit 4
    % make odor and air befor equal
    for unit = 1:length(Spike.data)

        for oi = 1:5
            air_trl = size(Spike.data{unit, 4}{2 * oi - 1, 2}, 1);
            ord_trl = size(Spike.data{unit, 4}{2 * oi, 2}, 1);
            minm = min(air_trl, ord_trl);
            Spike.data{unit, 5}{2 * oi - 1, 1} = minm;
            Spike.data{unit, 5}{2 * oi, 1} = minm;
            air_row = 1:air_trl;
            ord_row = 1:ord_trl;
            Spike.data{unit, 5}{2 * oi - 1, 2} = Spike.data{unit, 4}{2 * oi - 1, 2}(air_row(randperm(air_trl, minm)), :);
            Spike.data{unit, 5}{2 * oi, 2} = Spike.data{unit, 4}{2 * oi, 2}(ord_row(randperm(ord_trl, minm)), :);
            %rate
            Spike.rate{unit, 4}{2 * oi - 1, 1} = minm;
            Spike.rate{unit, 4}{2 * oi, 1} = minm;
            Spike.rate{unit, 4}{2 * oi - 1, 2} = Spike.rate{unit, 3}{2 * oi - 1, 1}(air_row(randperm(air_trl, minm)), :);
            Spike.rate{unit, 4}{2 * oi, 2} = Spike.rate{unit, 3}{2 * oi, 1}(ord_row(randperm(ord_trl, minm)), :);

        end
    end

    % sum bins (use rate4, not sampled), calculate ntrial, smooth
    Spike.add = cell(size((Spike.rate), 1), 1);

    for unit = 1:size((Spike.rate), 1)

        for of = 1:10
            Spike.add{unit, 1}{of, 1} = Spike.rate{unit, 4}{of, 1};
            Spike.add{unit, 1}{of, 2} = sum(Spike.rate{unit, 4}{of, 2}) ./ Spike.add{unit, 1}{of, 1};
            % Spike.add{unit, 1}{of, 3} = smoothdata(Spike.add{unit, 1}{of, 2}, 'gaussian', 4);
            % TODO: find smoothdata function
            Spike.add{unit, 1}{of, 3} = smooth(Spike.add{unit, 1}{of, 2}, 4);
        end

    end

    % F1/F0
    % TODO: what is f
    Spike.FF = cell(size((Spike.data), 1), 1);

    for unit = 1:size((Spike.data), 1)

        for of = 1:10
            ft = fft(Spike.add{unit, 1}{of, 3});
            f0 = abs(ft(1));
            f1 = abs(ft(2));
            f = f1 / f0;
            Spike.FF{unit, 1}{of, 1} = f;
        end

    end

    % get non zero values from data5, multiply pi
    % for radar plot based on spike numbers
    for unit = 1:size((Spike.data), 1)
        cat_spk = [];

        for od = 1:10
            spk_size = size(Spike.data{unit, 5}{od, 2}, 1) * size(Spike.data{unit, 5}{od, 2}, 2);
            cat_spk = reshape(Spike.data{unit, 5}{od, 2}, 1, spk_size);
            cat_spk(cat_spk == 0) = [];
            Spike.data{unit, 6}{od, 2} = cat_spk .* pi;
        end

    end

    % phase use Spike.data{unit, 5}
    thetabin = linspace(0, 2, 37);
    bin_number = 36;
    count = cell(10, 1);

    for unit = 1:size((Spike.data), 1)
        for od = 1:10
            for trl = 1:size((Spike.data{unit, 5}{od, 2}), 1)
                spks = Spike.data{unit, 5}{od, 2}(trl, 1:end);
                number = [];
                for nu = 1:bin_number
                    number(nu) = length(spks(spks > thetabin(nu) & spks < thetabin(nu + 1)));
                    count{od, 1}{trl, 1} = number;
                end
            end
        end
        Spike.count{unit, 2} = count;
    end

    % circular analysis, count{unit,4}{of,3}
    % TODO: ori?
    th = linspace(0, 35/18 * pi, 36);
    ori = circ_axial(circ_ang2rad(th), 2);
    dori = diff(ori(1:2));

    for unit = 1:size((Spike.count), 1)

        for of = 1:10
            Spike.count{unit, 3}{of, 1} = cell2mat(Spike.count{unit, 2}{of, 1});
            Spike.count{unit, 4}{of, 2} = sum(Spike.count{unit, 3}{of, 1});
            Spike.count{unit, 4}{of, 1} = sum(Spike.count{unit, 4}{of, 2});

            for s = 1:36
                Spike.count{unit, 4}{of, 3}(1, s) = exp(1i * th(s)) * (Spike.count{unit, 4}{of, 2}(1, s));
            end

            Spike.count{unit, 4}{of, 4} = abs(sum(Spike.count{unit, 4}{of, 3}, 2)) / ...
                Spike.count{unit, 4}{of, 1};
            %circular mean angle,Spike.count{unit,4}{of,5}
            spkk = Spike.count{unit, 4}{of, 2};
            Spike.count{unit, 4}{of, 5} = circ_mean(ori, spkk, 2);
            % circular variance,
            Spike.count{unit, 4}{of, 6} = circ_var(ori, spkk, dori, 2);
        end
    end

    %% plot settings
    %linewidth
    colors = {'#777DDD', '#69b4d9', '#149ade', '#41AB5D', '#ECB556', '#000000', '#E12A3C', '#777DDD', '#41AB5D'};
    lw = cell(1, 7);
    %linestyle
    ls = lw;

    for i = 1:9

        if i <= 5
            lw{i} = 1.5;

            if i <= 3
                ls{i} = '-.';
            else
                ls{i} = ':';
            end

        else
            lw{i} = 2;
            ls{i} = '-';
        end

    end

    %% plots
    % hist plots
    for unit = 1:length(Spike.add)
        unitname = strcat(Spike.Channellabel(unit, 1), Spike.Channellabel(unit, 2));
        picturename = strcat(monkey, con, '_', cur_date, dig, '-', unitname);
        histname = strcat(picturename, '_', 'hist');
        histname = histname{1, 1};
        figure('position', [20, 10, 800, 1200]);

        for of = 1:10
            subplot(5, 2, of);
            x = linspace(10, 360, 36);
            y = Spike.add{unit, 1}{of, 2};
            ymax = max(y) + 5;

            bar(x, y); hold on
            plot(x, Spike.add{unit, 1}{of, 3}, 'k', 'LineWidth', 2);
            xlabel('Phase(°) ');
            trialnumber = num2str(Spike.data{unit, 5}{of, 1});
            ylabel('Firing Rate (spk/s)');
            ylim([0, ymax]);
            c = mod(of, 2);

            if c == 0
                title(['odor' ' ' num2str(of / 2) '  ' 'n= ' trialnumber])
            else
                title(['air' '  n= ' trialnumber])
            end

        end

        saveas(gcf, [pic_dir histname], 'pdf')
        close all
    end

    % radar
    for unit = 1:length(Spike.data)
        unitname = strcat(Spike.Channellabel(unit, 1), Spike.Channellabel(unit, 2));
        picturename = strcat(monkey, con, '_', cur_date, dig, '-', unitname);
        polarhistname = strcat(picturename, '_', 'polarhist');
        polarhistname = polarhistname{1, 1};
        figure('position', [20, 10, 800, 1200]);

        for of = 1:10
            subplot(5, 2, of);
            theta = Spike.data{unit, 6}{of, 2};
            polarhistogram(theta, 36); 
            hold on
            c = mod(of, 2);
            if c == 0
                title(['odor' ' ' num2str(of / 2)])
            else
                title(['air'])
            end

        end

        saveas(gcf, [pic_dir polarhistname], 'pdf')
        close all
    end

    % line
    for unit = 1:size((Spike.data), 1)
        unitname = strcat(Spike.Channellabel(unit, 1), Spike.Channellabel(unit, 2));
        picturename = strcat(monkey, con, '_', cur_date, dig, '-', unitname);
        comparename = strcat(picturename, '_', 'compare');
        comparename = comparename{1, 1};
        figure('position', [20, 10, 800, 800]);

        for of = 1:5

            subplot(5, 1, of);
            x = linspace(0, 350, 36);
            ymax = max(Spike.add{unit, 1}{2 * of - 1, 3}) + 2;
            plot(x, Spike.add{unit, 1}{2 * of - 1, 3}, 'LineStyle', ls{6}, 'Color', hex2rgb(colors{6}), 'LineWidth', lw{6}); hold on %空气
            plot(x, Spike.add{unit, 1}{2 * of, 3}, 'LineStyle', ls{of}, 'Color', hex2rgb(colors{of}), 'LineWidth', lw{of});
            set(gca, 'XTick', [0, 90, 180, 270, 350])
            xlabel('Phase(°)');
            ylabel('Firing Rate (spk/s)');
            ylim([0, ymax]);
        end

        saveas(gcf, [pic_dir comparename], 'pdf')
        close all
    end

    % TODO: error in U(of) = sum(U)
    for unit = 1:size((Spike.add), 1)
        unitname = strcat(Spike.Channellabel(unit, 1), Spike.Channellabel(unit, 2));
        picturename = strcat(monkey, con, '_', cur_date, dig, '-', unitname);
        arrow = strcat(picturename, '_', 'arrow');
        arrow = arrow{1, 1};
        figure('position', [20, 10, 800, 1200]);

        for of = 1:10
            subplot(5, 2, of);
            th = linspace(0, pi * 35/18, 36);
            r = Spike.add{unit, 1}{of, 3};
            [U, V] = pol2cart(th, r);
            U(of) = sum(U);
            V(of) = sum(V);
            c (of) = compass(U(of), V(of));

            c = mod(of, 2);

            if c == 0
                title(['odor' ' ' num2str(of / 2)])
            else
                title(['air'])

            end

            %circular mean angle,Spike.FF{of,2}
            thi = linspace(0, 350, 36);
            ori = circ_axial(circ_ang2rad(thi), 2);
            dori = diff(ori(1:2));
            spk = Spike.add{unit, 1}{of, 3};
            Spike.FF{unit, 1}{of, 2} = circ_mean(ori, spk, 2);
            % circular variance
            Spike.FF{unit, 1}{of, 3} = circ_var(ori, spk, dori, 2);
        end

        saveas(gcf, [pic_dir arrow], 'pdf')
        close all
    end

    %6 results,n-PLV,n-angle,n-cv,r-F1/F0,r-angle,r-cv
    for unit = 1:size((Spike.count), 1)

        for of = 1:10
            Spike.result{unit, 1}{of, 1} = Spike.count{unit, 4}{of, 4};
            Spike.result{unit, 1}{of, 2} = Spike.count{unit, 4}{of, 5};
            Spike.result{unit, 1}{of, 3} = Spike.count{unit, 4}{of, 6};
            Spike.result{unit, 1}{of, 4} = Spike.FF{unit, 1}{of, 1};
            Spike.result{unit, 1}{of, 5} = Spike.FF{unit, 1}{of, 2};
            Spike.result{unit, 1}{of, 6} = Spike.FF{unit, 1}{of, 3};

        end

    end

    % tables
    str1 = 'Odors';
    m = 10; w = 6;
    column_name = {'Air1', 'Indole1', 'Air2', 'ISO_L2', ...
                'Air3', 'ISO_H3', 'Air4', 'Peach4', 'Air5', 'Banana5'};
    row_name = {'n-PLV', 'n-angle', 'n-cv', 'r-F1/F0', 'r-angle', 'r-cv'};

    for unit = 1:size((Spike.result), 1)
        figure('position', [20, 10, 800, 800]);
        Data = Spike.result{unit, 1}';
        unitname = strcat(Spike.Channellabel(unit, 1), Spike.Channellabel(unit, 2));
        picturename = strcat(monkey, con, '_', cur_date, dig, '-', unitname);
        comtable = strcat(picturename, '_', 'compute-table');
        comtable = comtable{1, 1};

        title(['compute result']);
        h = uitable(gcf, 'Data', Data, 'Position', [90, 600, 640, 128], ...
            'Columnname', column_name, 'Rowname', row_name);
        saveas(gcf, [pic_dir comtable], 'pdf')
        close all
    end

    % save
    save([pic_dir cur_date dig '_rm033_Spikes.mat'], 'Spike');
end
