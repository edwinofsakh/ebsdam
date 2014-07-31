clear all, close all;
ebsd = p01_load();close all;
% ebsd = cutEBSD(ebsd, 0,0, 20,20);
grains = getGrains(ebsd('Fe'), 5*degree, 20);
disp('Start check boundary!')
parent_v2_prepare('p01', grains, 'V1', 'OR:V1, GD: 5,20');
parent_v2_prepare('p01', grains, 'KS', 'OR:KS, GD: 5,20');
disp('Stop check boundary!')

clear all, close all;
ebsd = p02_load();close all;
% ebsd = cutEBSD(ebsd, 0,0, 20,20);
grains = getGrains(ebsd('Fe'), 5*degree, 20);
disp('Start check boundary!')
parent_v2_prepare('p02', grains, 'V1', 'OR:V1, GD: 5,20');
parent_v2_prepare('p02', grains, 'KS', 'OR:KS, GD: 5,20');
disp('Stop check boundary!')
