function [v, ind] = getVariants(o, ORmat, CS, varargin)
% Get all crystallographic variant of transformation products.
%   Array 'v' contain all variants. Variants groups by symmetry, first
%   variants for one rotation.
%   c1v1 c2v1 ... cnv1 c1v2 c2v2 ... cnv2 ...
%
% Syntax
%   [v, ind] = getVariants(r, OR, CS)
%
% Output
%   v       - variants
%   ind     - index of orientation
%
% Input
%   o       - orientations
%   ORmat   - orientation relation matrix
%
% History
% 17.04.13  Separate from 'findUniqueParent.m'

% Set misorientation
ORr = rotation('matrix', ORmat);

if check_option(varargin, 'someVariants')
    i = get_option(varargin, 'someVariants');
    % Some variants
    v00 = ORr*o;
    v0 = inverse(rotation(CS(i)))*v00(:);
    v = orientation(v0,get(o,'CS'),get(o,'SS'));
    ind = ones(length(v),1);
else
    % Some variants
    v0 = o*CS*ORr;
    v = orientation(v0,get(o,'CS'),get(o,'SS'));
    ind = repmat(1:length(o),1,size(CS,1))'; % ???
end

end
