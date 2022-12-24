function plotsigx( x, p, colors, ystart, line_wid)
% plot hline indicating significant x
if nargin < 5
    line_wid = 1;
end
cri = 0.05;
hold on
for i = 1:size(p,1)
    x(p(i,:) >= cri) = nan;
    y = ystart(i)*ones(size(x));
    h = plot(x,y,'Color',colors(i,:),'linewidth', line_wid);
    % the following line skip the name of the previous plot from the legend
    h.Annotation.LegendInformation.IconDisplayStyle = 'off';
end

end

