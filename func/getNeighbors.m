function [ neighbors ] = getNeighbors( i, pairs, varargin )
% Get neighbors for element 'i' useing 'pairs'
%
% Syntax
%   [ neighbors ] = getNeighbors( i, pairs, varargin )
%
% Output
%   neighbors   - indices of neighbors
%
% Input
%   i       - index
%   pairs   - pairs of index [n,2]
%
% Options
%   'secondRound' - add second order neighbors
%
% Example
%   [ neighbors ] = getNeighbors( i, pairs, 'secondRound' )
%
% History
% 09.10.13  Original implementation


% First order neighbors
ind1 = findNeighbors(i, pairs);

% Second order neighbors
if check_option(varargin, 'secondOrderNeighbors');
    indc = num2cell(ind1);
    ind2 = cellfun(@(x) getNeighbors(x, pairs), indc, 'UniformOutput', 0);
    ind2 = cell2mat(ind2);
    ind = unique([ind1; ind2]);
    neighbors = ind(ind ~= i);
else
    neighbors = ind1;
end

end

function neighbors = findNeighbors(i, pairs)

ind1 = pairs(pairs(:,1) == i, 2);
ind2 = pairs(pairs(:,2) == i, 1);

neighbors = [ind1; ind2];
end