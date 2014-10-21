function [ out ] = combineParamsByRegions( param )
% Combine outpur parameters by region for using as input.
% Convert from {{'s1', 'r1', {'p1', 10, 'p2', 35} } ,{'s1', 'r2', {'p1', 12, 'p2', 37} }}
% to {'p1', {{'s1', 'r1', 10},{'s1', 'r2', 12}}, 'p2', {{'s1', 'r1', 35},{'s1', 'r2', 37}}}
%
% Syntax
%   [ out ] = combineParamsByRegions( param )
%
% Output
%   param - set of parameters by regions
%
% Input
%   param - set of parameters for regions
%
% History
% 22.09.14  Original implementation

out = {};

if isa(param, 'cell')
    sid = cellfun(@(x) x(1),param);
    rid = cellfun(@(x) x(2),param);
    
    a = param{1};
    vars1 = a{3};
    if (mod(length(vars1),2) ~= 0)
        error('Bad array!');
    end
    for i = 1:2:length(vars1)
        outi = {};
        for j = 1:length(rid)
            a = param{j};
            varsj = a{3};
            outi = [outi, {{sid{j}, rid{j}, varsj{i+1}}}];
        end
        out = [out, {varsj{i}, outi}];
    end
end

end

