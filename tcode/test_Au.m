
g1 = findByLocation(grains, [50 5]);
g2 = findByLocation(grains, [38 6]);
g3 = findByLocation(grains, [40 15]);
g4 = findByLocation(grains, [30 18]);
g5 = findByLocation(grains, [50 20]);
g6 = findByLocation(grains, [20 15]);
g7 = findByLocation(grains, [30 44]);
g8 = findByLocation(grains, [50 45]);

%g = [g1 g2 g3 g4 g5 g6 g7 g8];

% plot(grains), hold on, plot(g1), plot(g2), plot(g3), plot(g4), ...
%     plot(g5), plot(g6), plot(g7), plot(g8), hold off;

o1 = get(g1, 'orientation');
o2 = get(g2, 'orientation');
o3 = get(g3, 'orientation');
o4 = get(g4, 'orientation');
o5 = get(g5, 'orientation');
o6 = get(g6, 'orientation');
o7 = get(g7, 'orientation');
o8 = get(g8, 'orientation');

%oo = [o1 o2 o3 o4 o5 o6 o7 o8];

% plot(o1), hold on, plot(o2), plot(o3), plot(o4), plot(o5), plot(o6),...
%     plot(o7), plot(o8), hold off;

figure;

plot(o1,'antipodal'); hold on;
plot(o5,'antipodal'); hold on;
plot(o7,'antipodal'); hold on;
plot(o8,'antipodal'); hold off;


figure;
plotpdf(o1,Miller(1,0,0),'antipodal'); hold on;
plotpdf(o5,Miller(1,0,0),'antipodal'); hold on;
plotpdf(o7,Miller(1,0,0),'antipodal'); hold on;
plotpdf(o8,Miller(1,0,0),'antipodal'); hold off;

figure;
oa = get(ebsd('Au'), 'orientation');
[oau,wau] = calcWeight(oa,5);
oam = mean(oau(wau>5));
% oam = oau(wau == max(wau));
plotpdf(oa,Miller(1,0,0),'antipodal')
hold on;
plotpdf(oau,Miller(1,0,0),'antipodal');
hold on;
plotpdf(oam,Miller(1,0,0),'antipodal');
hold off;

OR = getOR('KS');
ORo = rotation('matrix', OR);
ORoa =  rotation(get(o1,'CS')) * ORo;
ORoa = orientation(ORoa, get(o1,'CS'),get(o1,'SS'));

[~,~,dis,~] = calcKOG_new('KS');
figure;
plotpdf(oam*ORoa,Miller(1,0,0),'antipodal'); hold on;
plotpdf(oam*ORoa,Miller(1,0,0),'antipodal'); hold on;
plotpdf(oam,Miller(1,0,0),'antipodal'); hold on;
plotpdf(get(grains,'Orientation'),Miller(1,0,0),'antipodal'); hold off;

