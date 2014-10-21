function [a, ind1, ind2, b] = close2KOG(mori, kog, epsilon)

b = angle_outer(kog,mori);
[b,ind] = min(b,[],1);

ind1 = b < epsilon;
a = b(ind1)/degree;

ind2 = ind(ind1);
end