%EULMTX  Creation of Rotation Matrix
% EULMTX(fi) - функци€ перехода от углов Ёйлера к матрице поворота
% fi - углы Ёйлера (fi1 Fi fi2) в радианах.
%      ¬озможно введение одной ориентировки или массива,
%      дл€ которого кажда€ ориентировка из N описываетс€ строкой (fi - массив [Nx3]).
% ќбратна€ функци€ - MTXEUL.

function [Ar] = eulmtr(fi)
[c1 c2] = size(fi);
if min(c1,c2) == 1 
   V1 = [cos(fi(1))   sin(fi(1))   0;
      -sin(fi(1))   cos(fi(1))   0;
      0            0        1];
   V2 = [1       0            0 	;
      0    cos(fi(2))   sin(fi(2));
      0   -sin(fi(2))  	cos(fi(2))];
   V3 = [ cos(fi(3))   sin(fi(3))   0;
      -sin(fi(3))   cos(fi(3))   0;
      0            0        1]; 
   Ar = V3*V2*V1;
else
   Ar = zeros(3,3,c1);
   for jl = 1:c1
      fij = fi(jl,:);
      sfij = sin(fij);
      cfij = cos(fij);
      V1 = [cfij(1) sfij(1) 0;
         -sfij(1)   cfij(1) 0;
         0            0     1];
      V2 = [1   0       0;
         0    cfij(2) sfij(2);
         0   -sfij(2) cfij(2)];
      V3 = [cfij(3) sfij(3) 0;
         -sfij(3)   cfij(3) 0;
         0            0     1]; 
      Ar(:,:,jl) = V3*V2*V1;
   end;
end;



   
