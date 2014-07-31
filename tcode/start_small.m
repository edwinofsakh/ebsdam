clear all, close all;
ebsd_full = s01_load();
ebsd = cutEBSD(ebsd_full, 0,0, 100,50);
ebsd_Fe = ebsd('Fe'),
grains = getGrains(ebsd_Fe, 3*degree, 20);