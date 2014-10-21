function [ varargout ] = getRegionParams(sid, rid, param0, varargin )
% Get parameters for current region from array of parameters for all
% regions.
% Example of array: 'Param', {{'sid1', 'rid1', [1,2,3]},{'sid1', 'rid2', [2,3,4]},}
%
% Syntax
%   [ a, b, c, ... ] = getRegionParams( sid, rid, param )
%
% Output
%   varargout - set of parameters for current region
%
% Input
%   rid     - region id
%   param   - array of parameters for all region
%
% Options
%   singleArray     - output like single array
%
% History
% 17.04.14  Original implementation

param = param0;

if isa(param, 'cell')
    ind1 = cellfun(@(x) (strcmp(x{1},sid) || strcmp(x{1},'all')),param);
    ind2 = cellfun(@(x) (strcmp(x{2},rid) || strcmp(x{2},'all')),param);
    ind = (ind1 & ind2);
    param = param{ind};
    param = param{3};
    fprintf(1,'Apply region''s parameters.\n');
end

if (check_option(varargin, 'singleArray'))
    varargout{1} = param;
else
    nout = length(param);
    for k = 1:nout
        varargout(k) = {param(k)};
    end
end

end

