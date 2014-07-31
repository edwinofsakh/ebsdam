function out = viewOR( sid, rid, region, ebsd, tasks, varargin )
%View information about Orientation Relationship.
%   View information about Orientation Relationship.
%
% Syntax
%   viewOR( sid, rid, region, ebsd, tasks, varargin)
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

%% Preparation
% Check variables
if check_option(varargin, 'mgs')
    mgs = get_option(varargin, 'mgs');
end
if check_option(varargin, 'thrd')
    thrd = get_option(varargin, 'thrd');
end

% Add tasks to variables array
varargin = [varargin tasks];

% Convert to radian
thr = thrd*degree;

% Prepare EBSD region and grains
ebsd = checkEBSD(sid, ebsd, 'Fe');
ebsd = getRegion(ebsd, region);
grains = getGrains(ebsd, thr, mgs);

%% Calculation
mori = calcBoundaryMisorientation(grains, 'ext');
plotAngDist(mori, 60, 0, '', '', '', 'All boundary misorientation' );

length(mori)

optORm = optimizeOR2(mori, sid, rid, varargin{:});

out = {'optOR', optORm};

getVarAngles(optORm);

end