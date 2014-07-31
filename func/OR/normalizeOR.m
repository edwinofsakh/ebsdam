function [mtr, ind] = normalizeOR(varargin)
% Nornalize Orientation Relationship
%   Return right matrix for KOG variants.
%
% Syntax
%   [mtr, ind] = normalizeOR('ori', {o})
%
% Output
%   mtr     - matrix
%   ind     - index of matrix in symmetrise list
%
% Input
%   'ori'     - cell array of orientation in radian
%
% History
% 01.04.14  Original implementation

ori_param = get_option(varargin, 'ori');

CS = symmetry('m-3m');
SS = symmetry('m-3m');
o = orientation('Euler', ori_param{:}, CS,SS);

MM = matrix(symmetrise(o));
% EE = Euler(symmetrise(o));

MMr = reshape(MM, [9 576]);

ind = find(...
    all(MMr([2 3 6],:) < 0) &...
    all(MMr([1 4 5 7 8 9],:) > 0) &...
    (MMr(1,:) > MMr(4,:)) &...
    (MMr(4,:) > MMr(7,:)) );

if (length(ind) ~= 1)
    [~,mi] = max(abs(MMr), [], 1);
    ind = find(...
        all(MMr([2 3 6],:) < 0) &...
        all(MMr([1 4 5 7 8 9],:) > 0) &...
        mi == 9);
end

if (length(ind) ~= 1)
    error('Can not normalize Orientation Relationship.');
end

mtr = MM(:,:,ind);
% EE(ind,:)/degree
end