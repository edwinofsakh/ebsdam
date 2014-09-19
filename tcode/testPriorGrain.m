% Test different algorithm on model of prior grains
% Prior Grain Reconstruction and OR optimization
close all;

% Parameters of prior grain structure
N = 16; % Size of product grains grid
Np = 4; % Size of parent grains grid

sdev = 0.6;      % Spatial deviation (1 close to distance between grain centers)
odev = 0*degree; % Orientation deviation in degree

ORmat = getOR('KS'); % Orientation relation

% Reconstruction parameters
thr  = 4*degree;
Nv   = 4;
w0   = 5*degree;
w11  = 3*degree;
w12  = 0*degree;
w2   = 3*degree;
PRm  = 1.4;

if (1)
    [X, Y, in, in_xy] = gridPriorGrains(N, Np, sqrt(3)/2, 0.5, 'dev', 0.6);
    [ebsd, ori0] = Grid2EBSD(X,Y, 20, 'OR', ORmat, 'prior', in, 'crop', 'none', 'dev', dev);
    plotpdf(ori0,Miller(1,0,0), 'antipodal', 'MarkerSize',4);

    grains = getGrains(ebsd, 0.05*degree, 0, 'unitcell');
    if (0)
        saveResultData('testPriorGrain_save1', 'ebsd', 'ori0', 'grains');
    end
else
    [S, ebsd, ori0, grains] = loadResultData('testPriorGrain_save1', 'ebsd', 'ori0', 'grains');
%     ebsd   = S.ebsd;
%     ori0   = S.ori0;
%     grains = S.grains;
end

% Display prior grains orientations
ori0
% rotation(ori0)

% Plot EBSD map
plot(ebsd); hold on;
plotBoundary(grains); hold off;

% Plot prior boundary
figure;
paint_boundary3(grains, 'KS', 0.5, 0, 'pkg', 'del');

o = get(grains, 'mean');
[~,pairs] = neighbors(grains);

% Plot pole figure for prior grains
if (isdebug)
    for i = 1:length(in)
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

[ frg_info ] = findPriorGrains(grains, ORmat, thr, Nv, PRm, w0, w11, w12, w2,...
    'NeighborsOrder', 3, 'onlyFirst', 'combineClose', 'NOuseWeightFunc', 'refineOri');

colorFragments(grains, frg_info{1});

figure;
plotpdf(frg_info{2},Miller(1,0,0),'antipodal');

frg_info{2}
rotation(frg_info{2})