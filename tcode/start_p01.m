clear all, close all;

ebsd = p01_load();

grains = getGrains(ebsd('Fe'), 5*degree, 20);