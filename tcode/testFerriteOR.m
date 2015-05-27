%% Full data
ebsd = loadEBSD([getpref('ebsdam','data_dir') '\15K_ishod.ang']);

%% First part
ebsd1 = cutEBSD(ebsd, 0,0,185,84);
grains1 = calcGrains(ebsd1, 'threshold', 2*degree);
grains1_fe = grains1('Iron - Alpha');
gs1 = grainSize(grains1_fe);
grains1_fe_big = calcGrains(grains1_fe(gs1 > 50), 'threshold', 2*degree);
mori1 = calcBoundaryMisorientationBig(grains1_fe_big, 'ext');

%% Second part
ebsd2 = cutEBSD(ebsd, 0,84,185,84);
grains2 = calcGrains(ebsd2, 'threshold', 2*degree);
grains2_fe = grains2('Iron - Alpha');
gs2 = grainSize(grains2_fe);
grains2_fe_big = calcGrains(grains2_fe(gs2 > 50), 'threshold', 2*degree);
mori2 = calcBoundaryMisorientationBig(grains2_fe_big, 'ext');

%% Third part
ebsd3 = cutEBSD(ebsd, 0,168,185,84);
grains3 = calcGrains(ebsd3, 'threshold', 2*degree);
grains3_fe = grains3('Iron - Alpha');
gs3 = grainSize(grains3_fe);
grains3_fe_big = calcGrains(grains3_fe(gs3 > 50), 'threshold', 2*degree);
mori3 = calcBoundaryMisorientationBig(grains3_fe_big, 'ext');

%% Combine mori
mori = [mori1; mori2; mori3];
hist(angle(mori)/degree,1:61);

%%
optORm = optimizeOR2(mori, 'fer01', 'full', 'start', 'KS', 'firstView', 'freeSearch', 'removeFar', 'stepIter', [5 2 1], 'maxIter', 2, 'epsilon', [5 5 5]);

%%
% free from M1
[26.2472    9.3163   20.3056] % 6 eps, 8000 points
[26.0982    8.9897   20.3171] % 5 eps, 8000 points

% free from B1
[26.2930    9.0241   20.2369] % 5 eps, 8000 points

% free from KS
[22.7235   10.7888   25.0726] % 5 eps, 8000 points

%% First part mean
ori1 = get(grains1_fe_big,'meanOrientation');
[~,pairs1] = neighbors(grains1_fe_big);
A1 = ori1(pairs1(:,1));
B1 = ori1(pairs1(:,2));
mori1_m = (A1.\B1);

%% Second part mean
ori2 = get(grains2_fe_big,'meanOrientation');
[~,pairs2] = neighbors(grains2_fe_big);
A2 = ori2(pairs2(:,1));
B2 = ori2(pairs2(:,2));
mori2_m = (A2.\B2);

%% Second part mean
ori3 = get(grains3_fe_big,'meanOrientation');
[~,pairs3] = neighbors(grains3_fe_big);
A3 = ori3(pairs3(:,1));
B3 = ori3(pairs3(:,2));
mori3_m = (A3.\B3);

%% Combine mori
mori_m = [mori1_m; mori2_m; mori3_m];
hist(angle(mori_m)/degree,1:61);

%%
optORm = optimizeOR2(mori_m, 'fer01_m', 'full', 'start', 'B1', 'stepSearch', 'removeFar', 'stepIter', [5 2 1]*degree, 'maxIter', 2, 'epsilon', [8 6 4]*degree);

%% Results on mean
% free from M1
OR = [27.5364   11.7857   19.1769];
% step from M1
OR = [27.988144 11.809429 19.101510];

% free from KS
OR = [18.4779   12.2040   25.0726];
% step from KS
OR = [12.203782 7.529378 35.203782];

% free from B1
OR = [28.8140    8.9553   17.6643];
% step from B1
OR = [29.001706 8.899239 17.299755];
