function respplot( resp4s, semresp4s, p, colors, limx, savepath)
% plot respiration
if nargin<6
    save=0;
else
    save=1;
end
if nargin<5
    limx=[0 1500];
end
f1 = figure('position',[40,40,600,300]);
hold on
% number of conditions
num = size(resp4s,1);
alltime = size(resp4s,2);
x=1:alltime;
x=x/1000;
limx=limx/1000;
% plot a horizontal line at 0
f0 = plot([limx(1) limx(2)],[0 0],'k--','linewidth', 0.5);
f0.Annotation.LegendInformation.IconDisplayStyle = 'off';
% plot respiration
for con_i = 1:num
    stdshade(resp4s(con_i,:),1.96*semresp4s(con_i,:),0.2,hex2rgb(colors(1,con_i)),x); 
end
set(gca,'xlim',limx);
xlabel('Time (s)')
ylabel('Normalized respiration')
set(gca, 'FontSize', 18);
% pot p
cri = 0.05;
ystart = 0.5;
for i = 1:size(p,1)
    x(p(i,:) >= cri) = nan;
    y = ystart(i)*ones(size(x));
    if size(p,1)==1
        f2 = plot(x,y,'Color',hex2rgb('#000000'),'linewidth', 1);
    else
        f2 = plot(x,y,'Color',hex2rgb(colors(1,i)),'linewidth', 1);
    end
    % the following line skip the name of the previous plot from the legend
    f2.Annotation.LegendInformation.IconDisplayStyle = 'off';
end
if size(colors,1)>1
    legend(colors(2,:), 'Location', 'eastoutside')
end
if save~=0
    saveas(f1, savepath)
end
end