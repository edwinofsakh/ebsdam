function [ groups ] = add_group( groups, group, new_group, list )
%find_gg Find group of grains separeted by special boundary
%   Detailed explanation goes here

ind = [1:length(groups)];

for j = 1:length(group)
    groups_m = groups(logical(list));
    for k = 1:length(groups_m)
        test = find(groups_m{k} == group(j));
        if (~isempty(test))
            new_group = [new_group groups_m{k}];
            ind_m = ind(logical(list));
            list(ind_m(k)) = 0;
            add_group(groups, groups_m{k}, new_group, list);
        end
    end
end
        
end

