function awake = nc_findawake(name)
    % return anesthetic trials (1:awake(1)) and awake trials (awake(2):awake(3))
    % awake(1):awake(2) not sure
    % get file name
    switch name
        case 's02'
            % 105trials 2*3*5 anesthetic
            awake = [30 31 105];
        case 's03'
            % 150trials 2*3*5 anesthetic
            awake = [15 16 150];
        case 's04'
            % 195trials 6*3*5 anesthetic
            awake = [90 91 195];
        otherwise
            awake = 0;
    end

end
