function [t] = extractTask(task)
if iscell(task)
    t = task;
else
    t = {};
end
end