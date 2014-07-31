%% History

%% Cube Grid
% close all;
% N = 32;
% S = 20;
% 
% [X, Y] = gridGrains(N, 1, 0, S/2, 'dev', 0.0, 'display', 'tick_off');
% ebsd = Grid2EBSD(X,Y, S, 'omega', 0*degree);
% k = 1;
%
% viewSizes( 'tcube0010', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'LengthCor', k);
% viewSizes( 'tcube0011', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'removeBoxGrain', 'LengthCor', k);
% 
% a = 15*degree;
% ebsd = Grid2EBSD(X,Y, S, 'omega', a);
% k = 1/(sin(a)+cos(a));
% 
% viewSizes( 'tcube0020', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'LengthCor', k);
% viewSizes( 'tcube0021', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'removeBoxGrain', 'LengthCor', k);
% 
% a = 45*degree;
% ebsd = Grid2EBSD(X,Y, S, 'omega', a);
% k = 1/(sin(a)+cos(a));
% 
% viewSizes( 'tcube0030', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'LengthCor', k);
% viewSizes( 'tcube0031', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'removeBoxGrain', 'LengthCor', k);

%% Cube Grid Random Line
% close all;
% N = 32;
% S = 20;
% 
% [X, Y] = gridGrains(N, 1, 0, S/2, 'dev', 0.0, 'display', 'tick_off');
% ebsd = Grid2EBSD(X,Y, S, 'omega', 0*degree);
% 
% viewSizes( 'tcube0110', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'rndIntersect');
% 
% a = 15*degree;
% ebsd = Grid2EBSD(X,Y, S, 'omega', a);
% k = 1/(sin(a)+cos(a));
% 
% viewSizes( 'tcube0120', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'LengthCor', k, 'rndIntersect');
% 
% a = 45*degree;
% ebsd = Grid2EBSD(X,Y, S, 'omega', a);
% k = 1/(sin(a)+cos(a));
% 
% viewSizes( 'tcube0130', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'LengthCor', k, 'rndIntersect');

%% Hex Grid
% close all;
% N = 32;
% S = 20;
% 
% [X, Y] = gridGrains(N, sqrt(3)/2, 0.5, S/2, 'dev', 0.0, 'display', 'tick_off');
% ebsd = Grid2EBSD(X,Y, S, 'omega', 0*degree);
% 
% viewSizes( 'thex0010', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres');
% viewSizes( 'thex0011', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'removeBoxGrain');
% 
% ebsd = Grid2EBSD(X,Y, S, 'omega', 15*degree);
% 
% viewSizes( 'thex0020', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres');
% viewSizes( 'thex0021', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'removeBoxGrain');
% 
% ebsd = Grid2EBSD(X,Y, S, 'omega', 45*degree);
% 
% viewSizes( 'thex0030', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres');
% viewSizes( 'thex0031', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'removeBoxGrain');


%% Hex Grid Random Line
% close all;
% N = 32;
% S = 20;
% 
% [X, Y] = gridGrains(N, sqrt(3)/2, 0.5, S/2, 'dev', 0.0, 'display', 'tick_off');
% ebsd = Grid2EBSD(X,Y, S, 'omega', 0*degree);
% 
% viewSizes( 'thex0012', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'rndIntersect');
% 
% ebsd = Grid2EBSD(X,Y, S, 'omega', 15*degree);
% 
% viewSizes( 'thex0022', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'rndIntersect');
% 
% ebsd = Grid2EBSD(X,Y, S, 'omega', 45*degree);
% 
% viewSizes( 'thex0032', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'rndIntersect');

%% Modified Hex Grid
% close all;
% N = 32;
% S = 20;
% 
% [X, Y] = gridGrains(N, 2*sqrt(3)/2, 0.5, S/2, 'dev', 0.0, 'display', 'tick_off');
% ebsd = Grid2EBSD(X,Y, S, 'omega', 0*degree);
% 
% viewSizes( 'thex0110', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres');
% viewSizes( 'thex0111', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'removeBoxGrain');
% 
% ebsd = Grid2EBSD(X,Y, S, 'omega', 15*degree);
% 
% viewSizes( 'thex0120', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres');
% viewSizes( 'thex0121', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'removeBoxGrain');
% 
% ebsd = Grid2EBSD(X,Y, S, 'omega', 45*degree);
% 
% viewSizes( 'thex0130', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres');
% viewSizes( 'thex0131', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'removeBoxGrain');

%% Modified Hex Grid Random Line
% close all;
% N = 32;
% S = 20;
% 
% [X, Y] = gridGrains(N, 2*sqrt(3)/2, 0.5, S/2, 'dev', 0.0, 'display', 'tick_off');
% ebsd = Grid2EBSD(X,Y, S, 'omega', 0*degree);
% 
% viewSizes( 'thex0210', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'rndIntersect');
% 
% ebsd = Grid2EBSD(X,Y, S, 'omega', 15*degree);
% 
% viewSizes( 'thex0220', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'rndIntersect');
% 
% ebsd = Grid2EBSD(X,Y, S, 'omega', 45*degree);
% 
% viewSizes( 'thex0230', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'rndIntersect');

%% Hex Grid div
% close all;
% N = 32;
% S = 20;
% 
% [X, Y] = gridGrains(N, sqrt(3)/2, 0.5, S/2, 'dev', 0.2, 'display', 'tick_off');
% ebsd = Grid2EBSD(X,Y, S, 'omega', 0*degree);
% 
% viewSizes( 'thex1010', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres');
% viewSizes( 'thex1011', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'removeBoxGrain');
% viewSizes( 'thex1012', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'rndIntersect');
% 
% ebsd = Grid2EBSD(X,Y, S, 'omega', 15*degree);
% 
% viewSizes( 'thex1020', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres');
% viewSizes( 'thex1021', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'removeBoxGrain');
% viewSizes( 'thex1022', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'rndIntersect');
% 
% ebsd = Grid2EBSD(X,Y, S, 'omega', 45*degree);
% 
% viewSizes( 'thex1030', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres');
% viewSizes( 'thex1031', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'removeBoxGrain');
% viewSizes( 'thex1032', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'rndIntersect');

%% Hex Grid high div
close all;
N = 32;
S = 20;

[X, Y] = gridGrains(N, sqrt(3)/2, 0.5, S/2, 'dev', 0.4, 'display', 'tick_off');
ebsd = Grid2EBSD(X,Y, S, 'omega', 0*degree);

viewSizes( 'thex1010', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres');
viewSizes( 'thex1011', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'removeBoxGrain');
viewSizes( 'thex1012', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'rndIntersect');

ebsd = Grid2EBSD(X,Y, S, 'omega', 15*degree);

viewSizes( 'thex1020', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres');
viewSizes( 'thex1021', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'removeBoxGrain');
viewSizes( 'thex1022', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'rndIntersect');

ebsd = Grid2EBSD(X,Y, S, 'omega', 45*degree);

viewSizes( 'thex1030', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres');
viewSizes( 'thex1031', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'removeBoxGrain');
viewSizes( 'thex1032', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'rndIntersect');

%% Other
% [X, Y] = gridGrains(N, sqrt(3)/2, 0.5, S/2, 'dev', 0.0, 'display', 'tick_off', 'rnd', 0);
% %[X, Y] = hgridGrains(7, [9 3 2], 1, 2, 'display');
% ebsd = Grid2EBSD(X,Y, S, 'omega', 0*degree);
% %ebsd = Grid2EBSD(X,Y, S, 'omega', 0*degree, 'crop', [-0.25 0.25 -0.25 0.25]);
% 
% grains = getGrains(ebsd, 0.1*degree, 0, 'unitcell');
% 
% viewSizes( 'rndiii1', 0, ebsd, 1, 0.1, 0, 'unitcell', 'saveres', 'noIntersect', 'removeBoxGrain');

