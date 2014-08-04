function [ ebsd_f ] = simpleFilter( ebsd, cr )
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
% Options
%   ***     - ***
%
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
% 12.04.13  Original implementation

v = cell(1,3);
vm = cell(1,3);
        
h = zeros(1,3);
l = zeros(1,3);

par  = {'iq','ci','fit'};
md   = [   0,   0,    1];

for k = 1:length(par)
    v{k} = get(ebsd,par{k});
    h(k) = max(v{k});
    l(k) = min(v{k});
    if (md(k) == 1)
        vm{k} = 1-((v{k}-l(k))/(h(k)-l(k)));
    else
        vm{k} = (v{k}-l(k))/(h(k)-l(k));
    end
end

q = vm{1}.*vm{2}.*vm{3};

ebsd_f = ebsd(q>cr);

end
