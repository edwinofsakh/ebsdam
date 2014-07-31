CS = symmetry('m-3m');
SS = symmetry('1');

[~,~,dis,~] = calcKOG_new('KS');
OR = getOR('KS');

ORr_g2a = rotation('matrix', OR);
ORr_a2g = rotation('matrix', OR');

ORo_g2a = orientation('matrix', OR, CS, CS);
ORo_a2g = orientation('matrix', inv(OR), CS, CS);

% figure;
% plotpdf(ORo_g2a,Miller(1,0,0),'antipodal','complete','MarkerSize',3);
% figure;
% plotpdf(ORo_a2g,Miller(1,0,0),'antipodal','complete','MarkerSize',3);

ORra_g2a =  rotation(CS) * ORr_g2a;
ORra_a2g =  rotation(CS) * ORr_a2g;

% figure;
% plotpdf(orientation(ORra_g2a,SS,SS),Miller(1,0,0),'antipodal','complete','MarkerSize',3);
% figure;
% plotpdf(orientation(ORra_g2a,SS,SS),Miller(0,1,0),'antipodal','complete','MarkerSize',3);
% figure;
% plotpdf(orientation(ORra_g2a,SS,SS),Miller(0,0,1),'antipodal','complete','MarkerSize',3);
% figure;
% plotpdf(orientation(ORra_a2g,SS,SS),Miller(1,0,0),'antipodal','complete','MarkerSize',3);
% figure;
% plotpdf(orientation(ORra_a2g,SS,SS),Miller(0,1,0),'antipodal','complete','MarkerSize',3);
% figure;
% plotpdf(orientation(ORra_a2g,SS,SS),Miller(0,0,1),'antipodal','complete','MarkerSize',3);

% g0 = findByLocation(grains, [50 20]);
g0 = findByLocation(grains, [40 20]);
g0_id = find(g0);

o0_a = get(g0,'mean');

% figure;
% plotpdf(orientation(ORra_a2g * rotation(o0_a),CS,SS),Miller(1,0,0),'antipodal','complete','MarkerSize',3); hold on;
% % plotpdf(o0_a,Miller(0,0,1),'antipodal','complete','MarkerSize',3); hold off;
% 
% figure;
% plotpdf(orientation(ORra_g2a * rotation(o0_a),CS,SS),Miller(1,0,0),'antipodal','complete','MarkerSize',3); hold on;
% % plotpdf(o0_a,Miller(0,0,1),'antipodal','complete','MarkerSize',3); hold off;

v0 = 1;
delta = 12;

[b,v] = find_parent( grains, ORra_a2g, v0, o0_a, delta );

oo1 = get(grains(logical(b)),'mean');
oo2 = ORra_a2g(v(logical(b))) .* oo1;

oo2m = mean(oo2);
oo1m = ORra_g2a(v0) * oo2m;

figure;
plotpdf(oo1,Miller(1,0,0),'antipodal','complete','MarkerSize',3);
figure;
plotpdf(oo2,Miller(1,0,0),'antipodal','complete','MarkerSize',3);
hold on;
plotpdf(oo2m,Miller(1,0,0),'antipodal','complete','MarkerSize',3);
hold off;

% [b,v] = find_parent( grains, ORra_a2g, v0, oo1m, delta );
% 
% oo1 = get(grains(logical(b)),'mean');
% oo2 = ORra_a2g(v(logical(b))) .* oo1;
% 
% figure;
% plotpdf(oo1,Miller(1,0,0),'antipodal','complete','MarkerSize',3);
% figure;
% plotpdf(oo2,Miller(1,0,0),'antipodal','complete','MarkerSize',3);