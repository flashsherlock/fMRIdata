% load('subject1_2.mat')
m=eeg.trial{1,1}(39:42,:);
range=5000:55000;
figure
subplot(4,1,1)
plot(m(1,range))
set(gca, 'yLim', [0 4e6]);
title(eeg.label(39))

subplot(4,1,2)
plot(m(2,range))
set(gca, 'yLim', [0 4e6]);
title(eeg.label(40))

subplot(4,1,3)
plot(m(3,range))
set(gca, 'yLim', [0 4e6]);
title(eeg.label(41))

subplot(4,1,4)
plot(m(4,range))
title(eeg.label(42))