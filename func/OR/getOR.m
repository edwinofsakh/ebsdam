function [ A, o ] = getOR( ORdata )
% Get matrix for orientaion relationship
%
%% Description
% Return matrix of orientaion relation.
%  Old idea is that it is matrix from 'gamma' (fcc) to 'alpha' (bcc). Now i
%  think it's matrix from 'alpha' to 'gamma', see parallel planes.
%
% From 'Var select in low carbon bainite 2012.pdf'
%                           Euler angle (phi1, Phi, phi2)
%  Martensite (Ms = 713 K)  (119.9*, 8.8*, 196.0*)
%  Bainite         (723 K)  (119.0*, 8.9*, 197.3*)
%  Bainite         (773 K)  (117.1*, 8.4*, 199.0*)
%  Bainite         (853 K)  (111.9*, 7.7*, 204.3*)
%                           (108.0*, 7.8*, 207.8*)
%
% In "Crystallography of upper bainite in Fe–Ni–C alloys" we can find table
% of variants.
% V1: (111)g || (011)a, [ -1 0 1]g || [-1-1 1]a
%
% Current matrix transform:
% [-1-1 1] -> [-1 0 1]
% [ 0 1 1] -> [ 1 1 1]
%
% Another variant order
% V1: (111)g || (011)a, [ 1-1 0]g || [-1-1 1]a
% V2: (111)g || (011)a, [ 1-1 0]g || [-1 1-1]a
% ...
%
%% Input
%  orname	- named orientation relation
%    currently available:
%
%    * 'KS' - Kurdjumov-Sachs
%    * 'K'  - Kelly
%    * 'NW' - Nishiyama-Wasserman
%    * 'M1' - from G. Miyamoto article doi:10.1016/j.actamat.2010.08.001 (Miyamoto Reconstr AM2010.pdf)
%    * 'M2','B1','B2','B3' - from N. Takayama article doi:10.1016/j.actamat.2011.12.018 (Var select in low carbon bainite 2012.pdf)
%
%% See also
%  makeOR
%
%% History
%  16.10.12 Transpose KS, M1(old V1)
%  01.04.13 Add some comments. Check orientation operation.

if isa(ORdata, 'char')
	[ A, o ] = name2OR(ORdata);
else
    switch numel(ORdata)
        case 9
            [ A, o ] = mtr2OR(ORdata);
        case 3
            [ A, o ] = euler2OR(ORdata);
        otherwise
            error('Bad options!');
    end
end

end

function [A, o] = name2OR(ORname)

CS = symmetry('m-3m');
SS = symmetry('m-3m');

switch (ORname)
    case 'KS' % +
    A = [ 0.7416   0.6498  0.1667;
         -0.6667   0.7416  0.0749;
         -0.0749  -0.1667  0.9832; ];
    case 'K' % -
	A = [ 0.6667   0.0749   0.7416;
          0.0749   0.9832  -0.1667;
         -0.7416   0.1667   0.6498; ];
    case 'NW' % +
    A = [ 0.7071   0.6969   0.1196;
         -0.7071   0.6969   0.1196;
          0       -0.1691   0.9856; ];
    case 'M1' % +
   	A = [ 0.7174   0.6837   0.1340;
         -0.6952   0.7150   0.0742;
         -0.0450  -0.1464   0.9882; ];
    case 'M2' % +
   	A = [ 0.7153   0.6861   0.1326;
         -0.6975   0.7125   0.0763;
         -0.0422  -0.1471   0.9882; ];
    case 'B1' % +
   	A = [ 0.7198   0.6808   0.1353;
         -0.6926   0.7174   0.0750;
         -0.0460  -0.1477   0.9880; ];
    case 'B2' % +    
   	A = [ 0.7174   0.6844   0.1300;
         -0.6950   0.7159   0.0665;
         -0.0476  -0.1381   0.9893; ];
    case 'B3' % +
   	A = [ 0.7183   0.6845   0.1243;
         -0.6935   0.7187   0.0500;
         -0.0551  -0.1221   0.9910; ]; 
    otherwise
        error('Unknown orientation relation: %s', ORname);
end

o = orientation('matrix', A, CS,SS);

end

function [A, o] = mtr2OR(A)

CS = symmetry('m-3m');
SS = symmetry('m-3m');

o = orientation('matrix', A, CS,SS);

end

function [A, o] = euler2OR(EA)

CS = symmetry('m-3m');
SS = symmetry('m-3m');

o = orientation('euler', EA(1),EA(2),EA(3), CS,SS);

A = normalizeOR('ori', {EA});
end

% ss = symmetry('1');
% cs = symmetry('m-3m');
% 
% oo1 = orientation('matrix', A, cs,ss);
% oo2 = orientation('matrix', A', cs,ss);
% 
% angle(oo1)
% axis(oo1)
% angle(oo2)
% axis(oo2)

% find(all(MMr([2 3 6],:) < 0) & all(MMr([1 4 5 7 8 9],:) > 0))

