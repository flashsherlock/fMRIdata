function errinfo=ShowInstructionSE_UMNVAL(windowPtr, rect, msg, confirmKey, BackColor, FontColor, defaultwin)
% This program shows instruction for PTB3
% errinfo=ShowInstructionSE_UMNVAL(windowPtr, rect, msg, confirmKey, BackColor, FontColor [, defaultwin])
% Yi Jiang, Vision and Attention Lab, University of Minnesota

if ~ischar(msg)
    fprintf('msg must be a string!\n');
    errinfo=1;
    return
end
% [oldFontName, oldFontNumber]=Screen('TextFont',windowPtr);
% oldFontSize=Screen('TextSize',windowPtr);
% oldFontStyle=Screen('TextStyle',windowPtr);
% [center_x,center_y]=RectCenter(rect);
% Screen('TextFont',windowPtr,'Verdana');
% Screen('TextSize',windowPtr,12);
% Screen('TextStyle',windowPtr,1);
% normBoundsRect=Screen('TextBounds',windowPtr,msg);
% textwidth=RectWidth(normBoundsRect);
Screen('FillRect',windowPtr,BackColor);
Screen('DrawText',windowPtr,msg,20,20,FontColor);
if exist('defaultwin','var')
    Screen('DrawTexture',windowPtr,defaultwin);
end
Screen('Flip', windowPtr);
KbName('UnifyKeyNames');
escapeKey = KbName('ESCAPE');
[touch, secs, keyCode] = KbCheck;
touch = 0;
	while ~(touch && (keyCode(confirmKey) || keyCode(escapeKey)))
		[touch, secs, keyCode] = KbCheck;
	end
    if keyCode(escapeKey)
		Screen('CloseAll');
        errinfo=1;
        return
	end
Screen('FillRect',windowPtr,BackColor);
if exist('defaultwin','var')
    Screen('DrawTexture',windowPtr,defaultwin);
end
Screen('Flip', windowPtr);
% Screen('TextFont',windowPtr,oldFontNumber);
% Screen('TextSize',windowPtr,oldFontSize);
% Screen('TextStyle',windowPtr,oldFontStyle);
errinfo=0;
return