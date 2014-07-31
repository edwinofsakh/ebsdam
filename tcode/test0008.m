% Compare misorientation
ebsd = sel01_load();

o = get(ebsd, 'orientation');

i1 = 254;
i2 = 394;
i3 = 347;
i4 = 874;

o1 = o(i1);
o2 = o(i2);
o3 = o(i3);
o4 = o(i4);

m12 = o1 * inverse(o2);
m22 = o3 * inverse(o4);

m11 = inverse(o1) * o2;
m21 = inverse(o3) * o4;

display('****')
[angle(o1,o2)/degree, getx(axis(o1,o2)), gety(axis(o1,o2)), getz(axis(o1,o2));
 angle(m11)/degree, getx(axis(m11)), gety(axis(m11)), getz(axis(m11));
 angle(m12)/degree, getx(axis(m12)), gety(axis(m12)), getz(axis(m12))]

[angle(o3,o4)/degree, getx(axis(o3,o4)), gety(axis(o3,o4)), getz(axis(o3,o4));
 angle(m21)/degree, getx(axis(m21)), gety(axis(m21)), getz(axis(m21));
 angle(m22)/degree, getx(axis(m22)), gety(axis(m22)), getz(axis(m22))]

display('****')
[angle(m11,m21)/degree, getx(axis(m11,m21)), gety(axis(m11,m21)), getz(axis(m11,m21));
 angle(m12,m22)/degree, getx(axis(m12,m22)), gety(axis(m12,m22)), getz(axis(m12,m22));
 angle(inverse(m11) * m21)/degree, getx(axis(m11 * inverse(m21))), gety(axis(m11 * inverse(m21))), getz(axis(m11 * inverse(m21)));
 angle(inverse(m12) * m22)/degree, getx(axis(m12 * inverse(m22))), gety(axis(m12 * inverse(m22))), getz(axis(m12 * inverse(m22)))]

display('****')
[angle(m11,m21)/degree, getx(axis(m11,m21)), gety(axis(m11,m21)), getz(axis(m11,m21));
 angle(m12,m22)/degree, getx(axis(m12,m22)), gety(axis(m12,m22)), getz(axis(m12,m22));
 angle(inverse(m11) * m21)/degree, getx(axis(inverse(m11) * m21)), gety(axis(inverse(m11) * m21)), getz(axis(inverse(m11) * m21));
 angle(inverse(m12) * m22)/degree, getx(axis(inverse(m12) * m22)), gety(axis(inverse(m12) * m22)), getz(axis(inverse(m12) * m22))]

display('****')
[angle(m11,m21)/degree, getx(axis(m11,m21)), gety(axis(m11,m21)), getz(axis(m11,m21));
 angle(m12,m22)/degree, getx(axis(m12,m22)), gety(axis(m12,m22)), getz(axis(m12,m22));
 angle(m11 * inverse(m21))/degree, getx(axis(m11 * inverse(m21))), gety(axis(m11 * inverse(m21))), getz(axis(m11 * inverse(m21)));
 angle(m12 * inverse(m22))/degree, getx(axis(m12 * inverse(m22))), gety(axis(m12 * inverse(m22))), getz(axis(m12 * inverse(m22)))]

display('****')

r1 = symmetrise(o1);
r2 = symmetrise(o2);
r3 = symmetrise(o3);
r4 = symmetrise(o4);

rr1 = symmetrise(m11);
rr2 = symmetrise(m21);

a = angle_outer(rr1,rr2);
[C,ind] = min(a(:));
ma = C/degree
[I,J] = ind2sub(size(a),ind);
 axis(inverse(rr1(I)) * rr2(J))

