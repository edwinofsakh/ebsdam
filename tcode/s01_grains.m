clear all;
close all;

angle = 5;
small = 9;
mad_cor = 0;

% specify crystal and specimen symmetry
CS = symmetry('cubic'); % crystal symmetry phase ferrite
SS = symmetry('1');   % specimen symmetry

% file name
fname = './data/export_bainite_1.txt';

% view all phase
ebsd_raw = loadEBSD(fname,CS,SS,'interface','generic',...
  'ColumnNames', { 'Phase' 'x' 'y' 'Euler 1' 'Euler 2' 'Euler 3' 'Mad' 'BC'},...
  'Columns', [1 2 3 4 5 6 7 8],...
  'ignorePhase', [1 3], 'Bunge');

if mad_cor
    % extract the quantity mad
    mad = get(ebsd_raw,'mad');

    % eliminate all meassurements with MAD larger then one
    ebsd_mad = delete(ebsd_raw,mad>1)
else
    ebsd_mad = ebsd_raw;
end

[grains,ebsd] = segment2d(ebsd_mad,'angle',angle*degree,'antipodal','angletype','disorientation' )

% Original Grain
figure();
plot(grains,'antipodal');
colorbar

figure();
plot(grains,'antipodal','colorcoding','bunge');

gs = grainsize(grains);
bins = exp(0:0.5:log( max(gs) ));

% logarifm axe of grain size
% first bar for size < e^0.5 ~ 1.6
figure();
bar( hist(gs,bins) );

% Remove small grain
large_grains = grains(grainsize(grains) >= small);
ebsd_corrected = link(ebsd,large_grains);
[grains_corrected,ebsd_corrected] = segment2d(ebsd_corrected,'angle',angle*degree,'antipodal','angletype','disorientation' )


gs = grainsize(grains_corrected);
bins = exp(0:0.5:log( max(gs) ));
figure();
bar( hist(gs,bins) );

% Corrected Grain
figure();
plot(grains_corrected,'antipodal');

figure();
plot(grains_corrected,'antipodal','colorcoding','bunge');
