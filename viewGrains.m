function out = viewGrains( sid, rid, region, ebsd, tasks, varargin ) %#ok<INUSL>
% View information about grain structure of EBSD.
%   View information about grain structure of EBSD.
%
% Syntax
%   out = viewGrains( sid, rid, region, ebsd, tasks, varargin)
%
% Output
%   out - not used
%
% Input
%   sid      - sample id: 's01', 's02', 's03', 's04', 't01', 'p01', 'p02'
%   rid      - region id
%   region   - region coordinate
%   ebsd     - EBSD (all phases) data if 0, try load useing function "[sid '_load']"
%   tasks    - list of tasks
%
% History
% 01.12.12  Add 'tasklist'.
% 06.12.12  Add 'epsilon'.
% 28.12.12  Replace 'mgs' to 'thr' in 'plotBndRange'.
% 06.03.13  Move to MTEX 3.3.2: replace 'color' to 'linecolor'.
% 19.03.13  Remove 'plotAngDist' to separate file.
% 20.03.13  Add 'ext' and 'sub' boundary for 'doHistAllBndMis' and 'doHistAllBndMisSmall'.
% 21.03.13  Add Japanese style variants spectrum for 'doHistNearKOG'.
% 27.03.13  Add comments for 'doHistNearKOG'.
% 14.04.13  Add saveing of comment.
% 16.04.13  Separate degree and radian 'thr'.
% 26.04.14  New input system. 'THRD', 'MGS', 'EPSD' - from 'varargin'.
% 05.04.14  New output system. Replace 'best_OR' to 'optOR'.
% 22.09.14  Add 'getRegionParam' for 'optOR'.

out = {};

varargin = [varargin tasks];

% Check vars
if check_option(varargin, 'mgs')
    mgs = get_option(varargin, 'mgs');
end
if check_option(varargin, 'thrd')
    thrd = get_option(varargin, 'thrd');
end
if check_option(varargin, 'epsd')
    epsd = get_option(varargin, 'epsd');
end

saveres = getpref('ebsdam','saveResult');

% Convert to radian
thr = thrd*degree;
% eps = epsd*degree;

%% Settings
% Angle limit in degree
lmt  = 62;
small_lmt = 12;
hi = 40;

% Best OR, 0 - to find optimal
optOR = get_option(varargin, 'optOR', 'KS');
if isa(optOR, 'cell')
    optOR = getRegionParams( rid, optOR, 'singleArray' );
end

% % Sample information
% sinfo = ['\fontsize{8}Sample:"' sid '".'...
%     'Params: thr=' num2str(thr) '^\circ, mgs=' num2str(mgs)];

%% Tasklist
% Grains map
doGrainsMap     = get_option(varargin,'doGrainsMap',      0);
doGrainsMapAll  = get_option(varargin,'doGrainsMapAll',   0);
doGrainsMapLrg  = get_option(varargin,'doGrainsMapLrg',   0);

% Boundary map
doBndHighOnly   = get_option(varargin,'doBndHighOnly',    0);
doBndHighAngle  = get_option(varargin,'doBndHighAngle',   0);
doBndKOG        = get_option(varargin,'doBndKOG',         0);
doBndKOGPkg     = get_option(varargin,'doBndKOGPkg',      0);
doBndKOGBain    = get_option(varargin,'doBndKOGBain',     0);
doBndIntFull    = get_option(varargin,'doBndIntFull',     0);
doBndInt        = get_option(varargin,'doBndInt',         0);
doBndExtRange   = get_option(varargin,'doBndExtRange',    0);
doBndAllRange   = get_option(varargin,'doBndAllRange',    0);
doBndAngle      = get_option(varargin,'doBndAngle',       0);

% Misoreintation distribution
doHistMis2Mean      = get_option(varargin,'doHistMis2Mean',       0);
doHistAllBndMis     = get_option(varargin,'doHistAllBndMis',      0);
doHistAllBndMisSmall= get_option(varargin,'doHistAllBndMisSmall', 0);
doHistMis           = get_option(varargin,'doHistMis',            0);
doHistMeanMis       = get_option(varargin,'doHistMeanMis',        0);
doHistMeanMisSmall  = get_option(varargin,'doHistMeanMisSmall',   0);
doHistNearKOG       = get_option(varargin,'doHistNearKOG',        0);
doHistNearKOGAll    = get_option(varargin,'doHistNearKOGAll',     0);

% Others
doPlotKAM           = get_option(varargin,'doPlotKAM',            0);
doPlotTwin          = get_option(varargin,'doPlotTwin',           0);

%% Preparation
% File name prefix
prefixg = [sid '_' rid '_grn_' num2str(thrd) '_' num2str(mgs)];
prefixb = [sid '_' rid '_bnd_' num2str(thrd) '_' num2str(mgs)];
prefixk = [sid '_' rid '_kog_' num2str(thrd) '_' num2str(mgs) '_' num2str(epsd)];

% Get output directory
OutDir = checkDir(sid, 'grains', saveres);
comment = getComment();

% Get EBSD data (ebsd_all need for SEM map)
ebsd_all = checkEBSD(sid, ebsd, 0);
ebsd = ebsd_all('Fe');

% Get grains
[grains, grains_full] = getGrains(ebsd, thr, mgs);
if (get_option(varargin,'SmoothGrain', 0) == 1)
    grains = smooth(grains,1);
end

% Find optimal orientation relationship
if (isa(optOR, 'double') && numel(optOR) == 1 && optOR == 0)
    optOR = optimizeOR( sid, part, ebsd, grains, saveres, thrd, mgs, epsd );
    disp(['Best OR = ' optOR]);
end

optORn = nameOR(optOR);

%% Plotting grains
% Plot grains map
if doGrainsMap
    figure();
    plot(grains,'antipodal',1);
    saveimg( saveres, 1, OutDir, prefixg, 'map', 'png', comment);
end

% Plot all grains map
if doGrainsMapAll
    if (mgs > 0)
        figure();
        plot(grains_full,'antipodal',1);
        saveimg( saveres, 1, OutDir, prefixg, 'map_all', 'png', comment);
    end
end

% Plot big grains map
if doGrainsMapLrg
	if (mgs > 0) %#ok<ALIGN>
        large_grains = grains_full(grainSize(grains_full) >= mgs);
        figure();
        plot(large_grains,'antipodal',1);
        saveimg( saveres, 1, OutDir, prefixg, 'map_lrg', 'png', comment);
    end
end

%% Plotting boundary map
% Plot high angle boundary only
if doBndHighOnly
    figure();
    plotBoundary(grains,'property',[hi 70]*degree,'linecolor','k','linewidth',0.8);
    saveimg( saveres, 1, OutDir, prefixg, 'map_hi_only', 'png', comment);
end

% Plot high angle boundary on IQ
if doBndHighAngle
    if (any(cellfun(@(x) strcmpi(x, 'IQ'), get(ebsd_all))))
        figure();
        plot(ebsd_all, 'property', 'IQ');
        colormap(gray);
%         hold on
%         plotBoundary(grains,'linecolor','w','linewidth',1);
        hold on
        plotBoundary(grains,'property',[hi 70]*degree,'linecolor','k','linewidth',1);
        saveimg( saveres, 1, OutDir, prefixg, 'map_hi', 'png', comment);
    end
end

% Plot KOG
if doBndKOG
    figure();
    paint_boundary3(grains,optOR,epsd,'ext','hi-lo','del');
    saveimg( saveres, 1, OutDir, prefixk, ['a_' optORn '_del'], 'png', comment);
end

% Plot KOG - Packages
if doBndKOGPkg
    figure();
    paint_boundary3(grains,optOR,epsd,'ext','pkg','gray');
    saveimg( saveres, 1, OutDir, prefixk, ['a_' optORn '_p_gray'], 'png', comment);
end

% Plot KOG - Bain groups
if doBndKOGBain
    figure();
    paint_boundary3(grains,optOR,epsd,'ext','bain','gray');
    saveimg( saveres, 1, OutDir, prefixk, ['a_' optORn '_b_gray'], 'png', comment);
end


% Plot internal boundary for all grains
if doBndIntFull
    figure();
    plotBoundary(grains_full,'external')
    hold on, plotBoundary(grains_full,'internal','linecolor', 'r')

    saveimg( saveres, 1, OutDir, prefixb, 'internal_full', 'png', comment);
end

% Plot internal boundary
if doBndInt
    figure();
    plotBoundary(grains,'external')
    hold on, plotBoundary(grains,'internal','linecolor', 'r')
    
    saveimg( saveres, 1, OutDir, prefixb, 'internal', 'png', comment);
end

% Plot ext boundary colored by mis-angle range
if doBndExtRange
    plotBndRange( grains, thr, saveres, 1, OutDir, prefixb, 'ext', [ 2  5  15], [0.8 0.8 0.8; 0.5 0.5 0.5; 0 0 0], 'GridOff');
end

% Plot all boundary colored by mis-angle range
if doBndAllRange
    plotBndRange( grains, thr, saveres, 1, OutDir, prefixb, 'allbnd', [ 2  5  15], [0.8 0.8 0.8; 0.5 0.5 0.5; 0 0 0], 'GridOff');
end

% Plot boundary colored by mis-angle 
if doBndAngle
    figure();
    plotBoundary(grains, 'property', 'angle', 'extern', 'linewidth',1);
    saveimg( saveres, 1, OutDir, prefixb, 'angle', 'png', comment);
end

%% Plotting misoreintation distribution
% Plot mis2mean
if doHistMis2Mean
    fname = 'mis2mean';
    title1 = 'Misorientation inside grains';
    
    figure();
    % get the misorientations to mean
    mori = get(grains,'mis2mean');

    plotAngDist(mori, small_lmt, saveres, OutDir, prefixb, fname, title1 );
end

% Plot all boundary misorientation angle
if doHistAllBndMis
    fname = 'angdist_bnd_all';
    title1 = 'All boundary misorientation';
    
    mori = calcBoundaryMisorientation(grains);
    plotAngDist(mori, lmt, saveres, OutDir, prefixb, fname, title1 );
    
%     TESTING 'calcBoundaryMisorientation' for 'sub' and 'ext'
    fname = 'angdist_bnd_sub';
    title1 = 'Sub boundary misorientation';
    mori = calcBoundaryMisorientation(grains, 'sub');
    plotAngDist(mori, lmt, saveres, OutDir, prefixb, fname, title1 );

    fname = 'angdist_bnd_ext';
    title1 = 'Ext boundary misorientation';
    mori = calcBoundaryMisorientation(grains, 'ext');
    plotAngDist(mori, lmt, saveres, OutDir, prefixb, fname, title1 );
end

%% Plot all boundary misorientation angle for small angle
if doHistAllBndMisSmall
    fname = 'angdist_bnd_all_small';
    title1 = 'All boundary misorientation for small angles';
    
    mori = calcBoundaryMisorientation(grains);
    plotAngDist(mori, small_lmt, saveres, OutDir, prefixb, fname, title1 );
    
%     TESTING 'calcBoundaryMisorientation' for 'sub' and 'ext'
    fname = 'angdist_bnd_sub_small';
    title1 = 'Sub boundary misorientation';
    mori = calcBoundaryMisorientation(grains, 'sub');
    plotAngDist(mori, small_lmt, saveres, OutDir, prefixb, fname, title1 );

    fname = 'angdist_bnd_ext_small';
    title1 = 'Ext boundary misorientation';
    mori = calcBoundaryMisorientation(grains, 'ext');
    plotAngDist(mori, small_lmt, saveres, OutDir, prefixb, fname, title1 );
end

%% Plot neightbored measurment misorientation
if doHistMis
    fname = 'angdist';
    title1 = 'Misorientation between neightbored measurments';
    
    mori = calcMisorientation(grains, 'uncorrelated');
    plotAngDist(mori, lmt, saveres, OutDir, prefixb, fname, title1 );
end

%% Plot mean grains' orientation misoreintation
if doHistMeanMis
    fname = 'angdist_mean';
    title1 = 'Misoreantion between mean grains'' orientation';
    
    mori = getMeanMis(grains);
    plotAngDist(mori, lmt, saveres, OutDir, prefixb, fname, title1 );
end

%% Plot mean grains' orientation misoreintation for small angle
if doHistMeanMisSmall
    fname = 'angdist_mean_small';
    title1 = 'Misoreantion between mean grains'' orientation for small angle';
    
    mori = getMeanMis(grains);
    plotAngDist(mori, small_lmt, saveres, OutDir, prefixb, fname, title1 );
end

% Plot KOG fraction
if doHistNearKOG
    HistNearKOG(grains, epsd, optOR, 0, saveres, OutDir, prefixk, 'fKOG', comment)
end

% Plot KOG fraction for All boundary
if doHistNearKOGAll
    HistNearKOG(grains, epsd, optOR, 1, saveres, OutDir, prefixk, 'fKOGa', comment)
end

% Plot KAM
if doPlotKAM
    plotKAM(grains);
    saveimg( saveres, 1, OutDir, prefixg, 'KAM', 'png', comment);
end

% Plot twin boundary
if doPlotTwin
    plotBoundary(grains1,'color','k');
    hold on, plotBoundary(grains1,'property',CSL(3),'delta',2*degree,...
      'linecolor','b','linewidth',2);
    hold off;
    saveimg( saveres, 1, OutDir, prefixg, 'twin', 'png', comment);
end
% 
% figure();
% f = fracKOG(grains, epsd, 'KS');
% bar(f);
% saveimg( saveres, 1, OutDir, prefixb, 'fKOG_KS', 'png', comment);

end