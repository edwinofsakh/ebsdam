function [v1, v2] = ori2hkl(o)

[phi1, Phi phi2] = Euler(o,'Bunge');

h = sin(Phi)*sin(phi2);
k = sin(Phi)*cos(phi2);
l = cos(Phi);
v1 = [h k l];

u = cos(phi1)*cos(phi2)-sin(phi1)*sin(phi2)*cos(Phi);
v = -cos(phi1)*sin(phi2)-sin(phi1)*cos(phi2)*cos(Phi);
w = sin(Phi)*sin(phi1);

v2 = [u v w];