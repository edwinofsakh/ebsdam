% Draw all infromation about sample
clear all;
close all;

save = 1;

ebsd = p02_load();

viewMaps('p02', ebsd, save);

viewPhases('p02', ebsd, save);

viewProp('p02', ebsd, 'mad', save);

viewProp('p02', ebsd, 'bc', save);


grains = getGrains(ebsd('Fe'), 5*degree, 20);
plot(grains, 'antipodal')
savefigure('.\img\p02_grains\p02_grains.png');
close;