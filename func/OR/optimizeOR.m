function [best_OR, x,f, ma1, ma2] = optimizeOR( sid, part, ebsd, grains, save, thrd, mgs, epsd )
% Find optimal orientation relationship for list
%   Draw orientation maps
%
% Syntax
%   [best_OR, x,f, ma1, ma2] = optimizeOR( sid, part, ebsd, grains, save, thrd, mgs, epsd )
%
% Output
%   best_OR - name of best OR
%   x       - histogram edges
%   f       - fraction of misorientation from KOG (nx, nKOG)
%   ma1     - N/A
%   ma2     - minimal 
%
% Input
%   sid     - sample id: 's01', 's02', 's03', 's04' , 't01'
%   part    - number of parts
%   ebsd    - EBSD data if 0, try load useing function "[sid '_load']"
%   save    - save image to disk
%   thrd    - boundary detection threshold, in degree
%   mgs     - grain's size threshold (lesser grains deleted), in point
%   epsd    - KOG thershold in degree
%
% History
% 16.11.12  Original implementation.
% 06.12.12  Add 'epsd'. Save histogramm to disk.
% 21.03.13  Only 'external' boundaries are taken into account.
% 14.04.13  Add saveing of comment.
% 16.04.13  Separate 'thr' in degree and radian.

%% Settings
ma1 = 0;

% Max angle for ploting
amax = 12;

% List of orientation relation
names = {'KS', 'NW', 'M1', 'M2', 'B1', 'B2', 'B3'};
n = length(names);

%% Preparation
disp('Optimize OR:');

OutDir = checkDir(sid, 'grains', save);

comment = getComment();

if ~isa(grains, 'Grain2d')
    ebsd = checkEBSD(sid, ebsd, 'Fe');

    % Get grains
    grains = getGrains(ebsd, thr, mgs)
end

ma2 = zeros(1,n);

% Boundary misorientation
% mori = calcBoundaryMisorientation(grains, 'ext');
% np = length(mori);

% Angle between misorientation and KOG for all OR, in degree
a = cell(n,1);

% Histogram edges
x = 0:0.5:amax;
xf = 0:0.5:65;
nx = length(x);

% Calc angles
f = zeros(nx,n);
for i = 1:n   
    [~,ma2(i),a{i}] = fracKOG(grains, epsd, names{i}, 0);
    aa = a{i};
    aa = aa(aa < epsd);
    f(:,i) = histc(aa, x);
    fprintf(1,'.');
end
np = length(a{1});
f = f/np*100;

a = cell2mat(a)';

[~,best_OR] = min(ma2);

best_OR = names{best_OR};

% Plot
figure();
cmap = colormap(hsv(n));
for i = 1:n
    plot(x,f(:,i),'o','MarkerEdgeColor',cmap(i,:)); hold on;
end
for i = 1:n
    ff = fit(x',f(:,i),'smoothingspline');
    %ff = fit(x',f(:,i),'cubicinterp');
    p = plot(ff);
    set(p, 'Color',cmap(i,:), 'LineWidth', 2);
    hold on;
end
hold off;

% legend([names cellfun(@(x) [x ' fitted'], names, 'UniformOutput',false)]);
legend(names);
title('Deviation from KOG for different ORs');
xlabel('Misorientation angle in degree');
ylabel('%');
ylim = get(gca,'Ylim');
ylim(1) = 0;
set(gca,'Ylim',ylim);

prefix = [sid '_' num2str(part) '_kog_' num2str(thrd) '_' num2str(mgs) '_' num2str(epsd)];

figure;
saveimg( save, 1, OutDir, prefix, 'opt_OR', 'png', comment);

saveopt( x, f, names, save, OutDir, prefix, 'opt_OR', comment);

% Full 
f = histc(a, xf)/np*100;
plot(xf,f, 'LineWidth', 2)
legend(names);
title('Deviation from KOG for different ORs (Full)');

figure;
saveimg( save, 1, OutDir, prefix, 'opt_OR_full', 'png', comment);

saveopt( xf, f, names, save, OutDir, prefix, 'opt_OR_full', comment);

% % Pairs of grains
% [~, pairs] = neighbors(grains);
% 
% % Mean orientation of grains
% o = get(grains, 'mean');
% 
% % Get misorientation
% m = getMis( o, pairs );
% 
% % Calculate misorenation between variants of oreintation relation.
% [~,~,dis,~] = calcKOG_new(OR_name);
% 
% % Number of variants
% nv = length(dis);

