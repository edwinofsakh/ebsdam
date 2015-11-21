function S = example1(m,n)

[x,y] = meshgrid(-20:19,-20:19);
r = y.^2+x.^2;
S = 1./(1+n*((r))/10).*cos(2*pi*m*(r)/200);
