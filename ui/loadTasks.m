function [ tasks, hints ] = loadTasks( )
% Load main tasks
%   Load main tasks to processing EBSD data
%
% Output
% taskss - cell array of main tasks
%
% Syntax
%   [ tasks ] = loadTasks( )
%
% History
% 24.11.12  Original implementation


tasks = {...
    'doMaps',...
    'doPhases',...
    'doProp',...
    'doGrains',...
    'doSizes',...
    };

end
