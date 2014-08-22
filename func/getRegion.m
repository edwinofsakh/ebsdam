function ebsd_c = getRegion(ebsd, region)
% Crop region from EBSD data
%
% Syntax
%   ebsd_c = getRegion(ebsd, region)
%
% Output
%   ebsd_c	- cropped EBSD data
%
% Input
%   ebsd	- original EBSD data
%   region  - region information (0, [x y w h] or [x1 y1; x2 y2; ...])
%
% Example
%   ebsd_c = getRegion(ebsd, [0 0 10 10])
%
% See also
%   ***
%
% Used in
%   ***
%
% History
% 17.08.14  Original implementation

if length(region) == 1 && region == 0
    ebsd_c = ebsd;
    return;
elseif length(region) == 4
	x0 = region(1); y0 = region(2);
    dx = region(3); dy = region(4);
    region = [x0 y0; x0+dx y0; x0+dx y0+dy; x0 y0+dy; x0 y0];
end

in_reg = inpolygon(ebsd,region);
ebsd_c = ebsd(in_reg);

end