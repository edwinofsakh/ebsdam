function o1 = setOriDev(o0, dev)

cs = get(o0, 'CS');
ss = get(o0, 'SS');

r0 = rotation(o0);
a0 = Euler(r0);
ad = dev*(0.5-rand(length(o0),3));
a1 = a0 + ad;
o1 = orientation('Euler', a1(:,1), a1(:,2), a1(:,3), cs, ss);
        
end