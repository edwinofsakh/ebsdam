% clear all;
close all;

angle = 5;
small = 20;

% specify crystal and specimen symmetry
CS = {...
  symmetry('m-3m'),... % crystal symmetry phase austenite
  symmetry('m-3m'),... % crystal symmetry phase ferrite
  symmetry('m-3m')};   % crystal symmetry phase cementit

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
% 
% step = 2*degree;
% max = 70*degree;
% x = step/2 : step : max-step/2;
% 
% figure();
% hist(ebsd_mis_n_c,x);

% figure();
% plot(ebsd)
% pos = {'position',[100 100 400 250]};
% colorbar(pos{:})
% 
% figure();
% plot(ebsd_mis_n_c)
% colorbar(pos{:})
% 
% figure();
% plotboundary(grains_corrected,'property','colorcoding','hkl')
% colorbar(pos{:})

f = figure();
plotboundary(grains_corrected,'property','colorcoding','angle')
% colorbar(pos{:})

% figure();
% plot(ebsd)
% hold on
% plotboundary(grains_corrected,'property','colorcoding','hkl')
% hold off
% 
% figure();
% plotspatial(ebsd,'r',vector3d('polar',pi/6,pi/8))
% hold on
% plotboundary(grains_corrected,'property','colorcoding','hkl')
% hold off
