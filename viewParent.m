function out = viewParent( sid, rid, region, ebsd, tasks, varargin ) %#ok<INUSL>
%View information about austenite parent.
%   
%
% Syntax
%   viewParent( sid, rid, region, ebsd, tasks, varargin )
%
% Input
%   sid      - sample id: 's01', 's02', 's03', 's04', 't01', 'p01', 'p02'
%   rid      - region id
%   region   - region coordinate
%   ebsd     - EBSD (all phases) data if 0, try load useing function "[sid '_load']"
%   tasks    - list of tasks
%
% History
% 26.03.14  Original implementation.
% 05.04.14  New output system.

out = {};

if ~check_option(tasks, 'realRecon')
    param = get_option(tasks,'ParentRecParam', [0.4, 2, 6, 5]);

    [ cr, w1, vv, w2 ] = getRegionParams( rid, param );

    fishParent(ebsd, cr, sid, w1, vv, w2)
else 
    param = get_option(tasks,'ParentRecParam', [3*degree, 5, 1.4, 3*degree, 2*degree, 3*degree, 3*degree,]);
    
    ORmat = get_option(varargin, 'optOR', getOR('KS'));
    thr   = param(1);
    Nv    = param(2);
    PRm   = param(3);
    w0    = param(4);
    w11   = param(5);
    w12   = param(6);
    w2    = param(7);
    
    grains = getGrains(ebsd, 2*degree, 2,'unitcell');

%     [ frg_info ] = findPriorGrains(grains, ORmat, thr, Nv, PRm, w0, w11, w12, w2, 'onlyFirst', 'combineClose');
    
    [ frg_info ] = findPriorGrains(grains, ORmat, thr, Nv, PRm, w0, w11, w12, w2,...
    'secondOrderNeighbors', 'onlyFirst', 'combineClose', 'useWeightFunc');

    colorFragments(grains, frg_info{1});

    figure;
    plotpdf(frg_info{2},Miller(1,0,0),'antipodal');

    frg_info{2}
end
end