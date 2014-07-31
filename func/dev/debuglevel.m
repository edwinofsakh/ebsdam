function [ ret ] = debuglevel( )
% Return current debug level
%   Return 0 or current debug level.
%
% Syntax
%   [ ret ] = debuglevel( )
%
% Output
%   ret     - debug level
%
% History
% 21.04.13  Original implementation

global debugLevel

if isempty(debugLevel)
    ret = 0;
else
    ret = debugLevel;
end

end
