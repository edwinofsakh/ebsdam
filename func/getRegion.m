function ebsd_c = getRegion(ebsd, region)

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