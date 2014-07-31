% Draw all infromation about sample
clear all;
close all;

save = 0;

ebsd = s01_load();

viewMaps('s01', ebsd, save);

viewPhases('s01', ebsd, save);

viewProp('s01', ebsd, 'mad', save);

viewProp('s01', ebsd, 'bc', save);

% viewProp('s02', ebsd, 'v1', save);
% 
% viewProp('s02', ebsd, 'v2', save);