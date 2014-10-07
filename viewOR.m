function out = viewOR( sid, rid, region, ebsd, tasks, varargin )
% View information about Orientation Relationship.
%   View information about Orientation Relationship.
%
% Syntax
%   out = viewOR( sid, rid, region, ebsd, tasks, varargin)
%
% Output
%   out - output data {'optOR', optORm}
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

% Prepare output file
saveres = getpref('ebsdam','saveResult');
OutDir = checkDir(sid, 'OR', 1);
prefix = [sid '_' rid '_OR'];
f_rep = fopen([OutDir '\' prefix '_report.txt'], 'a');
comment = getComment();
fprintf(f_rep, '\n\n---- New session ---- (%s) %s\r\n', comment, datestr(now, 'dd/mm/yyyy HH:MM:SS'));

%% Preparation
% Check variables
mgs = get_option(varargin, 'mgs', 0, 'double');
if ~check_option(varargin, 'mgs')
    fprintf(f_rep, 'Use default MGS value (%d).\r\n', mgs);
end
thrd = get_option(varargin, 'thrd', 2, 'double');
if ~check_option(varargin, 'thrd')
    fprintf(f_rep, 'Use default THRD value (%d).\r\n', thrd);
end

eps2d = get_option(varargin, 'eps2d', 4, 'double')*degree;
eps2  = eps2d*degree;
fprintf(f_rep, 'EPS2D value (%d).\r\n', eps2d);

% Add tasks to variables array
varargin = [varargin tasks {'reportFile', f_rep}];

% Convert to radian
thr = thrd*degree;

% File name prefix
prefix1 = [sid '_' rid '_OR_' num2str(thrd) '_' num2str(mgs)];

% Get output directory
comment = getComment();

% Prepare EBSD region
ebsd = checkEBSD(sid, ebsd, 'Fe');
ebsd = getRegion(ebsd, region);
ebsd = simpleFilter(ebsd, 0.1);

% Prepare grains
grains = getGrains(ebsd, thr, mgs);

%% Calculation
mori = calcBoundaryMisorientation(grains, 'ext');
plotAngDist(mori, 60, saveres, OutDir, prefix1, 'ang', 'All boundary misorientation' );

fprintf(f_rep, 'Total number of extern boundaries: %u.\r\n', length(mori));

optORm = optimizeOR2(mori, sid, rid, varargin{:});

out = {'optOR', optORm};

%
bestKOG = getKOGmtr(optORm, symmetry('m-3m'));
[~, ~, ~,b] = close2KOG(mori, bestKOG, eps2);

%%
fprintf(f_rep, 'Number of non specific boundaries: %u.\r\n', sum(b < eps2));
fprintf(f_rep, 'Number of specific boundaries: %u.\r\n',     sum(b > eps2));
aa = angle(mori)/degree;
figure('Name','Non specific boundaries distribution'); hist(aa(b > eps2),64);
saveimg( saveres, 1, OutDir, prefix, 'non_spec', 'png', comment);


getVarAngles(optORm);

fclose(f_rep);
end