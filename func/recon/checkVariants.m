function [vnum] = checkVariants(opf, ORmat, CS, ori)

vv = getVariants(opf, inv(ORmat), CS);
ma = angle(ori\vv);
[~,ma2i] = min(ma,[],2);
vnum = ma2i;

end

