function [ m ] = getMis( o, pairs )
%getMis Misoreantation between pairs of orientation
%   Calcucate misorientation 'm' between 'pairs' of orientations 'o'. It's
%   need locate probmels with reindexing orientation.
%
% Syntax
%
% Input
%   o - array of orientation [n]
%   pairs - pairs on index [n,2]
%
% History
% 01.04.13  Check orientation operation.

% Old code. I think what indexing of orientations work bad
% % Convert to rotation (indexing of orientations work bad)
% r = rotation(o);
% rr = r(pairs(:,1));
% rl = r(pairs(:,2));
% 
% % Convert back to oreination (angle between orieantion is minimal)
% ol = orientation(rl,get(o,'CS'),get(o,'SS'));
% or = orientation(rr,get(o,'CS'),get(o,'SS'));

ol = o(pairs(:,2));
or = o(pairs(:,1));

% Calculate misoreintation
m = ol.\or;

end

