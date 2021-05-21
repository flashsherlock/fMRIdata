function odors_feedback(offcenter_x, offcenter_y)
% ROIsLocalizer(offcenter_x, offcenter_y), [LO, FFA, and EBA]
% Scan = 390s, TR = 3s, 130TR
times=8;% even number
% times
waittime=6;
cuetime=1.5;
odortime=2;
offset=1;
blanktime=0.5;
ratetime=4.5;
feedbacktime=1;
jmean=12-ratetime-blanktime-odortime-cuetime;
% jitter
if ~mod(times/2,2)
    jitter=jmean-(times/4-0.5):jmean+(times/4-0.5);   
else
    jitter=jmean-floor(times/4):jmean+floor(times/4);
end

% fixation
fix_size=18;
fix_thick=3;
fixcolor_back=[0 0 0];
fixcolor_cue=[246 123 0]; %[211 82 48];
fixcolor_inhale=[0 154 70];  %[0 0 240];

% port
port='COM4';
% keys
KbName('UnifyKeyNames');
Key1 = KbName('1!');
Key2 = KbName('2@');
Key3 = KbName('3#');
Key4 = KbName('4$');
Key5 = KbName('6^');
Key6 = KbName('7&');
Key7 = KbName('8*');
Key8 = KbName('9(');
escapeKey = KbName('ESCAPE');
triggerKey = KbName('s');

% rating instruction
imageSizex=100;
imageSizey=75;
StimSize=[0 0 imageSizex imageSizey];
feedbackSizex=75;
feedbackSizey=75;
StimSizef=[0 0 feedbackSizex feedbackSizey];
% block config
% odor seq
odors=[7 8 9 10];
air=0;
odors=repmat(odors,[times 1]);
% rating 1 valence 2 intensity
rating=[ones(times/2,size(odors,2));ones(times/2,size(odors,2))*2];
% jitter
jitter=repmat(jitter',[2 size(odors,2)]);

% final seq
seq=[reshape(odors,[],1) reshape(rating,[],1) reshape(jitter,[],1)];
seq=randseq(seq);
seq=seq(:,1:3);

% record
result=zeros(length(seq),7);
result(:,1:3)=seq;
% record all keystrokes
response=cell(length(seq),2);

% input
[subject, runnum] = inputsubinfo;
Screen('Preference', 'SkipSyncTests', 1);
if nargin < 2
    offcenter_x=0; offcenter_y=-150;
end

AssertOpenGL;
whichscreen=max(Screen('Screens'));
% backup resolution
oldResolution=Screen('Resolution', whichscreen);
Screen('Resolution', whichscreen, 800, 600);

% ettport
delete(instrfindall('Type','serial'));
ettport=ett('init',port);


%每次重启matlab时的随机种子都是相同的，所以随机数是一样的
%所以通过系统时间设置随机数的种子
ctime = datestr(now, 30);
tseed = str2num(ctime((end - 5) : end));
rng(tseed);

% colors
black=BlackIndex(whichscreen);
white=WhiteIndex(whichscreen);
gray=round((white+black)*4/5);
backcolor=gray;

datafile=sprintf('Data%s%s_feedback%s.mat',filesep,subject,datestr(now,30));

[windowPtr,rect]=Screen('OpenWindow',whichscreen,backcolor);
Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
StimRect=OffsetRect(CenterRect(StimSize,rect),offcenter_x,offcenter_y);
StimRectf=OffsetRect(CenterRect(StimSizef,rect),offcenter_x,offcenter_y+50);

fixationp1=OffsetRect(CenterRect([0 0 fix_thick fix_size],rect),offcenter_x,offcenter_y);
fixationp2=OffsetRect(CenterRect([0 0 fix_size fix_thick],rect),offcenter_x,offcenter_y);

fps=round(FrameRate(windowPtr));%Screen('NominalFrameRate',windowPtr);
ifi=Screen('GetFlipInterval',windowPtr);
oldPriority=Priority(MaxPriority(windowPtr));
% load pictures
cd ins
for i=1:7
    feedback(i)=Screen('MakeTexture', windowPtr, imread([num2str(i) '.bmp']));    
end
ins(1)=Screen('MakeTexture', windowPtr, imread('valence.bmp'));
ins(2)=Screen('MakeTexture', windowPtr, imread('intensity.bmp'));
cd ..
HideCursor;
ListenChar(2);      %关闭Matlab自带键盘监听
ett('set',ettport,air); 
% start screen
msg=sprintf('Waiting for the trigger to start...');
errinfo=ShowInstructionSE_UMNVAL(windowPtr, rect, msg, triggerKey, backcolor, white);
    if errinfo==1
		Screen('CloseAll');
        return
    end

tic;
zerotime=GetSecs;

% start
Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
Screen('Flip',windowPtr);

% wait time
WaitSecs(waittime);

for cyc=1:length(seq)
    
    odor=seq(cyc,1);
    
    % hint
    Screen('FillRect',windowPtr,fixcolor_cue,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_cue,fixationp2);
    vbl=Screen('Flip',windowPtr);
    starttime=GetSecs;
    result(cyc,4)=starttime-zerotime;
    
    % open
    WaitSecs(cuetime-offset);
    ett('set',ettport,odor);
    
    % offset
    % WaitSecs(offset);
    
    % inhale
    Screen('FillRect',windowPtr,fixcolor_inhale,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_inhale,fixationp2);
    vbl=Screen('Flip', windowPtr, vbl + (fps*cuetime-0.1)*ifi);
    trialtime=GetSecs;
    result(cyc,5)=trialtime-zerotime;
    
    % close 
    WaitSecs(odortime-offset);
    ett('set',ettport,air);    

    % offset
    WaitSecs(offset);
    
    % blank screen
    Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
    Screen('Flip', windowPtr);
    WaitSecs(blanktime);
    
    % rating    
    Screen('DrawTexture',windowPtr,ins(seq(cyc,2)),[],StimRect);
    vbl=Screen('Flip', windowPtr);

    fbpoint=GetSecs+999;
    while GetSecs-trialtime<(fps*(odortime+blanktime+ratetime)-0.9)*ifi
        if GetSecs-fbpoint>=feedbacktime
            Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
            Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
            Screen('Flip',windowPtr);
        end
        [touch, secs, keyCode] = KbCheck;
        ifkey=[keyCode(Key1) keyCode(Key2) keyCode(Key3) keyCode(Key4)...
             keyCode(Key5) keyCode(Key6) keyCode(Key7)];
        if touch && ismember(1,ifkey)
            if find(ifkey==1,1,'first')~=result(cyc,6)
            result(cyc,6)=find(ifkey==1,1,'first');
            result(cyc,7)=secs-trialtime;
            response{cyc,1}=[response{cyc,1} result(cyc,6)];
            response{cyc,2}=[response{cyc,2} result(cyc,7)];
            Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
            Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
            Screen('DrawTexture',windowPtr,feedback(result(cyc,6)),[],StimRectf);
            Screen('Flip',windowPtr);
            fbpoint=GetSecs;
            end
        elseif touch && keyCode(escapeKey)
            ListenChar(0);      %还原Matlab键盘监听
            Screen('CloseAll');
            save(datafile,'result','response');
            return
        end
    end

    Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
    vbl = Screen('Flip', windowPtr, vbl + (fps*ratetime-0.1)*ifi);

    fbpoint=GetSecs+999;
    while GetSecs-trialtime<odortime+blanktime+ratetime+seq(cyc,3)%jitter
        if GetSecs-fbpoint>=feedbacktime
            Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
            Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
            Screen('Flip',windowPtr);
        end
        [touch, secs, keyCode] = KbCheck;
        ifkey=[keyCode(Key1) keyCode(Key2) keyCode(Key3) keyCode(Key4)...
             keyCode(Key5) keyCode(Key6) keyCode(Key7)];
        if touch && ismember(1,ifkey)
            if find(ifkey==1,1,'first')~=result(cyc,6)
            result(cyc,6)=find(ifkey==1,1,'first');
            result(cyc,7)=secs-trialtime;
            response{cyc,1}=[response{cyc,1} result(cyc,6)];
            response{cyc,2}=[response{cyc,2} result(cyc,7)];
            % feedback
            Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
            Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
            Screen('DrawTexture',windowPtr,feedback(result(cyc,6)),[],StimRectf);
            Screen('Flip',windowPtr);    
            fbpoint=GetSecs;
            end
        elseif touch && keyCode(escapeKey)
            ListenChar(0);      %还原Matlab键盘监听
            Screen('CloseAll');
            save(datafile,'result','response');
            return
        end
    end
    
end

toc;
% restore
Priority(oldPriority);
ShowCursor;
ListenChar(0);      %还原Matlab键盘监听
Screen('CloseAll');
%restore resolution
Screen('Resolution', whichscreen, oldResolution.width, oldResolution.height);
%save
save(datafile,'result','response');
return