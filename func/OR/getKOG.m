function kog = getKOG(phi1, Phi, phi2, varargin)
% in radian

% Calculate misorenation between variants of oreintation relation.
CS = symmetry('m-3m');
SS = symmetry('1');

ORo = rotation('Euler', phi1, Phi, phi2);

ORoa = rotation(CS) * ORo;
kog = inverse(ORoa(1)) * ORoa(2:end);
kog = orientation(kog, CS, CS);

%
% [~,I] = sort(angle(kog)/degree);
% kog = kog(I);
end