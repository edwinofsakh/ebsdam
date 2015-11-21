function [xout,yout] = example2(x1,x2)

t = 0:.1:10;
xout = sin(x1*t);
yout = sin(x2*t);