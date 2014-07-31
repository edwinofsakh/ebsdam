function out = viewMaps( sid, rid, region, ebsd, tasks, varargin )
%Draw orientation maps.
%   Draw orientation maps
%   sid - sample id: 's01', 's02', 's03', 's04' , 't01'
%   ebsd - EBSD data if 0, try load useing function "[sid '_load']"
%   save - save image to disk
%
% Syntax
%   viewGrains( sid, rid, region, ebsd, tasks, varargin)
%
% Input
%   sid      - sample id: 's01', 's02', 's03', 's04', 't01', 'p01', 'p02'
%   rid      - region id
%   region   - region coordinate
%   ebsd     - EBSD (all phases) data if 0, try load useing function "[sid '_load']"
%   tasks    - list of tasks
%
% History
% 14.04.13  Add saveing of comment
% 06.03.14  Add three vectors. Add texture analysis.
% 26.03.14  New input system.
% 05.04.14  New output system.

out = {};

saveres = getpref('ebsdam','saveResult');

OutDir = checkDir(sid, 'maps', saveres);

ebsd = checkEBSD(sid, ebsd, 'Fe');

comment = getComment();

doOriMap     = get_option(tasks,'doOriMap',      0);
doPoleMap    = get_option(tasks,'doPoleMap',     0);
doODF        = get_option(tasks,'doODF',         0);

nn = {'1','2','3'};
vv = {xvector,yvector,zvector};

%% Orientation maps (ipdf colorcoding)
if doOriMap
    for i = 1:3
        figure();
        plot(ebsd, 'antipodal', 'r',vv{i});
        saveimg( saveres, 1, OutDir, sid, [rid '_map_' nn{i}], 'png', comment );
    end
end

if doPoleMap
    % Pole figure
    plotpdf(ebsd('Fe'),[Miller(1,0,0),Miller(1,1,0),Miller(1,1,1)],'antipodal','silent','FontSize',8, 'MarkerSize', 1);
    annotate([xvector,yvector,zvector],'BackgroundColor','w');
    saveimg(saveres, 1, OutDir, sid, [rid '_pdf'], 'png', comment);

    % Inverse pole figure
    for i = 1:3
        figure;
        plotipdf(ebsd('Fe'),vv{i}, 'antipodal', 'MarkerSize', 0.5, 'MarkerColor', 'k');
        annotate([Miller(1,0,0),Miller(1,1,0),Miller(1,1,1),Miller(1,1,2)],'all','labeled');
        saveimg(saveres, 1, OutDir, sid, [rid '_ipdf_orig_' nn{i}], 'png', comment);
    end
end

%% Calculate odf texture analysis
if doODF
    if ~ischar(sid)
        warning('Use general sample symmetry.'); %#ok<WNTAG>
    else
        isCaching = getpref('ebsdam','caching');
        setpref('ebsdam','caching',0);
        ebsd = checkEBSD(sid, 0, 'Fe', 'odf');
        setpref('ebsdam','caching',isCaching);
        ebsd = getRegion(ebsd, region);
    end

    if (check_option(varargin, 'calcKernel'))
        grains = calcGrains(ebsd);
        grains = grains(grainSize(grains)>5);
        psi = calcKernel(grains('Fe'));
    else
        psi = kernel('de la Vallee Poussin','HALFWIDTH',6*degree);
    end

    odf = calcODF(ebsd('Fe'),'kernel',psi);

    % Inverse pole figure
    for i = 1:3
        figure;
        plotipdf(odf,vv{i}, 'antipodal', 'MarkerSize', 2);
        annotate([Miller(1,0,0),Miller(1,1,0),Miller(1,1,1),Miller(1,1,2)],'all','labeled');
        colorbar;
        saveimg(saveres, 1, OutDir, sid, [rid '_ipdf_' nn{i}], 'png', comment);
    end

    % Plot ODF
    plotodf(odf,'phi2',45*degree,'resolution',5*degree,...
      'projection','plain','gray','contourf','FontSize',10,'silent', 'antipodal');
    colorbar;
    saveimg(saveres, 1, OutDir, sid, [rid '_odf'], 'png', comment);
end
end

