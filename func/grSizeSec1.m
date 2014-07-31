function [ ags, lengths, lines] = grSizeSec1( ebsd, n, varargin )
%Find grain size by secant method.
%   Find grain size on grain map by secant method. Image must be prepared.
%   Image must be Black&White. Function detect change in intensity along 
%   line.
%   Use Image Processing ToolBox.
%
% Syntax
%   [ ags ] = grSizeSec1( grains, n, varargin )
%
% Output
%   ags - average(nominal) grain size
%
% Input
%   fname   - image file name
%   n       - number of secants
%   upp     - micron per pixles (image scale)
%
% Options
%   'display'   - display secants
%   'crop'      - crop white fields
%
% History
% 13.12.12 Original implementation
% 14.03.13 Add displaying of lines.
%          Increase number of possible places of starting point, set slope 
%           of the line as ratio of random variables.
% 14.05.13 Remove white fields, if 'crop' is set.

lines = gerenateLines(grains, n);

lengths = getLength(ebsd, lines);

ags = getAverage(lengths);

end

function lines = gerenateLines(grains, n)
end

function getLength(lines);

for i=1:n
    [p,dist] = spatialProfile(ebsd,lines[i]);
end
end