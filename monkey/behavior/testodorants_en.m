channel=[1 2 4 7 8];
testchamber(0);
description={'TTL1  Indole  Unpleasant';
    'TTL2  Isovaleric acid(low concentrition)  Unpleasant';
    'TTL3  Isovaleric acid(high concentrition)  Unpleasant';
    'TTL4  Peach  Pleasant';
    'TTL5  Banana  Pleasant'};
for i=1:5
    testchamber(channel(i))
    clc;
    disp(description{i});
    pause(5);
    testchamber(10);
    clc;
    disp('TTL6  Air');
    pause(10);
end
testchamber(0);
clc;
disp('Chambers are closed');