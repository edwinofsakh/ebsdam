function [a, ind1, ind2, b, b0, ind] = close2KOG(mori, kog, epsilon)
% Find misorientation close to KOG
% b0 - distances for all variants
% b - distances for best close variant
% a - only good distances

b0 = angle_outer(kog,mori);
[b,ind] = min(b0,[],1);

ind1 = b < epsilon;
a = b(ind1)/degree;

ind2 = ind(ind1);
end