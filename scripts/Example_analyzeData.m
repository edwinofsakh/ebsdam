function Example_analyzeData(thr, mgsum, epsilon)
% thr - grain detection threshold in degree
% mgsum - grain detection minimal grain size in um2
% epsilon - angular tolerance for KOG finding

%% Options
% Save results on disk
saveres = 1;

% Samples' id
samples = {'p01', 'p02', 'p03', 'p04', 'p05', 'p06', 'p07', 'p08', 'p09'};

% Number of parts in sample (to prevent out of memory)
parts = [1,1,1,1,1,1,1,1,1];

% Skip samples (set 1 to skip sample)
skip = [0,0,0,0,1,0,1,0,1];

% Crop rectangle from EBSD data (set '0' to disable croppping)
nsize = {...
    %  x    y   dx   dy   
    [150, 150, 100, 100],... % p01
    [100,   0, 100, 100],... % p02
    [150, 100, 100, 100],... % p03
    [  0, 100, 100, 100],... % p04
    [  0,   0,  25,  25],... % p05
    [  0,   0, 100, 100],... % p06
    [  0,   0,  25,  25],... % p07
    [  0,   0, 100, 100],... % p08
    [  0,   0,  25,  25],... % p09
};
% nsize = 0;

% Main tasks list
tasklist = {...
    'doMaps',   0,... % Plot orientation map
    'doPhases', 0,... % Analyze phases
    'doProps',  0,... % Analyze properties like BC, MAD
    'doGrains', 0,... % Analyze grains and misorientation between them
    'doSizes',  1,... % Analyze grains size
};

% Detail grain task list
gtasklist = {...
    'doGrainsMap',          0,... % grains map (removing small grains)
    'doGrainsMapAll',       0,... % all grains map (small and large)
    'doGrainsMapLrg',       0,... % large grains map
    'doBndHighAngle',       0,... % high angle boundary on BC map
    'doBndKOG',             1,... % non KOG boundary
    'doBndKOGPkg',          1,... % package boundary
    'doBndKOGBain',         1,... % bain group bondary
    'doBndIntFull',         0,... % internal boundary for all grains
    'doBndInt',             0,... % internal boundary for grains
    'doBndExtRange',        0,... % range map for ext boundary
    'doBndAllRange',        0,... % range map for all boundary
    'doBndAngle',           0,... % misorientation angle map
    'doHistMis2Mean',       0,... % in grain misorientation histogram
    'doHistAllBndMis',      0,... % misorientation on boundary
    'doHistAllBndMisSmall', 0,... % misorientation on boundary low angles
    'doHistMeanMis',        0,... % misorientation between grains
    'doHistMeanMisSmall',   0,... % misorientation between grains low angles
    'doHistNearKOG',        1,... % variant selection spectrum
};

%% Processing
viewSamples( samples, parts, skip, thr, mgsum, epsilon, saveres, tasklist, gtasklist, nsize);
