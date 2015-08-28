function analyzeTest(varargin)
% Analyze test sample.
% 
% Options:
%   'thrd' - grain detection threshold in degree
%   'mgs'  - grain detection minimal grain size in point
%   'epsd' - angular tolerance for IVM distribution in degree

%% Options
% Save results on disk
saveResult('on');

% Sample's ids
samples = {'test1', 'test1', 'test1', 'test2'};

% Region's names
regions = {'0', '1', '2', '0'};

% Skip samples (set 1 to skip sample)
skip = [0, 0, 0, 0];

% Crop rectangle from EBSD data (set '0' to disable croppping)
rxy = {...
    0,...
    [ 0, 0, 6, 6],...
    [ 7  7;...
      2 12;...
      8 16;
     12 10;
      7  7],...
    0,...
    };

% NOTE: List of tasks
% tasklist = {...
%     'doMaps',   0,... % Plot orientation map
%     'doPhases', 0,... % Analyze phases
%     'doProps',  0,... % Analyze properties like BC, MAD
%     'doOR',     0,... % Optimize OR
%     'doGrains', 0,... % Analyze grains and misorientation between them
%     'doSizes',  0,... % Analyze grains size
% };


%% Processing - Step 1 - Plot maps

varMaps = {...
    'doRgnMap',  1,...
    'doOriMap',  1,...
    'doPoleMap', 1,...
    'doODF',     1,...
    };

tasklist = { 'doMaps', varMaps};


% viewSamples( samples, regions, rxy, skip, tasklist, varargin);

%% Processing - Step 2 - Analyze phases

skip = [1, 1, 1, 0];
tasklist = { 'doPhases', 1};

% viewSamples( samples, regions, rxy, skip, tasklist, varargin);

%% Processing - Step 3 - Analyze properties

skip = [0, 1, 1, 1];
varProps = {'properties', {'IQ', 'CI'}};

tasklist = { 'doProps', varProps};

% viewSamples( samples, regions, rxy, skip, tasklist, varargin);

%% Processing - Step 4 - Optimize OR
skip = [0, 1, 0, 1];
varOR1 = {'doOptimization', {'firstView', 'start', 'KS'}};

tasklist = { 'doOR', varOR1};

% viewSamples( samples, regions, rxy, skip, tasklist, varargin);


varOR2 = {'doEpsCurve', {'start', 'KS'}};

tasklist = { 'doOR', varOR2};

% viewSamples( samples, regions, rxy, skip, tasklist, varargin);

varOR3 = {'meaOrientation', 'doOptimization', {'start', 'KS', 'stepSearch'}};

tasklist = { 'doOR', varOR3};

out = viewSamples( samples, regions, rxy, skip, tasklist, varargin);

outm = combineParamsByRegions(out);
saveOutput('analyzeTest', outm, 'comment', 'Test calculation',...
    'enviroment', {samples, regions, tasklist});

%% Restore optOR or set it manual
optOR = {};     %#ok<NASGU>

% Load data from previous optimization (comment this part for manual setting)
[outm, cmt, env] = loadOutput('analyzeTest');
optOR = get_option(outm, 'optOR', {});
optOR = {optOR};
disp(cmt);
disp(env); % Can be use for checking optimization parameters

% Manual optOR setting: individual or common
if isempty(optOR)
    % Individual ORs for each region
    optOR = {...
        {'test', '0', [25.703782 10.529378 22.703782]*degree},...
        {'test', '1', [25.703782 10.529378 22.703782]*degree}...
        };
%     % Common OR for all region
%     optOR = 'NW';
end

% Add optOR to calculation parameters
varargin1 = [varargin, 'optOR', optOR];

%% Processing - Step 5 - Analyze IVM
skip = [0, 1, 0, 1];
varGrains = {...
    'doGrainsMap',          1,...
    'doGrainsMapAll',       1,...
    'doGrainsMapLrg',       1,...
    'doBndHighAngle',       1,...
    'doBndKOG',             1,...
    'doBndKOGPkg',          1,...
    'doBndKOGBain',         1,...
    'doBndIntFull',         1,...
    'doBndInt',             1,...
    'doBndExtRange',        1,...
    'doBndAllRange',        1,...
    'doBndAngle',           1,...
    'doHistMis2Mean',       1,...
    'doHistAllBndMis',      1,...
    'doHistAllBndMisSmall', 1,...
    'doHistMeanMis',        1,...
    'doHistMeanMisSmall',   1,...
    'doHistNearKOG',        1,...
    'doHistNearKOGAll',     1,...
};

tasklist = { 'doGrains', varGrains};

% viewSamples( samples, regions, rxy, skip, tasklist, varargin1{:});
