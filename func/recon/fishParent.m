function [op] = fishParent(ebsd, cr, sid, w1, vv, w2)
% Find parent austenite orientation for 'fish' samples. Function used for
% cropped EBSD data containing only one prior austenite grain.
%
% Use: findUniqueParent
% Used in: test0002.m, viewParent
%

%% Preparation
outdir = checkDir('fish','res', 1);
comment = getComment();

sr = 1; % save results
fc = 1; % close figure

% Plot main view of EBSD data
if (isdebug)
    figure;
    plot(ebsd,'antipodal','r',zvector);
    saveimg(sr,fc,outdir,sid,'ebsd','png',comment);
end

%% Filtration
% Remove points having "bad" values of properies. Use ImageQuality,
% ConfidenceIndex and Fit values. For IQ and CI more is better, for Fit
% opposite, so 'md' is used.

par = {'iq','ci','fit'};
md   = [   0,   0,    1];

v = cell(1,3);  % property values
vm = cell(1,3); % modified property values
h = zeros(1,3); % highest value
l = zeros(1,3); % lowest value

% Normalize properties
for i = 1:length(par)
    v{i} = get(ebsd,par{i});
    h(i) = max(v{i});
    l(i) = min(v{i});
    if (md(i) == 1)
        vm{i} = 1-((v{i}-l(i))/(h(i)-l(i)));
    else
        vm{i} = (v{i}-l(i))/(h(i)-l(i));
    end
end

% Plot normalized properties
if (isfulldebug)
    for i = 1:length(par)
        figure;
        plot(ebsd,'property',vm{i})
        saveimg(sr,fc,outdir,sid,['par_' par{i}],'png',comment);
    end
end

% Filtration parameter
q = vm{1}.*vm{2}.*vm{3};

% Plot filtration parameter
if (isfulldebug)
    figure;
    plot(ebsd,'property',q,'antipodal','r',zvector);
    saveimg(sr,fc,outdir,sid,'par_q','png',comment);
end

% Plot good points
if (isdebug)
    figure;
    plot(ebsd(q > cr),'antipodal','r',zvector);
    saveimg(sr,fc,outdir,sid,'ebsd_good','png',comment);
end

%% Get grains for good data

% Plot all orientation
o = get(ebsd,'orientation');
if (isdebug)
    figure;
    plotAllOrientations(o);
    saveimg(sr,fc,outdir,sid,'ori_all','png',comment);
end

% Get and plot only good orientation
grains = getGrains(ebsd(q>cr), 1.5*degree, 1,'unitcell');

o = get(grains,'mean');
wf = grainSize(grains);

if (isdebug)
    figure;
    plotAllOrientations(o);
    saveimg(sr,fc,outdir,sid,'ori_best','png',comment);
end

clear grains;

%% Reconstruction

% Find parent orientation for good orientations
[Pmax, PR, opf, gind, op, vnum] = findUniqueParent(o, wf, getOR('M1'), w1*degree, vv, w2*degree, 1.5, 'combineClose');

% For success reconstruction plot real and calculation children orientation
if (isa(opf, 'orientation'))
    CS = symmetry('m-3m');
    [oo, ooi] = getVariants(opf, getOR('M1'), CS);
    
    figure;
    plotAllOrientations(opf, 'MarkerColor', 'g'); hold on;
    plotAllOrientations(oo); hold off;
    saveimg(sr,fc,outdir,sid,'op_trans','png',comment);
    
%     a = mat2cell(oo,ones(1,24),1);
%     b = repmat([0 0 1], 24,1);
%     b = mat2cell(b,ones(1,24),3);
%     c = [a b];
%     d = reshape(c',1,24*2);
%     
%     figure;
%     plot(ebsd_f('Fe'),'colorcoding', 'orientations',d, 'halfwidth',5*degree);
%     saveimg(sr,fc,outdir,sid,'ebsd_rec','png',comment);
    
end

% Plot parent orientation variants
figure;
plotAllOrientations(op);
saveimg(sr,fc,outdir,sid,'op_all','png',comment);

figure;
plotipdf(op,xvector, 'antipodal', 'MarkerSize', 2);
annotate([Miller(1,0,0),Miller(1,1,0),Miller(1,1,1),Miller(1,1,2)],'all','labeled');
saveimg(sr,fc,outdir,sid,'op_ipdf_x','png',comment);

figure;
plotipdf(op,yvector, 'antipodal', 'MarkerSize', 2);
annotate([Miller(1,0,0),Miller(1,1,0),Miller(1,1,1),Miller(1,1,2)],'all','labeled');
saveimg(sr,fc,outdir,sid,'op_ipdf_y','png',comment);

figure;
plotipdf(op,zvector, 'antipodal', 'MarkerSize', 2);
annotate([Miller(1,0,0),Miller(1,1,0),Miller(1,1,1),Miller(1,1,2)],'all','labeled');
saveimg(sr,fc,outdir,sid,'op_ipdf_z','png',comment);

[v1, v2] = ori2hkl(mean(op))
mean(op)