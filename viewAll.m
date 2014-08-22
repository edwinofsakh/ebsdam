function out0 = viewAll( sid, rid, region, ebsd, tasklist, varargin )
%Draw all infromation about sample
%   Draw all infromation about sample
%
% Syntax
%   viewAll( sid, rid, region, ebsd, thr, mgs, epsilon, tasklist, varargin )
%
% Input
%   sid   		- sample id: 's01', 's02', 's03', 's04' , 't01'
%   rid 		- region id
%   region      - region coordinates
%   ebsd 		- EBSD data if 0, try load useing function "[sid '_load']"
%   thr 		- boundary detection threshold
%   mgs 		- minimal grain's size (lesser grains deleted)
%   epsilon 	- KOG thershold
%   tasklist 	- list of tasks
%
% History
% 28.10.12  Phases' map drawing, if number of phases > 1.
% 01.12.12  Add description of the function. Add 'tasklist' and
%           'gtasklist'.
% 06.12.12  Add 'epsilon'.
% 28.12.12  Add 'Fit' property.
% 26.04.14  Go to region from part.


% Display sample information
disp(['  ' sid '-' rid]);


%% Settings
% Tasks
tasks = {'doMaps', 'doPhases', 'doProps', 'doOR', 'doGrains', 'doSizes', 'doParent'};
func = {@viewMaps, @viewPhases, @viewProps, @viewOR, @viewGrains, @viewSizes, @viewParent};


%% Processing

% load data
if ~isa(ebsd, 'ebsd')
    ebsd = eval([sid '_load( varargin{:})']);
end

for i = 1:length(tasks)
    task = get_option(tasklist, tasks{i}, 0);
    if checkTask( task )
        disp(tasks{i});
        out = func{i}(sid, rid, region, ebsd, extractTask( task ), varargin{:});
        varargin = [varargin, out];
    end
end

out0 = out;
end
