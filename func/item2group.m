function [grp] = item2group( itm )
% Convert information about groups
%   Reverse! Convert index of items in group 'grp' to index of group for all items 'itm'.
%
% Syntax
%   [grp] = item2group( itm )
%
% Output
%   **itm     - index of items in group
%
% Input
%  ** grp     - index of group for all items
%  ** ni      - number of items
%
% History
% 17.04.13  Original impelemetion

ni = length(itm);
% ng = length(unique(cell2mat(itm)));
ng = max(cell2mat(itm));
grp = cell(1,ng);

for i = 1:ni
    if (~isempty(itm{i}))
        grp{itm{i}} =[grp{itm{i}} i];
    end
end

end
