% Draw all infromation about sample
clear all;
close all;

save = 1;

ebsd = p01_load();

viewMaps('p01', ebsd, save);

viewPhases('p01', ebsd, save);

viewProp('p01', ebsd, 'mad', save);

viewProp('p01', ebsd, 'bc', save);

grains = getGrains(ebsd('Fe'), 5*degree, 20);
plot(grains, 'antipodal')
savefigure('.\img\p01_grains\p01_grains.png');
close;