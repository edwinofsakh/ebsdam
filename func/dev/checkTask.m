function f = checkTask(task)
% Check task
%   Return true if task equal 1 or is cell.

    f = (iscell(task) == 1) || (task == 1) ;
end