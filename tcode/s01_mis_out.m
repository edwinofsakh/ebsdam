clear all;
close all;

angle = 5;
small = 5;
ma    = 10;

% specify crystal and specimen symmetry
CS = {...
  symmetry('cubic'),... % crystal symmetry phase austenite
  symmetry('cubic'),... % crystal symmetry phase ferrite
  symmetry('cubic')};   % crystal symmetry phase cementit

SS = symmetry('-1');   % specimen symmetry

% file name
fname = './data/export_bainite_1.txt';

ebsd = loadEBSD(fname,CS,SS,'interface','generic',...
  'ColumnNames', { 'Phase' 'x' 'y' 'Euler 1' 'Euler 2' 'Euler 3' 'Mad' 'BC'},...
  'Columns', [1 2 3 4 5 6 7 8],...
  'ignorePhase', [1 3], 'Bunge');

% extract the quantity mad
mad = get(ebsd,'mad');

% eliminate all meassurements with MAD larger then one
ebsd_corrected = delete(ebsd,mad>1);

% Grain
[grains,ebsd_corrected] = segment2d(ebsd_corrected,'angle',angle*degree);
large_grains = grains(grainsize(grains) >= small);
ebsd_corrected = link(ebsd_corrected,large_grains);
[grains_corrected,ebsd_corrected] = segment2d(ebsd_corrected,'angle',angle*degree);

% Misorientation Out
ebsd_mis_n_c = misorientation(grains_corrected);

% step = 2*degree;
% max = 70*degree;
% x = step/2 : step : max-step/2;
% 
% figure();
% hist(ebsd_mis_n_c,x);
% 
% figure();
% plotboundary(grains_corrected,'property','colorcoding','hkl')
% 
% figure();
% odf_mis_n_c = calcODF(ebsd_mis_n_c,'phase',1,'exact')
% plotipdf(odf_mis_n_c,vector3d(0,0,1))

figure();
plot(ebsd,'property','bc')

figure();
plot(grains,'property',shapefactor(grains))

% figure();
% grain_selection = find(grains_corrected,CSL(3),ma*degree,'misorientation')
% plotboundary(grain_selection,'property',CSL(3))
% 
% figure();
% rot = rotation('axis',vector3d(1,1,1),'angle',60*degree);
% plotboundary(grains_corrected,'property',rot)

% figure();
% odf_selection = calcODF(grain_selection,'phase',1,'silent');
% plotpdf(odf_selection,[Miller(1,0,0) Miller(1,1,0) Miller(1,1,1)],'antipodal',...
%   'position',[100 100 600 300])
