function [ output_args ] = plotAllOrientations( o, varargin )
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

ms = 2;
omax = get_option(varargin, 'max', 300);
n = length(o);

clr = get_option(varargin, 'MarkerColor', 'b');

if n < omax
    plotpdf(o,Miller(1,0,0),'antipodal','MarkerSize',ms,'MarkerColor', clr, varargin{:});
else
    for i = 1:fix(n/omax)
        s = omax*(i-1)+1;
        e = omax*i;
        plotpdf(o(s:e),Miller(1,0,0),'antipodal',...
            'MarkerSize',ms, 'MarkerEdgeColor',clr, 'MarkerFaceColor','none', varargin{:});
        hold on;
    end
    if mod(n,omax) ~= 0
        s = omax*i+1;
        plotpdf(o(s:end),Miller(1,0,0),'antipodal',...
            'MarkerSize',ms, 'MarkerEdgeColor',clr, 'MarkerFaceColor','none', varargin{:});
        hold on;
    end
    hold off;
end
