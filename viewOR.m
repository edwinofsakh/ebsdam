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
% 09.02.15  Move to Linux.
%           Add epsilon curve.

out = {};

% Prepare output file
saveres = getpref('ebsdam','saveResult');
OutDir = checkDir(sid, 'OR', 1);
prefix = [sid '_' rid '_OR'];
f_rep = fopen(fullfile(OutDir, [prefix '_report.txt']), 'a');
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

eps2d = get_option(varargin, 'eps2d', 8, 'double');
eps2  = eps2d*degree;
fprintf(f_rep, 'EPS2D value: %d.\r\n', eps2d);

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
if ~check_option(varargin, 'meanMisorientation')
    mori = calcBoundaryMisorientation(grains, 'ext');
else
    ori = get(grains,'meanOrientation');
    [~,pairs] = neighbors(grains);
    A = ori(pairs(:,1));
    B = ori(pairs(:,2));
    mori = (A.\B);
end

plotAngDist(mori, 60, saveres, OutDir, prefix1, 'ang', 'All boundary misorientation' );

fprintf(f_rep, 'Total number of extern boundaries: %u.\r\n', length(mori));

if (check_option(varargin, 'epsCurve') && check_option(varargin, 'start'))
    ORname = get_option(varargin, 'start', 'KS');
    ORmat = getOR(ORname);
    OR = orientation('matrix', ORmat, symmetry('m-3m'), symmetry('m-3m'));
    [phi1, Phi, phi2] = Euler(OR);
    kog = getKOG(phi1, Phi, phi2);

    epsa = [1 2 3 4 5 8 12 20 30 40 60]*degree;
    a = cell(1,length(epsa));
    n = zeros(1,length(epsa));
    
    for i=1:length(epsa)
        a{i} = close2KOG(mori, kog, epsa(i));
        n(i) = length(a{i});
    end
    
    disp(num2str([epsa'/degree n']));
    disp(length(mori));
    
    plot(epsa/degree,n/length(mori), '-o', 'lineWidth', 1, 'MarkerSize', 4,'MarkerFaceColor', 'b');
    ylim([0 1]);
    xlabel('epsilon in degree');
    ylabel('KOG fraction');
    title(['Optimal epsilon for ' sid '\_' rid]);
    saveimg( saveres, 1, OutDir, prefix, ['eps_curve_' nameOR(ORname)], 'png', comment);
    
else
    optORm = optimizeOR2(mori, sid, rid, varargin{:});

    out = {'optOR', optORm};

    %
    bestKOG = getKOGmtr(optORm, symmetry('m-3m'));
    [~, ~, ~,b] = close2KOG(mori, bestKOG, eps2);

    %
    fprintf(f_rep, 'Number of non specific boundaries: %u.\r\n', sum(b < eps2));
    fprintf(f_rep, 'Number of specific boundaries: %u.\r\n',     sum(b > eps2));
    aa = angle(mori)/degree;
    figure('Name','Non specific boundaries distribution'); hist(aa(b > eps2),64);
    saveimg( saveres, 1, OutDir, prefix, 'non_spec', 'png', comment);

    [~,ORm] = getOR(optORm);
    getVarAngles(optORm);

    a1 = angle(Miller(1,1,1), ORm * Miller(0,1,1))/degree
    a2 = angle(Miller(-1,0,1), ORm * Miller(-1,-1,1))/degree

    fprintf(f_rep, 'Angle between planes: %d.\r\n', a1);
    fprintf(f_rep, 'Angle between directions: %d.\r\n', a2);
end

fclose(f_rep);
end