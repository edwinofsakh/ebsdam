close all;
N = 32;
S = 25;

% [X, Y] = gridGrains(N, sqrt(3)/2*5, 0.0, S/2, 'dev', 0.1, 'display', 'tick_off');
% ebsd = Grid2EBSD(X,Y, S, 'omega', 0*degree);
% 
% viewSizes( 'rnd400', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres');
% 
% [X, Y] = gridGrains(N, sqrt(3)/2*5, 0.0, S/2, 'dev', 0.1, 'display', 'tick_off');
% ebsd = Grid2EBSD(X,Y, S, 'omega', 45*degree);
% 
% viewSizes( 'rnd401', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres');
% 
% [X, Y] = gridGrains(N, sqrt(3)/2*5, 0.0, S/2, 'dev', 0.1, 'display', 'tick_off');
% ebsd = Grid2EBSD(X,Y, S, 'omega', 45*degree);
% 
% viewSizes( 'rnd402', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'rndIntersect');
% 
% [X, Y] = gridGrains(N, sqrt(3)/2*5, 0.0, S/2, 'dev', 0.1, 'display', 'tick_off');
% ebsd = Grid2EBSD(X,Y, S, 'omega', 45*degree);
% 
% viewSizes( 'rnd403', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'rndIntersect');
% 
% [X, Y] = gridGrains(N, sqrt(3)/2*5, 0.0, S/2, 'dev', 0.1, 'display', 'tick_off');
% ebsd = Grid2EBSD(X,Y, S, 'omega', 45*degree);
% 
% viewSizes( 'rnd404', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'rndIntersect', 'numIntersect', 300);

[X, Y] = gridGrains(N, sqrt(3)/2, 0.5, S/2, 'dev', 0.1, 'display', 'tick_off', 'point', 200);
ebsd = Grid2EBSD(X,Y, S, 'omega', 0*degree);

viewSizes( 'rnd500', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres');