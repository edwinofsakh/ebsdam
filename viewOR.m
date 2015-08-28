function out = viewOR( sid, rid, region, ebsd, tasks, varargin )
% View information about orientation relationship.
%   Write report file. Work only with 'Fe' phase.
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
% Options
%   'mgs'    - grain detection minimal grain size in point (default value '0')
%   'thrd'   - grain detection threshold in degree (default '2')
%   'eps2d'  - angular tolerance for IVM distribution in degree (default value '8')
%
% Tasks
%   'meanMisorientation' - (option) use misorientation between mean grain
%                           orientation
%
%   'doEpsCurve'     - (task) plot epsilon curve (fraction of boundaries 
%                       close to IVM for different value of epsilon)
%       'OR'            - (param) selected OR for calculation (see getOR,
%                           default value 'KS')
%
%   'doOptimization' - (task) optimize orientation relation (for
%                       optimization parameters see optimizeOR2)
%
% History
% 26.03.14  Original implementation.
% 05.04.14  New output system.
% 09.02.15  Move to Linux.
%           Add epsilon curve.
% 19.08.15  Makeup. Write wiki.

out = {};

% Prepare output file
saveres = getpref('ebsdam','saveResult');
OutDir = checkDir(sid, 'OR', 1);
prefix = [sid '_' rid '_OR'];
f_rep = fopen(fullfile(OutDir, [prefix '_report.txt']), 'a');
comment = getComment();
fprintf(f_rep, '\n\n---- New session ---- (%s) %s\r\n', comment, datestr(now, 'dd/mm/yyyy HH:MM:SS'));

doEpsCurve      = get_option(tasks,'doEpsCurve',     0);
doOptimization  = get_option(tasks,'doOptimization', 0);


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

% For non specific boundaries
eps2d = get_option(varargin, 'eps2d', 8, 'double');
fprintf(f_rep, 'EPS2D value: %d.\r\n', eps2d);

% Convert to radian
thr = thrd*degree;
eps2  = eps2d*degree;

% File name prefix
prefix1 = [sid '_' rid '_OR_' num2str(thrd) '_' num2str(mgs)];

% Get output directory
comment = getComment();

% Prepare EBSD region
ebsd = checkEBSD(sid, ebsd, 'Fe');
ebsd = getRegion(ebsd, region);
ebsd = CIFilter(ebsd, 0.1);

% Prepare grains
grains = getGrains(ebsd, thr, mgs);

%% Calculation
% Prepare misorientation for optimization
if ~check_option(extractTask(tasks), 'meanMisorientation')
    mori = calcBoundaryMisorientation(grains, 'ext');
else
    ori = get(grains,'meanOrientation');
    [~,pairs] = neighbors(grains);
    A = ori(pairs(:,1));
    B = ori(pairs(:,2));
    mori = (A.\B);
end

fprintf(f_rep, 'Total number of extern boundaries: %u.\r\n', length(mori));

% Plot distribution of misorientation angle 
plotAngDist(mori, 60, saveres, OutDir, prefix1, 'ang', 'All boundary misorientation' );

% Plot epsilon curve
if checkTask(doEpsCurve)
    % Prepare OR
    ORname = get_option(extractTask(doEpsCurve), 'OR', 'KS');
    ORmat = getOR(ORname);
    OR = orientation('matrix', ORmat, symmetry('m-3m'), symmetry('m-3m'));
    [phi1, Phi, phi2] = Euler(OR);
    kog = getKOG(phi1, Phi, phi2);

    % List of epsilon values
    epsa = [1 2 3 4 5 8 12 20 30 40 60]*degree;
    
    a = cell(1,length(epsa));
    n = zeros(1,length(epsa));
    
    % Calculate curve
    for i=1:length(epsa)
        a{i} = close2KOG(mori, kog, epsa(i));
        n(i) = length(a{i});
    end
    
    % Display calculated data
    disp(num2str([epsa'/degree n']));
    disp(length(mori));
    
    % Plot calculated epsilon curve
    plot(epsa/degree,n/length(mori), '-o', 'lineWidth', 1, 'MarkerSize', 4,'MarkerFaceColor', 'b');
    ylim([0 1]);
    xlabel('epsilon in degree');
    ylabel('KOG fraction');
    title(['Optimal epsilon for ' sid '\_' rid]);
    saveimg( saveres, 1, OutDir, prefix, ['eps_curve_' nameOR(ORname)], 'png', comment);
end

% Optimize orientation relation
if checkTask(doOptimization)
    vars = extractTask(doOptimization);
    optORm = optimizeOR2(mori, sid, rid, 'reportFile', f_rep, vars{:});
    optORm = getOR('KS');

    out = {'optOR', optORm};

    % Normalize OR
    bestKOG = getKOGmtr(optORm, symmetry('m-3m'));
    [~, ~, ~,b] = close2KOG(mori, bestKOG, eps2);

    % Calculate statistic
    fprintf(f_rep, 'Number of non specific boundaries: %u.\r\n', sum(b < eps2));
    fprintf(f_rep, 'Number of specific boundaries: %u.\r\n',     sum(b > eps2));
    aa = angle(mori)/degree;
    
    % Plot distribution of misorientation angle for boundaries far from IVM
    figure('Name','Non specific boundaries distribution');
    hist(aa(b > eps2),64);
    saveimg( saveres, 1, OutDir, prefix, 'non_spec', 'png', comment);

    % Display list of angle and axis for variants
    getVarAngles(optORm);
    
    % Calculate deviation from close packed plan and direction
    [CPP, CPD] = calcCP_dev(optORm);
    fprintf(f_rep, 'Angle between planes: %d.\r\n', CPP);
    fprintf(f_rep, 'Angle between directions: %d.\r\n', CPD);
end

fclose(f_rep);
end