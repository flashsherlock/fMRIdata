function [ratings, again] = gen_rating(exp, windowPtr, rect, whichscreen)
% ratings
%   exp: vi or si
again = 0;
[width, height] = Screen('WindowSize', windowPtr);
[centerx, centery] = RectCenter(rect);
% colors
black = BlackIndex(whichscreen);
% white=WhiteIndex(whichscreen);
yellow = black;
white = black;
% common components
Screen('TextSize', windowPtr, 25);
rating_instruction = double('请评价闻到的气味：');
rating_insBoundsRect = Screen('TextBounds', windowPtr, rating_instruction);
rating_insWidth = RectWidth(rating_insBoundsRect);
rating_insHeight = RectHeight(rating_insBoundsRect);
msg_certain = double('确定');
msg_certainBoundsRect = Screen('TextBounds', windowPtr, msg_certain);
msg_certainWidth = RectWidth(msg_certainBoundsRect);
msg_certainHeight = RectHeight(msg_certainBoundsRect);
line_width = 3;
tick_width = 2;
% which experiment
switch exp
    case 'vi'
        rate_num = 4;
        % rating page
        rating_valence = double('愉悦度');
        v_insBoundsRect = Screen('TextBounds', windowPtr, rating_valence);
        v_insWidth = RectWidth(v_insBoundsRect);
        v_insHeight = RectHeight(v_insBoundsRect);
        rating_intensity = double('强    度');
        i_insBoundsRect = Screen('TextBounds', windowPtr, rating_intensity);
        i_insWidth = RectWidth(i_insBoundsRect);
        i_insHeight = RectHeight(i_insBoundsRect);
        rating_familarity = double('熟悉度');
        f_insBoundsRect = Screen('TextBounds', windowPtr, rating_familarity);
        f_insWidth = RectWidth(f_insBoundsRect);
        f_insHeight = RectHeight(f_insBoundsRect);
        rating_edibility = double('可食用性');
        e_insBoundsRect = Screen('TextBounds', windowPtr, rating_edibility);
        e_insWidth = RectWidth(e_insBoundsRect);
        e_insHeight = RectHeight(e_insBoundsRect);
        % labels
        rating_v1 = double('难闻');
        rating_v2 = double('好闻');
        rv1_BoundsRect = Screen('TextBounds', windowPtr, rating_v1);
        rv1_Width = RectWidth(rv1_BoundsRect);
        rv1_Height = RectHeight(rv1_BoundsRect);
        rv2_BoundsRect = Screen('TextBounds', windowPtr, rating_v2);
        rv2_Width = RectWidth(rv2_BoundsRect);
        rating_i1 = double('弱');
        rating_i2 = double('强');
        ri1_BoundsRect = Screen('TextBounds', windowPtr, rating_i1);
        ri1_Width = RectWidth(ri1_BoundsRect);
        ri1_Height = RectHeight(ri1_BoundsRect);
        ri2_BoundsRect = Screen('TextBounds', windowPtr, rating_i2);
        ri2_Width = RectWidth(ri2_BoundsRect);
        rating_f1 = double('不熟悉');
        rating_f2 = double('熟悉');
        rf1_BoundsRect = Screen('TextBounds', windowPtr, rating_f1);
        rf1_Width = RectWidth(rf1_BoundsRect);
        rf1_Height = RectHeight(rf1_BoundsRect);
        rf2_BoundsRect = Screen('TextBounds', windowPtr, rating_f2);
        rf2_Width = RectWidth(rf2_BoundsRect);
        rating_e1 = double('不能吃');
        rating_e2 = double('能吃');
        re1_BoundsRect = Screen('TextBounds', windowPtr, rating_e1);
        re1_Width = RectWidth(re1_BoundsRect);
        re1_Height = RectHeight(re1_BoundsRect);
        re2_BoundsRect = Screen('TextBounds', windowPtr, rating_e2);
        re2_Width = RectWidth(re2_BoundsRect);
        % lines and ticks
        ratingbarxys(1, :) = repmat([3 * width / 8 13 * width / 16], 1, 4);
        ratingbarxys(2, :) = repelem([3 * height / 8 4 * height / 8 5 * height / 8 6 * height / 8], 2);
        ratingcorxys(1, :) = repmat(repelem([3 * width / 8 + tick_width 31 * width / 64 38 * width / 64 45 * width / 64 52 * width / 64], 2), 1, 4) - floor(line_width / 2);
        ratingcorxys(2, :) = [repmat([3 * height / 8 - 10 3 * height / 8], 1, 5) repmat([4 * height / 8 - 10 4 * height / 8], 1, 5) repmat([5 * height / 8 - 10 5 * height / 8], 1, 5) repmat([6 * height / 8 - 10 6 * height / 8], 1, 5)];
        % instruction
        Screen('DrawText', windowPtr, rating_instruction, centerx - floor(rating_insWidth / 2), centery / 4 - floor(rating_insHeight / 2), white);
        % dimension
        % Screen('TextSize',windowPtr, 20);
        Screen('DrawText', windowPtr, rating_valence, width / 4 - floor(v_insWidth / 2), 3 * height / 8 - floor(v_insHeight / 2), white);
        Screen('DrawText', windowPtr, rating_intensity, width / 4 - floor(i_insWidth / 2), 4 * height / 8 - floor(i_insHeight / 2), white);
        Screen('DrawText', windowPtr, rating_familarity, width / 4 - floor(f_insWidth / 2), 5 * height / 8 - floor(f_insHeight / 2), white);
        Screen('DrawText', windowPtr, rating_edibility, width / 4 - floor(e_insWidth / 2), 6 * height / 8 - floor(e_insHeight / 2), white);
        Screen('DrawText', windowPtr, msg_certain, centerx - floor(msg_certainWidth / 2), 11 * height / 12 - floor(msg_certainHeight / 2), white);
        % labels of the rating
        Screen('TextSize', windowPtr, 20);
        Screen('DrawText', windowPtr, rating_v1, 3 * width / 8 - floor(rv1_Width / 2), 5 * height / 16 - floor(rv1_Height / 2), yellow);
        Screen('DrawText', windowPtr, rating_v2, 13 * width / 16 - floor(rv2_Width / 2), 5 * height / 16 - floor(rv1_Height / 2), yellow);
        Screen('DrawText', windowPtr, rating_i1, 3 * width / 8 - floor(ri1_Width / 2), 7 * height / 16 - floor(ri1_Height / 2), yellow);
        Screen('DrawText', windowPtr, rating_i2, 13 * width / 16 - floor(ri2_Width / 2), 7 * height / 16 - floor(ri1_Height / 2), yellow);
        Screen('DrawText', windowPtr, rating_f1, 3 * width / 8 - floor(rf1_Width / 2), 9 * height / 16 - floor(rf1_Height / 2), yellow);
        Screen('DrawText', windowPtr, rating_f2, 13 * width / 16 - floor(rf2_Width / 2), 9 * height / 16 - floor(rf1_Height / 2), yellow);
        Screen('DrawText', windowPtr, rating_e1, 3 * width / 8 - floor(re1_Width / 2), 11 * height / 16 - floor(re1_Height / 2), yellow);
        Screen('DrawText', windowPtr, rating_e2, 13 * width / 16 - floor(re2_Width / 2), 11 * height / 16 - floor(re1_Height / 2), yellow);
        % confirm
        Screen('FrameRect', windowPtr, white, [centerx - floor(msg_certainWidth / 2) - 10, 11 * height / 12 - floor(msg_certainHeight / 2) - 10, centerx + floor(msg_certainWidth / 2) + 10, 11 * height / 12 + floor(msg_certainHeight / 2) + 10], 2);
        % lines and ticks
        Screen('DrawLines', windowPtr, ratingbarxys, line_width, white);
        Screen('DrawLines', windowPtr, ratingcorxys, tick_width, white);

        % define the select rectors
        srm(:, 1) = repelem(3 * width / 8, 4)';
        srm(:, 3) = repelem(13 * width / 16, 4)';
        srm(:, 2) = [3 * height / 8 - 10 4 * height / 8 - 10 5 * height / 8 - 10 6 * height / 8 - 10]';
        srm(:, 4) = [3 * height / 8 + 10 4 * height / 8 + 10 5 * height / 8 + 10 6 * height / 8 + 10]';

    case 'si'

    otherwise
        error('Should be vi or si');
end

% get ratings
ShowCursor('Hand', windowPtr);
Screen('Flip', windowPtr);
bodyimage = Screen('GetImage', windowPtr, []);
ratingbody = Screen('MakeTexture', windowPtr, bodyimage);
% initiate variables
rallxs = cell(1, rate_num);
rectlables_vif = 1:rate_num;
ratingresults_vif = zeros(1, rate_num);

% get mouse
while true
    [x, y, buttons] = GetMouse(windowPtr);
    %            [touch, ~, keyCode] = KbCheck;
    % click in the rating region
    if buttons(1) && IsInRect(x, y, [srm(1, 1), srm(1, 2), srm(rate_num, 3), srm(rate_num, 4)])
        % find the xy in which rect
        [~, rectnumber] = min(abs(srm(:, 4) - y));
        [~, rectcentery] = RectCenter(srm(rectnumber, :));
        points = [x - 6, rectcentery - 15; x + 6, rectcentery - 15; x, rectcentery];
        rallxs{rectnumber} = [rallxs{rectnumber} x];
        % label rated rects
        blanks = cellfun('isempty', rallxs);
        rectchosen = rectlables_vif(blanks == 0);
        Screen('PreloadTextures', windowPtr, ratingbody);
        Screen('DrawTexture', windowPtr, ratingbody);
        % restore other ratings
        if size(rectchosen, 2) >= 2
            for r = 1:size(rectchosen, 2)
                [~, rectcenteryed] = RectCenter(srm(rectchosen(r), :));
                points_ed = [rallxs{rectchosen(r)}(end) - 6, rectcenteryed - 15; rallxs{rectchosen(r)}(end) + 6, rectcenteryed - 15; rallxs{rectchosen(r)}(end), rectcenteryed];
                Screen('FramePoly', windowPtr, yellow, points_ed, 2);
            end
        end
        % update the screen
        Screen('FramePoly', windowPtr, yellow, points, 2);
        Screen('Flip', windowPtr);
        ratingresults_vif(rectnumber) = ceil((rallxs{rectnumber}(end) - srm(rectnumber, 1)) / (7 * width / 16) * 100);
        WaitSecs(0.1);
    % left click on confirm but ratings not finished
    elseif buttons(1) && IsInRect(x, y, [centerx - floor(msg_certainWidth / 2) - 10, 11 * height / 12 - floor(msg_certainHeight / 2) - 10, centerx + floor(msg_certainWidth / 2) + 10, 11 * height / 12 + floor(msg_certainHeight / 2) + 10])
        blanks = cellfun('isempty', rallxs);
        if sum(blanks) == 0
            break;
        end
    % right click on confirm
    elseif buttons(2) && IsInRect(x, y, [centerx - floor(msg_certainWidth / 2) - 10, 11 * height / 12 - floor(msg_certainHeight / 2) - 10, centerx + floor(msg_certainWidth / 2) + 10, 11 * height / 12 + floor(msg_certainHeight / 2) + 10])
        % the same odor again
        again = 1;
        break;
        % elseif touch == 1 && (keyCode(escapeKey))
        % Screen('CloseAll');
        % ListenChar(0);
    end
end
    % return ratings
    ratings = ratingresults_vif;
end
