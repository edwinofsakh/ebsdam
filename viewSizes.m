function out = viewSizes( sid, rid, region, ebsd, tasks, varargin ) %#ok<INUSL>
% View information  about grain structure of EBSD.
%   Draw orientation maps
%
% Syntax
%   out = viewSizes( sid, rid, region, ebsd, tasks, varargin )
%
% Output
%   out - output data {'grainSize', ags}
%
% Input
%   sid      - sample id: 's01', 's02', 's03', 's04', 't01', 'p01', 'p02'
%   rid      - region id
%   region   - region coordinate
%   ebsd     - EBSD (all phases) data if 0, try load useing function "[sid '_load']"
%   tasks    - list of tasks
%
% Options:
%   'hierarchy'
%   'removeBad'
%   'smoothGrain'
%   'removeBoxGrain'
%   'extBoundary' - for boundary length and intersect methods
%   'rndIntersect'
%   'numIntersect'
%   'noIntersect'
%   'LengthCor'
%
% History
% 07.12.12  Add description of the function. Rename 'ma' to 'thr', 's' to
%           'mgs'.
% 14.04.13  Add saveing of comment.
% 16.04.13  Separate degree and radian 'thr'.
% 16.05.13  Add automatic intersect method.
% 18.03.14  Remove coefficient in intersect method.
% 26.04.14  New input system. 'THRD', 'MGS', 'EPSD' - from 'varargin'.
% 05.04.14  New output system.
% 22.09.14  Markup.
% 09.02.15 Move to Linux

%% Preparation

saveres = getpref('ebsdam','saveResult');

if check_option(varargin, 'mgs')
    mgs = get_option(varargin, 'mgs');
end
if check_option(varargin, 'thrd')
    thrd = get_option(varargin, 'thrd');
end

varargin = [varargin tasks];

outdir = checkDir(sid, 'sizes', saveres, varargin{:});
ebsd = checkEBSD(sid, ebsd, 'Fe');

% File name prefix
% prefixg = [sid '_' rid '_grains_' num2str(thrd) '_' num2str(mgs) '_x'];
prefixs = [sid '_' rid '_sizes_x_' num2str(mgs) '_x'];
% prefixh = [sid '_' rid '_hist_' num2str(thrd) '_' num2str(mgs) '_x'];

% Do some old jobs
% old_work( ebsd, saveres, thr, mgs, outdir, comment, prefixg, prefixh, varargin{:})

% Grain size vs threshold angle
ags = GrainSize4DifAngle( sid, rid, ebsd, saveres, thrd, mgs, outdir, prefixs, varargin{:});

out = {'grainSize', ags};
end


function ags = GrainSize4DifAngle( sid, rid, ebsd, saveres, thrd, mgs, outdir, prefix, varargin)
% Output diectory for temporary grains map
outdirsec = checkDir(sid, fullfile('sizes','sec'), saveres, varargin{:});

comment = getComment();

% Angle list
if check_option(varargin, 'hierarchy')
    alist = 2:5:22;
else
    alist = thrd;
end

% Average grain size
% 1 - intersect
% 2 - mean area to diameter
% 3 - area fraction
% 4 - equivalent diameter
% 5 - lengthgetGrains
% [ags, aga, agaa, agr, agl];
nn   = length(alist);
ags  = zeros(5,nn);

% boundary length method
agl = boundaryLengthGS(ebsd, thrd, mgs, alist, varargin{:});

% Grain size for different thr angle
for i = 1:nn
    a = alist(i);
    try
        ags(1:4,i) = difGrainSize(sid, rid, ebsd, a, mgs, outdirsec, saveres, varargin{:});
    catch err
        warning(err.message);
    end
end

% Normalize grain size
k = 1; %4/pi;
ags(1,:) = k*ags(1,:);          % intersect
ags(2,:) = 2*sqrt(ags(2,:)/pi); % mean area to diameter
ags(3,:) = ags(3,:);            % equivalent diameter
ags(4,:) = ags(4,:);            % area fraction
ags(5,:) = agl;                 % length

% Plot 
figure;
plot(alist, ags(1,:), alist, ags(2,:), alist, ags(3,:), alist, ags(4,:), alist, ags(5,:));
title('Grain size vs threshold angle');
legend('intersect "1.27*int"', 'from area "2*sqrt(area/pi)"', 'from eq radius "2*er"', 'from areafraction', 'from misori', 'Location','NorthWest');
saveimg( saveres, 1, outdir, prefix, 'thr', 'png', comment );

% Save data 
saveopt( alist, [ags(1,:); ags(2,:); ags(3,:); ags(4,:); ags(5,:)]',...
    {'intersect', 'from area', 'from eq radius', 'from areafraction', 'from misori'},...
    saveres, outdir, prefix, 'thr', comment );
end


function ret = difGrainSize(sid, rid, ebsd, thrd, mgs, outdir, saveres, varargin)

prefix = [sid '_' rid '_grains_' num2str(thrd) '_' num2str(mgs) '_x'];

comment = getComment();

[grains, grains0] = prepareGrains(ebsd, thrd, mgs, varargin{:});

gstat(grains, saveres, outdir, prefix, varargin{:})

ags = IntersectMethod(grains0, thrd, outdir, prefix, varargin{:});

% Mean grain area
ar = area(grains);
aga = mean(ar);

% Mean equivalent grain diameter
d = 2*sqrt(ar/pi);
agr = mean(d);

% Area weighted equivalent grain diameter
agaa = sum(ar.*d)/sum(ar);

% Save RAW area data
% savexy(           dd, af, saveres, outdir, prefix, ['area_frac' num2str(thrd)], 'Area Fraction', comment );
savexy( 1:length(ar), ar, saveres, outdir, prefix, ['area_raw'  num2str(thrd)], 'Area RAW',      comment );

% Form return array
ret = [ags, aga, agr, agaa];
end



function [ags] = IntersectMethod(grains, thrd, outdir, prefix, varargin)
    
comment = getComment();
 
if (check_option(varargin, 'noIntersect'))
    ags = 0;
else
    % Plot map and save it
    if (check_option(varargin, 'extBoundary'))
        figure; plotBoundary(grains, 'ext'); axis off;
        fprintf(1, 'Only ext boundary!\n');
    else
        figure; plotBoundary(grains); axis off;
    end

    saveimg( 1, 1, outdir, prefix, 'sec', 'png', comment );

    % Generate grain map image filename
    fname =  fullfile(outdir, [prefix '_sec.png']);

    % Get ebsd data size for calculate image resolation (um per pixel)
    [~,~,~,~,sx,sy] = getStep(get(grains, 'ebsd'));

    nLine = get_option(varargin, 'numIntersect', 150, 'double');

    % Run intersect method
    if (check_option(varargin, 'rndIntersect'))
        ags = grSizeSec( fname, nLine, [sx sy], 'crop', varargin{:});
    else
        ags = grSizeSec( fname, nLine, [sx sy], 'crop', 'grid', varargin{:});
    end
end
end



function [grains, grains0] = prepareGrains(ebsd, thrd, mgs, varargin)

% Remove bad indexing data
if (check_option(varargin, 'removeBad'))
    if  any(cellfun(@(x) strcmpi(x,'ci'), get(ebsd)))
        ebsd = ebsd(get(ebsd,'CI') > get_option(varargin, 'removeBad', 0.1, 'double'));
        fprintf(1, 'Remove bad indexing data!\n');
    end
end

% Get grains
grains = getGrains(ebsd, thrd*degree, mgs, varargin{:});
grains0 = grains;
fprintf(1, ['Number of grains: ' num2str(numel(grains)) '\n']);

% Smooth grain boundaries
if (check_option(varargin, 'smoothGrain'))
    grains = smooth(grains, get_option(varargin, 'smoothGrain', 1, 'double'));
    fprintf(1, 'Smooth grains!\n');
end

% Remove box grains
if (check_option(varargin, 'removeBoxGrain'))
    [dx,dy,~,~,sx,sy] = getStep(ebsd);
    grains0 = grains;
    grains = removeBoxGrain(grains, sx*sy/200/dx/dy);
    fprintf(1, 'Remove box grain!\n');
    fprintf(1, ['Number of grains: ' num2str(numel(grains)) '\n']);
end
end



function agl = boundaryLengthGS(ebsd, thrd, mgs, alist, varargin)

% Prepare grains
grains = prepareGrains(ebsd, thrd, mgs, varargin{:});

% Get misorientation
if (check_option(varargin, 'extBoundary'))
    mori = calcBoundaryMisorientation(grains, 'ext');
    fprintf(1, 'Only ext boundary!\n');
else
    mori = calcBoundaryMisorientation(grains);
end

% Get angles and area 
ang = angle(mori)/degree;
A = sum(area(grains));

% Calc boundary length
n = length(alist);
c = zeros(1,n);
for i = 1:n;
    c(i) = sum(ang > alist(i));
end

% Boundary length correcction coefficiant
k = pi/4;
if (check_option(varargin, 'LengthCor'))
    k = get_option(varargin, 'LengthCor', pi/4, 'double');
    fprintf(1, 'Set length correction!\n');
end

[dx,dy,nx,ny,~,~] = getStep(ebsd);
dd = (dx+dy)/2;
bl = 0*2*(nx+ny); % Length of working area boundary (not need to use)
c1 = dd*(c*k-bl);
agl = 2*(A)./c1;


% Show grains
if check_option(varargin, 'display')
    figure();
    plot(ebsd); hold on;
    plotBoundary(grains); hold off;
end
% clear grains mori;
end



function old_work( ebsd, saveres, thr, mgs, outdir, comment, prefixg, prefixh, varargin)

grains = getGrains(ebsd, thr, mgs, varargin{:});

figure();
plot(grains,'antipodal',1);
saveimg( saveres, 1, outdir, prefixg, '', 'png', comment );

% Grains' area
ar = area(grains);

% Grains' equivalent radius
er = equivalentradius(grains);

% Grains' shape factor
sf = shapefactor(grains);

% Grains' aspect ratio
as = aspectratio(grains);

disp(['Grains size information for ' prefixg ]);
grainStat(grains, saveres, outdir, prefixh);

% Logarithm scale for grains' area
bins = exp(-1:0.4:log(max(ar)));

% Plot area histogram
figure();
[nlog, xlog] = hist(ar,bins);
bar( xlog, nlog );
saveimg( saveres, 1, outdir, prefixh, 'area', 'png', comment );

savexy( xlog, nlog, saveres, outdir, prefixh, 'area_log', 'Area Disribution (Log)', comment );

[y, x] = hist(ar);
savexy( x, y, saveres, outdir, prefixh, 'area', 'Area Disribution', comment );

savexy( 1:length(ar), ar, saveres, outdir, prefixh, 'area_raw', 'Area RAW', comment );

% Plot equivalent radius histogram
figure();
bins = [0.25 0.5 1 2 4 8 16 32];
bar( hist(er,bins) )
set(gca,'XTickLabel',{'0.25';'0.5';'1';'2';'4';'8';'16';'32'})
title('Radius');
saveimg( saveres, 1, outdir, prefixh, 'radius_log', 'png', comment );

% Plot equivalent radius histogram
figure();
bins = [0.25 0.5 1 2 4 8 16 32];
bins = pi*(bins.*bins);
bar( hist(ar,bins) )
set(gca,'XTickLabel',{'0.25';'0.5';'1';'2';'4';'8';'16';'32'})
title('Area');
saveimg( saveres, 1, outdir, prefixh, 'radius_log_ar', 'png', comment );

% Plot equivalent radius histogram
figure();
bins = 2:2:20;
bar( bins, hist(er,bins) )
saveimg( saveres, 1, outdir, prefixh, 'radius_lin', 'png', comment );
end
