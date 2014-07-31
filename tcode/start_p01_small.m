clear all, close all;

ebsd = p01_load();

ebsd_cut = cutEBSD(ebsd('Fe'), 150,0, 50,50);

grains = getGrains(ebsd_cut('Fe'), 5*degree, 30);