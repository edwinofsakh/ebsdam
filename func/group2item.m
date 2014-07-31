function [itm] = group2item( grp, ni )
% Convert information about groups
%   Convert index of items in group 'grp' to index of group for all items 'itm'.
%
% Syntax
%   [itm] = group2item( grp, ni )
%
% Output
%   itm     - index of items in group
%
% Input
%   grp     - index of group for all items
%   ni      - number of items
%
% History
% 17.04.13  Original impelemetion

ng = length(grp);
itm = cell(1,ni);

for i = 1:ni
    for j = 1:ng
        if (any(grp{j} == i))
            itm{i} =[itm{i} j];
        end
    end
end

end
