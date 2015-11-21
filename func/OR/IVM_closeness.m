function c = IVM_closeness(a, varargin)
% Criterion closeness to the IVM
%   Analyse deviation from the IVM and return one scalar value (closeness 
%   to the IVM).
%
% Syntax
%   c = IVM_dev_crit(a, varargin)
%
% Output
%   c   - closeness to IVM
%
% Input
%   a    - set of deviations from the IVM
%
% Options
%   'type' - type of criterion
%       'mean'
%       'sqrt'
%       'mode'
%       'median'
%       'smart'
%
% History
% 28.09.15  Original implementation. Remove from 'optimizeOR2'.

type = get_option(varargin, 'type', 'sqrt');

switch type
    case 'sqrt'
        c = sqrt(sum(a.*a))/length(a);
    case 'mean'
        c = sum(abs(a))/length(a);
    case 'mode'
        c = crit_mode(a);
    case 'median'
        c = median(a);
    case 'max_hist'
        h = hist(a,1:64);
        c = -max(h);
    otherwise
end
end

function cr = crit_mode(a)
c = 0.1:0.1:32;
s = 2;

a1 = repmat(a', 1, length(c));
c1 = repmat(c, length(a), 1);

l = a1 > c1;
h = a1 < (c1+s);

r = l & h;

[m, i] = max(sum(r, 1));

% plot((c1+c1+1)/2, sum(r, 1));
% pause;

c0 = (c+c+1)/2;
cr = c0(i);
end