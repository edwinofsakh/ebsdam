function [a, ind1, ind2] = close2KOG(mori, kog, varargin)

epsilon = get_option(varargin, 'epsilon', 10*degree, 'double');

b = angle_outer(kog,mori);
[b,ind] = min(b,[],1);

ind1 = b < epsilon;
a = b(ind1)/degree;

ind2 = ind(ind1);
end