function [ mis ] = getORmis( ORname )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

CS = symmetry('m-3m');

v = getVariants(Eori,getOR(ORname), CS);
mis = v\v(1);

end

