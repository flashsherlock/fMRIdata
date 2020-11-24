%% Prepare stimuli
pictime=3;
times=6;
numbers=repmat(1:7,times);
trials=length(numbers);
acc=zeros(trials,3);
for i=1:3
numbers=numbers(randperm(trials));
end
acc(:,3)=numbers';
Screen('Preference', 'SkipSyncTests', 1);

offcenter_x=0;
offcenter_y=0;
AssertOpenGL;
whichscreen=max(Screen('Screens'));
% backup resolution
oldResolution=Screen('Resolution', whichscreen);
Screen('Resolution', whichscreen, 800, 600);

%定义颜色
black=BlackIndex(whichscreen);
white=WhiteIndex(whichscreen);
gray=round((black+white)*4/5);
backcolor=gray;
imageSizex=200;
imageSizey=200;
StimSize=[0 0 imageSizex imageSizey];

% fixation
fix_size=18;
fix_thick=3;
fixcolor_back=[0 0 0];
fixcolor_cue=[246 123 0]; %[211 82 48];
fixcolor_inhale=[0 154 70];  %[0 0 240];

[windowPtr,rect]=Screen('OpenWindow',whichscreen,backcolor);
Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
StimRect=OffsetRect(CenterRect(StimSize,rect),offcenter_x,offcenter_y);
StimRectf=OffsetRect(CenterRect([0 0 240 135],rect),offcenter_x,offcenter_y);
% load pictures
cd ins
for i=1:7
    ins(i)=Screen('MakeTexture', windowPtr, imread([num2str(i) '.bmp']));    
end
ins(8)=Screen('MakeTexture', windowPtr, imread('t.bmp'));
ins(9)=Screen('MakeTexture', windowPtr, imread('f.bmp'));
cd ..
%设定刺激大小
scale=1.6;
scale1=2;%注视点的大小

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

fixationp1=OffsetRect(CenterRect([0 0 fix_thick fix_size],rect),offcenter_x,offcenter_y);
fixationp2=OffsetRect(CenterRect([0 0 fix_size fix_thick],rect),offcenter_x,offcenter_y);

fps=round(FrameRate(windowPtr));%Screen('NominalFrameRate',windowPtr);
ifi=Screen('GetFlipInterval',windowPtr);
oldPriority=Priority(MaxPriority(windowPtr));
HideCursor;
ListenChar(2);      %关闭Matlab自带键盘监听

tic;
zerotime=GetSecs;
Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
vbl=Screen('Flip',windowPtr);
WaitSecs(3);
for cyc=1:trials
    num=numbers(cyc);
    
    Screen('DrawTexture',windowPtr,ins(num),[],StimRect);
    vbl=Screen('Flip',windowPtr);
    
    trialtime=GetSecs;
    while GetSecs-trialtime<(fps*pictime-0.9)*ifi
        [touch, secs, keyCode] = KbCheck;
        ifkey=[keyCode(Key1) keyCode(Key2) keyCode(Key3) keyCode(Key4)...
             keyCode(Key5) keyCode(Key6) keyCode(Key7)];
        if touch && ismember(1,ifkey)
            if find(ifkey==1)==num
                acc(cyc,1)=1;
                acc(cyc,2)=GetSecs-trialtime;
            Screen('DrawTexture',windowPtr,ins(8),[],StimRectf);
            Screen('Flip',windowPtr);
            WaitSecs(0.5);
            break;
%             Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
%             Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
%             Screen('Flip',windowPtr);
            else
            Screen('DrawTexture',windowPtr,ins(9),[],StimRectf);
            Screen('Flip',windowPtr);
            WaitSecs(0.5);
            break;
%             Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
%             Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
%             Screen('Flip',windowPtr);    
            end
        elseif touch && keyCode(escapeKey)
            ListenChar(0);      %还原Matlab键盘监听
            Screen('CloseAll');
            return
        end
    end
    
    if touch && ismember(1,ifkey)
    Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
    vbl = Screen('Flip', windowPtr);
    WaitSecs(1);
    else
    Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
    vbl = Screen('Flip', windowPtr, vbl + (fps*pictime-0.1)*ifi);
    WaitSecs(1);
    end
%     while GetSecs-trialtime<pictime+1
%         [touch, secs, keyCode] = KbCheck;
%         ifkey=[keyCode(Key1) keyCode(Key2) keyCode(Key3) keyCode(Key4)...
%              keyCode(Key5) keyCode(Key6) keyCode(Key7)];
%         if touch && ismember(1,ifkey)
%             if find(ifkey==1)==num
%                 acc(cyc,1)=1;
%                 acc(cyc,2)=GetSecs-trialtime;
%             Screen('DrawTexture',windowPtr,ins(8),[],StimRectf);
%             Screen('Flip',windowPtr);
%             WaitSecs(0.5);
%             Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
%             Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
%             Screen('Flip',windowPtr);
%             else
%             Screen('DrawTexture',windowPtr,ins(9),[],StimRectf);
%             Screen('Flip',windowPtr);
%             WaitSecs(0.5);
%             Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
%             Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
%             Screen('Flip',windowPtr);    
%             end          
%         elseif touch && keyCode(escapeKey)
%             ListenChar(0);      %还原Matlab键盘监听
%             Screen('CloseAll');
%             return
%         end
%     end
end
toc;
result=zeros(8,3);
for i=1:7
    result(i,1)=i;
    result(i,2)=mean(acc(acc(:,3)==i,1));
    result(i,3)=mean(acc(acc(:,3)==i&acc(:,1)==1,2));
end
result(8,2:3)=mean(result(1:7,2:3));

% restore
Priority(oldPriority);
ShowCursor;
ListenChar(0);      %还原Matlab键盘监听
Screen('CloseAll');
%restore resolution
Screen('Resolution', whichscreen, oldResolution.width, oldResolution.height);

disp(result);