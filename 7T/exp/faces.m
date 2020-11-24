function faces(offcenter_x, offcenter_y)
% ROIsLocalizer(offcenter_x, offcenter_y), [LO, FFA, and EBA]
% Scan = 382 s, TR = 3 s, 128 TR
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

black=BlackIndex(whichscreen);
white=WhiteIndex(whichscreen);
gray=round((white+black)/2);
backcolor=gray;
fixcolor=[255 255 255];
datafile=sprintf('Data%s%s_run%d%s.mat',filesep,subject,runnum,datestr(now,30));
% block config
times=9;
if mod(runnum,2)
    % fear first
    seq=[1 2];
else
    % neutral first
    seq=[2 1];
end
seq=repmat(seq,[1 times]);
% balance
for b=1:3
seq=[seq;fliplr(seq)];
seq=reshape(seq(:,1:times),1,[]);
end
trials=15;
stimtime=0.75;
isi=0.25;
interval=6;
imageSizex=180;
imageSizey=240;
StimSize=[0 0 imageSizex imageSizey];

[windowPtr,rect]=Screen('OpenWindow',whichscreen,backcolor);
Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
StimRect=OffsetRect(CenterRect(StimSize,rect),offcenter_x,offcenter_y);
% fixation
fixationp1=OffsetRect(CenterRect([0 0 3 18],rect),offcenter_x,offcenter_y);
fixationp2=OffsetRect(CenterRect([0 0 18 3],rect),offcenter_x,offcenter_y);
picshift=[-20:20];
fps=round(FrameRate(windowPtr));%Screen('NominalFrameRate',windowPtr);
ifi=Screen('GetFlipInterval',windowPtr);
% load pictures
cd Pic
for i=1:8
fear(i)=Screen('MakeTexture', windowPtr, imread(['f' int2str(i) '.bmp']));
end

for i=1:8
neutral(i)=Screen('MakeTexture', windowPtr, imread(['n' int2str(i) '.bmp']));
end
cd ..

KbName('UnifyKeyNames');
Key1 = KbName('1!');
Key2 = KbName('2@');
Key3 = KbName('3#');
Key4 = KbName('4$');

escapeKey = KbName('ESCAPE');
triggerKey = KbName('s');
    
HideCursor;
ListenChar(2);      %¹Ø±ÕMatlab×Ô´ø¼üÅÌ¼àÌý
% Screen('FillRect',windowPtr,fixcolor,fixationp1);
% Screen('FillRect',windowPtr,fixcolor,fixationp2);
% Screen('Flip', windowPtr);

msg=sprintf('Waiting for the trigger to start...');
errinfo=ShowInstructionSE_UMNVAL(windowPtr, rect, msg, triggerKey, backcolor, white);
    if errinfo==1
		Screen('CloseAll');
        return
    end

oldPriority=Priority(MaxPriority(windowPtr));
% start
Screen('FillRect',windowPtr,fixcolor,fixationp1);
Screen('FillRect',windowPtr,fixcolor,fixationp2);
vbl=Screen('Flip',windowPtr);
% equal to interval
WaitSecs(4);
N=1;
n=1;
con=zeros(4*times+1,2);
result=zeros(trials*times*2,4);
result(:,1)=reshape(repmat(seq,[trials 1]),[],1);

for cyc=seq
    switch cyc
    case {1}
        TestImgs=fear;
        con(N*2,2)=1;
    case {2}
        TestImgs=neutral;
        con(N*2,2)=2;
    end
        starttime=GetSecs;
        con(N*2-1,1)=starttime-con(1,1);
        for i=1:trials
            picture=randsample(length(TestImgs),1);
            result(n,2)=picture;
            DispRect=OffsetRect(StimRect,randsample(picshift,1),randsample(picshift,1));
            Screen('DrawTexture',windowPtr,TestImgs(picture),[],DispRect); %,[],OffsetRect(StimRect,randperm(picshift),randperm(picshift)));
            Screen('FillRect',windowPtr,fixcolor,fixationp1);
            Screen('FillRect',windowPtr,fixcolor,fixationp2);
            vbl=Screen('Flip',windowPtr);
            trialtime=GetSecs;
            while GetSecs-trialtime<(fps*stimtime-0.9)*ifi
                [touch, secs, keyCode] = KbCheck;
                 if touch &&  ~result(n,3) && keyCode(Key1)
                    result(n,3)=1;
                    result(n,4)=secs-trialtime;
                elseif touch && keyCode(escapeKey)
                    ListenChar(0);      %»¹Ô­Matlab¼üÅÌ¼àÌý
                    Screen('CloseAll');
                    save(datafile,'con','result');
                    return
                end
            end
            Screen('FillRect',windowPtr,fixcolor,fixationp1);
            Screen('FillRect',windowPtr,fixcolor,fixationp2);
            vbl = Screen('Flip', windowPtr, vbl + (fps*stimtime-0.1)*ifi);
            % interval            
%             if keyCode(escapeKey)
%             Screen('CloseAll');
%             return
%             end
            while GetSecs-trialtime<stimtime+isi
                [touch, secs, keyCode] = KbCheck;
                if touch &&  ~result(n,3) && keyCode(Key1)
                    result(n,3)=1;
                    result(n,4)=secs-trialtime;
                elseif touch && keyCode(escapeKey)
                    ListenChar(0);      %»¹Ô­Matlab¼üÅÌ¼àÌý
                    Screen('CloseAll');
                    save(datafile,'con','result');
                    return
                end
            end
            n=n+1;
           
        end
        con(N*2,1)=GetSecs-con(1,1);
        % wait for about interval
        difftime=starttime+trials*(stimtime+isi)+interval-GetSecs;
        WaitSecs(difftime);
        N=N+1;
end
% here N=25, so make (49,1)=(48,1)
con(N*2-1,1)=con(N*2-2)+interval;
con(1,1)=0;
con(:,1)=con(:,1)+4;
% restore
Priority(oldPriority);
ShowCursor;
ListenChar(0);      %»¹Ô­Matlab¼üÅÌ¼àÌý
Screen('CloseAll');
%restore resolution
Screen('Resolution', whichscreen, oldResolution.width, oldResolution.height);
%save
save(datafile,'con','result');
return