function odors(offcenter_x, offcenter_y)
% ROIsLocalizer(offcenter_x, offcenter_y), [LO, FFA, and EBA]
% Scan = 382 s, TR = 3 s, 128 TR
times=1;
% times
waittime=3;
odortime=2;
airtime=9;
offset=1.5;

% fixation
fix_size=18;
fix_thick=3;
fixcolor_white=[255 255 255];
fixcolor_orange=[255 165 0];
fixcolor_blue=[0 0 255];

% port
port='COM4';
% keys
KbName('UnifyKeyNames');
Key1 = KbName('1!');
Key2 = KbName('2@');
Key3 = KbName('3#');
Key4 = KbName('4$');
escapeKey = KbName('ESCAPE');
triggerKey = KbName('s');

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
tseed = str2num(ctime((end - 5) : end)) ;
rng(tseed);

% colors
black=BlackIndex(whichscreen);
white=WhiteIndex(whichscreen);
gray=round((white+black)/2);
backcolor=gray;

datafile=sprintf('Data%s%s_run%d%s.mat',filesep,subject,runnum,datestr(now,30));

% block config
odors=[7 8 9 11 0];
seq=zeros(length(odors),times);
for i=1:times
seq(:,i)=odors(randperm(5));
end
seq=reshape(seq,1,[]);

[windowPtr,rect]=Screen('OpenWindow',whichscreen,backcolor);
Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

fixationp1=OffsetRect(CenterRect([0 0 fix_thick fix_size],rect),offcenter_x,offcenter_y);
fixationp2=OffsetRect(CenterRect([0 0 fix_size fix_thick],rect),offcenter_x,offcenter_y);

fps=round(FrameRate(windowPtr));%Screen('NominalFrameRate',windowPtr);
ifi=Screen('GetFlipInterval',windowPtr);
   
HideCursor;
ListenChar(2);      %关闭Matlab自带键盘监听

msg=sprintf('Waiting for the trigger to start...');
errinfo=ShowInstructionSE_UMNVAL(windowPtr, rect, msg, triggerKey, backcolor, white);
    if errinfo==1
		Screen('CloseAll');
        return
    end

oldPriority=Priority(MaxPriority(windowPtr));

tic;
zerotime=GetSecs;
% start
Screen('FillRect',windowPtr,fixcolor_white,fixationp1);
Screen('FillRect',windowPtr,fixcolor_white,fixationp2);
Screen('Flip',windowPtr);

% wait time
WaitSecs(waittime);

result=zeros(length(seq),5);
result(:,1)=seq';

for cyc=1:length(seq)
    
    odor=seq(cyc);
    
    % hint
    Screen('FillRect',windowPtr,fixcolor_orange,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_orange,fixationp2);
    vbl=Screen('Flip',windowPtr);
    starttime=GetSecs-zerotime;
    result(cyc,2)=starttime;
    ett('set',ettport,odor);
    
    % offset-open
    WaitSecs(offset);
    
    % inhale
    Screen('FillRect',windowPtr,fixcolor_blue,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_blue,fixationp2);
    vbl=Screen('Flip',windowPtr);
    trialtime=GetSecs;
    result(cyc,3)=trialtime;
    
    % offset-close 
    WaitSecs(odortime-offset);
    ett('set',ettport,0);    
    
    while GetSecs-trialtime<(fps*odortime-0.9)*ifi
        [touch, secs, keyCode] = KbCheck;
         if touch &&  ~result(cyc,4) && (keyCode(Key1)|| keyCode(Key2))
            if keyCode(Key1)
            result(cyc,4)=1;
            else
            result(cyc,4)=2;    
            end
            result(cyc,5)=secs-trialtime;
        elseif touch && keyCode(escapeKey)
            ListenChar(0);      %还原Matlab键盘监听
            Screen('CloseAll');
            save(datafile,'result');
            return
        end
    end

    Screen('FillRect',windowPtr,fixcolor_white,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_white,fixationp2);
    vbl = Screen('Flip', windowPtr, vbl + (fps*odortime-0.1)*ifi);

    while GetSecs-trialtime<odortime+airtime
        [touch, secs, keyCode] = KbCheck;
        if touch &&  ~result(cyc,4) && (keyCode(Key1)|| keyCode(Key2))
            if keyCode(Key1)
            result(cyc,4)=1;
            else
            result(cyc,4)=2;    
            end
            result(cyc,5)=secs-trialtime;
        elseif touch && keyCode(escapeKey)
            ListenChar(0);      %还原Matlab键盘监听
            Screen('CloseAll');
            save(datafile,'result');
            return
        end
    end

    % wait for about interval
%     difftime=starttime+1+odortime+airtime-GetSecs;
%     if difftime>0
%     WaitSecs(difftime);
%     end
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
save(datafile,'result');
return