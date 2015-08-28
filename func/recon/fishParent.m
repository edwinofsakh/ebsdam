function [op] = fishParent(ebsd, ORmat, cr, sid, rid, w1, vv, w2, PRmin)
% Find parent austenite orientation for 'fish' samples. Function used for
% cropped EBSD data containing only one prior austenite grain.
%
% Use: findUniqueParent
% Used in: test0002.m, viewParent
%

%% Preparation
saveres = getpref('ebsdam','saveResult');
outdir  = checkDir(sid,'parent', saveres);
comment = getComment();

prefix = [sid '_' rid];

sr = 1; % save results
fc = 1; % close figure

% ORmat = getOR('M1');

% Plot main view of EBSD data
if (isdebug)
    figure;
    plot(ebsd,'antipodal','r',zvector);
    saveimg(sr,fc,outdir,prefix,'ebsd','png',comment);
end

%% Filtration
% Remove points having "bad" values of properies. Use ImageQuality,
% ConfidenceIndex and Fit values. For IQ and CI more is better, for Fit
% opposite, so 'md' is used.


[ebsd_f, vm, q, par] = CIFilter(ebsd, cr);

% Plot normalized properties
if (isfulldebug)
    for i = 1:length(par)
        figure;
        plot(ebsd,'property',vm{i})
        saveimg(sr,fc,outdir,prefix,['par_' par{i}],'png',comment);
    end
end

% Plot filtration parameter
if (isfulldebug)
    figure;
    plot(ebsd,'property',q,'antipodal','r',zvector);
    saveimg(sr,fc,outdir,prefix,'par_q','png',comment);
end

% Plot good points
if (isdebug)
    figure;
    plot(ebsd_f,'antipodal','r',zvector);
    saveimg(sr,fc,outdir,prefix,'ebsd_good','png',comment);
end

%% Get grains for good data

% Plot all orientation
o = get(ebsd,'orientation');
if (isdebug)
    figure;
    plotAllOrientations(o);
    saveimg(sr,fc,outdir,prefix,'ori_all','png',comment);
end

% Get and plot only good orientation
grains = getGrains(ebsd_f, 1.5*degree, 1,'unitcell');

o = get(grains,'mean');
wf = grainSize(grains);

if (isdebug)
    figure;
    plotAllOrientations(o);
    saveimg(sr,fc,outdir,prefix,'ori_best','png',comment);
end

clear grains ebsd ebsd_f;

%% Reconstruction

% Find parent orientation for good orientations
[Pmax, PR, opf, gind, op, vnum] = findUniqueParent(o, wf, ORmat, w1*degree, vv, w2*degree, PRmin, 'combineClose');

% For success reconstruction plot real and calculation children orientation
if (isa(opf, 'orientation'))
    CS = symmetry('m-3m');
    [oo, ooi] = getVariants(opf, ORmat, CS);
    
    figure;
    plotAllOrientations(o,   'MarkerColor', 'b'); hold on;
    plotAllOrientations(opf, 'MarkerColor', 'g'); hold on;
    plotAllOrientations(oo,  'MarkerColor', 'r'); hold off;
    saveimg(sr,fc,outdir,prefix,'op_trans','png',comment);       
end

% Plot parent orientation variants
figure;
plotAllOrientations(op);
saveimg(sr,fc,outdir,prefix,'op_all','png',comment);

figure;
plotipdf(op,xvector, 'antipodal', 'MarkerSize', 2);
annotate([Miller(1,0,0),Miller(1,1,0),Miller(1,1,1),Miller(1,1,2)],'all','labeled');
saveimg(sr,fc,outdir,prefix,'op_ipdf_x','png',comment);

figure;
plotipdf(op,yvector, 'antipodal', 'MarkerSize', 2);
annotate([Miller(1,0,0),Miller(1,1,0),Miller(1,1,1),Miller(1,1,2)],'all','labeled');
saveimg(sr,fc,outdir,prefix,'op_ipdf_y','png',comment);

figure;
plotipdf(op,zvector, 'antipodal', 'MarkerSize', 2);
annotate([Miller(1,0,0),Miller(1,1,0),Miller(1,1,1),Miller(1,1,2)],'all','labeled');
saveimg(sr,fc,outdir,prefix,'op_ipdf_z','png',comment);

[v1, v2] = ori2hkl(mean(op))
mean(op)