function kog = getKOG(phi1, Phi, phi2, varargin)
% Return misorientations between variants of original orientation.
%   Misorientation 24x24 symmetry. 
%
% Syntax
%   kog = getKOG(phi1, Phi, phi2, varargin)
%
% Output
%   kog     - misorientations
%
% Input
%   phi1, Phi, phi2 - euler angles in radian
%
% Options
%   not used
%
% Used in
%   optimizeOR2, showOptimOR
%
% History
% 24.03.14  Original implementation

% Calculate misorenation between variants of orientation relation.
CS = symmetry('m-3m');
SS = symmetry('1');

ORo = rotation('Euler', phi1, Phi, phi2);

ORoa = rotation(CS) * ORo;
kog = inverse(ORoa(1)) * ORoa(2:end);
kog = orientation(kog, CS, CS);

%
% [~,I] = sort(angle(kog)/degree);
% kog = kog(I);
end