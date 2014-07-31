function [ v ] = getVersion( )
%Get EBSDAM version
%   Detailed explanation goes here

v = getpref('ebsdam', 'version');
end

