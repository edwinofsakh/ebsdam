function [ ret ] = isdebug( )
% Check debug mode
%   Return 1 only if global variables 'Debug' or 'fullDebug' is set to 1.

if ispref('ebsdam', 'debug')
    ret = getpref('ebsdam', 'debug');
else
    ret = 0;
end


