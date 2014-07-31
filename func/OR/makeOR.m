function [ ORmat ] = makeOR( pa, pg, da, dg, dir)
% Make rotational matrix for orientation relation
%
% Syntax
%   [ OR ] = makeOR( pa, pg, da, dg, dir)
%
% Output
%   ORmat - matrix of Orientation relation
%
% Input
%   pa, pg - same plane in alpha and gamma
%   da, dg - same direction in alpha and gamma
%   dir: 'a2g' - alpha to gamma, 'g2a' - gamma to alpha
%
% Example:
%   makeOR([0,1,1]',[1,1,1]',[-1,-1,1]',[-1,0,1]','g2a');  - V1
%
% History
% 09.10.13  Original implementation
% 09.04.14  Recomment
% 18.04.14  Check function - all right

% Find thrid vector
ua = cross(pa,da);
ug = cross(pg,dg);

% Matrix from lab to alpha
Ga = [da/norm(da), ua/norm(ua), pa/norm(pa)];
% Matrix from lab to gamma
Gg = [dg/norm(dg), ug/norm(ug), pg/norm(pg)];

% Choose transformation direction
if (strcmp(dir,'a2g'))
    ORmat = Gg*Ga';
    %A = ORmat*pa
    %B = ORmat*da
elseif (strcmp(dir,'g2a'))
    ORmat = Ga*Gg';
    %A = ORmat*pg
    %B = ORmat*dg
else
    error('Bad direction');
end

end

