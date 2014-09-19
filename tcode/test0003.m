close all;
N = 32;
Np = 3;

[X, Y, in] = gridPriorGrains(N, Np, sqrt(3)/2, 0.5, 'dev', 0.8);
ebsd = Grid2EBSD(X,Y, 20, 'prior', in);

grains = getGrains(ebsd, 0.1*degree, 0, 'unitcell');

numel(grains)

plot(ebsd); hold on;
plotBoundary(grains); hold off;

figure;
paint_boundary3(grains, 'KS', 1, 0, 'pkg', 'del');

%%
ebsd = cutEBSD(ebsd,0,0,12,16);
grains = getGrains(ebsd, 0.1*degree, 0, 'unitcell');


figure;
o = get(grains,'orientation');
plotAllOrientations(o);

[Pmax, PR, opf, gind, op, vnum] = findUniqueParent(o, getOR('KS'), 2*degree, 4, 5*degree, 1.5);

if (isa(opf, 'orientation'))
    CS = symmetry('m-3m');
    [oo, ooi] = getVariants(opf, getOR('M1'), CS);
    
    figure;
    plotAllOrientations(opf, 'MarkerColor', 'g'); hold on;
    plotAllOrientations(oo); hold off;
end

figure;
plotAllOrientations(op);