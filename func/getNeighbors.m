function [ neighbors ] = getNeighbors( i, pairs )
%Get neighbors for element 'i' useing 'pairs'
%   Arguments:
%       i - index
%       pairs - pairs of index [n,2]

% i1 = (pairs(:,1) == i);
% i2 = (pairs(:,2) == i);

ind1 = pairs(pairs(:,1) == i, 2);
ind2 = pairs(pairs(:,2) == i, 1);

neighbors = [ind1; ind2];

end

