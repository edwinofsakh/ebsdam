function [ output_args ] = plotipdf_all( ebsd, r, n, varargin )
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
% 12.04.13  ***

for i = 1:n
    plotipdf(ebsd, r, varargin{:});
    hold on;
end

hold off;
annotate([Miller(1,0,0),Miller(1,1,0),Miller(1,1,1),Miller(1,1,2)],'all','labeled');

end
