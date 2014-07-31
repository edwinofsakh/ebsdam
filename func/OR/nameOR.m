function [ name ] = nameOR( ORdata )
% Name for orientation relationship
%   Return name for orientation relationship
%
% Syntax
%   [ optORn ] = nameOR( optOR )
%
% Output
%   name   - name of orientation relationship
%
% Input
%   ORdata - orientation relationship data
%
% History
% 05.04.14  Original implementation

if isa(ORdata, 'char')
    name = ORdata;
else
    name = 'opt';
end

end
