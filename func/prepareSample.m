function [ ebsd, grains, grains_full ] = prepareSample( sid, thr, mgs )
% Prepare sample
%   Get ebsd data and detect grains for sample.
%
% Input
%   sid - samples id, like: 'p01', 's04t', 'af06s' (see dir '.\load')
%   thr - grain detection threshold, in degree
%   mgs - minimal grain size, in point
%
% Output
%   ebsd        - EBSD data
%   grains      - grains (large grains)
%   grains_full - grains (all grains)
%
% Syntax
%   [ ebsd, grains, grains_full ] = prepareSample( sid, thr, mgs )
%
% History
% 23.11.12  Original implementation

ebsd = checkEBSD(sid, 0, 0);

[grains, grains_full] = getGrains(ebsd, thr, mgs);

end

