function k = mis_coeff(a)
l1 = 0.5204;
l2 = 1.5877;

k = (coeff(a+73.9*degree)*l1*4+coeff(a)*l2*2)/(l1*4+l2*2);
end

function k = coeff(a)
k = 1/(abs(sin(a))+abs(cos(a)));
end