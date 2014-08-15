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

varargin = [varargin tasks];

ORmat = get_option(varargin, 'optOR', getOR('KS'));
ORmat = getOR(ORmat);

if ~check_option(tasks, 'realRecon')
    param = get_option(tasks,'ParentRecParam', [0.4, 2, 6, 5, 1.5]);

    [ cr, w1, vv, w2, PRmin ] = getRegionParams( rid, param );

    fishParent(ebsd, ORmat, cr, sid, rid, w1, vv, w2, PRmin);
else 
    param = get_option(tasks,'ParentRecParam', [0.2, 2*degree, 4, 1.4, 4*degree, 6*degree, 0*degree, 10*degree,]);
    
    cr    = param(1);
    thr   = param(2);
    Nv    = param(3);
    PRm   = param(4);
    w0    = param(5);
    w11   = param(6);
    w12   = param(7);
    w2    = param(8);
    
    ebsd = simpleFilter(ebsd, cr);
    
    grains = getGrains(ebsd, 2*degree, 2);

%     [ frg_info ] = findPriorGrains(grains, ORmat, thr, Nv, PRm, w0, w11, w12, w2, 'onlyFirst', 'combineClose');
    
    [ frg_info ] = findPriorGrains(grains, ORmat, thr, Nv, PRm, w0, w11, w12, w2,...
    'NeighborsOrder', 3, 'onlyFirst', 'combineClose', 'NOuseWeightFunc');

    colorFragments(grains, frg_info{1});

    figure;
    plotpdf(frg_info{2},Miller(1,0,0),'antipodal');

    frg_info{2}
    figure;
    plotpdf(getVariants(frg_info{2}, getOR('M1'), symmetry('m-3m')),Miller(1,0,0),'antipodal');
    figure;
    plotpdf(get(grains,'mean'),Miller(1,0,0),'antipodal');
end
end