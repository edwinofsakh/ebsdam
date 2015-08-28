function [ ebsd_f, par, vm, q ] = simpleFilter( ebsd, cr, varargin)
% Simple filtration
%
% Syntax
%   [ ebsd_f, vm, q ] = simpleFilter( ebsd, cr )
%
% Output
%   ebsd_f  - ***
%
% Input
%   ebsd    - EBSD data
%   cr      - filtration criteria
%
% Options
%   par     - parameter for filtration
%   dir     - direction of parameter: 0 - more is better, 1 - less is better
%
% Example
%   ebsd = simpleFilter( ebsd, 0.1, 'par', {'ci'}, 'dir', [0]);
%
% History
% 12.04.13  Original implementation

v = cell(1,3);
vm = cell(1,3);
        
h = zeros(1,3);
l = zeros(1,3);

par = get_option(varargin, 'par', {'iq','ci','fit'});
dir = get_option(varargin, 'dir', [   0,   0,    1]);

ind = [];
for k = 1:length(par)
    if ( any(cellfun(@(x) strcmpi(x, par{k}), get(ebsd))))
        ind = [ind k];
    end
end

if isempty(ind)
    warning('Can not use filter. Bad params.');
    ebsd_f = ebsd;
    par = {};
    q = ones(length(ebsd),1);
    vm = {};
else

    par = par(ind);
    dir = dir(ind);

    q = ones(length(ebsd),1);

    for k = 1:length(par)
        v{k} = get(ebsd,par{k});
        h(k) = max(v{k});
        l(k) = min(v{k});
        if (dir(k) == 1)
            vm{k} = 1-((v{k}-l(k))/(h(k)-l(k)));
        else
            vm{k} = (v{k}-l(k))/(h(k)-l(k));
        end
        q = q.*vm{k};
    end

    ebsd_f = ebsd(q>cr);
end
end
