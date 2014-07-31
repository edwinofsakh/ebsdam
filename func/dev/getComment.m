function [ comment ] = getComment( )
% Return comment for output data.
%   Comment contain information about Working system.
%
% Syntax
%   [ comment ] = getComment( )
%
% Output
%   comment	- comment string
%
% Input
%   ***     - ***
%
% History
% 12.04.13  Original implementation

comment = [getpref('ebsdam', 'version') ' - ' getpref('mtex', 'version')];

end
