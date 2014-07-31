function [ ca ] = getCellArea( ebsd )
% Get cell area
%   Get area of cell useing MTEX function.
%
% Syntax
%   [ ca ] = getCellArea( ebsd )
%
% Output
%   ca      - cell area
%
% Input
%   ebsd	- EBSD data
%
% History
% 12.04.13  Original implementation

cXY = get(ebsd, 'unitCell');
ca = polyarea(cXY(:,1),cXY(:,2));

end
