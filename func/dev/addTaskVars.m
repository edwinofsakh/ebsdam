function out = addTaskVars(task, varargin)
% Add task variables to varargin
%
% Syntax
%   varargin = addTaskVars(task, varargin)
%
% Output
%   out     - cell array
%
% Input
%   task    - task variables
%   varargin
%
% History
% 17.08.14  Original implementation

if iscell(task) || ischar(task)
    out = [varargin{:} task];
else
    out = varargin;
end