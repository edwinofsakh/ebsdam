function viewAll( sid, rid, region, ebsd, tasklist, varargin )
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
% disp('----------------------');
disp(['  ' sid '-' rid]);
%return;

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

% doMaps      = get_option(tasklist, 'doMaps',     0);
% doPhases    = get_option(tasklist, 'doPhases',   0);
% doProps     = get_option(tasklist, 'doProps',    0);
% doGrains    = get_option(tasklist, 'doGrains',   0);
% doSizes     = get_option(tasklist, 'doSizes',    0);
% doOR        = get_option(tasklist, 'doOR',       0);
% 
% 
% %% Processing
% % View orientation maps
% if checkTask( doMaps )
%     viewMaps(sid, rid, region, ebsd, extractTask(doMaps), varargin);
% end
% 
% % View phases maps
% if checkTask( doPhases )
%     viewPhases(sid, rid, region, ebsd, extractTask(doPhases), varargin);
% end
% 
% % View Properties information, if it's defined
% if checkTask( doProps )
%     viewProps(sid, rid, region, ebsd, extractTask(doProps), varargin);
% end
% 
% % View grains maps
% if checkTask( doGrains )
%     viewGrains(sid, rid, region, ebsd, epsilon, extractTask(doGrains), varargin);
% end
% 
% % View grains' size information
% if checkTask( doSizes )
% 	viewSizes(sid, rid, region, ebsd, extractTask(doSizes), varargin);
% end
% 
% % View orientation relationship information
% if checkTask( doOR )
% 	viewOR(sid, rid, region, ebsd, extractTask(doOR), varargin);
% end

end
