function [ or ] = fix_o( o, a )
%round_o Round orientation
%   Round orientation
%   o - orientation
%   a - angle

a2 = a;

[phi1,Phi,phi2] = Euler(o,'Bunge');
phi1 = phi1/degree;
Phi  = Phi/degree;
phi2 = phi2/degree;

phi1r = fix(phi1/a2)*a2;
Phir = fix(Phi/a2)*a2;
phi2r = fix(phi2/a2)*a2;

or = orientation('Euler', phi1r*degree,Phir*degree,phi2r*degree, get(o,'CS'), get(o,'SS'),'Bunge');
end

