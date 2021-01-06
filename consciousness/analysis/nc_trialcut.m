function data = nc_trialcut( eeg , trl , pretime, posttime)
% cut data to trials according to the matrix trl
% pretime and postime are numbers of timepoints before(-)/after(+)
% trial start and trial end
% default values for pretime and posttime are 0
if nargin < 3
    pretime=0;
end
if nargin < 4
    posttime=0;
end

% create blank cells
trial=cell(1,length(trl));
time=trial;
trialinfo=zeros(length(trl),1);

% according to fieldtrip, offset only controls eeg.time
% start + offset
% trl(:,1)=trl(:,1)+trl(:,3);

% cut trials
for itrial=1:length(trl)
    % get trial star and end index
    start=trl(itrial,1)+pretime;
    stop=trl(itrial,2)+posttime;
    % get offset
    offset=trl(itrial,3);
    % get trial labels
    info=trl(itrial,4);
    % cut
    trial{itrial}=eeg.trial{1}(:,start:stop);
    % compute time points
    time{itrial}=0:1/eeg.fsample:(stop-start)/eeg.fsample;
    time{itrial}=time{itrial}+(offset+pretime)/eeg.fsample;
    % save labels for each trial
    trialinfo(itrial,1)=info;
end

% assign values to data
eeg.trial=trial;
eeg.time=time;
eeg.trialinfo=trialinfo;
data=eeg;
% add sampleinfo, cut point of each trial
data.sampleinfo=trl(:,1:2)+ones(length(trl),2).*[pretime posttime];
end

