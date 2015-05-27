function [CPP, CPD] = calcCP_dev(ORm)
% Calculation deviation from CPP and CPD
%   Calculation deviation from CPP and CPD after phase transformation in
%   steel. ORm matrix transform \_alpha direction and plane to \_gamma.
%
% Syntax
%   [CPP, CPD] = calcCP_dev(ORm)
%
% Output
%   CPP     - deviation from Close Packed Plane
%   CPD     - deviation from Close Packed Direction
%
% Input
%   ORm     - Orientation Relationship matrix for 1st variant
%
% History
% 27.05.15  Original implementation

CPP = angle(Miller(1,1,1), ORm * Miller(0,1,1))/degree;
CPD = angle(Miller(-1,0,1), ORm * Miller(-1,-1,1))/degree;

end