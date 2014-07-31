function [ ma, ax ] = minAngle( o1, o2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

r1 = symmetrise(o1);
r2 = symmetrise(o2);

a = angle_outer(r1,r2);
[C,ind] = min(a(:));
ma = C/degree;
[I,J] = ind2sub(size(a),ind);
ax = axis(inverse(r1(I)) * r2(J));
end

