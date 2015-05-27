function [ ivm ] = getKOGmtr( ORmat, CS )
% Get InterVariant Misorientation (IVM)
%   Return IVM for Orientation Relationship (OR) matix of first variant.
%   Numbering of variants MTEX default.
%
% Syntax
%   [ ivm ] = getKOGmtr( ORmat, CS )
%
% Output
%   ivm     - set of intervariant misorientation for current OR
%
% Input
%   ORmat   - OR matrxi
%
% Options
%   ***     - ***
%Summary of this function goes here
% Example
%   ***
%
% See also
%   ***
%
% Used in
%   ***
%
% History
% 27.05.15  Add comment

ORo = rotation('matrix', ORmat);
ORoa =  rotation(CS) * ORo;
ivm = inverse(ORoa(1)) * ORoa(2:end);

end

