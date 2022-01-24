function test_position(offcenter_x, offcenter_y)
% ROIsLocalizer(offcenter_x, offcenter_y), [LO, FFA, and EBA]
% Scan = 396s, TR = 3s, 132TR
if nargin < 2
    offcenter_x=0; offcenter_y=-205;
end
upmax=-260;
downmax=50;
leftmax=-180;
rightmax=180;
KbName('UnifyKeyNames');
escapeKey = KbName('ESCAPE');
Key1 = KbName('1!');
Key2 = KbName('2@');
KeyR = KbName('r');

% rating instruction
scale=0.8;
imageSizex=100;
imageSizey=75;
StimSize=[0 0 imageSizex imageSizey]*scale;
StimSize_num=[0 0 315+260 70]*scale;
distance=25;

Screen('Preference', 'SkipSyncTests', 1);

AssertOpenGL;
whichscreen=max(Screen('Screens'));
% backup resolution
% oldResolution=Screen('Resolution', whichscreen);
oldResolution=Screen('Resolution', whichscreen, 800, 600);

% colors
black=BlackIndex(whichscreen);
white=WhiteIndex(whichscreen);
gray=round((white+black)*4/5);
backcolor=gray;

[windowPtr,rect]=Screen('OpenWindow',whichscreen,backcolor);
Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
StimRect=OffsetRect(CenterRect(StimSize,rect),offcenter_x,offcenter_y-distance);
StimRect_num=OffsetRect(CenterRect(StimSize_num,rect),offcenter_x-1,offcenter_y+distance);

oldPriority=Priority(MaxPriority(windowPtr));
% load pictures
cd ins
ins(1)=Screen('MakeTexture', windowPtr, imread('valence.bmp'));
ins(2)=Screen('MakeTexture', windowPtr, imread('intensity.bmp'));
number(1)=Screen('MakeTexture', windowPtr, imread('number1.bmp'));
number(2)=Screen('MakeTexture', windowPtr, imread('number2.bmp'));
cd ..
HideCursor;
ListenChar(2);      % close keyboard

% rating
Screen('DrawTexture',windowPtr,ins(1),[],StimRect);
Screen('DrawTexture',windowPtr,number(1),[],StimRect_num);
Screen('Flip',windowPtr);

% up and down
while 1
    [touch, ~, keyCode] = KbCheck;
    ifkey=[keyCode(Key1) keyCode(Key2)];
    if touch && ismember(1,ifkey)             
        switch find(ifkey==1,1,'first')
            % up
            case 1
                offcenter_y=max(offcenter_y-5,upmax);
                WaitSecs(0.1);
            % down
            case 2
                offcenter_y=min(offcenter_y+5,downmax);
                WaitSecs(0.1);
        end
        StimRect=OffsetRect(CenterRect(StimSize,rect),offcenter_x,offcenter_y-distance);
        StimRect_num=OffsetRect(CenterRect(StimSize_num,rect),offcenter_x-1,offcenter_y+distance);
        Screen('DrawTexture',windowPtr,ins(1),[],StimRect);
        Screen('DrawTexture',windowPtr,number(1),[],StimRect_num);
        Screen('Flip',windowPtr);
    elseif touch && keyCode(KeyR) 
        % left and right
        while 1
            [touch, ~, keyCode] = KbCheck;
            ifkey=[keyCode(Key1) keyCode(Key2)];
            if touch && ismember(1,ifkey)             
                switch find(ifkey==1,1,'first')
                    % left
                    case 1
                        offcenter_x=max(offcenter_x-5,leftmax);
                        WaitSecs(0.1);
                    % right
                    case 2
                        offcenter_x=min(offcenter_x+5,rightmax);
                        WaitSecs(0.1);
                end
                StimRect=OffsetRect(CenterRect(StimSize,rect),offcenter_x,offcenter_y-distance);
                StimRect_num=OffsetRect(CenterRect(StimSize_num,rect),offcenter_x-1,offcenter_y+distance);
                Screen('DrawTexture',windowPtr,ins(1),[],StimRect);
                Screen('DrawTexture',windowPtr,number(1),[],StimRect_num);
                Screen('Flip',windowPtr);
            elseif touch && keyCode(escapeKey)        
                break
            end
        end
    elseif touch && keyCode(escapeKey)        
        break
    end
end

% restore
Priority(oldPriority);
ShowCursor;
ListenChar(0);      % open keyboard
Screen('CloseAll');
%restore resolution
Screen('Resolution', whichscreen, oldResolution.width, oldResolution.height);
disp('offcenter_x, offcenter_y')
disp([offcenter_x,offcenter_y]);
return