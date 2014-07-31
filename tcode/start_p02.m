clear all, close all;
ebsd = p02_load();
grains = getGrains(ebsd('Fe'), 5*degree, 20);