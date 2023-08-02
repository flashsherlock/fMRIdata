function [ratingresults, again] = gen_description( descriptors, windowPtr, rect, whichscreen,page_num )
% descriptions
again = 0;
[width, height] = Screen('WindowSize', windowPtr);
[centerx, centery] = RectCenter(rect);
desnum = size(descriptors, 1);
supele = 2 * page_num - mod(desnum, 2 * page_num);
% colors
black = BlackIndex(whichscreen);
white = WhiteIndex(whichscreen);
gray = round((black + white) / 2);
yellow = [255, 127, 0];
% define keys
KbName('UnifyKeyNames');
escapeKey = KbName('ESCAPE');
for i = 1:supele
    descriptors{desnum + i} = '--';
end
% results
ratingresults = zeros(1,desnum+supele);
% put the different descriptor label numbers into a matrix
supvector = [(size(descriptors, 1) - supele + 1):size(descriptors, 1)];
dseq = [randperm(size(descriptors, 1) - supele) supvector];

% rows in desmat stand for different pages
for p = 1:page_num

    demat = (reshape(dseq, [size(descriptors, 1) / page_num, page_num]))';

    % calculate the location of instruction and rating bars
    rowinpage = size(demat, 2) / 2 + 2;
    rowWidth = width / 2;
    rowHeight = height / rowinpage;
    msg_rating1 = double('完全不符合');
    msg_rating2 = double('非常符合');
    msg_certain = double('确定');
    Screen('TextSize', windowPtr, 15);
    msg_rating1BoundsRect = Screen('TextBounds', windowPtr, msg_rating1);
    msg_rating1Width = RectWidth(msg_rating1BoundsRect);
    msg_rating1Height = RectHeight(msg_rating1BoundsRect);
    msg_rating2BoundsRect = Screen('TextBounds', windowPtr, msg_rating2);
    msg_rating2Width = RectWidth(msg_rating2BoundsRect);
    msg_rating2Height = RectHeight(msg_rating2BoundsRect);
    msg_certainBoundsRect = Screen('TextBounds', windowPtr, msg_certain);
    msg_certainWidth = RectWidth(msg_certainBoundsRect);
    msg_certainHeight = RectHeight(msg_certainBoundsRect);
    Screen('TextSize', windowPtr, 15);
    Screen('DrawText', windowPtr, msg_rating1, width / 5 - floor(msg_rating1Width / 2), rowHeight / 2 - floor(msg_rating1Height / 2), yellow);
    Screen('DrawText', windowPtr, msg_rating1, 7 * width / 10 - floor(msg_rating1Width / 2), rowHeight / 2 - floor(msg_rating1Height / 2), yellow);
    Screen('DrawText', windowPtr, msg_rating2, 2 * width / 5 - floor(msg_rating2Width / 2), rowHeight / 2 - floor(msg_rating1Height / 2), yellow);
    Screen('DrawText', windowPtr, msg_rating2, 9 * width / 10 - floor(msg_rating2Width / 2), rowHeight / 2 - floor(msg_rating1Height / 2), yellow);
    Screen('DrawText', windowPtr, msg_certain, centerx - floor(msg_certainWidth / 2), height - rowHeight / 2 - floor(msg_certainHeight / 2), white);
    Screen('FrameRect', windowPtr, 255, [centerx - floor(msg_certainWidth / 2) - 10, height - rowHeight / 2 - floor(msg_certainHeight / 2) - 10, centerx + floor(msg_certainWidth / 2) + 10, height - rowHeight / 2 + floor(msg_certainHeight / 2) + 10], 3); %the confirm part
    % ratingbar coordinate matrix
    l = 1:size(demat, 2);
    xys1(1, l) = mod(l, 2) * (2/10) * width + width / 5;
    xys1(2, l) = 3 * rowHeight / 2 + (ceil(l / 2) - 1) * rowHeight;
    xys2(1, l) = mod(l, 2) * (2/10) * width + 7 * width / 10;
    xys2(2, l) = 3 * rowHeight / 2 + (ceil(l / 2) - 1) * rowHeight;

    Screen('DrawLines', windowPtr, xys1, 2, []);
    Screen('DrawLines', windowPtr, xys2, 2, []);
    % rating scale
    cali_rowy1 = [];
    for c = 1:size(demat, 2) / 2
        cali_rowy1c = repmat([3 * rowHeight / 2 - 5 + (c - 1) * rowHeight 3 * rowHeight / 2 + (c - 1) * rowHeight], 1, 5);
        cali_rowy1 = [cali_rowy1, cali_rowy1c];
    end
    cali_row1x1 = repelem([width / 5, width / 5 + width / 20, width / 5 + 2 * width / 20, width / 5 + 3 * width / 20, width / 5 + 4 * width / 20], 2);
    cali_rowx1 = repmat(cali_row1x1, 1, rowinpage - 2);
    cali_xys1 = [cali_rowx1; cali_rowy1];
    cali_rowy2 = [];
    for c = 1:size(demat, 2) / 2
        cali_rowy2c = repmat([3 * rowHeight / 2 - 5 + (c - 1) * rowHeight 3 * rowHeight / 2 + (c - 1) * rowHeight], 1, 5);
        cali_rowy2 = [cali_rowy2, cali_rowy2c];
    end
    cali_row1x2 = repelem([7 * width / 10, 7 * width / 10 + width / 20, 7 * width / 10 + 2 * width / 20, 7 * width / 10 + 3 * width / 20, 7 * width / 10 + 4 * width / 20], 2);
    cali_rowx2 = repmat(cali_row1x2, 1, rowinpage - 2);
    cali_xys2 = [cali_rowx2; cali_rowy2];
    Screen('DrawLines', windowPtr, cali_xys1, 2, []);
    Screen('DrawLines', windowPtr, cali_xys2, 2, []);

    % calculate the coordinates for elements
    words_centerx(1) = width / 10;
    words_centerx(2) = 6 * width / 10;
    words_centery = linspace(rowHeight / 2, height - rowHeight / 2, rowinpage);

    for des = 1:size(demat, 2) % calculate every words' location
        words{des} = double(descriptors{demat(p, des)});

        if mod(des, 2) == 0
            word_centerx = words_centerx(2);
        else
            word_centerx = words_centerx(1);
        end

        word_centery = round(words_centery(1 + floor((des + 1) / 2)));
        Screen('TextSize', windowPtr, 15);
        wordsBoundsRect = Screen('TextBounds', windowPtr, words{des});
        wordsWidth = RectWidth(wordsBoundsRect);
        wordsHeight = RectHeight(wordsBoundsRect);
        Screen('TextSize', windowPtr, 15);
        Screen('DrawText', windowPtr, words{des}, word_centerx - floor(wordsWidth / 2), word_centery - floor(wordsHeight / 2), white);
    end

    % generate the rating rect matrix, rows for the start and end coordinates of one rating rect
    rrm=[];
    rrm(:, 1) = repmat([width / 5; 7 * width / 10], size(demat, 2) / 2, 1);
    rrm(:, 3) = repmat([2 * width / 5; 9 * width / 10], size(demat, 2) / 2, 1);
    % rating height setvalue
    sens = rowHeight/2 - 5;
    rrm(:,2)=xys1(2,:) - sens;
    rrm(:,4)=xys1(2,:) + sens;

    sens = rowHeight / 4;
    % put the rating page onset
    ShowCursor('Hand', windowPtr);
    Screen('Flip', windowPtr);
    bodyimage = Screen('GetImage', windowPtr, []);
    ratingbody = Screen('MakeTexture', windowPtr, bodyimage);

    descriptorlabels = demat(p, :);
    allxs = cell(1, size(demat, 2));
    % if the last page, fill sup
    if p == page_num
        for i = 1:supele
            allxs{size(demat, 2) + 1 - i} = rrm(size(demat, 2) + 1 - i, 1);
        end
    end

    rectlables = 1:size(demat, 2);
    rectnumber = [];
    while true
        [x, y, buttons] = GetMouse(windowPtr);
        [touch, ~, keyCode] = KbCheck;

        if buttons(1) && (IsInRect(x, y, [rrm(1, 1), rowHeight, rrm(1, 3), height - rowHeight]) || IsInRect(x, y, [rrm(2, 1), rowHeight, rrm(2, 3), height - rowHeight]))
            % find the xy in which rect
            for rect = 1:size(demat, 2)
                if IsInRect(x, y, rrm(rect, :))
                    rectnumber = rect;
                end
            end
        if ~isempty(rectnumber)
            [~, rectcentery] = RectCenter(rrm(rectnumber, :));
            points = [x - 4, rectcentery - 10; x + 4, rectcentery - 10; x, rectcentery];
            allxs{rectnumber} = [allxs{rectnumber} x];
            blanks = cellfun('isempty', allxs); % label rated rects
            rectchosen = rectlables(blanks == 0);
            Screen('PreloadTextures', windowPtr, ratingbody);
            Screen('DrawTexture', windowPtr, ratingbody);
            % show ratings
            if size(rectchosen, 2) >= 2
                for r = 1:size(rectchosen, 2)
                    [~, rectcenteryed] = RectCenter(rrm(rectchosen(r), :));
                    points_ed = [allxs{rectchosen(r)}(end) - 4, rectcenteryed - 10; allxs{rectchosen(r)}(end) + 4, rectcenteryed - 10; allxs{rectchosen(r)}(end), rectcenteryed];
                    Screen('FramePoly', windowPtr, yellow, points_ed, 2);
                end
            else
                Screen('FramePoly', windowPtr, yellow, points, 2);
            end                
            Screen('Flip', windowPtr);
            ratingresults(descriptorlabels(rectnumber)) = max(1,ceil((allxs{rectnumber}(end) - rrm(rectnumber, 1)) / (width / 5) * 100));
            rectnumber = [];
            WaitSecs(0.1);
        end
        % confirm button
        elseif buttons(1) && IsInRect(x, y, [centerx - floor(msg_certainWidth / 2) - 10, height - rowHeight / 2 - floor(wordsHeight / 2) - 10, centerx + floor(msg_certainWidth / 2) + 10, height - rowHeight / 2 + floor(wordsHeight / 2) + 10])
            blanks = cellfun('isempty', allxs);
            % make sure no blanks
            if sum(blanks) == 0
                break;
            end
        % any other click on confirm
        % buttons(2) on mac but buttons(3) on win for right click
%         elseif ~buttons(1) && any(buttons) && IsInRect(x, y, [centerx - floor(msg_certainWidth / 2) - 10, height - rowHeight / 2 - floor(wordsHeight / 2) - 10, centerx + floor(msg_certainWidth / 2) + 10, height - rowHeight / 2 + floor(wordsHeight / 2) + 10])
%             % the same odor again
%             again = 1;
%             break;
        % esc
        elseif touch == 1 && (keyCode(escapeKey))
            Screen('CloseAll');
            ListenChar(0);
        end
    end % mouse while true end
end % page end           

end

