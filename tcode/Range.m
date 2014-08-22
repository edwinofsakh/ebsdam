ebsd = ses01_load();
sid = 'ses01';
grains = getGrains(ebsd, 2*degree, 4);
plotx2north();
outdir = getpref('ebsdam','output_dir');
figure; plotBndRange( grains, 0, 0, 1, outdir, [sid '_rng01'], 'all', [ 2  5  15], [0 0.8 0; 0.2 0.2 1; 0 0 0], 'GridOff');
figure; plot(ebsd, 'property', 'iq', 'GridOff'); colormap(gray); hold on; plotBndRange( grains, 0, 0, 0, outdir, [sid '_rng02'], 'all', [ 2  5  15], [0 0.8 0; 0.2 0.2 1; 0 0 0], 'GridOff'); hold off;