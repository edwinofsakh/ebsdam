function [ e ] = Eori( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

CS = symmetry('m-3m');
SS = symmetry('-1');

e = orientation('Euler',0,0,0,CS,SS);
end

