% Testing new functions

OR = getOR('KS');

CS = symmetry('m-3m');
SS = symmetry('1');

% ORo = orientation('matrix', OR, CS, SS);
ORo = rotation('matrix', OR);
o1 = orientation('Euler', 0, 0, 0, CS, CS);
o2 = orientation('matrix', OR, CS, CS);
os = symmetrise(ORo*o1);
% plotpdf(ORo*symmetrise(o1), Miller(1,0,0), 'antipodal', 'MarkerSize', 6, 'complete');
figure;
plot(symmetrise(o2)*vector3d(1,0,0), 'antipodal', 'MarkerSize', 6, 'complete');
figure;
plot(symmetrise(o2)*vector3d(1,1,0), 'antipodal', 'MarkerSize', 6, 'complete');
figure;
plot(symmetrise(o2)*vector3d(1,1,1), 'antipodal', 'MarkerSize', 6, 'complete');

return
ebsd = s01_load();

ebsd = cutEBSD (ebsd, 0,0, 100,100);

grains = getGrains(ebsd('Fe'), 3*degree, 4);

% Mean orientation of grains
o = get(grains, 'mean');

% Pairs of grains
[~, pairs] = neighbors(grains);

% Misorientation between grains
m = getMis (o, pairs);

% Number of grains
n = numel(grains);

c = 0;
for i = 1:n
    nn = getNeighbors(i, pairs);
    if (length(nn) > 4)
        c = c + 1;
    end
end

display([num2str(c) '/' num2str(n)]);