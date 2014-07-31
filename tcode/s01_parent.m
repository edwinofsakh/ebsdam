% History
% 06.03.13  Move to MTEX 3.3.2: replace 'color' to 'linecolor'.

% clear all;
% close all;
% 
% p = path;
% path(p,'func');
% 
% MisAng = 5;
% small = 25;
% PrAng = 10;
% 
% % load data
% ebsd = s01_load();
% 
% ebsd = ebsd('Fe');
% 
% % % extract the quantity mad
% % mad = get(ebsd,'mad');
% % 
% % % eliminate all meassurements with MAD larger then one
% % ebsd_c = ebsd(mad<1);
% 
% % Grain
% grains = calcGrains(ebsd, 'threshold',MisAng*degree, 'antipodal', 'angletype','disorientation');
% large_grains = grains(grainSize(grains) >= small);
% ebsd = ebsd(large_grains);
% grains = calcGrains(ebsd, 'threshold',MisAng*degree, 'antipodal', 'angletype','disorientation');
% 
% figure();
% plot(grains, 'antipodal');

% OR
OR_V1 = [ 0.7174  -0.6952  -0.0450;
          0.6837   0.7150  -0.1464;
          0.1340   0.0742   0.9882; ];
OR_KS = [ 0.7416  -0.6667  -0.0749;
          0.6498   0.7416  -0.1667;
          0.1667   0.0749   0.9832; ];

CS = symmetry('m-3m');
SS = symmetry('-1');

ORo = orientation('matrix', inv(OR_V1), CS, SS);

ORoa = CS * ORo;

% plot(ORoa, 'antipodal');

Dis = inverse(ORoa) * ORoa;
Ang = angle(Dis)/degree;

close all;
figure, hist(reshape(Ang,1,numel(Ang)),120)
figure, hist(Ang(1,:),120)
% Dis = inverse(Sym(1)) * Sym(1);
% for i = 1:length (Sym)
%     for j = 1:length (Sym)
%         D = inverse(Sym(i))* Sym(j);
%         U = find(Dis, D, 1*degree);
%         if ( U == 0)
%             Dis = [Dis, D];
%         end
%     end
% end

return;
figure();
plotBoundary(grains, 'linecolor','r','linewidth',2,'antipodal')
for i = 1:length(Dis)
    hold on, plotBoundary(grains,'property',Dis(i),'linecolor','b','linewidth',2, 'delta', 5*degree, 'antipodal');
end

return;

figure();
plotBoundary(grains,'property','angle','linewidth',1.5);
colorbar;

figure();
plotBoundary(grains);
hold on;
plotBoundary(grains,'property','misorientation','colorcoding','hkl','r',vector3d(1,1,1),...
  'linewidth',1.5);

return
grains_l = grains(grainSize (grains) == max (grainSize (grains)));
G1 = grains_l(1)
%G1 = grains(142);
G1o = get (G1, 'meanOrientation');

[n, pairs] = neighbors(grains);

neighbor_gr = grains(pairs(1,:))

mori = calcBoundaryMisorientation(neighbor_gr);

G1oAll = symmetrise (G1o, symmetry('m-3m'), 'antipodal');
grains_by_orientation = findByOrientation(grains('fe'), G1o, 5*degree)

figure();
plot(G1, 'antipodal');

figure();
plot(grains_by_orientation, 'antipodal')

return
% Misorientation Out
figure();
plotAngleDistribution(grains);
figure();
plotAngleDistribution(grains,'uncorrelated');

return;
% OR
OR_V1 = [ 0.7174  -0.6952  -0.0450;
          0.6837   0.7150  -0.1464;
          0.1340   0.0742   0.9882; ];

OR = OR_V1;

% Symmetry matrix
Sym = cubicsymm();

ORrot = rotation ('matrix', OR);

ORrotAll = symmetrise (ORrot, symmetry('m-3m'));

G1p = ORrot \ G1o;

Gso = get(grains,'orientations');

Gsp = ORrotAll\Gso;

D = inverse(G1p) * Gsp;

D = reshape(D,24,468);

dP = angle(D)/degree;

[C,I] = min(dP,[],1);

S = find(C < PrAng);

figure();
plot(grains(S),'antipodal')

path(p);