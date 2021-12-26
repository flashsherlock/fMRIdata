function test(offcenter_x, offcenter_y)
% ROIsLocalizer(offcenter_x, offcenter_y), [LO, FFA, and EBA]
% rate similarity
waittime=2;
% times
dur=3;
seq=[1 2 2 1];
lr={double('¡û'),double('¡ú')};
% fixation
fix_size=18;
fix_thick=3;
fixcolor_back=[0 0 0];

% port
port='COM3';%COM3
% keys
KbName('UnifyKeyNames');
escapeKey = KbName('ESCAPE');

% input
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'TextEncodingLocale', 'UTF-8');
if nargin < 2
    offcenter_x=0; offcenter_y=0;
end

AssertOpenGL;
whichscreen=max(Screen('Screens'));
% backup resolution
oldResolution=Screen('Resolution', whichscreen);
Screen('Resolution', whichscreen, 800, 600);

% colors
black=BlackIndex(whichscreen);
white=WhiteIndex(whichscreen);
gray=round((white+black)*4/5);
backcolor=gray;

[windowPtr,rect]=Screen('OpenWindow',whichscreen,backcolor);
Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

fixationp1=OffsetRect(CenterRect([0 0 fix_thick fix_size],rect),offcenter_x,offcenter_y);
fixationp2=OffsetRect(CenterRect([0 0 fix_size fix_thick],rect),offcenter_x,offcenter_y);

fps=round(FrameRate(windowPtr));%Screen('NominalFrameRate',windowPtr);
ifi=Screen('GetFlipInterval',windowPtr);
oldPriority=Priority(MaxPriority(windowPtr));

HideCursor;

tic;

for cyc=1:length(seq)
    % start
    Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
    Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
    Screen('Flip',windowPtr);

    % wait time
    WaitSecs(waittime);

    % count down iti
    Screen('TextSize', windowPtr, 64);
    [norm,~]=Screen('TextBounds', windowPtr, lr{seq(cyc)});
    count=OffsetRect(CenterRect(norm,rect),offcenter_x,offcenter_y);
    Screen('DrawText', windowPtr, lr{seq(cyc)},count(1),count(2),0);
    vbl = Screen('Flip', windowPtr);
    
    while GetSecs-vbl<dur     
        [touch, ~, keyCode] = KbCheck;
       if touch && keyCode(escapeKey)
            Screen('CloseAll');
            return
       end
    end
   
    % wait time 30s
%     Screen('FillRect',windowPtr,fixcolor_back,fixationp1);
%     Screen('FillRect',windowPtr,fixcolor_back,fixationp2);
%     Screen('Flip',windowPtr);
%     WaitSecs(dur);    
    
end

toc;
% restore
Priority(oldPriority);
ShowCursor;
Screen('CloseAll');
%restore resolution
Screen('Resolution', whichscreen, oldResolution.width, oldResolution.height);

return