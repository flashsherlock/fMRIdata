% load data and calculate correlation with ratings
datafolder = '/Volumes/WD_F/gufei/7T_odor';
subn = [4:11 13 14 16:18 19:29 31:34];
% shifts
shift = [-6 -3 6];
for sub_i = 1%:length(subn)
    sub = sprintf('S%02d', subn(sub_i));
    subfolder = [datafolder '/' sub '/' sub '.pabiode.results/'];
    % load all data
    data = [];
    for shift_i = 1:length(shift)
        time = findtrs(shift(shift_i),'s04',1);                
        Opt.Format = 'vector';
        Opt.Frames=time(:,2);
        BrikName = [subfolder  'allrun.volreg.' sub '.pabiode+orig'];
        [~, data(:,:,shift_i), Info, ~] = BrikLoad (BrikName, Opt);
    end
    % remove baseline
    data = mean(data(:,:,shift>0),3)-mean(data(:,:,shift<=0),3);
    
    % 1-valence 2-intensity
    rate = 1;
    % model RDMs
    mrdm = modelRDMs_7T(subn(sub_i),36);
    
    % ratings
    ratings = time(time(:,4)==rate,5);
    % if contain zeros
    if ~all(ratings)        
        mrating = zeros(5,1);
        for odor_i=1:5
            mrating(odor_i)=mean(time((ratings~=0)&(time(:,1)==odor_i),5));
        end
        % use average value to replace zeros
        ratings(ratings==0)=mrating(time(ratings==0,1));
    end
    % correlation
    rdata = corr(data(:,time(:,4)==rate)',ratings);    
    % write rdata
	InfoOut = Info;
	% modify header
	InfoOut.RootName = ''; %that'll get set by WriteBrik
	InfoOut.DATASET_RANK(2) = 1; %two sub-bricks
    InfoOut.TAXIS_NUMS(1) = 1;
	InfoOut.BRICK_TYPES = [1]; %store data as shorts
	InfoOut.BRICK_STATS = []; %automatically set
	InfoOut.BRICK_FLOAT_FACS = [];%automatically set
	InfoOut.BRICK_LABS = 'Correlation with valence';
	InfoOut.IDCODE_STRING = '';%automatically set
	InfoOut.BRICK_STATAUX = [0 2 3 90 1 1];% correlation for 90 samples	
	OptOut.Scale = 1;
	OptOut.Prefix = [subfolder 'stats_corr'];
	OptOut.verbose = 0;
    % remove existing files
    if exist([OptOut.Prefix '+orig.HEAD'],'file')
        unix(['rm ' OptOut.Prefix '*']);
    end
	[err, ErrMessage, InfoOut] = WriteBrik (rdata, InfoOut, OptOut);
end
