close all;
N = 20;
dev = 2*degree;

thr = 4*degree;
Nv  = 4;
w0  = 5*degree;
w11  = 1*degree;
w12  = 2*degree;
w2  = 2*degree;
PRm = 1.4;

[X, Y, in, in_xy] = gridPriorGrains(N, sqrt(3)/2, 0.5, 'dev', 0.6);
[ebsd, ori0] = Grid2EBSD(X,Y, 20, 'prior', in, 'crop', 'center', 'dev', dev);
plotpdf(ori0,Miller(1,0,0), 'antipodal', 'MarkerSize',4);

ori0

grains = getGrains(ebsd, 0.05*degree, 0, 'unitcell');

plot(ebsd); hold on;
plotBoundary(grains); hold off;

figure;
paint_boundary3(grains, 'KS', 2, 0, 'pkg', 'del');

o = get(grains, 'mean');
[~,pairs] = neighbors(grains);

if (isdebug)
    for i = 1:3
        grains_sub = findbyLocation(grains, [X(in{i}), Y(in{i})]);

        figure;
        plot(grains_sub);

        figure;
        o_sub = get(grains_sub, 'mean');
        plotpdf(o_sub,Miller(1,0,0), 'antipodal', 'MarkerSize',4);
    end
end
% 
% % [ gf, opp ] = recon_new2( grains, 'M1', 1.5*degree, 4, 1.2, 5*degree, 5*degree);

ORmat = getOR('KS');

[ frg_info ] = findPriorGrains(grains, ORmat, thr, Nv, PRm, w0, w11, w12, w2, 'onlyFirst', 'combineClose');

colorFragments(grains, frg_info{1});

figure;
plotpdf(frg_info{2},Miller(1,0,0),'antipodal');

frg_info{2}