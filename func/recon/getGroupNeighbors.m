function [ neighbours ] = getGroupNeighbors( i, grp, pairs )
% Summary of this function goes here
%   Detailed explanation goes here
%
% Syntax
%   ***
%
% Output
%   ***     - ***
%
% Input
%   ***     - ***
%
% History
% 12.04.13  

disp('DON''T WORK');
return;

n = length(grp{i});

neighbours = cell(1,n);

ind = grp{i};

for j = 1:n
	neighbours{j} = getNeighbors( ind(j), pairs )';
end

% index of initial orientation
ind = unique([neighbours{:}]);

% for k = ind
% 	cellfun()
% end
% 
% neighbours = ind
end
