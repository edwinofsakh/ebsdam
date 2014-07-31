function [ ebsd_c ] = cutEBSD( ebsd, x0, y0, dx, dy )
%cut Cut EBSD data
%   Get region from (x0,y0) to (x0+dx,y0+dy)
%   Arguments:
%       ebsd - EBSD data
%       x0,y0 - begin point
%       dx,dy - size of cropping block

region = [x0 y0; x0+dx y0; x0+dx y0+dy; x0 y0+dy; x0 y0];

in_reg = inpolygon(ebsd,region);
ebsd_c = ebsd(in_reg);

end

