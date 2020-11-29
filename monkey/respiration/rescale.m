function y = rescale(x, a, b)
    % rescale - rescale data in [a,b]

    if nargin < 2
        a = 0;
    end

    if nargin < 3
        b = 1;
    end

    m = min(x(:));
    M = max(x(:));

    y = (b - a) * (x - m) / (M - m) + a;
