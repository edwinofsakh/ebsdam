function [ ret ] = isfulldebug( )
% Check debug mode
%   Return 1 only if global variables 'fullDebug' is set to 1.

if ispref('ebsdam', 'fulldebug')
    ret = getpref('ebsdam', 'fulldebug');
else
    ret = 0;
end




