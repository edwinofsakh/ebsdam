function out = viewMaps( sid, rid, region, ebsd, tasks, varargin )
% Draw orientation map, pole figure, inverse pole figure and ODF
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
% Tasks
%   'doRgnMap'  - (task) mark region on full map
%
%   'doOriMap'  - (task) plot orientation maps for X, Y and Z direction
%       'vectors'    - (param) directions for IPF colormap (defualt value [xvector, yvector, zvector])
%       'vnames'     - (param) name for vectors (defualt value ['X','Y','Z'])
%
%   'doPoleMap' - (task) plot pole figure
%       'vectors'    - (param) directions for IPF (defualt value [xvector, yvector, zvector])
%       'vnames'     - (param) name for vectors (defualt value ['X','Y','Z'])
%       'indices'    - (param) indicies for pole figure (defualt value [Miller(1,0,0),Miller(1,1,0),Miller(1,1,1)])
%
%   'doODF'     - (task) calc ODF plot ipdf and ODF section phi2 = 45*degree
%       'calcKernel' - (param) calc kernel else use kernel('de la Vallee Poussin','HALFWIDTH',6*degree);
% 
% History
% 14.04.13  Add saveing of comment
% 06.03.14  Add three vectors. Add texture analysis.
% 26.03.14  New input system.
% 05.04.14  New output system.
% 17.08.14  Makeup. Add marking of region on big map.
% 17.08.15  Makeup. Write wiki. Add parameters.  Add titles.

out = {};

saveres = getpref('ebsdam','saveResult');

OutDir = checkDir(sid, 'maps', saveres);

ebsd = checkEBSD(sid, ebsd, 0);

comment = getComment();

doRgnMap     = get_option(tasks,'doRgnMap',      0);
doOriMap     = get_option(tasks,'doOriMap',      0);
doPoleMap    = get_option(tasks,'doPoleMap',     0);
doODF        = get_option(tasks,'doODF',         0);

%% Mark region
if checkTask(doRgnMap)
    ebsd_f = checkEBSD(sid, 0, 0);
    figure();
    markRegion(ebsd_f, rid, region);
    saveimg( saveres, 1, OutDir, sid, rid, 'png', comment );
    clear ebsd_f;
end

%% Orientation maps (ipdf colorcoding)
if checkTask(doOriMap)
    vars = extractTask(doOriMap);
    ud = get_option(vars, 'vectors', {xvector,yvector,zvector});
    un = get_option(vars, 'vnames', {'X','Y','Z'});
    
    for i = 1:3
        figure();
        plot(ebsd, 'antipodal', 'r',ud{i});
        title('Orientation map');
        saveimg( saveres, 1, OutDir, sid, [rid '_map_' un{i}], 'png', comment );
    end
end

if checkTask(doPoleMap)
    vars = extractTask(doPoleMap);
    vd = get_option(vars, 'vectors', {xvector,yvector,zvector});
    vn = get_option(vars, 'vnames',  {'X','Y','Z'});
    mm = get_option(vars, 'indices', [Miller(1,0,0),Miller(1,1,0),Miller(1,1,1)]);

    % Pole figure
    plotpdf(ebsd('Fe'),mm ,'antipodal', 'silent', 'FontSize', 8, 'MarkerSize', 1);
    annotate([xvector,yvector,zvector],'BackgroundColor','w');
    saveimg(saveres, 1, OutDir, sid, [rid '_pdf_orig'], 'png', comment);

    % Inverse pole figure
    for i = 1:3
        figure;
        plotipdf(ebsd('Fe'),vd{i}, 'antipodal', 'MarkerSize', 0.5, 'MarkerColor', 'k');
        title('Original inverse pole figure');
        annotate([Miller(1,0,0),Miller(1,1,0),Miller(1,1,1),Miller(1,1,2)],'all','labeled');
        saveimg(saveres, 1, OutDir, sid, [rid '_ipdf_orig_' vn{i}], 'png', comment);
    end
end

%% Calculate odf texture analysis
if checkTask(doODF)
    vars = extractTask(doODF);
    vd = get_option(vars, 'vectors', {xvector,yvector,zvector});
    vn = get_option(vars, 'vnames',  {'X','Y','Z'});
    mm = get_option(vars, 'indices', [Miller(1,0,0),Miller(1,1,0),Miller(1,1,1)]);
    
    sec = get_option(vars, 'section', 45*degree);
    res = get_option(vars, 'resolution', 5*degree);

    ebsd = set(ebsd,'SS', symmetry('222'));

    if (check_option(vars, 'calcKernel'))
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
    title('Calculated pole figure');
    annotate([xvector,yvector,zvector],'BackgroundColor','w');
    saveimg(saveres, 1, OutDir, sid, [rid '_pdf'], 'png', comment);
    
    % Inverse pole figure
    for i = 1:3
        figure;
        plotipdf(odf,vd{i}, 'antipodal', 'MarkerSize', 2);
        title('Calculated inverse pole figure');
        annotate([Miller(1,0,0),Miller(1,1,0),Miller(1,1,1),Miller(1,1,2)],'all','labeled');
        colorbar;
        saveimg(saveres, 1, OutDir, sid, [rid '_ipdf_' vn{i}], 'png', comment);
    end

    % Plot ODF
    plotodf(odf,'phi2',sec,'resolution',res,...
      'projection', 'plain', 'gray', 'contourf', 'silent', 'antipodal');
    title('Orientation distribution function');
    colorbar;
    saveimg(saveres, 1, OutDir, sid, [rid '_odf'], 'png', comment);
end
end

