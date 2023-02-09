function odor_present( block )
% parameters
description={'TTL1  Indole  Unpleasant';
    'TTL2  Isovaleric acid(low concentrition)  Unpleasant';
    'TTL3  Isovaleric acid(high concentrition)  Unpleasant';
    'TTL4  Peach  Pleasant';
    'TTL5  Banana  Pleasant';
    'TTL6  Air'};
channel = [1 2 4 8 16 32];
close = 7;% could send marker
% trials
trials = zeros(4,15);
trials(1,:) = [1 4 2 5 3 4 1 5 2 4 3 5 2 1 3];
trials(2,:) = [5 1 4 3 5 3 1 4 2 1 2 5 3 4 2];
trials(3,:) = [3 4 1 2 5 3 4 2 1 5 1 2 4 3 5];
trials(4,:) = [4 3 1 5 2 1 5 3 4 2 5 3 1 2 4];

% open port
port='COM6';
delete(instrfindall('Type','serial'));
s = serial(port, 'BaudRate',115200);
fopen(s); 

% present air for 15s first
disp(['block: ' num2str(block)])
disp(description{6})
% fwrite(s, channel(6));
pause(15)
% present odors
seq = trials(block,:);
for trial_i=1:length(seq)
    % trial start marker
    fwrite(s,close);
    pause(0.5)
    fwrite(s,0);
    pause(0.5)
    % odor 7s
    disp(description{seq(trial_i)})
    fwrite(s, channel(seq(trial_i)));
    pause(7)
    % air 13s
    disp(description{6})
    fwrite(s, channel(6));
    pause(13)
end
% close
fwrite(s,0);
fclose(s);
end

