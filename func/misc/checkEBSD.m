function [ ebsd ] = checkEBSD( sid, ebsd, phase, varargin )
% checkEBSD Check ebsd variable
%   Check is ebsd loaded, if not load it.
% 
% Syntax
%   [ ebsd ] = checkEBSD( sid, ebsd, phase )
%
% Input
%   sid     - sample id: 's01', 's02', 's03', 's04', 't01', 'p01', 'p02'
%   ebsd    - EBSD data if 0, try load useing function "[sid '_load']"
%   phase   - if not 0 select phase
%
% History
% 23.11.12 Add function description
% 21.04.13 Comments makeup
% 26.04.14 Always check phase

% Load data
if ~isa(ebsd, 'ebsd')
    ebsd = eval([sid '_load( varargin{:})']);
end

if ( phase ~= 0)
    ebsd = ebsd(phase);
end

end

