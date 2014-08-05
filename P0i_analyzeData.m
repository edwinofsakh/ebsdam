function P0i_analyzeData(thr, mgsum, epsilon)
% thr - grain detection threshold in degree
% mgsum - grain detection minimal grain size in um2
% epsilon - angular tolerance for KOG finding

%% Options
% Save results on disk
saveres = 1;

% Samples' id
samples = {'p01','p02', 'p03', 'p04','p06','p08','p08','p08'};

% Number of parts in sample (to prevent out of memory)
parts = [1,1,1,1,1,1,1,1];

% Skip samples (set 1 to skip sample)
skip = [1,1,1,1,1,0,1,1];

% Crop rectangle from EBSD data (set '0' to disable croppping)
nsize = {...
    %  x    y   dx   dy   
    [0,   0, 216, 108],... % 
    [0, 108, 216, 108],... % 
    [150, 150, 100, 100],... % 
    [100, 100, 150, 180],... % p04
    [0, 150, 127, 80],... % p06
    [0, 0, 95, 62],... % p08
    [0, 62, 95, 62],... % p08
    [0, 124, 95, 62],... % p08
 };
 nsize = 0;

% Main tasks list
tasklist = {...
    'doMaps',   0,... % Plot orientation map
    'doPhases', 0,... % Analyze phases
    'doProps',  0,... % Analyze properties like BC, MAD
    'doGrains', 1,... % Analyze grains and misorientation between them
    'doSizes',  1,... % Analyze grains size
};

% Detail grain task list
gtasklist = {...
    'doGrainsMap',          1,... % grains map (removing small grains)
    'doGrainsMapAll',       1,... % all grains map (small and large)
    'doGrainsMapLrg',       1,... % large grains map
    'doBndHighAngle',       1,... % high angle boundary on BC map
    'doBndKOG',             1,... % non KOG boundary
    'doBndKOGPkg',          1,... % package boundary
    'doBndKOGBain',         1,... % bain group bondary
    'doBndIntFull',         1,... % internal boundary for all grains
    'doBndInt',             1,... % internal boundary for grains
    'doBndExtRange',        1,... % range map for ext boundary
    'doBndAllRange',        1,... % range map for all boundary
    'doBndAngle',           1,... % misorientation angle map
    'doHistMis2Mean',       0,... % in grain misorientation histogram
    'doHistAllBndMis',      1,... % misorientation on boundary
    'doHistAllBndMisSmall', 1,... % misorientation on boundary low angles
    'doHistMeanMis',        0,... % misorientation between grains
    'doHistMeanMisSmall',   0,... % misorientation between grains low angles
    'doHistNearKOG',        1,... % variant selection spectrum
};

%% Processing
viewSamples( samples, parts, skip, thr, mgsum, epsilon, saveres, tasklist, gtasklist, nsize);
