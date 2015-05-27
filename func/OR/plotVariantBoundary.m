function plotVariantBoundary(grains, optOR, i, d)

lw = 1.2;
clr = 'b';

[~,~,dis] = calcKOG3(optOR);

reorder = JapanOrder();
dis_j = dis(reorder);

plotBoundary(grains, 'linecolor','k', 'linewidth',lw, 'antipodal', 'ext');
hold on;
plotBoundary(grains, 'property',rotation(dis_j(i-1)), 'linecolor',clr, 'linewidth',lw, 'delta',d, 'antipodal', 'ext');
hold off;