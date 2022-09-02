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
% define positions
line_left = 3 * width / 8;
line_right = 13 * width / 16;
% set scale
line_width = 3;
tick_width = 2;
tick_num = 5;
tick_pos = linspace(line_left,line_right,tick_num);
tick_pos(1) = tick_pos(1) + tick_width;
% which experiment
switch exp
    case 'vi'
        % define positions
        rate_num = 4;        
        rates = (height / 8) * (3:6);        
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
        rating_v1 = double('非常难闻');
        rating_v2 = double('非常好闻');
        rv1_BoundsRect = Screen('TextBounds', windowPtr, rating_v1);
        rv1_Width = RectWidth(rv1_BoundsRect);
        rv1_Height = RectHeight(rv1_BoundsRect);
        rv2_BoundsRect = Screen('TextBounds', windowPtr, rating_v2);
        rv2_Width = RectWidth(rv2_BoundsRect);
        rating_i1 = double('非常微弱');
        rating_i2 = double('非常强烈');
        ri1_BoundsRect = Screen('TextBounds', windowPtr, rating_i1);
        ri1_Width = RectWidth(ri1_BoundsRect);
        ri1_Height = RectHeight(ri1_BoundsRect);
        ri2_BoundsRect = Screen('TextBounds', windowPtr, rating_i2);
        ri2_Width = RectWidth(ri2_BoundsRect);
        rating_f1 = double('非常陌生');
        rating_f2 = double('非常熟悉');
        rf1_BoundsRect = Screen('TextBounds', windowPtr, rating_f1);
        rf1_Width = RectWidth(rf1_BoundsRect);
        rf1_Height = RectHeight(rf1_BoundsRect);
        rf2_BoundsRect = Screen('TextBounds', windowPtr, rating_f2);
        rf2_Width = RectWidth(rf2_BoundsRect);
        rating_e1 = double('不可食用');
        rating_e2 = double('可以食用');
        re1_BoundsRect = Screen('TextBounds', windowPtr, rating_e1);
        re1_Width = RectWidth(re1_BoundsRect);
        re1_Height = RectHeight(re1_BoundsRect);
        re2_BoundsRect = Screen('TextBounds', windowPtr, rating_e2);
        re2_Width = RectWidth(re2_BoundsRect);
        % dimension
        % Screen('TextSize',windowPtr, 20);
        Screen('DrawText', windowPtr, rating_valence, width / 4 - floor(v_insWidth / 2), rates(1) - floor(v_insHeight / 2), white);
        Screen('DrawText', windowPtr, rating_intensity, width / 4 - floor(i_insWidth / 2), rates(2) - floor(i_insHeight / 2), white);
        Screen('DrawText', windowPtr, rating_familarity, width / 4 - floor(f_insWidth / 2), rates(3) - floor(f_insHeight / 2), white);
        Screen('DrawText', windowPtr, rating_edibility, width / 4 - floor(e_insWidth / 2), rates(4) - floor(e_insHeight / 2), white);
        % labels of the rating
        Screen('TextSize', windowPtr, 22);
        Screen('DrawText', windowPtr, rating_v1, line_left - floor(rv1_Width / 2), 5 * height / 16 - floor(rv1_Height / 2), yellow);
        Screen('DrawText', windowPtr, rating_v2, line_right - floor(rv2_Width / 2), 5 * height / 16 - floor(rv1_Height / 2), yellow);
        Screen('DrawText', windowPtr, rating_i1, line_left - floor(ri1_Width / 2), 7 * height / 16 - floor(ri1_Height / 2), yellow);
        Screen('DrawText', windowPtr, rating_i2, line_right - floor(ri2_Width / 2), 7 * height / 16 - floor(ri1_Height / 2), yellow);
        Screen('DrawText', windowPtr, rating_f1, line_left - floor(rf1_Width / 2), 9 * height / 16 - floor(rf1_Height / 2), yellow);
        Screen('DrawText', windowPtr, rating_f2, line_right - floor(rf2_Width / 2), 9 * height / 16 - floor(rf1_Height / 2), yellow);
        Screen('DrawText', windowPtr, rating_e1, line_left - floor(re1_Width / 2), 11 * height / 16 - floor(re1_Height / 2), yellow);
        Screen('DrawText', windowPtr, rating_e2, line_right - floor(re2_Width / 2), 11 * height / 16 - floor(re1_Height / 2), yellow);

    case 'si'
        % define positions
        rate_num = 1;        
        rates = (height / 8) * 4;  
        % rating page
        rating_valence = double('相似度');
        v_insBoundsRect = Screen('TextBounds', windowPtr, rating_valence);
        v_insWidth = RectWidth(v_insBoundsRect);
        v_insHeight = RectHeight(v_insBoundsRect);
        % labels
        rating_v1 = double('非常相似');
        rating_v2 = double('非常不同');
        rv1_BoundsRect = Screen('TextBounds', windowPtr, rating_v1);
        rv1_Width = RectWidth(rv1_BoundsRect);
        rv1_Height = RectHeight(rv1_BoundsRect);
        rv2_BoundsRect = Screen('TextBounds', windowPtr, rating_v2);
        rv2_Width = RectWidth(rv2_BoundsRect);
        % dimension
        % Screen('TextSize',windowPtr, 20);
        Screen('DrawText', windowPtr, rating_valence, width / 4 - floor(v_insWidth / 2), rates(1) - floor(v_insHeight / 2), white);
        % labels of the rating
        Screen('TextSize', windowPtr, 22);
        Screen('DrawText', windowPtr, rating_v1, line_left - floor(rv1_Width / 2), 7 * height / 16 - floor(rv1_Height / 2), yellow);
        Screen('DrawText', windowPtr, rating_v2, line_right - floor(rv2_Width / 2), 7 * height / 16 - floor(rv1_Height / 2), yellow);              
        
    otherwise
        error('Should be vi or si');
end

% lines and ticks
ratingbarxys(1, :) = repmat([line_left line_right], 1, rate_num);
ratingbarxys(2, :) = kron(rates,ones(1,2));
ratingcorxys(1, :) = repmat(kron(tick_pos, ones(1,2)), 1, rate_num) - floor(line_width / 2);
ratingcorxys(2, :) = reshape(kron([rates-10;rates],ones(1,tick_num)),1,[]);
% instruction
Screen('TextSize', windowPtr, 25);
Screen('DrawText', windowPtr, rating_instruction, centerx - floor(rating_insWidth / 2), centery / 4 - floor(rating_insHeight / 2), white);
% confirm
Screen('DrawText', windowPtr, msg_certain, centerx - floor(msg_certainWidth / 2), 11 * height / 12 - floor(msg_certainHeight / 2), white);
Screen('FrameRect', windowPtr, white, [centerx - floor(msg_certainWidth / 2) - 10, 11 * height / 12 - floor(msg_certainHeight / 2) - 10, centerx + floor(msg_certainWidth / 2) + 10, 11 * height / 12 + floor(msg_certainHeight / 2) + 10], 2);
% lines and ticks
Screen('DrawLines', windowPtr, ratingbarxys, line_width, white);
Screen('DrawLines', windowPtr, ratingcorxys, tick_width, white);

% get ratings
ShowCursor('Hand', windowPtr);
Screen('Flip', windowPtr);
bodyimage = Screen('GetImage', windowPtr, []);
ratingbody = Screen('MakeTexture', windowPtr, bodyimage);

% initiate variables
rallxs = cell(1, rate_num);
rectlables_vif = 1:rate_num;
ratingresults_vif = zeros(1, rate_num);

% define rating region
srm(:, 1) = line_left*ones(rate_num,1);
srm(:, 3) = line_right*ones(rate_num,1);
srm(:, 2) = rates'-10;
srm(:, 4) = rates'+10;

% get mouse
while true
    [x, y, buttons] = GetMouse(windowPtr);
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
    % any other click on confirm
    % buttons(2) on mac but buttons(3) on win for right click
    elseif ~buttons(1) && any(buttons) && IsInRect(x, y, [centerx - floor(msg_certainWidth / 2) - 10, 11 * height / 12 - floor(msg_certainHeight / 2) - 10, centerx + floor(msg_certainWidth / 2) + 10, 11 * height / 12 + floor(msg_certainHeight / 2) + 10])
        % the same odor again
        again = 1;
        break;
    end
end
    % return ratings
    ratings = ratingresults_vif;
    HideCursor;
end
