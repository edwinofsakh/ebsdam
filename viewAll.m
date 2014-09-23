function out = viewAll( sid, rid, region, ebsd, tasklist, varargin )
% Draw all infromation about sample
%   Draw all infromation about sample
%
% Syntax
%   out = viewAll( sid, rid, region, ebsd, tasklist, varargin )
%
% Output
%   out - output data from all task for one sample&region ({'p1', 10, 'p2', 35})
%
% Input
%   sid   		- sample id: 's01', 's02', 's03', 's04' , 't01'
%   rid 		- region id
%   region      - region coordinates
%   ebsd 		- EBSD data if 0, try load useing function "[sid '_load']"
%   tasklist 	- list of tasks
%
% Options
%   thrd        - grain detection threshold in degree
%   mgs | mgsum - grain detection minimal grain size (MGS) (in point | in um^2)
%   epsd        - KOG threshold
%
% History
% 28.10.12  Phases' map drawing, if number of phases > 1.
% 01.12.12  Add description of the function. Add 'tasklist' and
%           'gtasklist'.
% 06.12.12  Add 'epsilon'.
% 28.12.12  Add 'Fit' property.
% 26.04.14  Go to region from part.
% 21.09.14  Markup.


out = {};

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
        out1 = func{i}(sid, rid, region, ebsd, extractTask( task ), varargin{:});
        varargin = [varargin, out];
        out = [out, out1];
    end
end

% out0 = out;
end
