function paint_boundary( grains, OR_name, drawExt)
% paint_boundary Paint boundary close to KOG in different colors
%   Paint boundary misoreintation on which is close to KOG useing 'jet'
%   colormap.
%   grains - MTEX grains set (use getGrains or calcGrains)
%   OR_name - orienarion relation name, specify KOG
%   drawExt - 1 for draw only extern boundary, 0 for draw all boundary

%grains = grains_cut;

% History
% 06.03.13  Move to MTEX 3.3.2: replace 'color' to 'linecolor'.

[~,~,dis,~] = calcKOG3(OR_name);
dis = dis(1:end);

figure();

cmap = colormap(jet(length(dis)));

if (drawExt)
    plotBoundary(grains, 'linecolor','k','linewidth',2,'antipodal','extern');
else
    plotBoundary(grains, 'linecolor','k','linewidth',2,'antipodal');
end;
n = length(dis);
for i = 1:n
    if (drawExt)
        hold on, plotBoundary(grains,'property',rotation(dis(i)),'linecolor',cmap(i,:),'linewidth',2, 'delta', 5*degree, 'antipodal','extern');
    else
        hold on, plotBoundary(grains,'property',rotation(dis(i)),'linecolor',cmap(i,:),'linewidth',2, 'delta', 5*degree, 'antipodal');
    end
    disp([num2str(i), ' - ', num2str(cmap(i,:))]);
end

hold off;

% legend('All', 'V1/V1', 'V1/V2', 'V1/V3', 'V1/V4', 'V1/V5', 'V1/V6',...
%     'V1/V7', 'V1/V8', 'V1/V9', 'V1/V10', 'V1/V11', 'V1/V12', 'V1/V13',...
%     'V1/V14', 'V1/V15', 'V1/V16', 'V1/V17', 'V1/V18', 'V1/V19',...
%     'V1/V20', 'V1/V21', 'V1/V22', 'V1/V23', 'V1/V24', 'Location','EastOutside');