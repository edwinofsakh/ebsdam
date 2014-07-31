%MTXEUL  Calculation of Euler angles from Rotation Matrix
% E = MTXEUL(A) - функци€ перехода от матрицы поворота к углам Ёйлера 
% A - матрица поворота размерностью 3х3.
% E - углы Ёйлера в радианах.
%
% (ќбратить внимание на возможность транспонировани€!)    
% ќбратна€ функци€ - EULMTX.


function [E] = mtxeul(A)
A = A';
if abs((det(A)-1))>1e-3
   errordlg('ќпределитель матрицы не равен 1!','Error in MTXEUL');
   return;
end;
E(2) = acos(A(3,3));
m = sin(E(2));
if m~=0
   vsp1 = A(3,1)/m;
   vsp2 = -A(3,2)/m;
   E(1) = atan2(vsp1,vsp2);
   vsp1 = A(1,3)/m;
   vsp2 = A(2,3)/m;
   E(3) = atan2(vsp1,vsp2);
else
   E(3) = 0;
   E(1) = acos(A(1,1));
end;
indx = find(E<0);
if ~isempty(indx) 
   E(indx) = 2*pi+E(indx);
end;

   

  