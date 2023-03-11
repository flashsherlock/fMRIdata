function [result, response]=exp_blind_practice
% 1*8*12s + 2s = 98s = 49 TRs
% parallel
port = '3EFC';
ioObject = io64;
status = io64(ioObject);
disp(status);
address = hex2dec(port);
io64(ioObject,address,0);
% beep freq
f=400;
scale=1;
% repeat
times=1;
% times
waittime=2;
cuetime=2;
odortime=2;
beep_du = odortime;
jmean=12-odortime-cuetime;
% jitter
jitter = jmean;
% rand according to time
ctime = datestr(now, 30);
tseed = str2num(ctime((end - 5) : end));
rng(tseed);

% fixation
fix_size=18;
fix_thick=3;
% color
fixcolor_black=[0 0 0];
fixcolor_cue=[246 123 0]; % orange
fixcolor_inhale=[0 154 70];  % green

% keys
KbName('UnifyKeyNames');
Key1 = KbName('1!');
Key2 = KbName('2@');
Key3 = KbName('3#');
Key4 = KbName('4$');
Key5 = KbName('5%');
Key6 = KbName('6^');
Key7 = KbName('7&');
escapeKey = KbName('ESCAPE');
triggerKey = KbName('s');

% odor seq
odors=1:8;
odors=repmat(odors,[times 1]);
% jitter
jitters=repmat(jitter',[times/length(jitter) size(odors,2)]);
% only 1 condition currently
rating=ones(times,size(odors,2));
% final seq
seq=[reshape(odors,[],1) reshape(rating,[],1) reshape(jitters,[],1)];
seq=randseq(seq);
seq=seq(:,1:3);

% record
result=zeros(length(seq),10);
result(:,1:3)=seq;
% record all keystrokes
response=cell(length(seq),2);

% load odors
wavedata = cell(1,length(odors));
soundtime = zeros(1,length(odors));
for odor_i = 1: length(odors)
    wavfilename = sprintf('./odor/odor %02d.wav', odor_i);
    [y, freq] = psychwavread(wavfilename);
    wavedata{odor_i} = y';
    % Number of rows == number of channels
    if size(wavedata{odor_i},1) < 2
        % make stero sound
        wavedata{odor_i} = [scale*wavedata{odor_i} ; scale*wavedata{odor_i}];
    end
    % calculate time of sounds
    soundtime(odor_i) = size(wavedata{odor_i},2)/freq;
end

% input
[subject, runnum] = inputsubinfo;
Screen('Preference', 'SkipSyncTests', 1);
AssertOpenGL;
whichscreen=max(Screen('Screens'));
% Perform basic initialization of the sound driver:
InitializePsychSound;
% open sound device
device = [];
pahandle = PsychPortAudio('Open', device, [], 0, freq, 2);
PsychPortAudio('Volume', pahandle, 1);
% beep
beep = MakeBeep(f, beep_du,freq);
beep = [beep; beep];
beep = beep/2;

% colors
black=BlackIndex(whichscreen);
white=WhiteIndex(whichscreen);
gray=round((white+black)*4/5);
backcolor=gray;
% data file
datafile=sprintf('Data%s%s_run%d_%s.mat',filesep,subject{1},runnum,ctime);

% open window
[windowPtr,rect]=Screen('OpenWindow',whichscreen,backcolor);
Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

fixationp1=CenterRect([0 0 fix_thick fix_size],rect);
fixationp2=CenterRect([0 0 fix_size fix_thick],rect);

fps=round(FrameRate(windowPtr));%Screen('NominalFrameRate',windowPtr);
ifi=Screen('GetFlipInterval',windowPtr);
oldPriority=Priority(MaxPriority(windowPtr));
HideCursor;

% start screen
msg=sprintf('Waiting for [s] key to start...');
Screen('FillRect',windowPtr,backcolor);
Screen('DrawText',windowPtr,msg,20,20,black);
Screen('Flip',windowPtr);
% wait for key to start
[touch, ~, keyCode] = KbCheck;
while ~(touch && (keyCode(triggerKey) || keyCode(escapeKey)))
    [touch, ~, keyCode] = KbCheck;
end
% record start time
tic;
zerotime=GetSecs;
% start marker
io64(ioObject,address,15);
% start marker

% wait time
Screen('Flip',windowPtr);

% PsychPortAudio('FillBuffer', pahandle, wavedata{9});
% PsychPortAudio('Start', pahandle, 1, 0, 1);
% PsychPortAudio('Stop', pahandle, 1);  

Screen('Flip',windowPtr,zerotime+waittime);

% after wait marker
io64(ioObject,address,0);

% start
for cyc=1:size(seq,1)
    
    odor=seq(cyc,1);
    
    % black fixation
    Screen('FillRect',windowPtr,fixcolor_black,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_black,fixationp2);
    Screen('Flip',windowPtr);
    
    % odor hint
    starttime = GetSecs;
    PsychPortAudio('FillBuffer', pahandle, wavedata{odor});
    PsychPortAudio('Start', pahandle, 1, 0, 1);
    [~, ~, ~, estStopTime] = PsychPortAudio('Stop', pahandle, 1);    
    % record the start of odor
    result(cyc,4)=starttime-zerotime;
    result(cyc,8)=estStopTime-zerotime;     
    
    % orange fixation
%     Screen('FillRect',windowPtr,fixcolor_cue,fixationp1);
%     Screen('FillRect',windowPtr,fixcolor_cue,fixationp2);    
%     Screen('Flip', windowPtr); 
    
    % odor beep
    PsychPortAudio('FillBuffer', pahandle, beep);
    PsychPortAudio('Start', pahandle, 1, (starttime + cuetime), 1);
    % trial start marker    
    io64(ioObject,address,odor);
    % green fixation
    Screen('FillRect',windowPtr,fixcolor_inhale,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_inhale,fixationp2);
    trialtime = Screen('Flip', windowPtr,estStopTime);
    result(cyc,5)=trialtime-zerotime;
%     PsychPortAudio('FillBuffer', pahandle, wavedata{11});
%     PsychPortAudio('Start', pahandle, 1, (starttime + cuetime - soundtime(11)), 1);
%     [startbeep, ~, ~, estStopTime] = PsychPortAudio('Stop', pahandle, 1);    
%     result(cyc,9)=startbeep-zerotime;
%     result(cyc,10)=estStopTime-zerotime;
    
    % stop and rating
%     PsychPortAudio('FillBuffer', pahandle, wavedata{12});
%     PsychPortAudio('Start', pahandle, 1, (trialtime + odortime  ), 1);
    [stopbeep, ~, ~, estStopTime] = PsychPortAudio('Stop', pahandle, 1);    
    result(cyc,9)=stopbeep-zerotime;
    result(cyc,10)=estStopTime-zerotime;
    
    % trial stop marker
    io64(ioObject,address,0);
    
    % black fix
    Screen('FillRect',windowPtr,fixcolor_black,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_black,fixationp2);
    Screen('Flip',windowPtr);
    % lastsecs=0;
    while GetSecs-starttime < (cuetime+odortime+seq(cyc,3))
        [touch, secs, keyCode] = KbCheck;
        ifkey=[keyCode(Key1) keyCode(Key2) keyCode(Key3) keyCode(Key4)];
        if touch && ismember(1,ifkey)  %&& secs-lastsecs>0.2
                    result(cyc,6)=find(ifkey==1, 1, 'last');
                    result(cyc,7)=secs-trialtime;
                    response{cyc,1}=[response{cyc,1} result(cyc,6)];
                    response{cyc,2}=[response{cyc,2} result(cyc,7)];
                    % show the response
                    Screen('TextSize', windowPtr, 32);
                    [norm,~]=Screen('TextBounds', windowPtr, num2str(result(cyc,6)));
                    count=CenterRect(norm,rect);
                    Screen('DrawText', windowPtr, num2str(result(cyc,6)),count(1),count(2),0);
                    Screen('Flip', windowPtr);
                    % lastsecs=secs;
        elseif touch && keyCode(escapeKey)
            Screen('CloseAll');
            % Stop playback:
            PsychPortAudio('Stop', pahandle);
            % Close the audio device:
            PsychPortAudio('Close', pahandle);
            save(datafile,'result','response');
            return
        end
    end
    
end

toc;
%save
save(datafile,'result','response');

% PsychPortAudio('FillBuffer', pahandle, wavedata{10});
% PsychPortAudio('Start', pahandle, 1, 0, 1);
% PsychPortAudio('Stop', pahandle);

% restore
Priority(oldPriority);
ShowCursor;
% Close the audio device:
PsychPortAudio('Close', pahandle);
Screen('CloseAll');

end

% function to imput exp information
function [subject,runnum] = inputsubinfo
prompt={'Subject No.'};
name='Experimental Information';
numlines=1;
defaultanswer={'s99'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
subject=answer(1);
runnum=0;
end

function rseq = randseq( seq )
%randseq Generate random sequence for experiment
odors= unique(seq(:,1));
while 1
    rseq=sortrows([seq(:,1:3) randperm(length(seq))'],4);

    % exclude same odors in consecutive 2 trials
    if ~ismember(0,rseq(2:end,1)-rseq(1:end-1,1)) 
%             for i=1:length(odors)
%                 % for each odor condition
%                 l=length(rseq(rseq(:,1)==odors(i),2));
%                 % ratings for valence and intensity are interleaved
%                 rseq(rseq(:,1)==odors(i),2)=repmat(randperm(2)',l/2,1);                
%             end
        break
    end
end
end
