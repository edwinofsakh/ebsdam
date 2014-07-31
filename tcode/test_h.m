close all; [X, Y] = hgridGrains(5, [8 2 1], 1, 2, 'display');
ebsd = Grid2EBSD(X,Y,400,'crop', 'area',[-0.25 0.25 -0.25 0.25]);
plot(ebsd, 'antipodal');

viewSizes('h001',0,ebsd,1,1,0, 'noIntersect', 'saveres', 'flatsave');
viewSizes('h002',0,ebsd,1,1,0, 'noIntersect', 'removeBoxGrain', 'saveres', 'flatsave');
