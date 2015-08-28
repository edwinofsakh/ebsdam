function [ ebsd_f, par, vm, q ] = CIFilter( ebsd, cr)
% EBSD CI filtration
%
% Syntax
%   [ ebsd_f, vm, q ] = CIFilter( ebsd, cr )
%
% Output
%   ebsd_f  - Filtered EBSD data
%
% Input
%   ebsd    - EBSD data
%   cr      - filtration criteria
%
% Example
%   ebsd = CIFilter( ebsd, 0.1);
%
% History
% 08.06.15  Original implementation

v = cell(1,3);
vm = cell(1,3);
        
h = zeros(1,3);
l = zeros(1,3);

par = {'ci'};
dir = [   0];

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
