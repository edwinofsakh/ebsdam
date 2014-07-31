function dprintf( fid, format, varargin )
% Debug info print
%   Print text only if global variables 'Debug' or 'fullDebug' is set to 1.

if (isdebug || isfulldebug)
    fprintf(fid, format, varargin{:});
end

