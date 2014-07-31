function plotow( o, a )
%plotow Plot fixed orientation and weight
%   Detailed explanation goes here

[ou,wu] = calcWeight(o,a);
% wm = max(wu);
% c = ceil(wm/5);
c = 2;
cmap = copper();
plotpdf(ou(wu<=c),Miller(1,0,0),'antipodal','property',wu(wu<=c),'markersize',2,'grid');
hold on;
plotpdf(ou(wu>c),Miller(1,0,0),'antipodal','property',wu(wu>c),'markersize',2,'grid');
colormap(cmap(end:-1:1,:));
colorbar;
hold off;
% plot(ou,'antipodal','property',wu,'markersize',2,'grid','RODRIGUES');
% ee = get(ou,'Euler');
% scatter3(ee(:,1),ee(:,2),ee(:,3),20,wu,'filled');