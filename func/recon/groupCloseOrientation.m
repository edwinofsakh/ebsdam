function [o, c, g] = groupCloseOrientation(o0, n0, w)
% Summary of this function goes here
%   Detailed explanation goes here
%
% Syntax
%   ***
%
% Output
%   o     - final orientation
%   g     - index of initial orientations for final
%
% Input
%   o0     - initial orientations
%   w      - angular tolerance
%
% History
% 12.04.13  ***

o = o0;
n = n0;

g = cell(1,n);  % orientation group
c = zeros(1,n); % count of orientation in group
oi = 1:n;       % orientation index

% Find close domains. It's not add new information.
i = 1;
while i <= n
    md = (angle(o\o(i)) < w)';
    g{i} = oi(md);
    c(i) = length(g{i});
    if sum(md) > 1
        o(i) = mean(o(md));
%         g{i} = oi(md);
        md(i) = 0;
        o = o(~md);
        oi = oi(~md);
        n = length(o);
    end
    i = i+1;
end

c = c(1:n);
g = g(1:n);

end