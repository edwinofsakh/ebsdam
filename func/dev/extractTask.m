function [t] = extractTask(task)
% Extract task
%   Retrun parameters or empty cell

if iscell(task)
    t = task;
else
    t = {};
end
end