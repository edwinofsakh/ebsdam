function [ varargout ] = getRegionParams( rid, param )
% Get parameters for current region from array of parameters for all
% regions.
%
% Syntax
%   [ a, b, c, ... ] = getRegionParams( rid, param )
%
% Output
%   varargout - set of parameters for current region
%
% Input
%   rid     - region id
%   param   - array of parameters for all region
%
% History
% 17.04.14  Original implementation

if isa(param, 'cell')
    ind = cellfun(@(x) strcmp(x{1},rid),param);
    param = param{ind};
    param = param{2};
    fprintf(1,'Apply region''s parameters.\n');
end

nout = length(param);
for k = 1:nout
    varargout(k) = {param(k)};
end

end

