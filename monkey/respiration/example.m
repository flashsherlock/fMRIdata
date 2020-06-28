clear all;close all
load('breath.mat','breath')
inhale = [103; 4284; 10599; 16892; 20776; 23713];
exhale = [708; 4916; 11244; 17623; 21019; 24259];
loopX = max([numel(inhale) numel(exhale)]);
subplot(4,1,1)
plot(breath);
title('target points')
hold on
for i = 1:loopX
    try
        plot(inhale(i),breath(inhale(i)),'r*')
    end
     plot(exhale(i),breath(exhale(i)),'r*')
end
%slope analysis
subplot(4,1,2);hold on
ind=findchangepts(breath,'Statistic','linear','MinThreshold',0.5)
plot(breath)
title('changepoints, calculated with minthreshold=0.5')
plot(ind,breath(ind),'rx')
subplot(4,1,3)
values=breath(ind);
%remove changepts with negative slope
dx=diff(ind);
dy=diff(breath(ind));
slope=dy./dx;
plot(slope)
thres=1e-4; %set minimum slope
a=find(slope>thres)
i_start=ind(a);
i_end=ind(a+1);
subplot(4,1,3);hold on
plot(breath,'b')
title('changepoints with slope > threshold')
plot(i_start,breath(i_start),'rx',...
    i_end,breath(i_end),'rx')
%remove changepts between start and end of inhalation process
b=find(i_start(2:end)==i_end(1:end-1))
i_end(b)=[];
i_start(b+1)=[];
subplot(4,1,4);hold on
title('removed intermediate points')
plot(breath,'b')
plot(i_start,breath(i_start),'rx',...
    i_end,breath(i_end),'rx')