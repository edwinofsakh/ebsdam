function out = viewMaps( sid, rid, region, ebsd, tasks, varargin )
% Draw orientation maps.
%   Draw orientation maps
%   sid - sample id: 's01', 's02', 's03', 's04' , 't01'
%   ebsd - EBSD data if 0, try load useing function "[sid '_load']"
%   save - save image to disk
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
% Options
%   'doRgnMap'  - mark region on full map
%   'doOriMap'  - plot orientation maps for X, Y and Z direction
%   'doPoleMap' - plot pole figure
%   'doODF'     - calc ODF plot ipdf and ODF section phi2 = 45*degree
%       'calcKernel' - calc kernel else use kernel('de la Vallee Poussin','HALFWIDTH',6*degree);
% 
% History
% 14.04.13  Add saveing of comment
% 06.03.14  Add three vectors. Add texture analysis.
% 26.03.14  New input system.
% 05.04.14  New output system.
% 17.08.14  Makeup. Add marking of region on big map.

out = {};

saveres = getpref('ebsdam','saveResult');

OutDir = checkDir(sid, 'maps', saveres);

ebsd = checkEBSD(sid, ebsd, 0);

comment = getComment();

doRgnMap     = get_option(tasks,'doRgnMap',      0);
doOriMap     = get_option(tasks,'doOriMap',      0);
doPoleMap    = get_option(tasks,'doPoleMap',     0);
doODF        = get_option(tasks,'doODF',         0);

un = get_option(varargin, 'EBSD_vectorsName', {'1','2','3'});
ud = get_option(varargin, 'EBSD_vectorsDir', {xvector,yvector,zvector});

vn = get_option(varargin, 'IPDF_vectorsName', {'1','2','3'});
vd = get_option(varargin, 'IPDF_vectorsDir', {xvector,yvector,zvector});
mm = get_option(varargin, 'PDF_indices', [Miller(1,0,0),Miller(1,1,0),Miller(1,1,1)]);

%% Mark region
if doRgnMap
    ebsd_f = checkEBSD(sid, 0, 0);
    figure();
    markRegion(ebsd_f, rid, region);
    saveimg( saveres, 1, OutDir, sid, rid, 'png', comment );
    clear ebsd_f;
end

%% Orientation maps (ipdf colorcoding)
if doOriMap
    for i = 1:3
        figure();
        plot(ebsd, 'antipodal', 'r',ud{i});
        saveimg( saveres, 1, OutDir, sid, [rid '_map_' un{i}], 'png', comment );
    end
end

if doPoleMap
    % Pole figure
    plotpdf(ebsd('Fe'),mm ,'antipodal', 'silent', 'FontSize', 8, 'MarkerSize', 1);
    annotate([xvector,yvector,zvector],'BackgroundColor','w');
    saveimg(saveres, 1, OutDir, sid, [rid '_pdf_orig'], 'png', comment);

    % Inverse pole figure
    for i = 1:3
        figure;
        plotipdf(ebsd('Fe'),vd{i}, 'antipodal', 'MarkerSize', 0.5, 'MarkerColor', 'k');
        annotate([Miller(1,0,0),Miller(1,1,0),Miller(1,1,1),Miller(1,1,2)],'all','labeled');
        saveimg(saveres, 1, OutDir, sid, [rid '_ipdf_orig_' vn{i}], 'png', comment);
    end
end

%% Calculate odf texture analysis
if doODF
    varargin = addTaskVars(doODF, varargin);
    
    ebsd = set(ebsd,'SS', symmetry('222'));

    if (check_option(varargin, 'calcKernel'))
        grains = calcGrains(ebsd);
        grains = grains(grainSize(grains)>5);
        psi = calcKernel(grains('Fe'));
    else
        psi = kernel('de la Vallee Poussin','HALFWIDTH',6*degree);
    end

    odf = calcODF(ebsd('Fe'),'kernel',psi);

    % Pole figure
    figure;
    plotpdf(odf, mm, 'antipodal', 'MarkerSize', 2, 'Complete');
    annotate([xvector,yvector,zvector],'BackgroundColor','w');
    saveimg(saveres, 1, OutDir, sid, [rid '_pdf'], 'png', comment);
    
    % Inverse pole figure
    for i = 1:3
        figure;
        plotipdf(odf,vd{i}, 'antipodal', 'MarkerSize', 2);
        annotate([Miller(1,0,0),Miller(1,1,0),Miller(1,1,1),Miller(1,1,2)],'all','labeled');
        colorbar;
        saveimg(saveres, 1, OutDir, sid, [rid '_ipdf_' vn{i}], 'png', comment);
    end

    % Plot ODF
    plotodf(odf,'phi2',45*degree,'resolution',5*degree,...
      'projection','plain','gray','contourf','FontSize',10,'silent', 'antipodal');
    colorbar;
    saveimg(saveres, 1, OutDir, sid, [rid '_odf'], 'png', comment);
end
end

