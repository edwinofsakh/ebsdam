% Draw orientation, CI, IQ and others maps
clear all;
close all;

angle = 5;
small = 5;
ci_cor = 0;

DirOut = '.\img\s02_grains';

if ~exist (DirOut, 'dir')
    mkdir (DirOut);
end

ebsd = s02_load();

% Remove bad point
if ci_cor
    % extract the quantity mad
    ci = get (ebsd, 'ci');

    % eliminate all meassurements with MAD larger then one
    ebsd = delete (ebsd, ci>1)
else
    ebsd = ebsd;
end

[grains,ebsd] = calcGrains (ebsd, 'threshold',angle*degree, 'angletype','disorientation')

% remove small grain
large_grains = grains (grainsize (grains) >= small);
ebsd = ebsd(large_grains);

clear largeGrains;

[grains, ebsd] = calcGrains (ebsd, 'threshold',angle*degree, 'angletype','disorientation')

gs = grainsize (grains);

% logarifm axe of grain size (first bar for size < e^0.5 ~ 1.6)
bins = exp (0 : 0.5 : log (max (gs)));

% grain size histogram (corrected)
figure();
bar (hist (gs, bins));
savefigure ([DirOut '\s02_gsize_c.png']);
close;

% plot corrected grain in 'ipdf'
figure();
plot (grains, 'antipodal', 'r',zvector);
savefigure ([DirOut '\s02_grain_a_c.png']);
close;

% plot corrected grain in 'hkl'
figure();
plot (grains, 'antipodal', 'r',zvector, 'colorcoding','hkl');
savefigure ([DirOut '\s02_grain_a_c_hkl.png']);
close;
