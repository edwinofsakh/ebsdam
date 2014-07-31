function [af] = areafraction(ar, dd)

n = length(dd);
ae = pi*(dd/2).^2;

af = zeros(1,n);

for i = 1:n-1
	ind = ((ar > ae(i)) & (ar < ae(i+1)));
    af(i) = sum(ar(ind));
end

ind = ar > ae(n);
af(n) = sum(ar(ind));
end