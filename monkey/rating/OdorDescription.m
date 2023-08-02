% this script is for describing odors
% revised on 2023.8.1
% input information
prompt = {'被试编号：', '休息时间：', '页数：'};
name = 'Experimental information';
numlines = 1;
defaultanswer = {'s01', '1', '5'};
answer = inputdlg(prompt, name, numlines, defaultanswer);
data.subject = answer{1};
data.break_time = str2double(answer{2});
data.odornum = 5;
data.page_num = str2double(answer{3});

datadir = '/Volumes/WD_D/share/programm/02_program/';
datafile = sprintf('%s_%s.mat', data.subject, datestr(now, 30));

% prepare for the rating page
AssertOpenGL;
whichscreen = max(Screen('Screens'));

black = BlackIndex(whichscreen);
white = WhiteIndex(whichscreen);
gray = round((black + white) / 2);
yellow = [255, 127, 0];

[~, str] = xlsread([datadir 'DescriptorsSelected_220422.xlsx'], 1); % import the descriptors
descriptors = str;

Screen('Preference', 'SkipSyncTests', 1);
[windowPtr, rectw] = Screen('OpenWindow', whichscreen, black);
Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Screen('TextFont', windowPtr, 'Kaiti');
[width, height] = Screen('WindowSize', windowPtr);
textlinespace = 1.5;
[centerx, centery] = RectCenter(rectw);

% first screen
msgwelcome = {'这是一个评价气味的实验。', ...
                  '请按照提示闻不同的气味并对其进行评价。', ...
                  '首先需要评价气味的愉悦度、熟悉度、强度、可食用性和唤醒度。', ...
                  '实验过程中可多次闻气味。', ...
                  '        ', ...
              '如果准备好了，请按“空格键”开始'};
newY = centery - 200;
for r = 1:numel(msgwelcome)
    Screen('TextSize', windowPtr, 20);
    msg_now = double(msgwelcome{r});
    msgiBoundsRect = Screen('TextBounds', windowPtr, msg_now);
    textWidth = RectWidth(msgiBoundsRect);
    textHeight = RectHeight(msgiBoundsRect);
    [~, newY] = Screen('DrawText', windowPtr, msg_now, centerx - floor(textWidth / 2), newY + textlinespace * textHeight, white);
end
Screen('Flip', windowPtr);

% define keys
KbName('UnifyKeyNames');
escapeKey = KbName('ESCAPE');
spaceKey = KbName('SPACE');
ListenChar(2);
HideCursor;

% check keys
[touch, ~, keyCode] = KbCheck;
while ~(touch && (keyCode(spaceKey) || keyCode(escapeKey)))
    [touch, ~, keyCode] = KbCheck;
end
if keyCode(escapeKey)
    Screen('CloseAll');
    ListenChar(0);
end

% odor sequence
odorseq = randperm(data.odornum);
data.seq = odorseq;
ratingresults_vif = zeros(data.odornum, 5);
ratingresults = [];
% for each odor
for o = 1:data.odornum
    no = odorseq(o);
    Screen('TextSize', windowPtr, 25);
    %         instruction = double(['请闻' num2str(no) '号气味']);
    instruction = double(['请闻气味——' num2str(no)]);
    insBoundsRect = Screen('TextBounds', windowPtr, instruction);
    insWidth = RectWidth(insBoundsRect);
    insHeight = RectHeight(insBoundsRect);
    Screen('TextSize', windowPtr, 25);
    Screen('DrawText', windowPtr, instruction, centerx - floor(insWidth / 2), centery - floor(insHeight / 2), white);
    Screen('Flip', windowPtr);
    WaitSecs(1);
    [touch, ~, keyCode] = KbCheck;
    while ~(touch && (keyCode(spaceKey) || keyCode(escapeKey)))
        [touch, ~, keyCode] = KbCheck;
    end
    if keyCode(escapeKey)
        Screen('CloseAll');
        ListenChar(0);
    end

    % rating
    while ~all(ratingresults_vif(no, :))
        ratingresults_vif(no, :) = gen_rating('all', windowPtr, rectw, whichscreen);
    end
    % rate on descriptors
    msgwelcome = {'接下来，请评价该气味符合描述词的程度。', ...
                      '实验过程中可多次闻气味。', ...
                      '        ', ...
                  '如果准备好了，请按“空格键”开始'};
    newY = centery - 200;
    for r = 1:numel(msgwelcome)
        Screen('TextSize', windowPtr, 20);
        msg_now = double(msgwelcome{r});
        msgiBoundsRect = Screen('TextBounds', windowPtr, msg_now);
        textWidth = RectWidth(msgiBoundsRect);
        textHeight = RectHeight(msgiBoundsRect);
        [~, newY] = Screen('DrawText', windowPtr, msg_now, centerx - floor(textWidth / 2), newY + textlinespace * textHeight, white);
    end
    Screen('Flip', windowPtr);
    [touch, ~, keyCode] = KbCheck;
    while ~(touch && (keyCode(spaceKey) || keyCode(escapeKey)))
        [touch, ~, keyCode] = KbCheck;
    end
    if keyCode(escapeKey)
        Screen('CloseAll');
        ListenChar(0);
    end

    % descriptions
    ratingresults(no, :) = gen_description(descriptors, windowPtr, rectw, whichscreen, data.page_num);

    if o < data.odornum
        Screen('TextSize', windowPtr, 25);
        waitmessage = double('请休息一下......');
        wmBoundsRect = Screen('TextBounds', windowPtr, waitmessage);
        wmWidth = RectWidth(wmBoundsRect);
        wmHeight = RectHeight(wmBoundsRect);
        Screen('DrawText', windowPtr, waitmessage, centerx - floor(wmWidth / 2), centery -floor(wmHeight / 2), white);
        Screen('Flip', windowPtr);
        WaitSecs(data.break_time);
    else
        Screen('TextSize', windowPtr, 30);
        breakmessage = double('评价结束，谢谢！');
        bBoundsRect = Screen('TextBounds', windowPtr, breakmessage);
        bWidth = RectWidth(bBoundsRect);
        bHeight = RectHeight(bBoundsRect);
        Screen('DrawText', windowPtr, breakmessage, centerx - floor(bWidth / 2), centery -floor(bHeight / 2), white);
        Screen('Flip', windowPtr);
        WaitSecs(2);
        Screen('CloseAll');
        ListenChar(0);
    end   
end
% save results
data.results_vif = ratingresults_vif;
data.results = ratingresults(:,1:length(descriptors));
save([datadir datafile], 'data');